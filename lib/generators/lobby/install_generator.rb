require 'rails/generators'
require 'rails/generators/migration'

module Lobby
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    attr_accessor :user_name, :session_name

    argument :user_name, :type => :string, :default => "user"
    argument :session_name, :type => :string, :default => "session"

    source_root File.expand_path("../../templates", __FILE__)

    def create_views
      directory "views", "app/views/lobby"
    end

    def create_locales
      template "config/locales/de.yml", "config/locales/de.lobby.yml"
      template "config/locales/en.yml", "config/locales/en.lobby.yml"
    end

    def create_config_files
      template "config/config.yml", "config/app_config.yml"
      template "config/locales/en.yml", "config/locales/en.lobby.yml"
    end

    def create_config_files
      template "config/config.yml", "config/app_config.yml"
      template "config/initializers/action_mailer.rb", "config/initializers/action_mailer.rb"
      template "config/initializers/constants.rb", "config/initializers/constants.rb"
    end

    def setup_routes
      route "mount Lobby::Engine => '/', :as => 'lobby_engine'"
    end

    def create_migration
      migration_template 'db/migrate/create_users.rb', "db/migrate/create_#{user_plural_name}.rb"
    end

    private

    def user_singular_name
      user_name.underscore
    end

    def user_plural_name
      user_singular_name.pluralize
    end

    def user_class_name
      user_name.camelize
    end

    def user_plural_class_name
      user_plural_name.camelize
    end

    def session_singular_name
      session_name.underscore
    end

    def session_plural_name
      session_singular_name.pluralize
    end

    def session_class_name
      session_name.camelize
    end

    def session_plural_class_name
      session_plural_name.camelize
    end

    def self.next_migration_number(dirname) #:nodoc:
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

  end
end
