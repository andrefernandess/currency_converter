FactoryBot.define do
  factory :user do
    name { "Teste de usuario" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
