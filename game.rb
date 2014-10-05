module Blackjack
	class Game
		def initialize(players, table, dealer)
			@players = players
			@table = table
			@dealer = dealer
			@round = 0
		end
		def declare_bets
			@players.each do |player|
				puts "#{player.name}, what is your bet? You may bet an integer between 1 and 1000"
				puts "You currently have $#{player.cash}"
				print "> "
				bet = $stdin.gets.chomp.to_i
				while bet > player.cash
					puts "Sorry, you don't have enough money to bet $#{bet}."
					puts "You currently have $#{player.cash}"
					print "> "
					bet = $stdin.gets.chomp.to_i
				end
				player.bet = bet
				puts "Your bet is #{bet}", ""
			end
		end
		def distribute_cards
			@players.each do |player|
				card1 = @dealer.deal_one
				card2 = @dealer.deal_one
				player.add_card(card1)
				player.add_card(card2)
				puts "#{player.name} got dealt a #{card1.type} of #{card1.suit} and a #{card2.type} of #{card2.suit}."
			end
			faceup = @dealer.deal_to_self
			puts "The dealer has a #{faceup.type} of #{faceup.suit} and a face-down card."
		end
		def do_moves
			puts "moves"
			$stdin.gets
		end
		# 	@players.each do |player|
		# 		if !player.active
		# 			return

		# 		puts "What do you want to do?"
		# 		puts "H: Hit (take a card)"
		# 		puts "E: Stand (end turn)"
		# 		puts "D: Double (double bet and take one card)"
		# 		puts "S: Split (If the 2 cards have equal value, separate them and make 2 hands"
		# 		puts "X: Surrender (Give up a half-bet and retire from game)"
		# 		print "> "
		# 		move = $stdin.gets.chomp.downcase
		# 		puts "You chose #{move}", ""

		# 		case move
		# 		when "h"
		# 			player.hit(@dealer.deal_one)
		# 		when "e"
		# 			player.stand
		# 		when "d"
		# 			can_double = player.double(@dealer.deal_one)
		# 			if !can_double
		# 				puts "Sorry, you don't have enough cash to double"
		# 			end
		# 		when "s"
		# 			# derp
		# 		when "x"
		# 			player.surrender
		# 		else
		# 			puts "invalid move"
		# 		end

		# 		still_in = player.do_move(move)
		# 		if !still_in
		# 			@remaining_players
		# 		end
		# 	end
		# end
		# def determine_winners
		# 	@remaining_players.each do |player|
		# 		value = player.get_value
		# 		if value > dealer.get_value && value <= 21
		# 			player.update_cash(player.bet)
		# 		end
		# 	end
		# 
		def active_players
			return @players.select {|player| player.active}
		end
		def play
			while true
				# each player makes bets
				self.declare_bets

				# dealer deals 2 cards to each player
				# dealer deals 1 face-up card and 1 face-down card to himself
				self.distribute_cards

				# # players go around the table deciding what moves to make
				while self.active_players
				 	self.do_moves
				end

				# # whoever won gets their bet
				# self.determine_winners
				# end
				return
			end
		end
	end
end