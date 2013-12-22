module Lobby
  require "lobby/engine"
  require "../../app/models/lobby/authentication"
  require "../../app/models/lobby/auth_user"
  require "../../app/models/lobby/password_forgotten_form_abstract"
  require "../../app/mailers/lobby/confirmation_mailer"
  require "../../app/forms/lobby/password_forgotten_form"
  require "../../app/controllers/lobby/confirmation_controller"
  require "../../app/controllers/lobby/password_forgotten_controller"
  require "../../app/controllers/lobby/sessions_controller"
  require "../../app/controllers/lobby/users_controller"
end
