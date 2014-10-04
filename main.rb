require "./game"

puts """
  ____  _            _     _            _    
 | __ )| | __ _  ___| | __(_) __ _  ___| | __
 |  _ \\| |/ _` |/ __| |/ /| |/ _` |/ __| |/ /
 | |_) | | (_| | (__|   < | | (_| | (__|   < 
 |____/|_|\\__,_|\\___|_|\\_\\/ |\\__,_|\\___|_|\\_\\
                        |__/  by Diane Yang
"""

puts "\n\n"

prompt = '> '

puts "How many players are at the table?", prompt
nplayers = $stdin.gets.chomp.to_i

puts """
There are #{nplayers} players at the table.
"""

players = Array.new(nplayers)
for i in 1..nplayers
	players[i] = Blackjack::Player.new
end

Blackjack::Game.new(players).play