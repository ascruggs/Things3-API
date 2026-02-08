require_relative "boot"

require "rails"
require "active_support/railtie"
require "action_controller/railtie"
require "action_dispatch/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Things3
  class Application < Rails::Application
    config.load_defaults 8.1
    config.api_only = true
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
