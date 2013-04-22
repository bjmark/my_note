require 'coderay'
require "RedCloth"
require "redclothcoderay"

class NotesController < ApplicationController
  def index
    word = params[:word]
    @searches = Search.order("id desc").limit(10)
    if word.blank?
      @categories = []
      @notes = []
    else
      Search.add(word)
      @notes,@categories = Note.search(word)
      @notes = @notes.collect do |e|
        text = e.content
        text = text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
          code = CodeRay.scan($3, $2).div(:css => :class)
          "<notextile>#{code}</notextile>"
        end
        [e,RedCloth.new(text).to_html]
      end
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
