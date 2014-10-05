module Blackjack
	class Deck
		def initialize
			cards = Array.new(52)
			cards.each_index do |i|
				cards[i] = Blackjack::Card.new
			end
			@cards = cards
		end
		def shuffle
			@cards.scramble
		end
		def remove_card
			return @cards.shift
		end
	end
end