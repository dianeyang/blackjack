module Blackjack
	class Game
		def initialize(players, dealer)
			@players = players
			@dealer = dealer
			@round = 0
		end
		def active_players
			return @players.select {|player| player.active}
		end
		def eligible_players
			return @players.select {|player| !player.lost}
		end
		def reset_game
			@players.each do |player|
				if player.cash > 0
					player.reset
				else
					puts "Sorry #{player.name}, but you'll have to sit this out. You don't have any money left."
				end
			end
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
				puts "#{player.name} got dealt a #{card1.type} #{card1.suit} and a #{card2.type} #{card2.suit}."
			end
			faceup = @dealer.deal_to_self
			puts "The dealer has a #{faceup.type} #{faceup.suit} and a face-down card."
			puts ""
		end
		def do_moves
			self.active_players.each do |player|
				valid = false
				while !valid
					move = player.make_decision(@round)
					valid = player.validate_decision(move, @round)
				end
				self.handle_decision(move, player)
			end
		end
		def handle_decision(move, player)
			case
			when move == "h"
				player.hit(@dealer.deal_one)
			when move == "e"
				player.stand
			when move == "d"
				player.double(@dealer.deal_one)
			when move == "s"
				player.split
			when move == "r"
				player.surrender
			end
		end
		def determine_winners
			target = @dealer.reveal
			self.eligible_players.each do |player|
				score = player.calc_score
				if score > target && score <= 21
					player.win
				else
					player.lose
				end
			end
		end
		def play
			while true
				self.reset_game
				# each player makes bets
				self.declare_bets

				# dealer deals 2 cards to each player
				# dealer deals 1 face-up card and 1 face-down card to himself
				self.distribute_cards

				# # players go around the table deciding what moves to make
				while !self.active_players.empty?
				 	self.do_moves
				 	@round += 1
				end

				# the dealer reveals the hole card and hits until 17

				# whoever won gets their bet
				if !self.eligible_players.empty?
					self.determine_winners
				else
					puts "All players lost. Better luck next time!"
				end

				puts "Play another round? (Y/N)"
				print "> "
				response = $stdin.gets.chomp.downcase
				if response == "n"
					puts "Thanks for playing Blackjack!"
					break
				end
			end
		end
	end
end