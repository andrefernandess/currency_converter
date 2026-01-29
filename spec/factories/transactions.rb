FactoryBot.define do
  factory :transaction do
    user_id { 123 }
    from_currency { 'USD' }
    to_currency { 'BRL' }
    from_value { 100.0 }
    to_value { 525.32 }
    rate { 5.2532 }
  end
end
