class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses
  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  def guess(letter)
    if letter.nil? || !letter.match?(/\A[a-zA-Z]\z/)
      raise ArgumentError
    end
    letter = letter.downcase

    if @wrong_guesses.index(letter) || @guesses.index(letter)
      return false
    end

    if @word.index(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    
    return true
  end
  def word_with_guesses
    hidden_word = ''

    @word.each_char do |current_letter|
      if !@guesses.include?(current_letter)
        hidden_word += '-'
      else
        hidden_word += current_letter
      end
    end
    hidden_word
  end
  def check_win_or_lose
    wrong_count = @wrong_guesses.length
    current_word = word_with_guesses
    if wrong_count >= 7
      return :lose
    elsif current_word == @word
      return :win
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end

