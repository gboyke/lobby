module Lobby
  class PasswordForgottenFormAbstract
    include ActiveModel::Model

    attr_accessor :new_password

    validates :new_password, length: { minimum: 5 }
    validates :new_password, confirmation: true

    USER_CLASS = "User"

    def user_class
      proc{ self.class::USER_CLASS.constantize}.call
    end

    def user_object
      @user_object ||= (@token.present?)? user_class.where(password_token: @token).first : nil
    end

    def initialize(token)
      @token = token
    end

    def submit(params)
      self.new_password = params[:new_password]
      self.new_password_confirmation = params[:new_password_confirmation]

      if valid?
        user_object.password = new_password
        user_object.password_confirmation = new_password_confirmation
        user_object.password_token = nil
        user_object.save!
        true
      else
        false
      end
    end

    def method_missing(m, *args, &block)
      if m == self.user_class.name.downcase.to_sym
        send("user_object")
      else
        super
      end
    end
  end
end
