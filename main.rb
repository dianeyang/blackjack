require './blackjack'

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
print "> "
nplayers = $stdin.gets.chomp.to_i

puts "#{nplayers} players? Sounds good. What are your names?", ""

players = Array.new(nplayers)
players.each_with_index do |item, i|
	print "Player #{i+1}: "
	name = $stdin.gets.chomp
	players[i] = Blackjack::Player.new(name)
	puts "Nice to meet you, #{name}!", ""
end
deck = Blackjack::Deck.new
dealer = Blackjack::Dealer.new(deck)

Blackjack::Game.new(players, dealer).play