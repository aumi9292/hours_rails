# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource(
      '*',
      headers: :any,
      expose: ["Authorization"],
      methods: [:get, :patch, :put, :delete, :post, :options, :show]
    )
  end
end

run Rails.application
