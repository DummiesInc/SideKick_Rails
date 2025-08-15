# lib/tasks/dynamic_generated.rake
namespace :new do
    desc 'Generate OpenAPI JSON dynamically for all controllers and DTOs'
    task generate: :environment do
      require 'json'
  
      openapi = {
        openapi: '3.0.4',
        info: { title: 'SideKick API', version: '1.0' },
        paths: {},
        components: { schemas: {} }
      }
  
      # 1️⃣ Eager load all app files to make sure DTO classes exist
      Dir[Rails.root.join('app', '**', '*.rb')].each { |file| require file }
  
      # 2️⃣ Collect all DTO classes dynamically
      dto_classes = ObjectSpace.each_object(Class).select { |c| c.name&.end_with?('Dto') }
  
      dto_classes.each do |dto|
        properties = {}
  
        # Detect attributes depending on class type
        if dto < Struct
          dto.members.each { |member| properties[member.to_s] = { type: 'string' } }
        elsif defined?(ActiveModel::Serializer) && dto < ActiveModel::Serializer
          dto._attributes_data.each { |attr, _| properties[attr.to_s] = { type: 'string' } }
        else
          # Plain PORO: get instance variables from new instance
          properties = if dto < Struct
            dto.members.map { |m| [m.to_s, { type: 'string' }] }.to_h
          elsif defined?(ActiveModel::Serializer) && dto < ActiveModel::Serializer
            dto._attributes_data.keys.map { |attr| [attr.to_s, { type: 'string' }] }.to_h
          else
            # fallback: use attr_accessors
            dto.instance_methods(false).grep(/=$/).map { |m| [m.to_s.delete('='), { type: 'string' }] }.to_h
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
  
        # Schema: single for :id, array otherwise
        schema = path.include?(':id') ?
          { '$ref' => '#/components/schemas/GetStateDto' } :
          { type: 'array', items: { '$ref' => '#/components/schemas/GetStateDto' } }
  
        operation = {
          tags: [controller.camelize],
          summary: "#{action} #{controller}",
          responses: {
            '200' => {
              description: 'OK',
              content: {
                'application/json' => { schema: schema },
                'text/plain' => { schema: schema },
                'text/json'  => { schema: schema }
              }
            }
          }
        }
  
        # Add path parameter for :id routes
        if path.include?(':id')
          operation[:parameters] = [
            { name: :id, in: :path, required: true, schema: { type: :integer }, description: 'ID' }
          ]
          operation[:responses]['404'] = { description: 'Not Found' }
        end
  
        # Add request body for write actions
        if %w[post put patch].include?(verb)
          operation[:requestBody] = {
            required: true,
            content: {
              'application/json' => { schema: { '$ref' => '#/components/schemas/GetStateDto' } }
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
  