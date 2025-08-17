Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:8080" # Next.js dev server
    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
