module Blackjack
	class Deck
		def initialize
			types = Array(2..10).concat(["J", "Q", "K", "A"])
			suits = ["<3", "o8<", "<>", "<8<"]
			cards = Array.new(52)
			i = 0
			types.each do |type|
				suits.each do |suit|
					cards[i] = Blackjack::Card.new(type, suit)
					i += 1
				end
			end
			@cards = cards
		end
		def shuffle
			@cards = @cards.shuffle
		end
		def remove_card
			return @cards.shift
		end
	end
end