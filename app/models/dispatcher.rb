class Dispatcher
  def initialize(emergency)
    @emergency = emergency
  end

  def handle
    severities.each do |type, severity|
      responders = available_responders(type).by_capacity(severity)
      responders = available_responders(type).order(capacity: :desc) if responders.none?

      remainder = responders.reduce(severity) do |acc, responder|
        next if acc.to_i <= 0
        emergency.responders << responder
        acc - responder.capacity
      end
      emergency.update_attributes(full_response: remainder.to_i == 0)
    end
  end

private

  attr_reader :emergency

  def available_responders(type)
    Responder.by_type(type.classify.constantize).available
  end

  def severities
    { "Fire" => emergency.fire_severity,
      "Police" => emergency.police_severity,
      "Medical" => emergency.medical_severity }
  end
end
