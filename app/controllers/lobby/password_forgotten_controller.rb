module Lobby
  class PasswordForgottenController < ApplicationController

    before_action :check_token, only: [:new, :create]

    def new
    end

    def create
      if @password_forgotten_form.submit(password_forgotten_form_params)
        flash[:success] = t('.notice.success')
        redirect_to log_in_url
      else
        render "new"
      end
    end

    def order_new_password
      if params[:email]
        @user = User.where( :email => params[:email] ).first
        if @user && @user.send_password_reset
          # nothing special. Send always the same notice. so you can prevent from e-mail-guessing.
        else
          puts "*******************************"
          puts "An non-existing email was given"
          puts "*******************************"
        end
        flash[:success] = t( '.flash.success' )
        redirect_to log_in_url
      end
    end


    def check_token
      @token = params[:token]
      @password_forgotten_form = PasswordForgottenForm.new(@token)

      if @password_forgotten_form.user.blank?
        render :recover_password_auth
        false
      end
    end

    def password_forgotten_form_params
      params.require(:password_forgotten_form).permit(:new_password, :new_password_confirmation)
    end
  end
end
