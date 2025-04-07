class Event::Launch
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :match_format, :string
  attribute :number_of_coats, :integer
  attribute :number_of_players, :integer

  validates :name, presence: true, length: { maximum: 30 }
  validates :match_format, presence: true, inclusion: { in: Event.match_formats.keys }
  validates :number_of_coats, presence: true, numericality: { only_integer: true, in: 1..2 }
  validates :number_of_players, presence: true, numericality: { only_integer: true, in: 2..16 }
  # FIXME: rubocopに怒られている通り、lambdaを使った書き方はあまり可読性が高くないのでリファクタリングしたい
  # rubocop:disable all
  validates :number_of_players, numericality: { less_than_or_equal_to: ->(launch) { launch.number_of_coats * 8 } }
  validates :number_of_players, numericality: { greater_than_or_equal_to: lambda { |launch| launch.number_of_coats * 4 } }, if: lambda { match_format == "doubles" }
  validates :number_of_players, numericality: { greater_than_or_equal_to: lambda { |launch| launch.number_of_coats * 2} }, if: lambda { match_format == "singles"}
  # rubocop:enable all

  def save!
    return false if invalid?

    ApplicationRecord.transaction do
      event = Event.create!(name:, match_format:, number_of_coats:)
      Player.insert_all_default_players(event:, number_of_players:)
      Match.insert_all_default_matches(event:)
      MatchPlayer.insert_all_default_match_players(event:)
      event
    end
  end
end
