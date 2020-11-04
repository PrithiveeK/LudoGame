class InvitedPlayer < ApplicationRecord
  belongs_to :invite
  belongs_to :user

  def self.all_joined?
    where(claimed: false).count == 0
  end
end
