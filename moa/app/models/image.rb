class Image < ActiveRecord::Base
  self.primary_key = "ghash"

  validates :ghash, uniqueness: true
end
