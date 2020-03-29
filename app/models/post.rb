class Post
  include Mongoid::Document
  field :title, type: String
  field :content, type: String
  field :published, type: Boolean 

  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, :content, presence: true
  validates :published, inclusion: { in: [true, false]}
end
