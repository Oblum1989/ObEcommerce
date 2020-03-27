class CommentSerializer < ActiveModel::Serializer
  attributes :id, :name, :message
  has_one :post
end
