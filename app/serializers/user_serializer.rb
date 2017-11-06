class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :token

  def token
    JWTCoder.encode(user_id: object.id)
  end
end
