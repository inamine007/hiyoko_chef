module AuthHelper
  def auth_headers(user)
    post '/auth/sign_in', params: {email:user['email'], password: 'password'}
    { 'Content-Type' => 'application/json', 'uid'=>response.header['uid'], 'client'=>response.header['client'], 'access-token'=>response.header['access-token'] }
  end

  def auth_form_headers(user)
    post '/auth/sign_in', params: {email:user['email'], password: 'password'}
    { 'Content-Type' => 'multipart/form-data', 'uid'=>response.header['uid'], 'client'=>response.header['client'], 'access-token'=>response.header['access-token'] }
  end
end