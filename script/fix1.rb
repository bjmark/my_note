#change id to #id
Note.all.each do |e|
  e.categories.each do |c|
    if c.name == e.id.to_s
      c.name = "##{e.id}"
      c.save
    end
  end
end
