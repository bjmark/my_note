require 'coderay'
require "RedCloth"
require "redclothcoderay"

class NotesController < ApplicationController
  def index
    word = params[:word]
    @searches = Search.order("id desc").limit(20)
    if word.blank?
      @categories = []
      @notes = []
    else
      case 
      when params[:like]
        @notes,@categories = Note.search(word,:like)
        Search.add(word,'like')
      else
        @notes,@categories = Note.search(word)
        Search.add(word,'search')
      end
      @notes = @notes.collect do |e|
        text = e.content
        text = text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
          code = CodeRay.scan($3, $2).div(:css => :class)
          "<notextile>#{code}</notextile>"
        end
        [e,RedCloth.new(text).to_html]
      end
    end
    @notes = Kaminari.paginate_array(@notes).page(params[:page]).per(3)
  end

  def new
    @path = notes_path
    @method = 'post'
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
