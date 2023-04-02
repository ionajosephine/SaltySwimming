class SwimLog < ApplicationRecord
  belongs_to :user
  belongs_to :spot, optional: true
end
