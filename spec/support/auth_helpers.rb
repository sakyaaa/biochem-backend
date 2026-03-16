module AuthHelpers
  def sign_in_as(user)
    post "/api/auth/sign_in",
         params: { api_user: { email: user.email, password: "Password123!" } }
    { "Authorization" => response.headers["Authorization"] }
  end
end
