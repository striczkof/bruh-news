# Hasher
gem 'bcrypt'

class User < ApplicationRecord
  # Hardcoded admins, will be set as admins when they register with the following usernames
  HARDCODED_ADMINS = %w[admin max]
  before_create :set_defaults

  # Hash password
  has_secure_password

  # Relations
  has_many :comments, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  def set_defaults
    self[:is_admin] = HARDCODED_ADMINS.include? self[:username] if self[:is_admin].blank?
    self[:is_banned] = false if self[:is_banned].blank?
  end

  def can_be_demoted?(self_id: self[:id])
    true unless self[:id].equal?(self_id) || HARDCODED_ADMINS.include?(self[:username])
  end

end
