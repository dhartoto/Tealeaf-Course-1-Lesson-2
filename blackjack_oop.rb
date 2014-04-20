# START OF MODULES

# The card module converts the short name of a card to
# the full name i.e. 'JD' to 'Jack of Diamonds'
module Card

  attr_accessor :short_name, :suits, :royals

  def conv_to_str(card)
    @short_name = card
    @suits  = {H: 'Hearts', C: 'Clubs', D: 'Diamonds', S: 'Spades'}
    @royals = {K: 'King', Q: 'Queen', J: 'Jack', A: 'Ace'}
    val  = self.short_name[0..-2]
    suit = self.short_name[-1]
    suit = self.suits[suit.to_sym]      # Converts abreviation to suit name.
    
    if val.to_i == 0                    # checks for royals
      royal = self.royals[val.to_sym]
      "#{royal} of #{suit}"
    else                                # numerical cards
      "#{val} of #{suit}"
    end
  end
end

# The hand module calculates the total value of the hand.
module Hand

  attr_accessor :total

  def calc(hand)
    @total = 0
    ace = hand.select {|x| x[0] == 'A'}
    # Calculation of hand without aces.
    if ace == []
      hand.each do |x|
        x = x[0..-2].to_i
        x == 0? @total += 10 : @total += x
      end
      @total    
    else
    # Calculation of hand with ace(s)
      # Step 1. Calculate cards without the aces
      hand.reject{|x| ace.include?(x)}.each do |x|
        x = x[0..-2].to_i
        x == 0? @total += 10 : @total += x
      end

      # Add the value of ace(s) to the current total
      nr_ace = ace.length
      case nr_ace
        when 1 then @total <= 10? @total += 11 : @total += 1
        when 2 then @total <= 9? @total += 12 : @total += 2
        when 3 then @total <= 8? @total += 13 : @total += 3
        else @total <= 7? @total += 14 : @total += 4
      end
    @total 
    end
  end
end

# END OF MODULE

# START OF CLASSES

# The class Deck contains and array of 52 cards in an abreviated form. 
# The deck is shuffled when instantiated.
# It also contains a method that deals a card when called.

class Deck

  attr_accessor :deck

  def initialize
    @deck = 
      ['KH', 'QH', 'JH', 'AH', '2H', '3H','4H',
       '5H', '6H', '7H', '8H', '9H', '10H',
       'KC', 'QC', 'JC', 'AC', '2C', '3C','4C',
       '5C', '6C', '7C', '8C', '9C', '10C',
       'KD', 'QD', 'JD', 'AD', '2D', '3D','4D',
       '5D', '6D', '7D', '8D', '9D', '10D',
       'KS', 'QS', 'JS', 'AS', '2S', '3S','4S',
       '5S', '6C', '7S', '8S', '9S', '10S']
    @deck.shuffle!
  end

  def deal
    card = self.deck.pop
    card
  end
end

# The Player class includes the Hand and Card modules and have 
# methods to 'hit', calculate the 'total', and evaluate the
# players hand (eval_hand). The instance variable 'state' indicates if
# the player's hand is 'under' 21, 'blackjack' or 'bust'

class Player

  include Hand
  include Card

  attr_accessor :name, :short_hand, :long_hand, :state

  def initialize(name)
    @name = name
    @short_hand = []
    @long_hand = ""
    @state = 'under'
  end

  def hit(abr)
    self.long_hand += "#{conv_to_str(abr)}, "
    self.short_hand << abr
  end

  def total   # not needed
    calc(short_hand)
  end

  def eval_hand
    if self.total == 21
      self.state = 'blackjack'
      puts "Blackjack! You win!!"
    elsif self.total > 21
      self.state = 'bust'
      puts "You bust! Dealer wins"
    else
    end
  end
end

# Dealer is a subclass of Player. 
class Dealer < Player

  def initialize
    @short_hand = []
    @long_hand = ""
    @state = 'under'
  end

  def eval_hand
    if self.total == 21
      self.state = 'blackjack'
      puts "Blackjack! Dealer wins!!"
    elsif self.total > 21
      self.state = 'bust'
      puts "Dealer bust! You win."
    else
    end
  end

  def hidden_hand
    "Hidden, #{conv_to_str(short_hand[1])}"
  end
end

# The BlackjackGame class is the game engine. It welcomes the player and asks
# for a name on instantiation. The class contains a method to 'display' the card
# of both the player and dealer, a 'player_turn' method that handles the logic of 
# a player hitting or staying, a 'dealer_turn' method that hits when the dealers hand
# is less than 17, a 'start' method to begin the game, and a 'replay' method to allow
# the player to play a new game.

class BlackjackGame

  attr_accessor :name, :deck, :player, :dealer, :resp

  def initialize
    self.resp = '1'
    puts "Welcome! You have entered the Blackjack room."
    puts "How should I address you?"
    @name = gets.chomp
    puts "Hello #{name}, enter '1' to play or '2' to exit"
    resp = gets.chomp

    while resp != '1' and resp != '2'
      puts "Please enter '1' or '2'."
      resp = gets.chomp
    end

    if resp == '2'
      puts "Bye #{name} please come again!"
      exit
    end

    @deck   = Deck.new
    @player = Player.new(name)
    @dealer = Dealer.new

  end

  def display
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts
    if self.resp == '2'
      puts "Dealer\'s hand (total: #{dealer.total})"
      puts "#{dealer.long_hand}"
    else
      puts "Dealer\'s hand"
      puts "#{dealer.hidden_hand}"
    end
    puts
    puts "#{player.name}\'s hand (total: #{player.total})"
    puts "#{player.long_hand}"
    puts
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  end

  def player_turn
    self.resp = '1'
    self.display
    player.total
    if player.state == 'blackjack' or player.state == 'bust'
      self.replay
    end

    while self.resp == '1'
      puts "To hit enter '1' to stay enter '2'."
      self.resp = gets.chomp

      while self.resp != '1' and self.resp != '2'
        puts "Please enter '1' or '2'."
        self.resp = gets.chomp
      end

      if self.resp == '1'
        player.hit(deck.deal)
        self.display
        player.total
        player.eval_hand
        
        if player.state == 'blackjack' or player.state == 'bust'
          self.replay
        end
      else
      end
    end
  end

  def dealer_turn
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "Dealer reveals her cards"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    self.display
    while dealer.total < 17
      puts "Dealer hits"
      dealer.hit(deck.deal)
      self.display
      dealer.total
      dealer.eval_hand

      if dealer.state == 'blackjack' or dealer.state == 'bust'
        self.replay
      else
        dealer.total = 20  #test
        player.total = 20  #test
        if dealer.total >= player.total
          puts "Dealer wins!!"
        else
          puts "Congratulations, you win!"
        end
      end
    end
  end

  def start
    #First deal
    2.times do
      player.hit(deck.deal)
      dealer.hit(deck.deal)
    end
    self.player_turn
    self.dealer_turn
    self.replay
    # if bust ask if self.replay

  end

  def replay
    puts "Enter '1' to play again or '2' to exit."
    resp = gets.chomp
    while resp != '1' and resp != '2'
      puts "Please enter '1' or '2'."
      resp = gets.chomp
    end
    if resp == '1'
    player_name = player.name
    @deck   = Deck.new
    @player = Player.new(player_name)
    @dealer = Dealer.new
    self.start
    else
      exit
    end
  end

end

# Start game!
BlackjackGame.new.start
