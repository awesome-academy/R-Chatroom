class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :receiver, class_name: User.name

  has_many :tags
  has_many :last_reads
  has_many :notifications
end
