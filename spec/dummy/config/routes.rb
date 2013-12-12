Rails.application.routes.draw do

  mount Lobby::Engine => "/", :as => "lobby_engine"

end
