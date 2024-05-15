class SessionsController < ApplicationController
  def create
      user = User.find_by(username: params[:username])

      # testing:
      # puts "Username: #{params[:username]}"
      # puts "User found: #{user.present?}"
      # puts "password: #{params[:password]}"
      # puts "Authentication result: #{user&.authenticate(params[:password])}"  # Corrected line

      if user&.authenticate(params[:password])
          token = Devise.friendly_token

          # Send the token and user
          render json: { token: token, user: user }
      else
        render json: { status: 400, error: 'Invalid username or password' }, status: :bad_request
      end
  end
end