class Search < ActiveRecord::Base
  def self.add(word)
    word = word.strip
    self.delete_all(['word = ?',word])
    self.create(:word=>word)
  end
end
