class User
  include Mongoid::Document
  field :email, type: String
  field :name, type: String
  field :auth_token, type: String

  has_many :posts, dependent: :destroy

  validates :email, :name, :auth_token, presence: true

  after_initialize :generate_auth_token

  def generate_auth_token
    unless auth_token.present?
      self.auth_token = TokenGenerationService.generate
    end
  end
  
end
