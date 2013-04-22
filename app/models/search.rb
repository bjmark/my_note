class Search < ActiveRecord::Base
  def self.add(word)
    self.delete_all(['word = ?',word])
    self.create(:word=>word)
  end
end
