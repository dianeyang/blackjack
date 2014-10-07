module Blackjack
	class Game
		def initialize(players)
			@players = players
			@dealer = Blackjack::Dealer.new
			@round = 0
		end
		def active_players
			return @players.select {|player| player.is_active}
		end
		def eligible_players
			return @players.select {|player| !player.has_lost}
		end
		def reset_game
			@players.each do |player|
				if player.cash <= 0
					puts "Sorry #{player.name}, but you'll have to sit this out. You don't have any money left."
					next
				end
				player.reset
			end
			@round = 0
		end
		def declare_bets
			self.active_players.each do |player|
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
				player.hands[0].bet = bet
				puts "Your bet is #{bet}", ""
			end
		end
		def distribute_cards
			@dealer.deck.shuffle
			self.active_players.each do |player|
				card1 = @dealer.deal_one
				card2 = @dealer.deal_one
				player.add_card(card1, 0)
				player.add_card(card2, 0)
				puts "#{player.name} got dealt a #{card1.type} #{card1.suit} and a #{card2.type} #{card2.suit}."
			end
			faceup = @dealer.deal_to_self
			puts "The dealer has a #{faceup.type} #{faceup.suit} and a face-down card."
			puts ""
		end
		def do_moves
			self.active_players.each do |player|
				puts "#{player.name}'s turn:"
				player.hands.each_index do |i|
					next if !player.hands[i].active
					puts "Hand \##{i+1}:"
					move = player.get_move(@round, i)
					self.handle_decision(move, player, i)
				end
			end
		end
		def handle_decision(move, player, i)
			case
			when move == "h"
				player.hit(@dealer.deal_one, i)
			when move == "e"
				player.stand(i)
			when move == "d"
				player.double(@dealer.deal_one, i)
			when move == "s"
				player.split
			when move == "r"
				player.surrender(i)
			end
		end
		def determine_winners
			if self.eligible_players.empty?
				puts "All players lost. Better luck next time!"
				return
			end
			puts "All players have either bust, surrendered, or are standing."
			puts "Time to determine winners among the remaining #{self.eligible_players.length} players.", ""
			target = @dealer.reveal
			self.eligible_players.each do |player|
				player.hands.each_index do |i|
					next if player.hands[i].lost
					value = player.hands[i].calc_value
					if value > target
						player.win(i)
					elsif value == target
						player.tie(i)
					else
						player.lose(i)
					end
				end
			end
		end
		def play
			while true
				self.reset_game
				if self.active_players.length == 0
					puts "No one has cash left. Guess it's game over. Thanks for playing!"
					break
				end
				# each player makes bets
				self.declare_bets

				# dealer deals 2 cards to each player
				# dealer deals 1 face-up card and 1 face-down card to himself
				self.distribute_cards

				# players go around the table deciding what moves to make
				while !self.active_players.empty?
				 	self.do_moves
				 	@round += 1
				end
				# the dealer reveals the hole card and hits until 17

				# whoever won gets their bet
				self.determine_winners

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