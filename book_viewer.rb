require "tilt/erubis"
require "sinatra"
require "sinatra/reloader" if development?

before do
  @table_of_contents = File.readlines "data/toc.txt"
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph, idx|
      "<p id=paragraph#{idx}>#{paragraph}</p>"
    end.join
  end

  def each_chapter
    @table_of_contents.each_with_index do |chapter, index|
      number = index + 1
      text = File.read "data/chp#{number}.txt"
      yield number, chapter, text
    end
  end
  
  def chapters_matching(query)
    results = []
  
    return results if !query || query.empty?
  
    each_chapter do |number, chapter, text|
      results << { number: number, chapter: chapter } if text.include?(query)
    end
  
    results
  end

  def matching_text(query)
    @results.each do |hash|
      matches = []
      text = File.read "data/chp#{hash[:number]}.txt"
      text.split("\n\n").each_with_index do |p, idx|
        if p.include?(query)
          matches << [idx, p]
        end
      end
      hash[:text] = matches
    end
  end

  def highlight(text, term)
    text.gsub(term, "<strong>#{term}</strong>")
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @table_of_contents[number-1]
  redirect "/" unless chapter_name
  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read "data/chp#{number}.txt"

  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])
  matching_text(params[:query])
  erb :search
end

not_found do
  redirect "/"
end