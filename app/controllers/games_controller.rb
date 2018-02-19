require 'open-uri'
require 'json'

ALPHABET = ("A".."Z").to_a
$grid = []

class GamesController < ApplicationController
  def new
    $grid = []
    8.times { $grid << ALPHABET.sample }
  end

  def score
    word = params['word']
    score = 0
    if word_in_dictionary?(word) && word_in_grid?(word)
      score = (word.length**2 * 100).to_i
    end
    @message = generate_message(word, score)
  end

  private

  def word_in_grid?(word)
    word_array = word.upcase.chars
    return word_array.all? { |letter| $grid.count(letter) >= word_array.count(letter) }
  end

  def word_in_dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = open(url).read
    json_result = JSON.parse(result_serialized)
    return json_result["found"]
  end

  def generate_message(word, score)
    if word_in_dictionary?(word)
      if word_in_grid?(word)
        message = "Well done! Your score is #{score}!"
      else
        message = "Sorry but #{word.upcase} can't be built of #{$grid.join(", ")}"
      end
    else
      message = "Sorry but #{word.upcase} does not seem to be a valid English word..."
    end
    return message
  end

end
