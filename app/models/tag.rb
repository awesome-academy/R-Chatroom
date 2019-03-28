class Tag < ApplicationRecord
  belongs_to :message
  belongs_to :tagged, class_name: User.name
end
