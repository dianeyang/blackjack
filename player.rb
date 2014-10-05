module Blackjack
	class Player
		attr_accessor :bet
		attr_accessor :cash
		attr_accessor :active
		attr_reader :name
		def initialize(name)
			@cash = 1000
			@bet = nil
			@hand = Array.new
			@active = true
			@name = name
		end
		def do_move(move)
			
		end
		def add_card(card)
			@hand << card
		end
		def hit(card)
			self.add_to_hand(card)
		end
		def stand
			@active = false
		end
		def double
			if @bet * 2 <= @cash
				@bet *= 2
				return true
			end
			return false
		end
		def split
		end
		def surrender
			@active = false
			@cash -= 0.5 * @bet
		end
	end
end