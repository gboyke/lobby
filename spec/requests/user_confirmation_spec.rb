require 'spec_helper'

describe "UserConfirmation" do
  it "emails user to confirm his sign up" do
    visit lobby_engine.sign_up_form_path
    fill_in "user_email", :with => "test@test.de"
    fill_in "user_username", :with => "testuser"
    fill_in "user_password", :with => "geheim"
    fill_in "user_password_confirmation", :with => "geheim"
    click_button "sign_up_button"
    current_path.should eq lobby_engine.log_in_path
    #page.should have_content( I18n.t( "users.create.flash.success" ))
    last_email.to.should include("test@test.de")
  end

  it "user uses confirmation token form and is confirmed" do
    user = FactoryGirl.create(:user, :signup_token => "halloklaus")
    visit lobby_engine.confirm_path(:action => :registration)
    fill_in "token", :with => user.signup_token
    click_button "token_button"
    current_path.should eq lobby_engine.log_in_path
    page.should have_content( I18n.t( "lobby.confirmation.registration.flash.success" ))
  end

  it "user not confirmed with false confirmation token" do
    user = FactoryGirl.create(:user, :signup_token => "halloklaus")
    visit lobby_engine.confirm_path(:action => :registration)
    fill_in "token", :with => "ein_anderer_token"
    click_button "token_button"
    current_path.should eq lobby_engine.confirm_path(:action => :registration)
    page.should have_content( I18n.t( "lobby.confirmation.registration.flash.error" ))
  end

  it "user asks for new confirmation token" do
    user = FactoryGirl.create(:user, :signup_token => "halloklaus2")
    visit lobby_engine.confirm_path(:action => :registration)
    click_link "resend_signup_token"
    current_path.should eq lobby_engine.confirm_path(:action => "resend_confirmation")
    fill_in "email", :with => user.email
    fill_in "password", :with => user.password
    click_button "resend_signup_token_button"
    user = User.find(user.id)
    last_email.to.should include(user.email)
    page.should have_content( I18n.t( "lobby.confirmation.resend_signup_token.flash.success" ))
    user.signup_token.should_not eq "halloklaus2"
  end

  it "confirmed user cannot request new confirmation token" do
    user = FactoryGirl.create(:user, :signup_token => "halloklaus", :confirmed => Time.now)
    visit lobby_engine.confirm_path(:action => :registration)
    click_link "resend_signup_token"
    current_path.should eq lobby_engine.confirm_path(:action => "resend_confirmation")
    fill_in "email", :with => user.email
    fill_in "password", :with => user.password
    click_button "resend_signup_token_button"
    last_email.should eq nil
    current_path.should eq lobby_engine.log_in_path
    page.should have_content( I18n.t( "lobby.confirmation.resend_signup_token.flash.error" ))
  end


end
