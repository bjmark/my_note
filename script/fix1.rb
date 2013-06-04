#change id to #id
=begin
Note.all.each do |e|
  e.categories.each do |c|
    if c.name == e.id.to_s
      c.name = "##{e.id}"
      c.save
    end
  end
end
=end
n = 0
Category.where("name like '#%'").each do |e|
  s = e.name[1..-1]
  if s.to_i > 0
    e.name = s
    e.save!
    n += 1
  end
end

puts "update #{n} records"
