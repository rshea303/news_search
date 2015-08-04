class Article < ActiveRecord::Base
  has_many :keywords
  has_many :entities
end
