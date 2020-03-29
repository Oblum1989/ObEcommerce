FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::FunnyName.name }
  end
end
