class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: { message: 'Successful sign up' }
  end

  def register_failed
    render json: { message: 'An error occured while signing up' }
  end
end