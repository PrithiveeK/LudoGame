class MoveRecord < ApplicationRecord
  belongs_to :game_record

  scope :finished, -> { where(:last_position => 56)}

  def move_piece!(dice)
    return self.update_attribute(:last_position, self.last_position + dice) if self.last_position != -1
    return self.update_attribute(:last_position, 0)
  end

  def kill_piece!
    self.update_attribute(:last_position, -1)
  end
end
