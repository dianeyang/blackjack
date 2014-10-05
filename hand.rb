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
			@cards << card
		end
		def split
			hand1 = Blackjack::Hand.new([self.get(0)], @bet)
			hand2 = Blackjack::Hand.new([self.get(1)], @bet)
			return hand1, hand2
		end
		def print_hand
			string = ""
			@cards.each do |card|
				string += card.print_card + ", "
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