module Blackjack
	class Player
		attr_reader :cash
		attr_reader :name
		attr_reader :hands
		def initialize(name)
			@cash = 1000
			@hands = [Blackjack::Hand.new]
			@name = name
		end
		def reset
			@hands = [Blackjack::Hand.new]
		end
		def is_active
			return @hands.reduce(false) do |others, current|
				others || current.active
			end
		end
		def has_lost
			return @hands.reduce(true) do |others, current|
				others && current.lost
			end
		end
		def add_card(card, i)
			@hands[i].add_card(card)
		end
		def print_stats(i)
			puts "Cash: $#{@cash}"
			puts "Current bet: $#{@hands[i].bet}"
			puts "Hand: #{@hands[i].print_hand}"
		end
		def can_double_bet
			return @hands[0].bet * 2 > @cash
		end
		def get_move(round, i)
			puts "#{@name}, what do you want to do with this hand?"
			puts "H: Hit (take a card)"
			puts "E: Stand ([E]nd turn)"
			if round == 0
				puts "D: Double down (double bet, take one card, and stand)"
				puts "S: Split (If the 2 cards have equal value, separate them and make 2 hands)"
			end
			puts "R: Surrender ([R]etire from game and lose half your bet)"
			puts ""
			self.print_stats(i)

			valid = false
			while !valid
				print "> "
				move = $stdin.gets.chomp.downcase
				valid = self.validate_move(move, round, i)
			end
			return move
		end
		def validate_move(move, round, i)
			in_set = ["h", "e", "d", "s", "r"].include? move
			if !in_set
				puts "Invalid move. Please try again."
				return false
			end
			not_first_round = (move == "d" || move == "s") && round != 0
			if not_first_round
				puts "You can only make that move for your first two cards. Please try again."
				return false
			end
			not_pair = move == "s" && @hands[0].get(0).value != @hands[0].get(1).value
			if not_pair
				puts "Sorry, you can't split because your cards do not have the same value."
				return false
			end
			not_enough_cash = (move == "d" || move == "s") && self.can_double_bet
			if not_enough_cash
				puts "Sorry, you don't have enough cash to make that move. Please try again."
				return false
			end
			return true
		end
		def check_hand(i)
			value = @hands[i].calc_value
			if value > 21
				self.bust(i)
			elsif value == 21
				self.stand(i, true)
			end
		end
		def bust(i)
			@cash -= @hands[i].bet
			@hands[i].active = false
			@hands[i].lost = true
			puts "Uh oh! The value of your hand has surpassed 21."
			puts "Your bet of $#{@hands[i].bet} has been deducted from your cash, leaving you with $#{@cash}", ""
		end
		def hit(card, i)
			puts "You chose to hit."
			self.add_card(card, i)
			puts "#{@name} was dealt a #{card.type} #{card.suit}.", ""
			self.check_hand(i)
		end
		def stand(i, automatic=false)
			@hands[i].active = false
			if automatic
				puts "You hit blackjack, so you automatically stand."
			else
				puts "You chose to stand."
			end
			puts "You cannot take any more cards for this hand, and your total will stay at #{@hands[i].calc_value}.", ""
		end
		def double(card)
			puts "You chose to double."
			self.add_card(card, i)
			@hands[i].bet *= 2
			@hands[i].active = false
			puts "Your bet is now $#{@hands[i].bet}.", ""
			puts "#{@name} was dealt a #{card.type} #{card.suit}.", ""
			self.check_hand(i)
		end
		def split
			puts "You chose to split", ""
			first_hand = @hands[0]
			hand1, hand2 = first_hand.split
			@hands = [hand1, hand2]
		end
		def surrender(i)
			@cash -= @hands[i].bet/2
			@hands[i].lost = true
			@hands[i].active = false
			puts "You chose to surrender hand \##{i+1}."
			puts "You lost half of your $#{@hands[i].bet} bet, leaving you with $#{@cash}.", ""
		end
		def calc_score(i)
			return @hands[i].calc_value
		end
		def win(i)
			@cash += @hands[i].bet
			puts "#{@name} won $#{@hands[i].bet} from hand \##{i+1} and now has $#{@cash}!"
			@hands[i].active = false
		end
		def lose(i)
			@hands[i].lost = true
			@cash -= @hands[i].bet
			puts "#{@name}'s hand \##{i+1} didn't surpass the dealer. #{@name} lost $#{@hands[i].bet} and now has $#{@cash}."
		end
	end
end