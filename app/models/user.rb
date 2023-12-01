class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :recipes, dependent: :destroy
  has_many :shop_lists, dependent: :destroy
  has_many :meals, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { maximum: 21 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
