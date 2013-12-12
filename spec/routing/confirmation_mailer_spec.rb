require 'spec_helper'

describe Lobby::ConfirmationMailer do

  before(:each) { @routes = Lobby::Engine.routes }

  describe "#password_reset" do
    let(:user) { FactoryGirl.create(:user, :password_token => "irgendwas") }
    let(:mail) { Lobby::ConfirmationMailer.send_password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq( I18n.t( 'lobby.confirmation_mailer.send_password_reset.subject' ))
      mail.to.should eq([user.email])
      mail.body.encoded.should include( recover_password_form_url(:token => user.password_token))
    end
  end

  describe "#registration" do
    let(:user) { FactoryGirl.build(:user, :signup_token => "irgendwas") }
    let(:mail) { Lobby::ConfirmationMailer.registration(user) }

    it "send user confirmation url" do
      mail.subject.should eq( I18n.t( 'lobby.confirmation_mailer.registration.subject' ))
      mail.to.should eq([user.email])
      mail.body.encoded.should match( confirm_url( :registration, user.signup_token ))
    end
  end

  describe "#resend_signup_token" do
    let(:user) { FactoryGirl.create(:user, :signup_token => "irgendwas") }
    let(:mail) { Lobby::ConfirmationMailer.resend_signup_token(user) }

    it "send user new confirmation url" do
      mail.subject.should eq( I18n.t( 'lobby.confirmation_mailer.resend_signup_token.subject' ))
      mail.to.should eq([user.email])
      mail.body.encoded.should match( confirm_url( :registration, user.signup_token ))
    end
  end

end
