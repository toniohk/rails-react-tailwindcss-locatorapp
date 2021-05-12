class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :locations
  ROLES = %w[admin manager]

  def role_symbols
    [role.to_sym]
  end

  def admin?
    role == "admin"
  end

  def manager?
    role == "manager"
  end

  def self.search(search)
    users = all # for not existing search params
    users = users.where("LOWER(email) like LOWER('%#{search}%') OR LOWER(role) like LOWER('%#{search}%')") if search
    users
  end
  
  # ensure user account is active  
  def active_for_authentication?  
    super && !deleted_at  
  end
  
  # provide a custom message for a deleted account   
  def inactive_message   
    !deleted_at ? super : :deleted_account  
  end
end
