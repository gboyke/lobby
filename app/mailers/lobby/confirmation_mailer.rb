module Lobby
  class ConfirmationMailer < ActionMailer::Base

    helper :application

    default :from => APP_CONFIG['registration_mailer']['from']

    def registration( user )
      @confirmation_url = confirm_url( :registration, user.signup_token )
      mail( :to => user.email, :subject => t( '.subject' ))
    end

    def resend_signup_token( user )
      @user = user
      @confirmation_url = confirm_url( :registration, @user.signup_token )
      mail( :to => user.email, :subject => t( '.subject' ))
    end

    def send_password_reset( user )
      @confirmation_url = recover_password_form_url( :token => user.password_token )
      mail( :to => user.email, :subject => t( '.subject' ))
    end

    def new_email_request( user )
      @user = user
      @confirmation_url = new_email_url( @user.new_email_token )
      mail( :to => @user.new_email, :subject => t( '.subject' ))
    end
  end
end
