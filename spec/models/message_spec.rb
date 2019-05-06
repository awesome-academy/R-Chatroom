require "rails_helper"

RSpec.describe Message do
  let(:user_created) {FactoryBot.create :user}
  let(:room_created) {FactoryBot.create :room, user_created_id: user_created.id}
  subject {FactoryBot.create :message, user_id: user_created.id, room_id: room_created.id}
  it {is_expected.to be_valid}

  context "content" do
    it {is_expected.to validate_presence_of(:content)}
  end

  context "associations" do
    it {is_expected.to belong_to(:user)}
    it {is_expected.to belong_to(:room).optional}
    it {is_expected.to belong_to(:receiver).class_name(:User).optional}

    it {is_expected.to have_many(:tags)}
    it {is_expected.to have_many(:last_reads)}
    it {is_expected.to have_many(:notifications)}
  end

  context "scopes" do
    let!(:another_user) {FactoryBot.create :user}
    let!(:room_1) {FactoryBot.create :room, user_created_id: user_created.id}
    let!(:room_2) {FactoryBot.create :room, user_created_id: another_user.id}
    let!(:message_1) {FactoryBot.create :message, user_id: another_user.id, room_id: room_1.id}
    let!(:message_2) {FactoryBot.create :message, user_id: another_user.id, room_id: room_2.id}

    it {expect(Message.find_by_room(room_2.id)).to include(message_2)}
    it {expect(Message.find_by_room(room_1.id)).not_to include(message_2)}
  end

  describe "#total_messages_behind" do
    let!(:another_user) {FactoryBot.create :user}
    let!(:room) {FactoryBot.create :room, user_created_id: user_created.id}
    let!(:message_1) {FactoryBot.create :message, user_id: another_user.id, room_id: room.id}
    let!(:message_2) {FactoryBot.create :message, user_id: another_user.id, room_id: room.id}
    let!(:message_3) {FactoryBot.create :message, user_id: another_user.id, room_id: room.id}
    let!(:message_4) {FactoryBot.create :message, user_id: another_user.id, room_id: room.id}

    it {expect(message_4.total_messages_behind).to be(3)}
    it {expect(message_3.total_messages_behind).to be(2)}
  end
end
