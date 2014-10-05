module Blackjack
	class Dealer
		def initialize(deck)
			@hand = Array.new
			@deck = deck
		end
		def deal_one
			return @deck.remove_card
		end
		def deal_to_self
			@hand << @deck.remove_card
			@hand << @deck.remove_card
			return @hand[0]
		end 
	end
end