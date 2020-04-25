class Tag
  include Mongoid::Document

  field :name, type: String
  field :is_destroyed, type: Boolean, default: false
  field :active, type: Boolean, default: false


  # has_many :comments, dependent: :destroy
  # belongs_to :user

  validates :name, presence: true
  validates :active, inclusion: { in: [true, false]}
end
