class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    #payload => {beef: 'steak'}
    JWT.encode(payload, 'my_s3cr3t')
    #jwt string:
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token(token)
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'my_s3cr3t')[0]
      rescue JWT::DecodeError
        nil
      end
    end
  end

def currentUser
  if decoded_token
    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end
end

def logged_in?
  !!currentUser
end

def authorized
  render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
end

end
