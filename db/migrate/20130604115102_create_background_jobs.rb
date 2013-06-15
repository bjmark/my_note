class CreateBackgroundJobs < ActiveRecord::Migration
  def self.up
    create_table :background_jobs do |t|
      t.text :job
      t.timestamps
    end
  end

  def self.down
    drop_table :background_jobs
  end
end
