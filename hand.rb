module Blackjack
	class Hand
		attr_accessor :bet
		attr_accessor :active
		attr_accessor :lost
		attr_reader :cards
		attr_reader :current_value
		attr_reader :min_value
		attr_reader :n_aces
		def initialize(cards=Array.new, bet=nil)
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
		def add_card(card)
			if card.type === "A"
				@n_aces += 1
			end
			@cards << card
			@min_value += card.value
		end
		def split
			hand1 = Blackjack::Hand.new([self.get(0)], @bet)
			hand2 = Blackjack::Hand.new([self.get(1)], @bet)
			return hand1, hand2
		end
		def in_range(min, max)
			value = @min_value
			n_aces = @n_aces
			while value < min && n_aces > 0
				value += 10
				n_aces -= 1
			end	
			if value > max
				return false
			end
			return true
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