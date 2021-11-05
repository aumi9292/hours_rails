class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'You are logged in.' }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: "You are logged out." }, status: :ok
  end

  def log_out_failure
    render json: { message: "Hmm nothing happened."}, status: :unauthorized
  end
end

# the below was working with post requests made in Postman, but does not account for any token authentication
# class SessionsController < ApplicationController
#   def create
#     user = User.where(email: params[:email]).first

#     if user && user.valid_password?(params[:password])
#       render json: user.as_json
#     else
#       head(:unauthorized)
#     end
#   end

#   def destroy
#   end
# end