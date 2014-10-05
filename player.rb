module Blackjack
	class Player
		attr_accessor :bet
		attr_reader :cash
		attr_reader :active
		attr_reader :lost
		attr_reader :name
		def initialize(name)
			@cash = 1000
			@bet = nil
			@hand = Blackjack::Hand.new
			@active = true
			@lost = false
			@name = name
		end
		def reset
			@bet = nil
			@hand = Blackjack::Hand.new
			@active = true
			@lost = false
		end
		def add_card(card)
			@hand.add_card(card)
		end
		def print_stats
			puts "Cash: $#{@cash}"
			puts "Current bet: $#{@bet}"
			puts "Hand: " + @hand.print_hand
		end
		def can_double_bet
			return @bet * 2 > @cash
		end
		def bust
			@cash -= @bet
			@active = false
			@lost = true
			puts "Uh oh! The value of your hand is over 21 :("
			puts "Your bet of $#{@bet} has been deducted from your cash, leaving you with $#{@cash}", ""
		end
		def hit(card)
			puts "You chose to hit."
			self.add_card(card)
			puts "#{@name} got dealt a #{card.type} #{card.suit}.", ""
			if @hand.calc_value > 21
				self.bust
			end
		end
		def stand
			@active = false
			puts "You chose to stand."
			puts "You are now sitting out of the game.", ""
		end
		def double(card)
			if @bet * 2 > @cash
				puts "Sorry, you don't have enough cash to double", ""
				return
			end
			puts "You chose to double."
			self.add_card(card)
			puts "#{@name} got dealt a #{card.type} #{card.suit}.", ""
			if @hand.calc_value > 21
				self.bust
				return
			end
			@bet *= 2
			puts "Your bet is now $#{@bet}.", ""
			@active = false
		end
		def split
			if @bet * 2 > @cash
				puts "Sorry, you don't have enough cash to split", ""
				return
			end
			puts "You chose to split", ""
			if @hand.get(0).value == @hand.get(1).value
				hand1, hand2 = @hand.split
			end
		end
		def surrender
			@cash -= @bet/2
			@lost = true
			@active = false
			puts "You chose to surrender."
			puts "You lost half of your $#{@bet}, leaving you with $#{@cash}.", ""
		end
		def calc_score
			return @hand.calc_value
		end
		def win
			@cash += @bet
			puts "#{@name} won $#{@bet}! Your cash is now $#{@cash}."
			@active = false
		end
		def lose
			@lost = true
			@cash -= @bet
			puts "#{@name} didn't surpass the dealer, so you lost. Your cash is now $#{@cash}."
		end
	end
end