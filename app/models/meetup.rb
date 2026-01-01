class Meetup < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :players, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :number_of_coats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  enum :game_format, { singles: 1, doubles: 2 }, validate: true
end
