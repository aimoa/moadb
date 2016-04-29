class Image < ActiveRecord::Base
  self.primary_key = "ghash"

  validates :url, presence: true
  validates :tweet, presence: true
  validates :ghash, presence: true,
                    uniqueness: true

  def next
    self.class.where('ghash > ?', ghash).first
  end
  
  def previous
    self.class.where('ghash < ?', ghash).last
  end
end
