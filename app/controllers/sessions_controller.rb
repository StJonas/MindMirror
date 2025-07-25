class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  def create
      user = User.find_by(username: params[:username])

      # testing:
      # puts "Username: #{params[:username]}"
      # puts "User found: #{user.present?}"
      # puts "password: #{params[:password]}"
      # puts "Authentication result: #{user&.authenticate(params[:password])}"  # Corrected line

      if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: user }, status: :ok
      else
        render json: { status: 400, error: 'Invalid username or password' }, status: :bad_request
      end
  end
end