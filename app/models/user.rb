class User < ActiveRecord::Base
  
  # == Constants ============================================================
  
  ROLES = %W{admin regular_user}
  
  # == Extensions ===========================================================

  wristband :roles => ROLES

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
    },
    :uniqueness => true
    
  validates :password,
    :length => {
      :within => 4..40,
      :too_short => "The password you entered is too short (minimum is 4 characters)"
    },
    :presence => { 
      :message => 'Please choose a password',
      :if => :password_required? 
    },
    :confirmation => {:message => "The password you entered does not match with the confirmation"}
    
  validates :role, 
    :inclusion => { :in => ROLES },
    :presence => true
  
  # == Relationships ========================================================
  
  has_many :memberships,
    :dependent => :destroy
  has_many :areas,
    :through => :memberships
  
  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def password_required?
    self.new_record?
  end
end
