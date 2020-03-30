module Secured
  def authenticate_user!
    token_regex = /Bearer (\w+)/
    headers = request.headers
    if headers['HTTP_AUTHORIZATION'].present? && headers['HTTP_AUTHORIZATION'].match(token_regex)
      token = headers['HTTP_AUTHORIZATION'].match(token_regex)[1]
      if (Current.user = User.find_by(auth_token: token))
        return
      end
    end
    render json: {error: 'Unauthorized'}, status: :unauthorized
  end
end