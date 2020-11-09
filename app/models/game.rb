class Game < ApplicationRecord
  has_many :game_records
  has_many :move_records, through: :game_records
  belongs_to :created_by, :class_name => "User"

  scope :finished, -> { where(status: 'FINISHED') }
  scope :active, -> { where(status: 'ACTIVE')  }
  scope :online_mode, -> { where("room != ?", "self")  }
  scope :offline_mode, -> { where("room = ?", "self")  }

  def players_game_record(id)
    game_records.find_by_player_id(id)
  end

  def no_of_players
    game_records.count
  end

  def no_of_players_finished
    game_records.finished_players
  end

  def player_joined!(player_id)
    self.game_records.find_by_player_id(player_id)&.update_attribute(:has_joined, true)
  end

  def join_all!
    self.game_records.update_all(:has_joined => true)
  end

  def can_start?
    game_records.all_joined?
  end

  def game_players
    game_records.who_are_playing
  end

  def this_player(which_player)
    game_records.find_by(which_player: which_player)
  end

end
