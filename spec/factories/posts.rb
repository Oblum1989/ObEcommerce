FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph }
    published {
      r = rand(0..1)
      if r == 0
        false
      else
        true
      end
    }
    user
  end
end
