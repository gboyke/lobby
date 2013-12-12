require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  unless ENV['DRB']
   # require 'simplecov'
   # SimpleCov.start 'rails'
  end
  require File.expand_path("../dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'factory_girl'
  require 'database_cleaner'

  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  Lobby::ConfirmationMailer.default_url_options = { :host => 'localhost:3000' }

  RSpec.configure do |config|
    config.include SpecLoginHelper, :type => :controller
    config.mock_with :rspec
    config.use_transactional_fixtures = false
    config.include(MailerMacros)
    config.before(:each) { reset_email }
    config.include FactoryGirl::Syntax::Methods
    config.include Capybara::DSL

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
  end
end

Spork.each_run do
  if ENV['DRB']
    #require 'simplecov'
    #SimpleCov.start 'rails'
  end
  FactoryGirl.reload
end
