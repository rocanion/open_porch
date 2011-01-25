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
    @user = User.authenticate(self.email, self.password) if self.valid?
  end
  
  def to_key
    nil
  end
end
