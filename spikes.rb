text = File.read "data/chp1.txt"
results = [{number: 1, chapter: "Chapter 1"}]
query = " have hopes"

def matching_text(results, query, text)
  matches = []

  results.each do |hash|
    text.split("\n\n").each_with_index do |p, idx|
      if p.include?(query)
        matches << [idx, p]
      end
    end
    
    hash[:text] = matches
  end
end

p matching_text(results, query, text)