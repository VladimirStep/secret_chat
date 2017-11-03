class JWTCoder
  def self.encode(payload, expiration = 24.hours.from_now)
    payload[:exp] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.jwt_secret)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.jwt_secret).first
  rescue
    nil
  end
end