module Blackjack
	class Dealer
		attr_reader :hand
		def initialize
			@hand = Hand.new
			@deck = Deck.new
		end
		def reset
			@hand = Hand.new
		end
		def deal_one
			return @deck.remove_card
		end
		def deal_n
			for i in 1..n
				self.deal_one
			end
		end
		def get_top_n(n)
			return @deck.get_top_n(n)
		end
		def hit
			card = @deck.remove_card
			@hand.add_card(card)
			puts "The dealer got dealt a #{card.type} of #{card.suit}."
		end
		def deal_to_self
			@hand.add_card(self.deal_one)
			@hand.add_card(self.deal_one)
			return @hand.get(0)
		end 
		def reveal
			up_card = @hand.get(0)
			puts "The dealer already had a #{up_card.type} #{up_card.suit}."
			hole_card = @hand.get(1)
			puts "The dealer revealed the hole card: a #{hole_card.type} #{hole_card.suit}."

			# deal until dealer busts or gets between 17 and 21
			while @hand.min_value <= 21
				if @hand.clamp_value(17, 17) > 0 && @hand.n_aces > 0 # hit on soft 17
					self.hit
					value = @hand.clamp_value(17, 27)
					break
				elsif @hand.clamp_value(17, 21) > 0 # hard 17 or anything 18 to 21
					value = @hand.clamp_value(17, 21)
					break
				end
				self.hit
			end

			if @hand.min_value > 21 # bust
				puts "The dealer got over 21! All remaining players win their bets."
				return 0
			elsif value == 21
				if @hand.get_size == 2
					puts "The dealer got a blackjack!"
				else
					puts "The dealer has a total value of #{value} (though not a blackjack)."
				end
				return value
			else # below 21
				puts "The dealer has a total value of #{value}.", ""
				return value
			end
		end
		def print_upcard
			puts "Dealer upcard:".upcase
			puts @hand.get(0).to_string
		end
		def shuffle_deck
			@deck.shuffle
		end
		def replenish_deck(cards)
			cards.concat(@hand.cards)
			@deck.replenish(cards)
		end
	end
end