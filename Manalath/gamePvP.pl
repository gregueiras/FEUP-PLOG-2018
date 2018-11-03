:- ensure_loaded(game).

play_game_PvP :-
  initial_board(Board),
  assertPlayers_PvP, %initializes the players
  play_game_loop(Board,0).




