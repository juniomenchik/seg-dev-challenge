class TbTokenService
  def initialize(payload)
    @payload = payload
  end

  def get_from_jwt(key)
    @payload[key]
  end

end
