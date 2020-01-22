# TODO: 

module JwtUtils
  ISSUER = "#{APP_CONFIG['auth_domain']}"
  TOKEN_LIFE = 4.hours

  def self.encode(payload)
    data = payload.merge(base_payload((DateTime.now.utc + TOKEN_LIFE).to_i))
    JWT.encode data, private_key, 'RS256'
  end

  def self.decode(token, verify = true, algorithm = 'RS256')
    return if token.nil?
    begin
      jwt = JWT.decode token, public_key, verify, algorithm: algorithm
      return read_payload(jwt)
    rescue StandardError => e
      Rails.logger.error(event: "jwt_decode_error", error: e, token: token)
    end
    nil
  end

  def self.read_payload(payload)
    return nil if payload.nil?
    return nil if payload.first['iss'] != ISSUER

    # Remove properties we don't need to read downstream
    payload.first.except('orig_iat', 'exp', 'jti', 'iat', 'iss')
  end

  def self.get_default_payload(user_id)
    base_payload(Time.now.utc + TOKEN_LIFE).merge(user_id: user_id)
  end

  private

  def self.base_payload(expiration)
    issued_at = Time.now.utc.to_i
    not_before = (issued_at - 5.seconds).to_i
    {
      jti: SecureRandom.uuid,
      iss: ISSUER,
      iat: issued_at,
      nbf: not_before,
      exp: expiration
    }
  end

  def self.public_key
    return @public_rsa if @public_rsa
    @public_rsa = OpenSSL::PKey::RSA.new(Rails.application.credentials.JWT_PUBLIC_KEY&.gsub("\\n","\n") || ENV['JWT_PUBLIC_KEY'])
  end

  def self.private_key
    return @private_rsa if @private_rsa
    @private_rsa = OpenSSL::PKey::RSA.new(Rails.application.credentials.JWT_PRIVATE_KEY&.gsub("\\n","\n") || ENV['JWT_PRIVATE_KEY'])
  end
end