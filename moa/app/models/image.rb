require 'elasticsearch/model'

class Image < ActiveRecord::Base
#  include Elasticsearch::Model
#  include Elasticsearch::Model::Callbacks

  self.primary_key = "ghash"

  validates :url, presence: true
  validates :tweet, presence: true
  validates :ghash, presence: true,
                    uniqueness: true

  paginates_per 28

  def next
    self.class.where('spam = ? AND ghash > ?', false, ghash).first or self.class.where(:spam => false).first
  end
  
  def previous
    self.class.where('spam = ? AND ghash < ?', false, ghash).last or self.class.where(:spam => false).last
  end
end

#Image.import
