module Lobby
  class ConfirmationController < ApplicationController

    def registration
      @user = User.where( :signup_token => params[:token] ).first unless params[:token].nil?

      if @user
        @user.confirm_signup!
        redirect_to log_in_url, flash: { success: t( '.flash.success' ) }
      else
        flash.now[:notice] = t( '.flash.error') if params[:token]
      end
    end

    #
    # User has lost email with signup token. we send this email again.
    #

    def resend_signup_token
      flash[:notice] = nil
      @user = User.find_by_email(params[:email])
      if @user && @user.authenticate(params[:password])
        if @user.resend_signup_token
          redirect_to log_in_url, flash: { success: t( '.flash.success' ) }
        else
          redirect_to log_in_url, flash: { danger: t( '.flash.error' ) }
        end
      end
    end


    def new_email
      @user = User.find_by_new_email_token( params[:token] ) unless params[:token].nil?
      if @user
        if @user.confirm_new_email!
          redirect_to( root_url, :notice => t( '.flash.success' ))
        else
          flash[:notice] = t( '.flash.error' )
        end
      else
        render :new_email_token
      end
    end

  end
end
