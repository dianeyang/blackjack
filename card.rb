module Blackjack
	class Card
		attr_reader :suit
		attr_reader :type
		def initialize(type, suit)
			@suit = suit
			@type = type
		end
		def value
			if type === 'A'
				return 11
			elsif type.is_a?(Integer) && type >= 2 && type <=9
				return type
			else
				return 10
			end
		end
		def print_card
			return "#{@type} #{@suit}"
		end
	end
end