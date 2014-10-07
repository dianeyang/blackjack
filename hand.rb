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
			@has_ace = !cards.select {|card| card.type === "A"}.empty?
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
		def print_hand
			string = ""
			ncards = self.get_size
			@cards.each_with_index do |card, i|
				string += card.print_card
				if i != ncards-1
					string += ", "
				end
			end
			string += "\n"
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