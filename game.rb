require './table'
require './player'

module Blackjack
	class Game
		def initialize(players)
			puts "new game started"
			@players = players
		end
	end
end