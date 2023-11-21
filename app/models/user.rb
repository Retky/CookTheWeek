class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes, dependent: :destroy
  has_many :shop_lists, dependent: :destroy
  has_many :meals, dependent: :destroy
  has_many :user_ingredients, dependent: :destroy
  has_many :ingredients, through: :user_ingredients

  validates :username, presence: true, uniqueness: true, length: { maximum: 21 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
