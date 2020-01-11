# TODO: 

module JwtUtils
  ISSUER = "#{APP_CONFIG['auth_domain']}"
  TOKEN_LIFE = 4.hours

  def self.encode(payload)
    JWT.encode payload.merge(base_payload((DateTime.now.utc + TOKEN_LIFE).to_i)), private_key, 'RS256'
  end

  def self.decode(token, verify = true, algorithm = 'RS256')
    jwt = JWT.decode token, public_key, verify, algorithm: algorithm
    read_payload(jwt, verify)
  end

  def self.read_payload(jwt, verify)
    payload = jwt.first
    return nil if payload.nil?
    return nil if verify && payload['iss'] != ISSUER

    # Remove properties we don't need to read downstream
    payload.except('orig_iat', 'exp', 'jti', 'iat', 'iss')
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
    @public_rsa = OpenSSL::PKey::RSA.new(APP_CONFIG['public_jwt_key'])
  end

  def self.private_key
    return @private_rsa if @private_rsa
    @private_rsa = OpenSSL::PKey::RSA.new(ENV['JWT_PRIVATE_KEY'])
  end
end