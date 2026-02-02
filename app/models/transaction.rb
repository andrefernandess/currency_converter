class Transaction < ApplicationRecord
  belongs_to :user
  VALID_CURRENCIES = %w[BRL USD EUR JPY].freeze

  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :from_currency, presence: true, inclusion: { in: VALID_CURRENCIES }
  validates :to_currency, presence: true, inclusion: { in: VALID_CURRENCIES }
  validates :from_value, presence: true, numericality: { greater_than: 0 }
  validates :to_value, presence: true, numericality: { greater_than: 0 }
  validates :rate, presence: true, numericality: { greater_than: 0 }

  validate :currencies_must_be_different

  private

  def currencies_must_be_different
    if from_currency.present? && to_currency.present? && from_currency == to_currency
      errors.add(:to_currency, "must be different from origin currency")
    end
  end
end
