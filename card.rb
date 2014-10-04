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
	class Game
		attr_accessor :value
		attr_accessor :suit
		def initialize(value, suit)
			@value = value
			@suit = suit
	end
end