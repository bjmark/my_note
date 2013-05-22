ContentIndex.delete_all

Note.all.each do|t|
  ContentIndex.add_note(t)
end
