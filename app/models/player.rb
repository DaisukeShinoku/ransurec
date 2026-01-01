class Player < ApplicationRecord
  validates :display_name, presence: true, length: { maximum: 10 }
end
