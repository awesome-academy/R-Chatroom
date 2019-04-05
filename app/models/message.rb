class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room, optional: true
  belongs_to :receiver, class_name: User.name, optional: true

  has_many :tags
  has_many :last_reads
  has_many :notifications

  scope :find_by_room, ->(id){where room_id: id}
  scope :find_less_than_id, ->(id){where "id < ?", id}
  scope :find_more_than_id, ->(id){where "id > ?", id}
  scope :find_by_range_id, ->(less_than_id, more_than_id){where "id < ? AND id > ?", less_than_id, more_than_id}

  def total_messages_behind
    Message.find_by_room(room.id).find_less_than_id(id).count
  end
end
