BLACKJACK
by Diane Yang

=============

HOW TO PLAY:
Just run "ruby main.rb" from the command line.

=============

COMMENTS:
There are many variations of Blackjack, so here are a few notes about this implementation:

- This game uses 6 decks shuffled together.

- The table is limited to 8 people. This decision was made because in real life, the dealer only has a certain number of cards and can therefore only support a game with a certain maximum number of people.

- Players have the option to hit, stand, surrender, double down, or split. Doubling down and splitting can only happen on hands with exactly 2 cards.

- Players can only split 2 cards if they have exactly the same type. i.e. they cannot split a K and a 10 even though both of their values are 10. Players can split a maximum of 3 times (leaving them with at most 4 hands).

- The dealer hits on a soft 17.

- A player automatically stands if he/she hits 21.

- Players are not allowed to bet money they do not have. So, can only bet an integer amount of money between 1 and their total cash. Furthermore, they cannot double down or split if they cannot afford it, and they're out of the game if they go bankrupt.

- If a player ties with a dealer, he/she neither loses nor wins money.

- Blackjacks (when your first 2 cards have a value of 21) always win over non-blackjacks.

=============

ASCII art credits:

Blackjack text:
http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20

Money bag:
http://www.angelfire.com/ca/mathcool/unsorted.html

Cards:
http://www.retrojunkie.com/asciiart/sports/cards.htm

