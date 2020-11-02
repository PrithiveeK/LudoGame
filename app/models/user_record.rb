class UserRecord < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  belongs_to :user

  def self.online_users
    where(is_online: true).count
  end
end
