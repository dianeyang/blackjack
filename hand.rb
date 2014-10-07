module Blackjack
	class Hand
		attr_accessor :bet
		attr_accessor :active
		attr_accessor :lost
		attr_reader :cards
		attr_reader :current_value
		def initialize(cards=Array.new, bet=nil)
			@cards = cards
			@bet = bet
			@active = true
			@lost = false
			@n_aces = cards.select {|card| card.type === "A"}.length
		end
		def get(index)
			return @cards[index]
		end
		def get_size
			return @cards.length
		end
		def clear
			@cards = Array.new
		end
		def add_card(card)
			if card.type === "A"
				@has_ace = true
			end
			@cards << card
		end
		def split
			hand1 = Blackjack::Hand.new([self.get(0)], @bet)
			hand2 = Blackjack::Hand.new([self.get(1)], @bet)
			return hand1, hand2
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
		def calc_value
			total = 0
			@cards.each do |card|
				total += card.value
			end
			return total
		end
	end
end