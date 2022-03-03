Instead of listing chapters, update the search to:
* link to specific paragraphs of the text that match the search phrase.
* Add `id` attributes to each paragraph on the chapter page so they can be linked to by incl that `id` as the anchor component of the appropriate link.

**NOTE:**When a browser loads a URL that contains an anchor (the part of the URL that starts with a #) and that page contains a DOM element with an id attribute equal to the anchor, it will automatically scroll the page to display that element.
From this:
* Chapter Title (LINK)

To this:
* Chapter Title
  * Snippet of matching text (LINK)
  * Snippet of matching text (LINK)

Example snippets seem to be paragraphs containing the matching query.

Right now, results are:
A bulleted list of chapter titles, linking to the chapters themselves

What I want are results that are:
A bulleted list of chapter titles (no links) and nested within each one;
- the matching paragraph, linked to that particular paragraph in that chapters text

Current `@results` DS is an array of hashes, each hash containing the chapter # and name of the matching text.
[number: 1, chapter: "A Scandal in Bohemia"]

Want `@results` DS to be an array of hashes with the third key-value pair being, text: an array of matching paragraphs
[{ 
  number: 1, 
  chapter: "A Scandal in Bohemia", 
  text: ["But you have hopes?", "I have hopes."]
}]

<!-- `#chapter_contents(number)` takes a chapter number & returns the text for that chapter -->
`#text_matching(@results, query)` that mutates the original hash, adding a the third key-value pair above

INPUT: @results, query
- `@results` is an array of hashes, each hash contains two key-value pairs
-- number: number (chapter #) and chapter: name
OUTPUT: mutated @results, a third key-value pair
- third key-value pair, e.g.
-- text: ["But you have hopes?", "I have hopes."]

DS: Array, Hash

ALGO:
- Create a method that takes 2 args `@results` and a `query`
- Iterate thru `@results` and for each hash;
-- get chapter text and split it into paragraphs, iterating thru each paragraph;
---- only keep paragraphs for which query can be found
- Add matching paragraphs to `@results` with the key `:text`
```ruby
results = [{number => 1, chapter: "Chapter 1: yellow house"}, number => 2, chapter: "Chapter 2: yellow dog"}]
query = "house"

def matching_text(results, query)
  results.each do |hash|
    text = File.read "data/chp#{hash[number]}.txt"
    matches = text.split("\n\n").select { |p| p.include?(query) }
    results[:text] = matches
  end
end
```