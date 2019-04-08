class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room, optional: true
  belongs_to :receiver, class_name: User.name, optional: true

  has_many :tags
  has_many :last_reads
  has_many :notifications

  scope :find_by_room, ->(id){where room_id: id}
end
