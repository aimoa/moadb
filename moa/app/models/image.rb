require 'elasticsearch/model'

class Image < ActiveRecord::Base
#  include Elasticsearch::Model
#  include Elasticsearch::Model::Callbacks

  self.primary_key = "ghash"

  validates :url, presence: true
  validates :tweet, presence: true
  validates :ghash, presence: true,
                    uniqueness: true

  def next
    self.class.where('spam = ? AND ghash > ?', false, ghash).first
  end
  
  def previous
    self.class.where('spam = ? AND ghash < ?', false, ghash).last
  end
end

#Image.import
