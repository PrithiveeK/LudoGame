class Invite < ApplicationRecord
  belongs_to :game
  belongs_to :created_by, :class_name => "User"
  has_many :invited_players

  def self.can_start?(code)
    find_by_code(code).invited_players.all_joined?
  end
end
