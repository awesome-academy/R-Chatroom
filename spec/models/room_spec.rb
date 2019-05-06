require "rails_helper"

RSpec.describe Room do
  let(:user_created) {FactoryBot.create :user}
  subject {FactoryBot.create :room, user_created_id: user_created.id}

  it {is_expected.to be_valid}

  context "room_name" do
    it {is_expected.to validate_presence_of(:room_name)}
    it {is_expected.to validate_length_of(:room_name)}
    it {is_expected.to allow_value("this.is-A_valid_username").for(:room_name)}
    it {is_expected.not_to allow_value("this is ^not valid").for(:room_name)}
    it {is_expected.to validate_uniqueness_of(:room_name).case_insensitive}
  end

  context "show_name" do
    it {is_expected.to validate_presence_of(:show_name)}
    it {is_expected.to validate_length_of(:show_name)}
  end

  context "description" do
    it {is_expected.to validate_length_of(:description)}
    it {is_expected.to allow_value("", nil).for(:description)}
  end

  context "associations" do
    it {is_expected.to have_many(:messages)}
    it {is_expected.to have_many(:room_members)}
    it {is_expected.to have_many(:admin_members)
      .conditions(admin: true)
      .class_name(:RoomMember)
    }
    it {is_expected.to have_many(:users).through(:room_members)}
    it {is_expected.to have_many(:admins).through(:admin_members)}
  end

  context "scopes" do
    let!(:room_1) {FactoryBot.create :room, show_name: "Room BAB", user_created_id: user_created.id}
    let!(:room_2) {FactoryBot.create :room, show_name: "Room ABA", user_created_id: user_created.id}

    it {expect(Room.order_by_name).to eq([room_2, room_1])}
    it {expect(Room.find_by_name("BAB")).to eq([room_1])}
  end

  context "methods" do
    let(:user_1) {FactoryBot.create :user}
    let(:user_2) {FactoryBot.create :user}

    describe "#has_joined?" do
      it {expect(subject.has_joined?(user_1)).not_to be(true)}
      it {
        user_2.join_room subject
        expect(subject.has_joined?(user_2)).to be(true);
      }
      it {expect(subject.has_joined?(user_created)).to be(true)}
    end

    describe "#is_admin?" do
      it {expect(subject.is_admin?(user_1)).not_to be(true)}
      it {expect(subject.is_admin?(user_created)).to be(true)}
    end

    describe "#kick" do
      it {
        user_1.join_room subject
        expect {subject.kick(user_1)}.to change {subject.has_joined?(user_1)}
          .from(true).to(false)
      }
    end

    describe "#downcase_room_name" do
      it {
        subject.room_name = "THisIsSparta"
        expect {subject.save}.to change(subject, :room_name)
          .from("THisIsSparta")
          .to("thisissparta")
      }
    end
  end
end
