:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_board(Board).

tp :-
  initial_board(_B), print_board(_B).