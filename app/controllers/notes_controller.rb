require 'coderay'
require "RedCloth"
require "redclothcoderay"

class NotesController < ApplicationController
  def index
    word = params[:word]
    @searches = Search.order("id desc").limit(20)
    return if word.blank?

    case 
    when params[:like]
      @notes,@categories = Note.search(word,:like)
      Search.add(word,'like')
    when params[:index]
      @notes,@categories = Note.search(word,:index)
      Search.add(word,'index')
    else
      @notes,@categories = Note.search(word)
      Search.add(word,'search')
    end
    @notes = @notes.page(params[:page]).per(3)
    @textiles = @notes.collect do |e|
      s = e.content.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        code = CodeRay.scan($3, $2).div(:css => :class)
        "<notextile>#{code}</notextile>"
      end
      RedCloth.new(s).to_html
    end
  end

  def new
    @path = notes_path
    @method = 'post'
    @note = Note.new
    @content = Note.where(:id=>params[:id]).first.try(:content)
    @names = []
  end

  def create
    content = params[:content]
    note = Note.create!(:content=>content)

    names = params[:names]
    names << "\n#{Date.today}"
    names << "\n##{note.id}"

    categories = Category.bulk_create(note,names)
    ContentIndex.add_note(note)

    Operation.create!(:operation=>'create',:content=>names.split("\n").join(','))
    redirect_to notes_path(:word=>"##{note.id}")
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

    unless params['no_reindex'] #do not rebuild index
      ContentIndex.del_note(note)
      ContentIndex.add_note(note)
    end

    Operation.create!(:operation=>'update',:content=>params[:names].split("\n").join(','))
    redirect_to notes_path(:word=>"##{note.id}")
  end

  def destroy
    note = Note.find(params[:id])
    names = note.categories.collect{|e| e.name}.join(",")
    note.delete2

    Operation.create!(:operation=>'destroy',:content=>names)
    redirect_to notes_path
  end
end
