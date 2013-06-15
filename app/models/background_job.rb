class BackgroundJob < ActiveRecord::Base
  serialize :job, Hash

  def job
    read_attribute(:job) || write_attribute(:job, {})
  end
end
