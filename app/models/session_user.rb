class SessionUser
  include ActiveModel::Validations
  
  # == Attribute ==========================================================

  attr_accessor :email
  attr_accessor :password
  attr_accessor :remember_me
  attr_accessor :user
  
  # == Validations ==========================================================

  validates :email,
    :presence => {:message => 'Please enter your email address'},
    :length => {
      :within => 6..100,
      :too_short => "The email address you entered is to short"
    },
    :format => {
      :with => /^([\w.%-+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
      :message => 'The email address you entered is not valid'
    }
    
  validates :password,
    :length => {
      :within => 4..40,
      :too_short => "The password you entered is too short (minimum is 4 characters)"
    },
    :presence => { 
      :message => 'Please choose a password'
    },
    :confirmation => {:message => "The password you entered does not match with the confirmation"}
    
  # == Class Methods ========================================================
  
  def self.create(params={})
    session_user = self.new(params)
    session_user.save
    session_user
  end
  
  # == Instance Methods =====================================================
  
  def initialize(params = {})
    if params
      @email = params[:email]
      @password = params[:password]
      @remember_me = params[:remember_me]
    end
  end
  
  def save
    return unless self.valid?
    if @user = User.authenticate(self.email, self.password) 
      if @user.is_verified?
        return @user
      else
        @user.email_verification_key ||= @user.set_email_verification_key
        @user.save!
        self.errors.add(:email, "This email address needs to be verified before you can login. <a href='/resend-email-verification/#{@user.email_verification_key}'>Resend verification</a>".html_safe)
        return false
      end
    end
  end
  
  def to_key
    nil
  end
end
