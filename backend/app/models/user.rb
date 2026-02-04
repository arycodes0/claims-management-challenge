class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def generate_token!
    update!(authentication_token: SecureRandom.hex(20))
    authentication_token
  end

  def invalidate_token!
    update!(authentication_token: nil)
  end
end
