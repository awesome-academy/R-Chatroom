require "rails_helper"

RSpec.describe User do
  subject {FactoryBot.build :user}

  it {is_expected.to be_valid}

  context "email" do
    it {is_expected.to validate_presence_of(:email)}
    it {is_expected.to validate_length_of(:email)}
    it {is_expected.to allow_value("email@address.com").for(:email)}
    it {is_expected.not_to allow_value("blalba@@@!!").for(:email)}
    it {is_expected.to validate_uniqueness_of(:email).case_insensitive}
  end

  context "user_name" do
    it {is_expected.to validate_presence_of(:user_name)}
    it {is_expected.to validate_length_of(:user_name)}
    it {is_expected.to allow_value("this.is-a_valid_username").for(:user_name)}
    it {is_expected.not_to allow_value("this is @not valid").for(:user_name)}
    it {is_expected.to validate_uniqueness_of(:user_name).case_insensitive}
  end

  context "show_name" do
    it {is_expected.to validate_presence_of(:show_name)}
    it {is_expected.to validate_length_of(:show_name)}
  end

  context "password" do
    it {is_expected.to have_secure_password}
    it {is_expected.to validate_length_of(:password)}
  end

  context "associations" do
      it {is_expected.to have_many(:messages)}
      it {is_expected.to have_many(:user_relationships).with_foreign_key(:relating_id)}
      it {is_expected.to have_many(:relateds).through(:user_relationships)}
      it {is_expected.to have_many(:room_members)}
      it {is_expected.to have_many(:rooms).through(:room_members)}
  end

  context "scopes" do
    let!(:user_1) {FactoryBot.create :user, show_name: "Lão Hạc"}
    let!(:user_2) {FactoryBot.create :user, show_name: "Bạch Tuyết"}
    let!(:user_3) {FactoryBot.create :user, show_name: "Thúy Vân"}
    let!(:user_4) {FactoryBot.create :user, show_name: "Thúy Kiều"}

    it {expect(User.order_by_name).to eq([user_2, user_1, user_4, user_3])}
    it {expect(User.find_by_name("Thúy")).to eq([user_3, user_4])}
  end

  describe ".generate_token" do
    let(:token_1) {User.generate_token}
    let(:token_2) {User.generate_token}

    it {expect(token_1).not_to eq(token_2)}
  end

  describe "#reroll_token" do
    let(:auth_token_1) {subject.auth_token}
    let(:auth_token_2) {subject.reroll_token; subject.auth_token}

    it {expect(auth_token_1).not_to eq(auth_token_2)}
  end

  describe "#valid_token?" do
    it {
      subject.reroll_token
      expect(subject.valid_token?(subject.auth_token)).to be(true)
    }
  end

  describe "#valid_activation_token??oken" do
    it {
      subject.reroll_token
      expect(subject.valid_activation_token?(subject.activation_token)).to be(true)
    }
  end

  describe "#activate" do
    it {expect {subject.activate}.to change(subject, :activated).from(false).to(true)}
  end

  describe "#downcase_email" do
    it {
      subject.email = "EXAMPLE@eXample.com"
      expect {subject.save}.to change(subject, :email)
        .from("EXAMPLE@eXample.com")
        .to("example@example.com")
    }
  end

  describe "#downcase_user_name" do
    it {
      subject.user_name = "THisIsSparta"
      expect {subject.save}.to change(subject, :user_name)
        .from("THisIsSparta")
        .to("thisissparta")
    }
  end
end
