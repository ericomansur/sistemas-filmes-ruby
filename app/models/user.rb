class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :preference, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :watch_laters, dependent: :destroy

  after_create :create_default_preference

  private

  def create_default_preference
    create_preference
  end
end