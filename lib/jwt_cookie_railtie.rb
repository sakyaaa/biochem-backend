require_relative "../app/middleware/jwt_cookie_middleware"

class JwtCookieRailtie < Rails::Railtie
  # devise-jwt registers Warden::JWTAuth::Middleware in 'devise-jwt-middleware'.
  # By running after it, JwtCookieMiddleware is inserted BEFORE it in the stack
  # (outermost), so it wraps TokenDispatcher and sees the Authorization header
  # that warden-jwt_auth adds to the response.
  initializer "jwt_cookie_middleware.insert", after: "devise-jwt-middleware" do |app|
    app.middleware.insert_before Warden::JWTAuth::Middleware, JwtCookieMiddleware
  end
end
