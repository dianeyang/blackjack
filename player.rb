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
		def bust
			@cash -= @bet
			@active = false
			@lost = true
			puts "Uh oh! The value of your hand is over 21 :("
			puts "Your bet of $#{@bet} has been deducted from your cash, leaving you with $#{@cash}", ""
		end
		def hit(card)
			self.add_card(card)
			puts "You chose to hit."
			puts "#{@name} got dealt a #{card.type} of #{card.suit}.", ""
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
			puts "You got dealt a #{card.type} of #{card.suit}."
			if @hand.calc_value > 21
				self.bust
				return
			end
			@bet *= 2
			puts "Your bet is now $#{@bet}.", ""
			@active = false
		end
		def split
			puts "You chose to split", ""
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