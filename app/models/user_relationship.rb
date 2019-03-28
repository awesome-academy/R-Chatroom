class UserRelationship < ApplicationRecord
  belongs_to :relating, class_name: User.name
  belongs_to :related, class_name: User.name
end
