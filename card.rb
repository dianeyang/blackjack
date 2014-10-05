club = """
.------.
|B.--. |
| :(): |
| ()() |
| '--'B|
`------'
"""
heart = """
.------.
|A.--. |
| (\\/) |
| :\\/: |
| '--'A|
`------'
"""

diamond = """
.------.
|C.--. |
| :/\\: |
| :\\/: |
| '--'C|
`------'
"""

spade = """
.------.
|L.--. |
| :/\\: |
| (__) |
| '--'L|
`------'
"""

module Blackjack
	class Card
		attr_reader :value
		attr_reader :suit
		attr_reader :type
		def initialize(value=nil)
			card = (1..10).to_a.sample
			@value = card
			@suit = ["<3", "o8<", "<>", "<8<"].sample
			@type = card
		end
		def print_card
			return "#{@type} #{@suit}"
		end
	end
end