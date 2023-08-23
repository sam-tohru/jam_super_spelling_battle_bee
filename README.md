# super_spelling_battle_bee
an asynchronous multiplayer word game I made in Godot 4 (in 1 week for a game-jam)

can be played online at itch: https://kobemano.itch.io/super-spelling-battle-bee

This uses SilentWolf back-end for godot games, to basically save user generated words, which will then be loaded in as enemies for other players to battle
making this asynchronous multiplayer word game, you move the letters to form a valid word, click battle and fight someone elses word
The gameplay loop in programming terms: Player forms a word on the top-row -> these letters are checked against an open-source word dictionary -> if valid word the player moves to the battle-phase -> randomly loads another persons saved word (saved on SilentWolf) -> and they battle

A Current weird problem that I encountered revolving around this asynchronous multiplayer part is player names, to save words so that other players can battle them I need to save in a dictionary both a key (the name) & the data (the word). So right now names are randomly generated 3 letter words (as seen in the menu, the player can generate a new 3 letter name), this is a simple solution implemented due to the time-limit on the game-jam, however the problem is that only 1 word can be saved to 1 name, so sometimes people can get the same random name and overright an older players word (I think this is fine in the context of it being a game-jam game)

BUGS & FIXES NOTICES:

 1. _FIXED_ ~This github version upload will spawn Letters behind the Board (works normally on the playable itch web build, but something changed and need to adjust where the letters spawn), you can still click on the letters & form words (as you can see the "scrabble" piece, but the drawn letter sprites are behind)~
 2. Click & Dragging letters is a bit weird sometimes, I currently have this as a setting (default is player clicks on letter & then clicks where to go) but i think dragging the letters is more intuitive 
