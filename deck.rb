module Blackjack
	class Deck
		def initialize
			types = Array(2..10).concat(["J", "Q", "K", "A"])
			suits = ["<3", "o8<", "<>", "<8<"]
			cards = Array.new
			types.each do |type|
				suits.each do |suit|
					cards << Blackjack::Card.new(type, suit)
				end
			end
			# we use 2 decks of cards
			@cards = cards.concat(cards)
		end
		def shuffle
			@cards = @cards.shuffle
			puts "Shuffling the deck..."
		end
		def remove_card
			if @cards.empty?
				raise "Uh oh, the deck shouldn't be empty."
			end 
			return @cards.shift
		end
		# replenish: shuffle discarded cards back into the deck
		def replenish(discarded)
			@cards.concat(discarded)
			self.shuffle
		end
	end
end