class Emergency < ActiveRecord::Base
  self.primary_key = :code

  has_many :responders, foreign_key: 'emergency_code'

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_create :dispatch_responders

  def self.full_responses
    [1, 3]
  end

  def self.find(arg)
    find_by(code: arg) || raise(ActiveRecord::RecordNotFound)
  end

  def to_param
    code
  end

private

  def dispatch_responders
    Dispatcher.new(self).handle
  end
end
