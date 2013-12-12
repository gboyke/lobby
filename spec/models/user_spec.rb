require 'spec_helper'

describe User do

  before(:each) do
    @user = FactoryGirl.build(:user)
  end

  it "should have an email field" do
    @user.should respond_to(:email)
  end

  it "should have an username field" do
    @user.should respond_to(:username)
  end

  it "should be valid when created by factory" do
    @user.should be_valid
  end

  it "should be invalid without email" do
    @user.email = nil
    @user.should_not be_valid
  end

  it "should be invalid without username" do
    @user.username = nil
    @user.should_not be_valid
  end

  it "should only accept real emails" do
    @user.email = nil

    [ 'foo', 'foo.org', 'foo@.org', 'foo@', 'foo@@bar.org', '@bar.org' ].each do |email|
      @user.email = email
      @user.should_not be_valid
    end

    @user.email = 'foo@bar.org'
    @user.should be_valid
  end


  it "email address should be unique" do
    same_email = 'foo@bar.org'

    @user.email = same_email
    @user.confirmed = Time.now
    @user.save

    @other_user = FactoryGirl.build( :user, :username => "this-is-a-unique-username", :email => same_email )
    @other_user.should_not be_valid

    @other_user.email = 'foo@otherbar.org'
    @other_user.should be_valid
  end


  it "username should only exist once" do
    @user.username = "guidoboyke"
    @user.save
    @user.confirm_signup!

    @other_user = FactoryGirl.build( :user, :username => "guidoboyke" )
    @other_user.should_not be_valid

    @other_user.username = 'nickknatterton'
    @other_user.should be_valid
  end



  it 'should authenticate valid user' do
    @user.save

    @user.authenticate( @user.password ).should be @user
    @user.authenticate( '' ).should be false
  end

  it 'should be confirmable' do
    @user.should respond_to( :confirm_signup! )
    @user.should respond_to( :confirmed? )

    @user.confirmed?.should be false
    @user.confirm_signup!
    @user.confirmed?.should be true
  end

  it 'has confirmation token' do
    @user.save
    @user.send_registration
    @user.signup_token.should match /^[\da-z]{26}$/
  end

  describe "#send_password_reset" do
    let(:user) { FactoryGirl.create(:user) }

    it "generate a unique password_token each time" do
      user.send_password_reset
      last_token = user.password_token
      user.send_password_reset
      user.password_token.should_not eq(last_token)
    end

    it "delivers email to user" do
      user.send_password_reset
      last_email.to.should include(user.email)
    end
  end

  describe "User (active field)" do

    it "has an active field" do
      @user.should respond_to(:active)
    end

    it "is active after registration confirmation" do
      @user.confirm_signup!
      @user.active.should be_true
    end
  end


end
