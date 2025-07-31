class JwtAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    auth_header = req.get_header("HTTP_AUTHORIZATION")

    if auth_header.nil?
      return [401, { "Content-Type" => "application/json" }, [{ error: "Authorization header ausente" }.to_json]]
    end

    if auth_header.start_with?("Basic ")
      # Permite passar para endpoints que usam Basic Auth (ex: /app/token)
      @app.call(env)
    elsif auth_header.start_with?("Bearer ")
      token = auth_header.split(" ", 2).last

      begin
        secret = Rails.application.secret_key_base
        decoded = JWT.decode(token, secret, false, { algorithm: "HS256" })
        payload = decoded[0]

        env["jwt.payload"] = payload
      rescue JWT::DecodeError => e
        return [401, { "Content-Type" => "application/json" }, [{ error: "Token inválido", message: e.message }.to_json]]
      end
      @app.call(env)
    else
      [401, { "Content-Type" => "application/json" }, [{ error: "Tipo de Authorization não suportado" }.to_json]]
    end

  end
end
