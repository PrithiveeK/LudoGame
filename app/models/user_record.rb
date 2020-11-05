class UserRecord < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  belongs_to :user
  belongs_to :default_piece, :class_name => "Product"

  def add_points(points)
    self.update_attribute(:points, self.points + points)
  end

  def chech_and_raise_level
    self.update_attribute(:level, (self.points / 20).to_i + 1)
  end
end
