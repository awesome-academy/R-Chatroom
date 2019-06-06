class Message < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :room, optional: true
  belongs_to :receiver, class_name: User.name, optional: true

  has_many :tags
  has_many :last_reads
  has_many :notifications
  has_one_attached :attachment

  validates :content, presence: true

  scope :find_by_room, ->(id){where room_id: id}
  scope :find_less_than_id, ->(id){where "id < ?", id}
  scope :find_more_than_id, ->(id){where "id > ?", id}
  scope :find_by_range_id, ->(less_than_id, more_than_id){where "id < ? AND id > ?", less_than_id, more_than_id}

  def Message.format_message message
    formatted_message = {
      id: message.id,
      user_id: message.user_id,
      room_id: message.room_id,
      show_name: message.user.show_name,
      username: message.user.user_name,
      content: message.content,
      created_at: message.created_at,
      updated_at: message.updated_at
    }
    if message.attachment.attached?
      formatted_message[:attachment_filename] = message.attachment.filename
      formatted_message[:attachment_byte_size] = message.attachment.byte_size
      formatted_message[:attachment_content_type] = message.attachment.content_type
      formatted_message[:attachment_url] = Rails.application.routes.url_helpers
        .rails_blob_path(message.attachment, only_path: true)
      if message.attachment.image?
        formatted_message[:attachment_thumb] = Rails.application.routes.url_helpers
          .rails_representation_url(
            message.attachment.variant(resize: "200x200").processed,
            only_path: true
          )
      end
    end
    return formatted_message
  end

  def Message.format_messages messages
    messages.map do |message|
      Message.format_message message
    end
  end

  def total_messages_behind
    Message.find_by_room(room.id).find_less_than_id(id).count
  end
end
