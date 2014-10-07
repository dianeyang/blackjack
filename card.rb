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
		# def print_card
		# 	return "#{@type} #{@suit}"
		# end
		def to_string
			if @suit === "<3"
				return """
.------.
|#{@type}_  _ |
|( \\/ )|
| \\  / |
|  \\/ #{@type}|
`------'\n"""
			elsif @suit === "<>"
				return """
.------.
|#{@type} /\\  |
| /  \\ |
| \\  / |
|  \\/ #{type}|
`------'\n"""
            elsif @suit === "o8<"
        		return """
.------.
|#{@type} _   |
| ( )  |
|(_x_) |
|  Y  #{@type}|
`------'\n"""
			else
				return """
.------.
|#{@type} .   |
| / \\  |
|(_,_) |
|  I  #{@type}|
`------'\n"""
			end
		end
	end
end