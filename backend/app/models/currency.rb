class Currency < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :exchange_rate, presence: true, numericality: { greater_than: 0 }
end
