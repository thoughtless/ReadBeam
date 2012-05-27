class User < ActiveRecord::Base
  has_many :edocs, :inverse_of => :owner, :dependent => :destroy, :foreign_key => :owner_id

  devise :registerable, :recoverable, :rememberable, :trackable, :lockable,
         :confirmable, :rememberable, :timeoutable, :database_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :account_email, :password, :password_confirmation, :remember_me,
                  :turing, :device, :format, :device_email, :timezone

  before_create :derive_format

  validates :account_email, :uniqueness => true, :presence => true, :email => true
  validates :device_email, :uniqueness => true, :allow_blank => true, :email => true
  validates :password, :confirmation => true, :length => { :in => 5..20 }
  #Turing test - if form field is filled, it's a robot
  validates :username, :length => { :is => 0 }

  # Alias key attribute for devise to :recognize account_email as :email
  alias_attribute :email, :account_email

  def derive_format
    case device
    when 'kindle', 'kindle_dx' then self.format = 'mobi'
    else self.format = 'epub'
    end
  end

  # Email address to use for distribution
  def distribution_email
    self.device_email.presence || self.account_email
  end
end