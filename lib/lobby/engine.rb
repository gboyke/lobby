module Lobby
  class Engine < ::Rails::Engine
    isolate_namespace Lobby

     config.generators do |g|
       g.test_framework :rspec, :view_specs => false
       g.integration_tool :rspec
       g.fixture_replacement :factory_girl, :dir => 'spec/factories'
     end

    config.autoload_paths += Dir["#{config.root}/lib"]
  end
end
