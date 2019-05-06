FactoryBot.define do
  factory :message do
    content {Faker::Quotes::Shakespeare.as_you_like_it_quote}
  end
end
