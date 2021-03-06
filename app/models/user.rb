class User < ActiveRecord::Base
  
  # == Constants ============================================================
  
  ROLES = %w{admin regular_user}
  
  # == Attributes =====================================================
  
  attr_protected :role

  # == Extensions ===========================================================

  if defined?(Wristband)
    wristband :roles => ROLES, :has_authorities => true
  end
  
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
      :with => EmailSupport::RFC822::EmailAddress, 
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
    :dependent => :nullify
  
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  
  # == Scopes ===============================================================

  # Search Scope
  scope :email_or_name_or_address_search,
    lambda {|str|
      like_str = "%#{str}%"
      where("email ILIKE ? OR ((first_name || ' ' || last_name) ILIKE ?) OR ((address || ', ' || city || ', ' || state) ILIKE ?)", 
            like_str, like_str, like_str)
    }
  
  if defined?(MetaSearch)
    search_methods :email_or_name_or_address_search 
  end
  
  scope :admins, where(:role => 'admin')
    
  # == Callbacks ============================================================

  before_validation :assign_role, :on => :create
  
  # == Class Methods ========================================================

  def self.per_page
    100
  end
  
  def self.roles_for_select
    ROLES.collect{|r| [r.humanize, r]}
  end

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
  
  def set_email_verification_key
    self.email_verification_key = Wristband::Support.random_salt.gsub(/[^A-Za-z0-9]/,'')
  end
  
  def is_verified?
    !!self.verified_at?
  end 

protected
  def assign_role
    self.role = 'regular_user'
  end
  
  def password_required?
    self.new_record?
  end

end
