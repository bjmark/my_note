class NotesController < ApplicationController
  def index
    word = params[:word]
    if word.blank?
      @categories = []
      @notes = []
    else
      @categories = Category.search(word)
      
      category_ids = @categories.collect{|e| e.id}
      note_ids = CategoriesNotes.where(:category_id=>category_ids).collect{|e| e.note_id}
      @notes = Note.where(:id=>note_ids)
    end
  end

  def new
    @path = notes_path
    @method = 'post'
    @content = ''
    @names = []
  end

  def create
    content = params[:content]
    note = Note.create!(:content=>content)

    names = params[:names]
    names << "\n#{Date.today}"
    names << "\n#{note.id}"

    categories = Category.bulk_create(note,names)
    redirect_to notes_path
  end

  def edit
    @note = Note.find(params[:id])

    @path = note_path(@note)
    @method = 'put'
    @content = @note.content
    
    @names = @note.categories.collect{|e| e.name}
  end

  def update
    note = Note.find(params[:id])
    note.content = params[:content]
    note.save

    Category.bulk_update(note,params[:names])
    
    redirect_to notes_path
  end

  def destroy
    note = Note.find(params[:id])
    note.delete2
    redirect_to notes_path
  end
end
