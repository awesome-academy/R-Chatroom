FactoryBot.define do
  factory :room do
    room_name {Faker::Internet.unique.user_name(6..18)}
    show_name {Faker::Name.unique.name}
    description {Faker::Lorem.paragraphs(rand(6)).join("\n\n")}
  end
end
