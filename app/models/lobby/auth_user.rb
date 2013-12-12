module Lobby
  module AuthUser

    def self.included(base)
      base.has_secure_password

      base.validates :email, presence: true
      base.validates :email, format: {with: EMAIL_REGEX, multiline: true}, if: Proc.new { |u| u.email.present? }
      base.validates :email, uniqueness: true, :unless => :confirmed_duplicate_email, :on => :create, if: Proc.new { |u| u.email.present? }
      base.validates :password, length: { minimum: 5 }, :on => :create, if: Proc.new { |u| u.password.present? }

      base.validates :username, presence: true
      base.validates :username, uniqueness: true, :unless => :confirmed_duplicate_username, :on => :create

      base.extend ClassMethods
    end


    module ClassMethods
      def confirmed
        where("confirmed IS NOT NULL")
      end

      def with_email(email)
        where(:email => email)
      end

      def with_username(username)
        where(:username => username)
      end

    end


    def confirmed_duplicate_email(test_mail = self.email)
      if ((self.class.name.constantize.confirmed.with_email(test_mail).count == 0) ||
          (self.class.name.constantize.with_email(test_mail).count == 0))
        true
      else
        false
      end
    end

    def confirm_signup!
      update_attribute(:confirmed, Time.now)
      update_attribute(:signup_token, nil)
      update_attribute(:active, true)
    end

    def confirmed?
      !self.confirmed.nil?
    end

    def active?
      self.active == true
    end

 # attr_accessible :username

    def confirmed_duplicate_username(test_username = self.username)
      if ((User.confirmed.with_username(test_username).count == 0) ||
          (User.with_username(test_username).count == 0))
        true
      else
        false
      end
    end

    # Wenn der User sich registriert, dann wird ein signup_token für ihn hinterlegt.
    # Dieser Token wird per Mail verschickt. Der User kann sich nun per Klick auf den
    # Tokenlink verifizieren. Sollte die Mail nicht mehr erreichbar sein, so kann der User
    # unter Angabe seiner Email einen neuen signup_Token anfordern. Der alte Token ist
    # ab diesem Zeitpunkt ungültig.

    # Nach erfolgreicher Verifizierung der Email-Adresse) wird das
    # Feld confirmed mit einem Datum gefüllt. Ab diesem Zeitpunkt kann keine neuer
    # Confirmation-Token generiert und verschickt werden.

    def tokenmail(request)
      ConfirmationMailer.send(request, self).deliver
    end

    def send_password_reset(with_mail = true)
      return unless generate_token(:password_token)
      if with_mail
        tokenmail(:send_password_reset)
      end
    end

    def send_registration
      return unless generate_token(:signup_token)
      tokenmail(:registration)
    end

    def resend_signup_token
      return unless (!confirmed? && generate_token(:signup_token))
      tokenmail(:resend_signup_token)
    end


    private

    def generate_token( token )
      (defined?( token ) && update_attribute( token, SecureRandom.hex(13) ))? true : false
    end
  end
end
