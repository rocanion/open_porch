class User < ActiveRecord::Base
  
  # == Constants ============================================================
  
  ROLES = %w{admin regular_user content_manager}
  
  # == Attributes =====================================================
  
  attr_protected :role

  # == Extensions ===========================================================


  wristband :has_authorities => true, :roles => ROLES

  # == Validations ==========================================================
  
  validates :first_name,
    :presence => {:message => 'Please enter your first name'}
  
    validates :last_name,
      :presence => {:message => 'Please enter your last name'}

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
    :uniqueness => {:message => 'This email has already been taken'}
    
  validates :password,
    :length => {
      :within => 4..40,
      :too_short => "The password you entered is too short (minimum is 4 characters)",
      :if => :password_required?
    },
    :presence => { 
      :message => 'Please choose a password',
      :if => :password_required? 
    },
    :confirmation => {:message => "The password you entered does not match with the confirmation"}
    
  validates :role, 
    :inclusion => { :in => ROLES },
    :presence => true
  
  validates :address, :city, :state,
    :presence => {
      :message => 'Please enter your full address'
    }
    
  # == Relationships ========================================================
  
  has_many :memberships,
    :dependent => :destroy
  has_many :areas,
    :through => :memberships
  has_many :posts,
    :dependent => :destroy
  
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  
  # == Scopes ===============================================================

  # == Callbacks ============================================================

  before_validation :assign_role, :on => :create
  
  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def address_attributes=(address_attr)
    if address_attr.is_a?(Address)
      self.address = address_attr.address
      self.city = address_attr.city
      self.state = address_attr.state
      self.lat = address_attr.lat
      self.lng = address_attr.lng
    end
  end
  
  def full_address
    [self.address, self.city, self.state].join(', ')
  end
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def member_of?(area)
    self.areas.include?(area)
  end
  
protected
  def assign_role
    self.role = 'regular_user'
  end
  
  def password_required?
    self.new_record?
  end
  
end
