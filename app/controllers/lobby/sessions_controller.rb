module Lobby
  class SessionsController < ApplicationController
    def new
    end

    def create
      @user = User.where('email = ? OR username = ?', params[:email], params[:email]).first
      if @user && @user.authenticate(params[:password])
        if @user.confirmed?
          if @user.active?
            session[:user_id] = @user.id
            flash.now[:success] = t( '.flash.success' )
            redirect_to root_url
          else
            flash.now[:danger] = t( '.flash.error.not_active' )
            redirect_to log_in_url
          end
        else
          flash.now[:danger] = t( '.flash.error.not_confirmed' )
          redirect_to confirm_url( :action => "registration" )
        end
      else
        flash.now[:danger] = t( '.flash.error.wrong_password_or_email' )
        render :new
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url, flash: {success: t( '.success' ) }
    end
  end
end
