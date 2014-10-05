module Blackjack
	class Dealer
		def initialize(deck)
			@hand = Blackjack::Hand.new
			@deck = deck
		end
		def deal_one
			return @deck.remove_card
		end
		def add_card(card)
			@hand.add_card(card)
		end
		def hit
			card = @deck.remove_card
			self.add_card(card)
			puts "The dealer got dealt a #{card.type} of #{card.suit}."
		end
		def deal_to_self
			@hand.add_card(@deck.remove_card)
			@hand.add_card(@deck.remove_card)
			return @hand.get(0)
		end 
		def calc_score
			return @hand.calc_value
		end
		def reveal
			hole_card = @hand.get(1)
			puts "The dealer revealed the hole card: a #{hole_card.type} of #{hole_card.suit}."
			while @hand.calc_value < 17
				self.hit
			end
			if @hand.calc_value > 21
				puts "The dealer got over 21! All remaining players win."
			else
				puts "The dealer has a total value of #{@hand.calc_value}."
			end
		end
	end
end