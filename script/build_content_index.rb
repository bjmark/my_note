require 'benchmark'

ContentIndex.delete_all
Benchmark.bm do |x|
  x.report do
    Note.all.each do|t|
      ContentIndex.add_note(t)
    end
  end
end
