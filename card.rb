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
				return 1
			elsif type.is_a?(Integer) && type >= 2 && type <=9
				return type
			else
				return 10
			end
		end
		def to_string
			if @type == 10
				top = 10
				bottom = 10
				pad = ""
			else
				top = @type.to_s + " "
				bottom = @type.to_s
				pad = " "
			end
			if @suit === "<3"
				return """
.-------.
|#{top}_  _ |
| ( \\/ )|
|  \\  / |
|   \\/#{pad}#{bottom}|
`-------'\n"""
			elsif @suit === "<>"
				return """
.-------.
|#{top} /\\  |
|  /  \\ |
|  \\  / |
|   \\/#{pad}#{bottom}|
`-------'\n"""
            elsif @suit === "o8<"
        		return """
.-------.
|#{top} _   |
|  ( )  |
| (_x_) |
|   Y #{pad}#{bottom}|
`-------'\n"""
			else
				return """
.-------.
|#{top} .   |
|  / \\  |
| (_,_) |
|   I #{pad}#{bottom}|
`-------'\n"""
			end
		end
	end
end