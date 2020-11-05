class GameRecord < ApplicationRecord
  belongs_to :game
  belongs_to :player, :class_name => "User"
  has_many :move_records

  def self.all_joined?
    where(:has_joined => false).count == 0
  end

  def self.finished_players
    where(place: !nil).count
  end

  def self.who_are_playing
    where(has_joined: true).order(:which_player)
  end

  def piece_position(piece_name)
    move_records.find_by(piece: piece_name)
  end

  def player_home!(which_player, place)
    self.find_by(which_player: which_player).update_attribute(:place, place)
  end

  def has_finished?
    self.move_records.finished.count == 4
  end
end
