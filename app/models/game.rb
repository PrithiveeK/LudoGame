class Game < ApplicationRecord
  belongs_to :player1, :class_name => "User"
  belongs_to :player2, :class_name => "User"
  belongs_to :player3, :class_name => "User"
  belongs_to :player4, :class_name => "User"
  has_one :invite, dependent: :nullify
  has_many :invited_players, through: :invite
  has_one :game_record
  has_many :move_records

  def am_i_a_player?(id)
    return self.player1_id == id || self.player2_id == id || self.player3_id == id || self.player4_id == id
  end

  def which_player(id)
    return "Player1" if self.player1_id == id
    return "Player2" if self.player2_id == id
    return "Player3" if self.player3_id == id
    return "Player4" if self.player4_id == id
    return nil
  end

  def no_of_players
    invited_players.count
  end

  def has_finished(player)
    case player
    when "Player1"
      self.player1_id == nil || self.game_record.player1 != nil
    when "Player2"
      self.player2_id == nil || self.game_record.player2 != nil
    when "Player3"
      self.player3_id == nil || self.game_record.player3 != nil || true
    when "Player4"
      self.player4_id == nil || self.game_record.player4 != nil || true
    end
  end

  def no_of_players_finished
    count = 0
    count = count + 1 if self.has_finished("Player1")
    count = count + 1 if self.has_finished("Player2")
    count = count + 1 if self.has_finished("Player3")
    count = count + 1 if self.has_finished("Player4")
    count
  end

end
