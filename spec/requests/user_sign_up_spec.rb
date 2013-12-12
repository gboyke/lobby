require 'spec_helper'

describe "UserSignUp" do

  context "no username provided" do
    it "User can sign up" do
      visit lobby_engine.sign_up_form_path
      fill_in "user_email", :with => "hallo@test.de"
      fill_in "user_username", :with => "testuser"
      fill_in "user_password", :with => "geheim"
      fill_in "user_password_confirmation", :with => "geheim"
      click_button "sign_up_button"
      page.should have_content( I18n.t( "lobby.users.create.success" ))
      current_path.should eq lobby_engine.log_in_path
    end

    [
     {:email => "test@test.de", :username => "testuser", :password => "",       :password_confirmation => "", :errortext => I18n.t( "activerecord.errors.models.user.attributes.password.blank" ) },
     {:email => "test@test.de", :username => "testuser", :password => "geheim", :password_confirmation => "", :errortext => I18n.t( "activerecord.errors.messages.confirmation")},
     {:email => "test@test.de", :username => "testuser", :password => "geheim", :password_confirmation => "gehei_", :errortext => I18n.t( "activerecord.errors.messages.confirmation")},
     {:email => "test@test.de", :username => "testuser", :password => "",       :password_confirmation => "geheim", :errortext => I18n.t( "activerecord.errors.models.user.attributes.password.blank")},
     {:email => "test@test",    :username => "testuser",    :password => "geheim", :password_confirmation => "geheim", :errortext => I18n.t( "activerecord.errors.models.user.attributes.email.invalid")},
     {:email => "testtest.de",  :username => "testuser",  :password => "geheim", :password_confirmation => "geheim", :errortext => I18n.t( "activerecord.errors.models.user.attributes.email.invalid")}
    ].each do |u|
      it "User cannot sign up with wrong parameters" do
        visit lobby_engine.sign_up_form_path
        fill_in "user_email", :with => u[:email]
        fill_in "user_username", :with => u[:username]
        fill_in "user_password", :with => u[:password]
        fill_in "user_password_confirmation", :with => u[:password_confirmation]
        click_button "sign_up_button"
        page.should have_content( u[:errortext])
      end
    end


    it "User can sign up with used email-address unless confirmed" do
      user = FactoryGirl.build(:user)
      visit lobby_engine.sign_up_form_path
      fill_in "user_email", :with => user.email
      fill_in "user_username", :with => "testuser"
      fill_in "user_password", :with => "geheim"
      fill_in "user_password_confirmation", :with => "geheim"
      click_button "sign_up_button"
      page.should have_content( I18n.t( "lobby.users.create.success" ))
    end

    it "User cannot sign up with used email-address if confirmed" do
      user = FactoryGirl.build(:user)
      user.confirm_signup!
      visit lobby_engine.sign_up_form_path
      fill_in "user_email", :with => user.email
      fill_in "user_username", :with => "testuser"
      fill_in "user_password", :with => "geheim"
      fill_in "user_password_confirmation", :with => "geheim"
      click_button "sign_up_button"
      page.should have_content( I18n.t( "lobby.users.new.title" ))
    end

  end


end
