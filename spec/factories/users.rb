FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::FunnyName.name }
    auth_token { "xxxxx" }
  end
end
