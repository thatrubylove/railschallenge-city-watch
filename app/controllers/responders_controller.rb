class RespondersController < ApplicationController

  def index
    if show_capacity?
      render json: { capacity: Responder.capacities }, status: 200
    else
      render json: responders, each_serializer: ResponderSerializer, status: 200
    end
  end

  def show
    render json: responder, serializer: ResponderSerializer, status: 200
  end

  def create
    if new_responder(responder_params).save
      render json: new_responder, serializer: ResponderSerializer, status: 201
    else
      render json: { message: errors_for(new_responder) }, status: 422
    end
  end

  def update
    if responder.update_attributes(responder_params)
      render json: responder, serializer: ResponderSerializer, status: 201
    else
      render json: { message: errors_for(responder)}, status: 422
    end
  end

private

  def responders
    @responders ||= Responder.all
  end

  def new_responder(attrs={})
    @responder ||= Responder.new(attrs)
  end

  def responder
    @responder ||= Responder.find(params[:id])
  end

  def errors_for(e)
    e.errors.messages.reduce({}) {|acc, (k, v)| acc.merge(k => v.sort) }
  end

  def show_capacity?
    params[:show] == "capacity"
  end

  def responder_params
    case action_name
    when 'create'
      params.require(:responder).permit(:type, :name, :capacity)
    when 'update'
      params.require(:responder).permit(:on_duty)
    end
  end
end
