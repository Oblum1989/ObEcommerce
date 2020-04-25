class Store
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  field :link, type: String
  field :address, type: String
  field :contact_phones, type: Array, default: []
  field :email, type: String
  field :is_destroyed, type: Boolean, default: false
  field :active, type: Boolean, default: false


  # has_many :comments, dependent: :destroy
  # belongs_to :user

  validates :name, :description, :link, :address, :contact_phones, :email, presence: true
  validates :active, inclusion: { in: [true, false]}
end
