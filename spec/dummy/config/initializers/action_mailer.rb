# Email settings

if Rails.env == "production"
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
    :address => "www.example.com",
    :port => 25,
    :domain => 'example.com',
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => "username",
    :password => "password"
  }
end

if Rails.env == "staging"
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
    :address => "www.example.com",
    :port => 25,
    :domain => 'example.com',
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => "username",
    :password => "password"
  }
end

if Rails.env == "development"
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.perform_deliveries = false
  ActionMailer::Base.smtp_settings = {
    :address => "www.example.com",
    :port => 25,
    :domain => 'example.com',
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => "username",
    :password => "password"
  }
end

if Rails.env == "test"
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
    :openssl_verify_mode => 'none'
  }
end

if ActionMailer::Base.delivery_method == :smtp and ActionMailer::Base.smtp_settings.has_key?(:pop3_auth)
  class ActionMailer::Base
    alias_method :base_perform_delivery_smtp, :perform_delivery_smtp
    @@pop3_auth_done = nil

    private

    def perform_delivery_smtp(mail)
      do_pop_auth if !@@pop3_auth_done or (Time.now - smtp_settings[:pop3_auth][:expires]) >= @@pop3_auth_done
      base_perform_delivery_smtp(mail)
    end

    def do_pop_auth
      require 'net/pop'
      pop = Net::POP3.new(smtp_settings[:pop3_auth][:server])
      pop.start(smtp_settings[:pop3_auth][:user_name], smtp_settings[:pop3_auth][:password])
      @@pop3_auth_done = Time.now
      pop.finish
    end
  end
end
