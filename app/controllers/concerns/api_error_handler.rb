module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found_error
    rescue_from ArgumentError, with: :handle_argument_error
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing_error
  end

  private
  
  def handle_standard_error(exception)
    Rails.logger.error("Unexpected error: #{exception.class} - #{exception.message}")
    Rails.logger.error(exception.backtrace.join("\n"))

    message = "Conversion failed: #{exception.message}"
    render_error(message, :internal_server_error)
  end

  def handle_validation_error(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_not_found_error(exception)
    message = exception.respond_to?(:model) && exception.model.present? ? "#{exception.model} not found" : exception.message
    render_error(message, :not_found)
  end

  def handle_argument_error(exception)
    render_error(exception.message, :unprocessable_entity)
  end

  def handle_parameter_missing_error(exception)
    render_error("Missing required parameter: #{exception.param}", :bad_request)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end