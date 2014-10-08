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
		def hit
			card = @deck.remove_card
			@hand.add_card(card)
			puts "The dealer got dealt a #{card.type} of #{card.suit}."
		end
		def deal_to_self
			@hand.add_card(@deck.remove_card)
			@hand.add_card(@deck.remove_card)
			return @hand.get(0)
		end 
		def reveal
			up_card = @hand.get(0)
			puts "The dealer already had a #{up_card.type} #{up_card.suit}."
			hole_card = @hand.get(1)
			puts "The dealer revealed the hole card: a #{hole_card.type} #{hole_card.suit}."
			value = @hand.max_value
			while value < 17
				self.hit
				value = @hand.max_value
			end
			if value > 21
				puts "The dealer got over 21! All remaining players win their bets."
				return 0
			elsif value == 21 && @hand.get_size > 2
				puts "The dealer has a total value of #{value} (though not a blackjack)."
				return value
			else
				puts "The dealer has a total value of #{value}.", ""
				return value
			end
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