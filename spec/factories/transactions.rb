FactoryBot.define do
  factory :transaction do
    user_id { 1 }
    from_currency { "MyString" }
    to_currency { "MyString" }
    from_value { "9.99" }
    to_value { "9.99" }
    rate { "9.99" }
  end
end
