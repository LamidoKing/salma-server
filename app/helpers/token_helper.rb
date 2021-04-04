module TokenHelper
  def generate(user)
    expiry_date = (Time.now + 2.days).to_i
    payload = {user_id: user.id, exp: expiry_date, iat: Time.now.to_i}
    JWT.encode payload, Rails.application.secret_key_base, 'HS256'
  end

  def decode(token)
    JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
  end
end
