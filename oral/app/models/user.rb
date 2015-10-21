# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  username             :string(255)
#  email                :string(255)
#  encrypted_password   :string(255)
#  password_salt        :string(255)
#  reset_password_token :string(255)
#  is_admin             :boolean(1)      default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :is_admin

  has_many :voices, :dependent => :destroy
  has_many :votes

  attr_accessor :password
  before_save :encrypt_password

  validates :username, :uniqueness => {:case_sensitive => true}, :presence => true
  validates :email, :uniqueness => true, :presence => true, :format => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  validates :password, :presence => { :on => :create }, :confirmation => true
  validates_length_of :password, :minimum => 6, :too_short => "please enter at least 6 characters"

  # Authenticates a user based on `email` and `password`, returns the
  # User object associated with those attributes.
  # @param [String] email the email of the user
  # @param [String] password the password of the user
  # @return [User, nil] the user object or nil
  def self.authenticate(email, password)
    user = where('username = :login or email = :login', {:login => email}).pop
    user if user &&
      user.encrypted_password == BCrypt::Engine.hash_secret(password, user.password_salt)
  end

  # Encrypts the password using bcrypt if it is present.
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  # Generates a token to reset the password
  def reset_token
    self.reset_password_token = BCrypt::Engine.generate_salt
    self.save(:validate => false)
  end

end
