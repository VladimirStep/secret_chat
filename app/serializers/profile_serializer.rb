class ProfileSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :gender
end
