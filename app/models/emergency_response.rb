class EmergencyResponse < ActiveRecord::Base
  belongs_to :emergency
  belongs_to :responder

  validates :emergency, :responder, presence: true
end
