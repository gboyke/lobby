module SpecLoginHelper

  def login(user)
    session[:user_id] = user.id
  end

  def confirm_and_login(user)
    user.confirm_signup!
    login(user)
  end

  def create_logged_in_user
    @user = FactoryGirl.create(:user)
    confirm_and_login(@user)
    @user
  end

  def create_logged_in_admin
    @admin = FactoryGirl.create(:beuser)
    confirm_and_login(@admin)
    @admin
  end

  def create_member
    ApplicationController.any_instance.stub(:current_user).and_return(FactoryGirl.build(:user))
  end

  def create_wikiadmin
    ApplicationController.any_instance.stub(:current_user).and_return(FactoryGirl.build(:wikiadmin))
  end
end
