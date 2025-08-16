# lib/tasks/dynamic_generated.rake
namespace :dtov2 do
  desc 'Generate OpenAPI JSON dynamically for all controllers and DTOs'
  task generate: :environment do
    require 'json'

    openapi = {
      openapi: '3.0.4',
      info: { title: 'SideKick API', version: '1.0' },
      paths: {},
      components: { schemas: {} }
    }

    # 1️⃣ Eager load all app files to ensure DTOs and controllers exist
    Dir[Rails.root.join('app', '**', '*.rb')].each { |file| require file }

    # 2️⃣ Collect all DTO classes dynamically
    dto_classes = ObjectSpace.each_object(Class).select { |c| c.name&.end_with?('Dto') }

    dto_classes.each do |dto|
      properties = {}

      # Struct-based DTOs
      if dto < Struct
        dto.members.each do |member|
          type = member == :id ? 'integer' : 'string'
          properties[member.to_s] = { type: type }
        end
        # ActiveModel::Serializer DTOs
      elsif defined?(ActiveModel::Serializer) && dto < ActiveModel::Serializer
        dto._attributes_data.each { |attr, _| properties[attr.to_s] = { type: 'string' } }
        # Plain PORO with attr_accessors
      else
        dto.instance_methods(false).grep(/=$/).each do |setter|
          properties[setter.to_s.delete('=')] = { type: 'string' }
        end
      end

      openapi[:components][:schemas][dto.name] = {
        type: 'object',
        properties: properties,
        required: properties.keys,
        additionalProperties: false
      }
    end

    # 3️⃣ Process all Rails routes
    Rails.application.routes.routes.each do |route|
      verb = route.verb&.downcase&.gsub(/[$^]/, '')
      path = route.path.spec.to_s.gsub('(.:format)', '').gsub(/:([a-zA-Z_]+)/, '{\1}')
      controller = route.defaults[:controller]
      action = route.defaults[:action]

      next if controller.nil? || action.nil? || verb.blank? || path.include?('rails/')

      openapi[:paths][path] ||= {}

      # Determine controller class
      begin
        controller_class = "#{controller.camelize}Controller".constantize
      rescue NameError
        next
      end

      # Determine DTO mapping for this action
      dto_entry = if controller_class.const_defined?(:RETURN_DTO)
                    controller_class::RETURN_DTO[action.to_sym]
                  end
      next unless dto_entry

      # Response DTO
      response_dto = dto_entry.is_a?(Hash) ? dto_entry[:response] : dto_entry

      response_schema = path.include?(':id') ?
                          { '$ref' => "#/components/schemas/#{response_dto.name}" } :
                          { type: 'array', items: { '$ref' => "#/components/schemas/#{response_dto.name}" } }

      operation = {
        tags: [controller.camelize],
        summary: "#{action} #{controller}",
        responses: {
          '200' => {
            description: 'OK',
            content: {
              'application/json' => { schema: response_schema },
              'text/plain'       => { schema: response_schema },
              'text/json'        => { schema: response_schema }
            }
          }
        }
      }

      # Path parameters for :id routes
      if path.include?(':id')
        operation[:parameters] = [
          { name: :id, in: :path, required: true, schema: { type: :integer }, description: 'ID' }
        ]
        operation[:responses]['404'] = { description: 'Not Found' }
      end

      # Request body for write actions (POST/PUT/PATCH)
      if %w[post put patch].include?(verb) && dto_entry.is_a?(Hash) && dto_entry[:params]
        operation[:requestBody] = {
          required: true,
          content: {
            'application/json' => { schema: { '$ref' => "#/components/schemas/#{dto_entry[:params].name}" } }
          }
        }
      end

      openapi[:paths][path][verb.to_sym] = operation
    end

    # 4️⃣ Write JSON file
    File.open(Rails.root.join('sidekick_schema.json'), 'w') do |f|
      f.write(JSON.pretty_generate(openapi))
    end

    puts '✅ sidekick_schema.json generated successfully!'
  end
end
