class Query < ApplicationRecord
  validates :search, uniqueness: true

  before_create :normalize

  def normalize
    self.search.downcase!
    self.count = 1
  end

  def increment_count
    self.count += 1
    self.save
  end

  def decrement_count
    self.count -= 1
    puts self.inspect
    self.count == 0 ? self.destroy : self.save
  end
end
