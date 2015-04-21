class EmergencySerializer < ActiveModel::Serializer
  attributes :id, :code, :fire_severity, :police_severity,
             :medical_severity, :resolved_at
  has_many :responders
end
