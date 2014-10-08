module Blackjack
	class Game
		def initialize
			puts """
			  ____  _            _     _            _    
			 | __ )| | __ _  ___| | __(_) __ _  ___| | __
			 |  _ \\| |/ _` |/ __| |/ /| |/ _` |/ __| |/ /
			 | |_) | | (_| | (__|   < | | (_| | (__|   < 
			 |____/|_|\\__,_|\\___|_|\\_\\/ |\\__,_|\\___|_|\\_\\
			                        |__/  by Diane Yang
			"""
			puts "\n\n"
			puts "Hello there, lucky ladies and gents! I'll be your dealer tonight."
			puts "But first, how many players are at the table?"

			begin
				print "> "
				nplayers = $stdin.gets.chomp.to_i
				puts ""
				if nplayers <= 0
					puts "Invalid number of players. Please try again."
				elsif nplayers > 10
					puts "Sorry, we only have room for up to 10 people. Please try again."
				end
			end while nplayers <= 0 || nplayers > 10

			puts "#{nplayers} players? Sounds good. What are your names?", ""

			players = Array.new(nplayers)
			players.each_with_index do |item, i|
				print "Player #{i+1}: "
				name = $stdin.gets.chomp
				players[i] = Blackjack::Player.new(name)
				puts "Nice to meet you, #{name}!", ""
			end

			@players = players
			@dealer = Blackjack::Dealer.new
			@turn = 0
			@round = 0
		end
		# active_players: returns players in the game who still need to make moves
		# on some of their hands.
		def active_players
			return @players.select {|player| player.is_active}
		end
		# eligible_players: players who are eligible to win (i.e. those who haven't
		# surrendered or bust)
		def eligible_players
			return @players.select {|player| !player.has_lost}
		end
		def non_bankrupt_players
			return @players.select {|player| player.cash > 0 }
		end
		# reset_game: reset the players who are able to play in the next round
		def reset_game
			@players.each do |player|
				if player.cash <= 0
					puts "Sorry #{player.name}, but you'll have to sit this out. You don't have any money left."
				end
				player.reset
			end
			@dealer.reset
			@turn = 0
		end
		def declare_bets
			self.active_players.each do |player|
				puts "#{player.name}, what is your bet? You may bet an integer between 1 and 1000"
				puts "You currently have $#{player.cash}."

				begin
					print "> "
					bet = $stdin.gets.chomp.to_i
					puts ""
					if bet > player.cash
						puts "Sorry, you don't have enough money to bet $#{bet}. Please try again."
						puts "You currently have $#{player.cash}."
					elsif bet <= 0
						puts "Invalid bet. Please try again."
					end
				end while bet > player.cash || bet <= 0

				player.set_bet(0, bet)
				puts "Your bet is #{bet}", ""
			end
		end
		# distribute_cards: deal 2 cards to each player and the dealer
		# at the start of the game
		def distribute_cards
			@dealer.shuffle_deck
			self.active_players.each do |player|
				card1 = @dealer.deal_one
				card2 = @dealer.deal_one
				puts "#{player.name} got dealt a #{card1.type} #{card1.suit} and a #{card2.type} #{card2.suit}."
				player.add_card(card1, 0)
				player.add_card(card2, 0)
			end
			faceup = @dealer.deal_to_self
			puts "The dealer has a #{faceup.type} #{faceup.suit} and a face-down card."
			puts ""
		end
		def do_moves
			self.active_players.each do |player|
				puts "==============================================="
				puts "#{player.name}'s turn:".upcase
				puts "===============================================", ""
				player.hands.each_index do |i|
					next if !player.hands[i].active
					puts "Hand \##{i+1}:".upcase
					move = player.get_move(@turn, i)
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
				player.double(@dealer.deal_one)
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
			puts "===============================================", ""
			puts "All players have either bust, surrendered, or are standing."
			puts "Time to determine winners among the remaining #{self.eligible_players.length} players!", ""
			puts """
               \\`\\/\\/\\/`/
                )======(
              .'        '.
             /    _||__   \\
            /    (_||_     \\
           |     __||_)     |
           |       ||       |
           '.              .'
             '------------'
			"""
			target = @dealer.reveal
			self.eligible_players.each do |player|
				player.hands.each_index do |i|
					next if player.hands[i].lost
					value = player.hands[i].clamp_value(target, 21)
					if value < 0 # there was no value between target and 21
						player.lose(i)
					elsif value > target || (player.hands[i].is_blackjack && !@dealer.hand.is_blackjack)
						player.win(i)
					else
						player.tie(i)
					end
				end
			end
			puts ""
		end
		def discard_cards
			to_discard = Array.new
			@players.each do |player|
				to_discard.concat(player.get_all_cards)
				player.reset
			end
			@dealer.replenish_deck(to_discard)
		end
		def play
			while true
				self.reset_game

				puts "==============================================="
				puts "ROUND #{@round+1}"
				puts "===============================================", ""

				# each player makes bets
				self.declare_bets

				# dealer deals 2 cards to each player, as well as
				# 1 face-up card and 1 face-down card to himself
				self.distribute_cards

				# players go around the table deciding what moves to make
				while !self.active_players.empty?
				 	self.do_moves
				 	@turn += 1
				end

				# the dealer reveals the hole card and hits until 17
				# whoever won gets their bet
				self.determine_winners

				# can't play any more if everyone is bankrupt
				if self.non_bankrupt_players.length == 0
					puts "No one has cash left. Guess it's game over. Thanks for playing!"
					break
				end

				# put cards from this round back in the deck
				self.discard_cards

				puts "Play another round? (Y/N)"
				print "> "
				begin
					response = $stdin.gets.chomp.downcase
					puts ""
					if response == "n"
						puts "Thanks for playing Blackjack!"
						return
					elsif response == 'y'
						# something
					else
						puts "Invalid response. Please try again."
					end
				end while response != 'n' && response != 'y'

				puts ""
				@round += 1
			end
		end
	end
end