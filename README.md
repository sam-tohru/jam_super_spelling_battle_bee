# super_spelling_battle_bee
an asynchronous multiplayer word game I made in Godot 4 (in 1 week for a game-jam)

can be played online at itch: https://kobemano.itch.io/super-spelling-battle-bee

This uses SilentWolf back-end for godot games, to basically save user generated words, which will then be loaded in as enemies for other players to battle
making this asynchronous multiplayer word game, you move the letters to form a valid word, click battle and fight someone elses word


BUG NOTICES:
 1. This github version upload will spawn Letters behind the Board (works normally on the playable itch web build, but something changed and need to adjust where the letters spawn), you can still click on the letters & form words (as you can see the "scrabble" piece, but the drawn letter sprites are behind)
