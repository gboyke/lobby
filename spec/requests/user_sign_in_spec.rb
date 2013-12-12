require 'spec_helper'

describe "UserSignIn" do

  before(:each) do
    @user = FactoryGirl.create(:user, :confirmed => nil)
    visit lobby_engine.log_in_path
    fill_in "email", :with => @user.email
    fill_in "password", :with => @user.password
  end

  it "Signed up user cannot login if not confirmed" do
    click_button "log_in_button"
   # page.should have_content( I18n.t( "sessions.create.flash.error.not_confirmed" ))
    current_path.should eq lobby_engine.confirm_path(:action => :registration)
  end

  it "Signed up user cannot login if not active" do
    @user.confirm_signup!
    @user.active = false
    @user.save
    click_button "log_in_button"
   # page.should have_content( I18n.t( "sessions.create.flash.error.not_active" ))
    current_path.should eq lobby_engine.log_in_path
  end

  it "Signed up user can sign in" do
    @user.confirm_signup!
    click_button "log_in_button"
   # page.should have_content( I18n.t( "sessions.create.flash.success" ))
    current_path.should eq lobby_engine.root_path
  end

  it "Signed up user can sign in with username and password" do
    fill_in "email", :with => @user.username
    @user.confirm_signup!
    click_button "log_in_button"
   # page.should have_content( I18n.t( "sessions.create.flash.success" ))
    current_path.should eq lobby_engine.root_path
  end

end
