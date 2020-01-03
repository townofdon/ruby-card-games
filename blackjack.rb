
#
# Blackjack
#
# Note - I did NOT research the rules of blackjack before creating this,
# so the game logic may be a little off. If any fixes need to be made they
# are probably easy edits.
#

puts "Blackjack"
20.times { print "-" }

class Card
  def initialize (name, suite)
    @name = name
    @suite = suite
  end

  def name
    @name
  end

  def suite
    @suite
  end

  def to_s
    _print_me
  end

  def to_str
    _print_me
  end

  def is_ace?
    @name == "A"
  end

  def is_not_ace?
    @name != "A"
  end

  def val
    _blackjack_val
  end

  private

    def _blackjack_val
      return "_%_" if @name == "A"
      return 10 if @name == "K" || @name == "Q"
      @name.to_i
    end

    def _print_me
      "#{@name} of #{@suite}"
    end
end

@deck = []
@user_hand = []
@house_hand = []
@turn = 0
@quit_game = false

def new_game
  puts
  puts
  puts
  @deck = build_deck
  @user_hand = []
  @house_hand = []
  @turn = 0
  deal_hands(true, false)
end

def build_deck
  deck = []
  names = ['A'].concat(("1".."10").to_a).concat(['Q', 'K'])
  suites = ['hearts', 'clubs', 'spaids', 'diamonds']
  for suite in suites
    for name in names
      deck << Card.new(name, suite)
    end
  end
  deck = deck.shuffle!.shuffle!.shuffle!
end

def deal_hands(should_hit = false, print_dealings = true)
  if should_hit
    @user_hand << @deck.shift
  end
  if get_score(@house_hand) < 15
    @house_hand << @deck.shift
    puts "Dealer hits" if print_dealings
  else
    puts "Dealer stays" if print_dealings
  end
  print_hands
  @turn += 1
end

def print_hands
  puts
  puts "Your hand:"
  10.times { print "-" }
  puts
  @user_hand.each {|card| print "#{card.name} " }
  puts "  => #{get_score(@user_hand)} points"
  puts
  puts "Dealer hand:"
  10.times { print "-" }
  puts
  @house_hand.each {|card| print "#{card.name} " }
  puts "  => #{get_score(@house_hand)} points"
  puts
end

def get_score(cards)
  score = 0
  ace_cards = cards.select { |card| card.is_ace? }
  other_cards = cards.select { |card| card.is_not_ace? }
  other_cards.each { |card| score += card.val }
  aces_high = ace_cards.clone
  aces_low = []
  # if score is greater than 20, keep lowering the value
  # of each ace one-by-one until score <= 20 or all aces
  # are exhausted
  while score + aces_high.length * 11 > 20 && aces_high.length > 0
    aces_low << aces_high.pop
  end
  aces_high.each {|card| score += 11 }
  aces_low.each {|card| score += 1 }
  score
end

def check_winner
  user_score = get_score(@user_hand)
  house_score = get_score(@house_hand)

  winner = false

  # correct me if game logic is faulty ;)
  if user_score > 21 && house_score > 21
    winner = "tie"
    puts "You and the house both went bust!"
  elsif user_score > 21
    winner = "house"
    puts "You went bust"
  elsif house_score > 21
    winner = "user"
  elsif user_score == 21
    winner = "user"
    puts "B L A C K J A C K"
  elsif house_score == 21
    winner = "house"
    puts "Noooooo!! The house got B L A C K J A C K"
  elsif @turn >= 3 && user_score >= house_score
    winner = "user"
  elsif @turn >= 3 && user_score < house_score
    winner = "house"
  end

  if winner == "house"
    puts "The house wins. :("
  elsif winner == "user"
    puts "You won!"
  end

  if winner
    puts
    puts
    puts
    puts "New game? y - yes, n - no"
    user_input = gets.chomp || ""
    if user_input.downcase == "y"
      new_game
    else
      @quit_game = true
    end
  end
end

def looop
  puts "How to proceed? h - hit, s - stay"
  user_input = gets.chomp || ""

  if user_input.downcase == "h"
    deal_hands(true)
  else
    deal_hands(false)
  end

  check_winner
end

new_game

while !@quit_game
  begin
    looop
  rescue Exception => e
    puts e, "please try again"
  end
end

puts "Have a nice day!"
