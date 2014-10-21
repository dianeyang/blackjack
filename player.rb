module Blackjack
	class Player
		attr_reader :cash
		attr_reader :name
		attr_accessor :hands
		attr_accessor :inactive_hands
		def initialize(name)
			@cash = 1000
			@hands = HandCollection.new([Hand.new])
			@inactive_hands = HandCollection.new
			@name = name
			@splits = 0
		end
		def reset
			@hands = HandCollection.new([Hand.new])
			@inactive_hands = HandCollection.new
			@splits = 0
		end
		def is_active
			return @hands.hands.length > 0 && cash > 0
		end
		def has_lost
			return @inactive_hands.has_lost
		end
		def add_card(card, hand)
			hand.add_card(card)
			return self.check_hand(hand)
		end
		def format_cash
			return "%.2f" % @cash.round(2)
		end
		def print_stats
			puts "CASH REMAINING: $#{self.format_cash}".upcase, ""
			self.print_inactive_hands
			self.print_active_hands
		end
		def print_active_hands
			if @hands.length > 0
				puts "Hands still in play:".upcase
				@hands.print
			end
		end
		def print_inactive_hands
			if @inactive_hands.length > 0
				puts "Hands out of play:".upcase
				@inactive_hands.print(true)
			end
		end
		def get_moves
			if @hands.length == 1
				puts "#{@name}, what do you want to do with this hand?"
			else
				puts "#{@name}, what do you want to do with each of your hands still in play?"
				puts "Please list your moves for each hand in play below."
				puts "Example: if you had 3 hands in play, then you could type 'REH' to represent surrendering on the first hand, standing on the second hand, and hitting on the third hand."
			end
			puts "H: Hit (take a card)"
			puts "E: Stand ([E]nd turn)"
			puts "D: Double down (double bet, take one card, and stand)"
			puts "S: Split (If the 2 cards have equal value, separate them and make 2 hands)"
			puts "R: Surrender ([R]etire from game and lose half your bet)"
			puts ""

			begin
				print "> "
				moves = $stdin.gets.chomp.downcase.chars
				valid = self.validate_moves(moves)
			end while !valid

			return moves
		end
		def validate_moves(moves)
			if moves.length != @hands.length
				puts "You specified #{moves.length} moves, but you have #{@hands.length} hands. Please try again."
				return false
			end
			if @hands.total_at_stake(moves) > self.cash
				if moves.length > 1
					puts "You don't have enough money to make those moves."
				else
					puts "You don't have enough money to make that move."
				end
				return false
			end
			@hands.hands.zip(moves).each do |hand, move|
				if !validate_move(move, hand)
					return false
				end
			end
			return true
		end
		def validate_move(move, hand)
			in_set = ["h", "e", "d", "s", "r"].include? move
			if !in_set
				puts "One or more of your moves was invalid. Please try again."
				return false
			end
			not_two_cards = (move == "d" || move == "s") && hand.get_size != 2
			if not_two_cards
				puts "You can only do #{move.upcase} on a hand with 2 cards. Please try again."
				return false
			end
			max_splits = move == "s" && @splits == 3
			if max_splits
				puts "You can only split up to 3 times. Please try again."
				return false
			end
			not_pair = move == "s" && !hand.is_splittable
			if not_pair
				puts "Sorry, you can't split because your cards are not the same type."
				return false
			end
			return true
		end
		# check_hand: check if the player should retire, either because he/she has bust,
		# or because he/she has reached exactly 21.
		def check_hand(hand)
			min_value = hand.min_value
			clamped = hand.clamp_value(21, 21)
			if min_value > 21
				updated = self.bust(hand)
			elsif clamped > 0 # Value of hand is 21
				updated = self.stand(hand, true, hand.is_blackjack)
			else
				updated = [hand]
			end
			return updated
		end
		def set_hand_to_inactive(hand)
			@inactive_hands.add([hand])
		end
		def bust(hand)
			@cash -= hand.bet
			hand.status = "bust"
			hand.lost = true
			puts "Uh oh! The value of your hand has surpassed 21."
			puts "Your bet of $#{hand.bet} on that hand has been deducted from your cash, leaving you with $#{self.format_cash}", ""
			self.set_hand_to_inactive(hand)
			return nil
		end
		def hit(card, hand)
			puts "You chose to hit."
			puts "That hand was dealt a #{card.type} #{card.suit}.", ""
			updated = self.add_card(card, hand)
			return updated
		end
		def stand(hand, automatic=false, blackjack=false)
			self.set_hand_to_inactive(hand)
			hand.status = "stand"
			if blackjack
				puts "One of your hands is a blackjack and automatically stands."
			elsif automatic
				puts "One of your hands hit 21 and automatically stands."
			else
				puts "You chose to stand."
			end
			puts "You cannot take any more cards for this hand.", ""
			return nil
		end
		def double(card, hand)
			puts "You chose to double down."
			hand.bet = 2*hand.bet
			hand.active = false
			hand.status = "doubled"
			puts "Your bet is now $#{hand.bet}.", ""
			puts "#{@name} was dealt a #{card.type} #{card.suit}.", ""
			result = self.add_card(card, hand)
			if !result.nil?
				self.set_hand_to_inactive(hand)
			end
			return nil
		end
		def split(card1, card2, hand)
			puts "You chose to split the pair containing a #{hand.get(0).type} #{hand.get(0).suit} and a #{hand.get(1).type} #{hand.get(1).suit}."
			puts "The dealer dealt a #{card1.type} #{card1.suit} to one of the resulting hands and a #{card2.type} #{card2.suit} to the other."
			hand1, hand2 = hand.split(card1, card2)
			@splits += 1
			return [hand1, hand2]
		end
		def surrender(hand)
			@cash -= hand.bet/2.0
			hand.lost = true
			hand.status = "surrendered"
			puts "You chose to surrender."
			puts "You lost half of your $#{hand.bet} bet on that hand, leaving you with $#{self.format_cash}.", ""
			self.set_hand_to_inactive(hand)
			return nil
		end
		def win(hand)
			@cash += hand.bet
			puts "#{@name} won $#{hand.bet} from their hand containing#{hand.to_inline_string}. #{@name} now has $#{self.format_cash}!"
		end
		def tie(hand)
			puts "#{@name}'s hand containing#{hand.to_inline_string} tied with the dealer, neither winning nor losing money. #{@name} still has $#{self.format_cash}."
		end
		def lose(hand)
			@cash -= hand.bet
			puts "#{@name}'s hand containing#{hand.to_inline_string} didn't surpass the dealer. #{@name} lost $#{hand.bet} and now has $#{self.format_cash}."
		end
	end
end