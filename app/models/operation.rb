class Operation < ActiveRecord::Base
  scope :operation, lambda {|op| op == 'all' ? where('') : where(:operation=>op)}
  scope :bdate, lambda {|d| (d2=self.to_date(d)) ? where('created_at > ?',d2) : where('')}
  scope :edate, lambda {|d| (d2=self.to_date(d)) ? where('created_at < ?',d2) : where('')}

  def self.to_date(s)
    begin
      d = s.to_date
    rescue
      d = nil
    end
  end
end
