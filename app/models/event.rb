class Event < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :players, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :number_of_coats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  enum :match_format, { singles: 1, doubles: 2 }, validate: true

  def matches_grouped_by_sequence
    matches.order(:sequence_num, :coat_num).group_by(&:sequence_num)
  end
end
