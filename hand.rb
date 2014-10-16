module Blackjack
	class Hand
		attr_accessor :bet
		attr_accessor :active
		attr_accessor :lost
		attr_reader :cards
		attr_reader :current_value
		attr_reader :min_value
		attr_reader :n_aces
		def initialize(cards=Array.new, bet=0)
			@cards = cards
			@bet = bet
			@active = true
			@lost = false
			@n_aces = cards.select {|card| card.type === "A"}.length
			@min_value = cards.reduce(0) do |others, current|
				others + current.value
			end
		end
		def get(index)
			return @cards[index]
		end
		def get_size
			return @cards.length
		end
		def is_blackjack
			return clamp_value(21, 21) && self.get_size == 2
		end
		def add_card(card)
			if card.type === "A"
				@n_aces += 1
			end
			@cards << card
			@min_value += card.value
		end
		def split(card1, card2)
			hand1 = Hand.new([self.get(0), card1], @bet)
			hand2 = Hand.new([self.get(1), card2], @bet)
			return hand1, hand2
		end
		# clamp_value: test if some interpretation of the hand has a value
		# that lies between min and max (inclusive).
		def clamp_value(min, max)
			value = @min_value
			n_aces = @n_aces
			while n_aces >= 0
				if value >= min && value <= max
					return value
				end
				value += 10
				n_aces -= 1
			end	
			return -1
		end
		def to_string
			string = ""
			ncards = self.get_size
			strings = @cards.map {|card| card.to_string}
			all_lines = strings.map {|string| string.split("\n")}
			n_lines = all_lines[0].length
			(0..n_lines-1).each do |i|
				all_lines.each do |lines|
					string += lines[i]
				end
				string += "\n"
			end
			return string
		end
		def max_value
			@min_value + 10*n_aces
		end
	end
end