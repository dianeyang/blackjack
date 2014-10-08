module Blackjack
	class Player
		attr_reader :cash
		attr_reader :name
		attr_reader :hands
		def initialize(name)
			@cash = 1000
			@hands = [Hand.new]
			@name = name
		end
		def reset
			@hands = [Hand.new]
		end
		def is_active
			has_active_hand = @hands.reduce(false) do |others, current|
				others || current.active
			end
			return has_active_hand && cash > 0
		end
		def has_lost
			return @hands.reduce(true) do |others, current|
				others && current.lost
			end
		end
		def set_bet(i, bet)
			@hands[i].bet = bet
		end
		def get_bet(i)
			return @hands[i].bet
		end
		def add_card(card, i)
			@hands[i].add_card(card)
			self.check_hand(i)
		end
		def format_cash
			return "%.2f" % @cash.round(2)
		end
		def print_stats(i)
			puts "Cash: $#{self.format_cash}"
			puts "Current bet: $#{self.get_bet(i)}"
			puts "Hand: #{@hands[i].to_string}"
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

			begin
				puts ""
				print "> "
				move = $stdin.gets.chomp.downcase
				valid = self.validate_move(move, round, i)
			end while !valid

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
			not_pair = move == "s" && @hands[0].get(0).type != @hands[0].get(1).type
			if not_pair
				puts "Sorry, you can't split because your cards are not the same type."
				return false
			end
			not_enough_cash = (move == "d" || move == "s") && (self.get_bet(0) * 2 > @cash)
			if not_enough_cash
				puts "Sorry, you don't have enough cash to make that move. Please try again."
				return false
			end
			return true
		end
		# check_hand: check if the player should retire, either because he/she has bust,
		# or because he/she has reached exactly 21.
		def check_hand(i)
			min_value = @hands[i].min_value
			clamped = @hands[i].clamp_value(21, 21)
			if min_value > 21
				self.bust(i)
			elsif clamped > 0 # Value of hand is 21
				self.stand(i, true, @hands[i].is_blackjack)
			end
		end
		def bust(i)
			@cash -= self.get_bet(i)
			@hands[i].active = false
			@hands[i].lost = true
			puts "Uh oh! The value of your hand has surpassed 21."
			puts "Your bet of $#{self.get_bet(i)} has been deducted from your cash, leaving you with $#{self.format_cash}", ""
		end
		def hit(card, i)
			puts "You chose to hit."
			puts "#{@name} was dealt a #{card.type} #{card.suit}.", ""
			self.add_card(card, i)
		end
		def stand(i, automatic=false, blackjack=false)
			@hands[i].active = false
			if blackjack
				puts "#{@name} got a blackjack and automatically stands."
			elsif automatic
				puts "#{@name} hit 21 and automatically stands."
			else
				puts "You chose to stand."
			end
			puts "You cannot take any more cards for this hand.", ""
		end
		def double(card)
			puts "You chose to double down."
			bet = self.get_bet(0)
			self.set_bet(0, 2*bet)
			@hands[0].active = false
			puts "Your bet is now $#{2*bet}.", ""
			puts "#{@name} was dealt a #{card.type} #{card.suit}.", ""
			self.add_card(card, 0)
		end
		def split
			puts "You chose to split", ""
			first_hand = @hands[0]
			hand1, hand2 = first_hand.split
			@hands = [hand1, hand2]
		end
		def surrender(i)
			@cash -= self.get_bet(i)/2.0
			@hands[i].lost = true
			@hands[i].active = false
			puts "You chose to surrender hand \##{i+1}."
			puts "You lost half of your $#{self.get_bet(i)} bet, leaving you with $#{self.format_cash}.", ""
		end
		def win(i)
			@cash += self.get_bet(i)
			puts "#{@name} won $#{self.get_bet(i)} from hand \##{i+1}. #{@name} now has $#{self.format_cash}!"
			@hands[i].active = false
		end
		def tie(i)
			puts "#{@name}'s hand \##{i+1} tied with the dealer, neither winning nor losing money. #{@name} still has $#{self.format_cash}."
		end
		def lose(i)
			@hands[i].lost = true
			bet = self.get_bet(i)
			@cash -= bet
			puts "#{@name}'s hand \##{i+1} didn't surpass the dealer. #{@name} lost $#{bet} and now has $#{self.format_cash}."
		end
		def get_all_cards
			cards = Array.new
			@hands.each do |hand|
				cards.concat(hand.cards)
			end
			return cards
		end
	end
end