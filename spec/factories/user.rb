FactoryBot.define do
  factory :user do
    user_name {Faker::Internet.unique.user_name}
    show_name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password {"123456"}
    password_confirmation {"123456"}
  end
end
