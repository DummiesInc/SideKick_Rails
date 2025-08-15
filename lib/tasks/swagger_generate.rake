# lib/tasks/swagger_generate.rake
namespace :swagger do
    desc 'Generate OpenAPI JSON for States endpoints'
    task generate: :environment do
      require 'json'
  
      openapi = {
        openapi: '3.0.4',
        info: { title: 'SideKick API', version: '1.0' },
        paths: {},
        components: { schemas: {} }
      }
  
      # Define GetStateDto schema
      openapi[:components][:schemas]['GetStateDto'] = {
        type: 'object',
        properties: {
          id: { type: 'integer' },
          name: { type: 'string' },
          abbreviation: { type: 'string' }
        },
        required: %w[name abbreviation],
        additionalProperties: false
      }
  
      # Only process StatesController routes
      Rails.application.routes.routes.each do |route|
        verb = route.verb&.downcase&.gsub(/[$^]/, '')
        path = route.path.spec.to_s.gsub('(.:format)', '').gsub(/:([a-zA-Z_]+)/, '{\1}')
        controller = route.defaults[:controller]
        action = route.defaults[:action]
  
        next unless controller == 'states'
        next if verb.blank?
  
        openapi[:paths][path] ||= {}
  
        # Determine schema: array for index, single for show
        schema = path.include?(':id') ? 
          { '$ref' => '#/components/schemas/GetStateDto' } :
          { type: 'array', items: { '$ref' => '#/components/schemas/GetStateDto' } }
  
        operation = {
          tags: ['States'],
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
  
      # Write JSON file
      File.open(Rails.root.join('api_doc.json'), 'w') do |f|
        f.write(JSON.pretty_generate(openapi))
      end
  
      puts '✅ api_doc.json generated successfully!'
    end
  end


  # bundle exec rake swagger:generate