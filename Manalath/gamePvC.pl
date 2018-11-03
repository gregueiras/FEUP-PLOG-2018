:- ensure_loaded(game).


choose_move(Board,Level,X,Y,Color) :-
    getCurrentPlayer(Player),
    valid_moves(Board,Player,ListOfMoves),
    random_member(Move,ListOfMoves),
    getMove(Move,X,Y,Color).

getMove((X,Y, Color),RX,RY,RColor) :-
    RX = X,
    RY = Y,
    RColor = Color.

getInfo(Board,Player, X,Y,Color) :-
    Player = 1,
    read_validate_info(Board,X,Y,Color).

getInfo(Board,Player, X,Y,Color) :-
    Player = 2,
    choose_move(Board, 1, X, Y, Color).

play_game_loop_PvC(Board,Winner) :-
    (Winner = 1; Winner = 2; Winner = -1),
    display_game_winner(Board,Winner), !.
    
play_game_loop_PvC(Board,Winner) :-
   getCurrentPlayer(Player),
   display_game(Board,Player), !,
   getInfo(Board,Player, X,Y,Color),
   setCurrentColor(Player, Color),
   move(X,Y,Board,NewBoard),
   game_over(NewBoard, New_Winner),
   getCurrentPlayerValue(ValidPlay),
   switchCurrentPlayer(ValidPlay),
   play_game_loop_PvC(NewBoard, New_Winner).
  
play_game_PvC :-
    initial_board(Board),
    assertPlayer, %initializes the players
    play_game_loop_PvC(Board,0).

