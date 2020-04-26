class StoreSerializer < ActiveModel::Serializer
  attributes :id
  attributes :name
  attributes :description
  attributes :link
  attributes :address
  attributes :contact_phones
  attributes :email
  attributes :is_destroyed
  attributes :active
  
end
