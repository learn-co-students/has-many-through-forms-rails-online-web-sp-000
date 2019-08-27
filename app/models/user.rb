class User < ActiveRecord::Base
  has_many :comments
  has_many :posts, through: :comments
has_many :comments
has_many :posts, through: :comments
validates :username, uniqueness: true

end