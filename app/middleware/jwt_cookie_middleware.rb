class JwtCookieMiddleware
  JWT_COOKIE = "jwt_token"

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    # warden-jwt_auth middleware adds JWT to Authorization response header after sign_in.
    # We move it to an httpOnly cookie so JS cannot read it.
    auth_header = headers["Authorization"]
    if auth_header&.start_with?("Bearer ")
      token    = auth_header.delete_prefix("Bearer ")
      max_age  = 24 * 3600
      secure   = env["rack.url_scheme"] == "https" ? "; Secure" : ""
      cookie   = "#{JWT_COOKIE}=#{token}; HttpOnly; SameSite=Strict; Path=/; Max-Age=#{max_age}#{secure}"

      existing = headers["Set-Cookie"]
      headers["Set-Cookie"] = existing ? "#{existing}\n#{cookie}" : cookie
      headers.delete("Authorization")
    end

    # On sign_out the controller deletes the cookie via ActionDispatch — nothing extra needed here.

    [status, headers, body]
  end
end
