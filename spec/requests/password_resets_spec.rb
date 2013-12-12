require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit lobby_engine.log_in_path
    click_link "password_forgotten_link"
    fill_in "email", :with => user.email
    click_button "send_new_password_button"
    current_path.should eq lobby_engine.log_in_path
    page.should have_content( I18n.t( "lobby.password_forgotten.order_new_password.flash.success" ))
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit lobby_engine.log_in_path
    click_link "password_forgotten_link"
    fill_in "email", :with => "diese.mail@gibt.es.nicht.de"
    click_button "send_new_password_button"
    current_path.should eq lobby_engine.log_in_path
    last_email.should be_nil
  end

  it "password recovery with password token form" do
    user = FactoryGirl.create(:user, :password_token => "ein_kleiner_token")
    visit lobby_engine.recover_password_path
    fill_in "token", :with => user.password_token
    click_button "password_token_button"
    current_path.should eq lobby_engine.recover_password_path
  end

  it "password recovery without valid token leads to token_form" do
    params = { :token => 'den_token_gibt_es_nicht' }
    visit lobby_engine.recover_password_path
    current_path.should eq lobby_engine.recover_password_path
  end

  it "password recovery with valid token leads to password recover form and user sets new pw" do
    user = FactoryGirl.create(:user, :password_token => "12345", :confirmed => Time.now)
    visit lobby_engine.recover_password_form_path(token: "12345")
    current_path.should eq lobby_engine.recover_password_form_path(token: "12345")
    fill_in "password_forgotten_form_new_password", :with => "geheim"
    fill_in "password_forgotten_form_new_password_confirmation", :with => "geheim"
    click_button "password_forgotten_form_button"
    current_path.should eq lobby_engine.log_in_path

    ## and logs in with new password
    fill_in "email", :with => user.email
    fill_in "password", :with => "geheim"
    click_button "log_in_button"
    current_path.should eq lobby_engine.root_path
  end


end
