class Transaction < ApplicationRecord
  validates :amount, presence: true
  validates :description, presence: true
  validates :date, presence: true
end
