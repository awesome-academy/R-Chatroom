User.create! user_name: "tranxuanthang",
  show_name: "Trần Xuân Thắng",
  email: "tranthang.yb@outlook.com",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now

User.create! user_name: "cauvang",
  show_name: "Cậu Vàng",
  email: "cauvang@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now

User.create! user_name: "laohac",
  show_name: "Lão Hạc",
  email: "laohac@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now

User.create! user_name: "cuudolly",
  show_name: "Cừu Dolly",
  email: "cuudolly@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now

User.create! user_name: "bachtuyet",
  show_name: "Bạch Tuyết",
  email: "bachtuyet@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  activated: true,
  activated_at: Time.zone.now

25.times do
  User.create! user_name: Faker::Internet.unique.user_name,
    show_name: Faker::Name.name,
    email: Faker::Internet.free_email,
    password: "123456",
    password_confirmation: "123456",
    activated: true,
    activated_at: Time.zone.now
end

users = User.all.take 15

users.each do |user|
  3.times do
    word = Faker::Internet.unique.domain_word
    room = Room.new room_name: word,
      show_name: word.upcase,
      description: Faker::Lorem.paragraphs(rand(6)).join("\n\n")
    room.user_created_id = user.id
    room.save
  end
end

rooms = Room.all.take(15)
rooms.each do |room|
  rand(56).times do
    offset = rand(User.count)
    rand_user = User.offset(offset).first

    rand_user.join_room room

    message = Message.new user_id: rand_user.id,
      room_id: room.id,
      content: Faker::Quotes::Shakespeare.as_you_like_it_quote
    message.save
  end
end
