class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,:omniauthable,
  :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
  omniauth_providers: [:facebook]
  
  has_one :user_record
  has_many :created_games, dependent: :nullify, :class_name => "Game", :foreign_key => "created_by_id"
  validates :username, presence: true
  has_many :game_records, :class_name => "GameRecord", :foreign_key => "player_id"
  has_many :games, :class_name => "Game", through: :game_records
  has_many :orders
  has_many :products, through: :orders

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.name
      user.passord = Devise.friendly_token[0,20]
    end
  end

  def can_access_game?(code)
    return games.find_by_code(code)
  end

  def find_next_game(time)
    games.where("scheduled_at < ? and join_window > ?", time, time).first
  end

end
