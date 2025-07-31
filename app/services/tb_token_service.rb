class TbTokenService
  def initialize(request)
    @request = request
  end

  def check_token_expiration
    payload = @request.env["jwt.payload"]
    if payload && payload["exp"] && Time.at(payload["exp"]) < Time.now
      return false # Token expirado
    end
    true # Token válido
  end

  def has_scope?(scopes)
    # Verificar se o token está expirado
    unless check_token_expiration
      return false # Se expirado, retorna false
    end

    payload = @request.env["jwt.payload"]
    user_scopes = payload && payload["scope"].to_s.split
    return false unless user_scopes && scopes.is_a?(Array)
    (user_scopes & scopes).any?
  end

  def token_expired?
    payload = @request.env["jwt.payload"]
    if payload && payload["exp"] && Time.at(payload["exp"]) < Time.now
      return true
    end
    false
  end
end
