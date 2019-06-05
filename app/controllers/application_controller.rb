class ApplicationController < ActionController::API
  include Pagy::Backend

  rescue_from CanCan::AccessDenied do |exception|
    @error_message = exception.message
    render :error, status: :unauthorized
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    @error_message = exception.message
    render :error, status: :unprocessable_entity
  end
end
