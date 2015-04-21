class ApplicationController < ActionController::Base
private

  def process(action, *args)
    super
  rescue AbstractController::ActionNotFound,
         ActiveRecord::RecordNotFound
    render_404
  end

  rescue_from(ActionController::UnpermittedParameters) do |up|
    render json: {
      message: "found unpermitted parameter: #{up.params.join(', ')}"
    }, status: 422
  end

  def render_404
    render json: { message: "page not found" }, status: 404
  end

end
