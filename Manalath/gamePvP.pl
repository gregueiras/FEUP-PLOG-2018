:- ensure_loaded(game).

  
play_game_loop_PvP(Board,Winner) :-
  (Winner = 1; Winner = 2; Winner = -1),
  display_game_winner(Board,Winner), !.


play_game_loop_PvP(Board,Winner) :-
 getCurrentPlayer(Player),
 display_game(Board,Player), !,
 read_validate_info(Board,X,Y,Color),
 setCurrentColor(Player, Color),
 move(X,Y, Board,NewBoard),
 game_over(NewBoard, New_Winner),
 getCurrentPlayerValue(ValidPlay),
 switchCurrentPlayer(ValidPlay),
 play_game_loop_PvP(NewBoard, New_Winner).

play_game_PvP :-
  initial_board(Board),
  assertPlayer, %initializes the players
  play_game_loop_PvP(Board,0).




