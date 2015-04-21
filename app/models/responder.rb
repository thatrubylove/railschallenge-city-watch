class Responder < ActiveRecord::Base
  self.primary_key = :name

  belongs_to :emergency, foreign_key: 'emergency_code'

  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: (1..5)
  validates :type, presence: true

  scope :by_type,     ->(type) { where(type: type) }
  scope :by_capacity, ->(cap)  { where(capacity: cap) }
  scope :available,   ->       { where(emergency: nil).on_duty }
  scope :on_duty,     ->       { where(on_duty: true) }

  def self.find(arg)
    find_by(name: arg) || raise(ActiveRecord::RecordNotFound)
  end

  def self.capacities
    [Fire, Police, Medical].reduce({}) do |acc, responder|
      acc.merge(responder.to_s => capacity_for(responder))
    end
  end

  def self.capacity_for(type)
    [
      type.sum(:capacity),
      type.available.sum(:capacity),
      type.on_duty.sum(:capacity),
      type.available.on_duty.sum(:capacity)
    ]
  end

  def to_param
    name
  end
end
