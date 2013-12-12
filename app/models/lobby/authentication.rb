module Lobby
  module Authentication

    def self.included(controller)
      controller.send :helper_method, :current_user
    end

    def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

  end
end
