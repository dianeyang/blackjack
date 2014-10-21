module Blackjack
	class HandCollection
		attr_reader :hands
		def initialize(hands = Array.new)
			@hands = hands
		end
		def get(i)
			return @hands[i]
		end
		def length
			return @hands.length
		end
		def has_lost
			return @hands.reduce(true) do |others, current|
				others && current.lost
			end
		end
		def print(with_status = false)
			@hands.each_index do |i|
				puts @hands[i].to_string
				puts "Bet: $#{@hands[i].bet}"
				if with_status
					puts "Status: #{@hands[i].status}"
				end
				puts ""
			end
		end
		def total_at_stake(moves)
			total = 0
			moves.zip(@hands).each do |move, hand|
				if move == "s" || move == "d"
					total += 2 * hand.bet
				elsif move == "r"
					total += 0.5 * hand.bet
				else
					total += hand.bet
				end
			end
			return total
		end
		def add(update)
			@hands.concat(update)
		end
		def get_all_cards
			cards = Array.new
			@hands.each do |hand|
				cards.concat(hand.cards)
			end
			return cards
		end
	end
end