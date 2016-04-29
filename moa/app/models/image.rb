class Image < ActiveRecord::Base
  self.primary_key = "ghash"

  validates :url, presence: true
  validates :tweet, presence: true
  validates :ghash, presence: true,
                    uniqueness: true
end
