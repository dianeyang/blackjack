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
		def validate_decision(move, round)
			in_set = ["h", "e", "d", "s", "r"].include? move
			if !in_set
				puts "Invalid move. Please try again."
				return false
			end
			not_first_round = (move == "d" || move == "s") && (round != 0)
			if not_first_round
				puts "You can only make that move at the first decision. Please try again."
				return false
			end
			not_enough_cash = (move == "d" || move == "s") && (self.can_double_bet)
			if not_enough_cash
				puts "Sorry, you don't have enough cash to make that move. Please try again."
				return false
			end
			return true
		end
		def make_decision(round)
			puts "#{@name}, what do you want to do?"
			puts "H: Hit (take a card)"
			puts "E: Stand ([E]nd turn)"
			if round == 0
				puts "D: Double down (double bet, take one card, and stand)"
				puts "S: Split (If the 2 cards have equal value, separate them and make 2 hands)"
			end
			puts "R: Surrender ([R]etire from game and lose half your bet)"
			puts ""

			self.print_stats

			print "> "
			move = $stdin.gets.chomp.downcase
			return move
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
			puts "You chose to double."
			self.add_card(card)
			@bet *= 2
			puts "Your bet is now $#{@bet}.", ""
			puts "#{@name} got dealt a #{card.type} #{card.suit}.", ""
			if @hand.calc_value > 21
				self.bust
				return
			end
			@active = false
		end
		def split
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
			puts "You lost half of your $#{@bet} bet, leaving you with $#{@cash}.", ""
		end
		def calc_score
			return @hand.calc_value
		end
		def win
			@cash += @bet
			puts "#{@name} won $#{@bet} and now has $#{@cash}!"
			@active = false
		end
		def lose
			@lost = true
			@cash -= @bet
			puts "#{@name} didn't surpass the dealer and lost. #{@name}'s cash is now $#{@cash}."
		end
	end
end