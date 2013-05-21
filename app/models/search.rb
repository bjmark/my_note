class Search < ActiveRecord::Base
  def self.add(word, kind)
    word = word.strip
    self.delete_all(['word = ?',word])
    self.create(:word=>word,:kind=>kind)
  end
end
