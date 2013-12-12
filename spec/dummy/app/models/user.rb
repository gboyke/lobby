class User < ActiveRecord::Base
  include Lobby::AuthUser
end
