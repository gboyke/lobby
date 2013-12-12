module Lobby
  class UsersController < ApplicationController

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to log_in_url, flash: {success: t( '.success' ) }
        @user.send_registration
      else
        render :new
      end
    end

    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation)
    end

  end
end
