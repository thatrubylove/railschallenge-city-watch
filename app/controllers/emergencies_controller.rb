class EmergenciesController < ApplicationController
  def index
    render json: {
      'emergencies' => Emergency.all,
      'full_responses' => Emergency.full_responses
    }
  end

  def show
    render json: emergency, serializers: EmergencySerializer, status: 201
  end

  def create
    if new_emergency(emergency_params).save
      render json: new_emergency, serializers: EmergencySerializer, status: 201
    else
      render json: { message: errors_for(new_emergency) }, status: 422
    end
  end

  def update
    if emergency.update_attributes(emergency_params)
      render json: { emergency: emergency }, status: 201
    else
      render json: { message: errors_for(emergency)}, status: 422
    end
  end

private

  def new_emergency(attrs={})
    @emergency ||= Emergency.new(attrs)
  end

  def emergency
    @emergency ||= Emergency.find(params[:id])
  end

  def errors_for(e)
    e.errors.messages.reduce({}) {|acc, (k, v)| acc.merge(k => v.sort) }
  end

  def emergency_params
    case action_name
    when 'create'
      params.require(:emergency).permit(:code, :fire_severity, :medical_severity, :police_severity)
    when 'update'
      params.require(:emergency).permit(:fire_severity, :medical_severity, :police_severity, :resolved_at)
    end
  end
end
