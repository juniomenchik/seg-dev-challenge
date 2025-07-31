class TbTokenService
  def initialize(request)
    @request = request
  end

  def has_scope?(scopes)
    payload = @request.env["jwt.payload"]
    user_scopes = payload && payload["scope"].to_s.split
    return false unless user_scopes && scopes.is_a?(Array)
    (user_scopes & scopes).any?
  end

end
