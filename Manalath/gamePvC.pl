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

  
play_game_PvC :-
    initial_board(Board),
    assertPlayers_PvC, %initializes the players
    play_game_loop(Board,0).

