class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,:omniauthable,
  :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null,
  omniauth_providers: [:facebook]
  
  has_one :user_record
  has_many :games, dependent: :nullify
  validates :username, presence: true
  has_many :invites
  has_many :orders
  has_many :products, through: :orders

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.name
      user.passord = Devise.friendly_token[0,20]
    end
  end

end
