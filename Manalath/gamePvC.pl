:- ensure_loaded(game).

%se jogar aqui ganho? -> conta os vizinhos da minha cor, se forem 4 jogo
%se jogar aqui perco? -> conta os vizinhos da minha cor, se forem 3 nao jogo
%se nao jogar aqui ele ganha? ->conta os vizinhos da cor do outro se forem 4 jogo

can_player_win(Board,Player_Color,(X,Y,Color), Res) :-
    countCellNeighbors(Board,X,Y,Player_Color,Count),
    Count = 4 -> Res = 1;
    Res = 0.
    
can_op_player_win(Board,Player_Color,(X,Y,Color),Res) :-
    getOppositeColor(Player_Color, OpColor),
    countCellNeighbors(Board,X,Y,OpColor,Count),
    Count = 4 -> Res = 1;
    Res = 0.

can_player_loose(Board,Player_Color,(X,Y,Color),Res) :-
    countCellNeighbors(Board,X,Y,Player_Color,Count),
    Count = 3 -> Res = 1;
    Res = 0.

choose_from_validMoves(Board,Player_Color,List,Tmp,Cells) :-
    length(List, N),
    N == 0,
    Cells = Tmp.

choose_from_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    can_player_win(Board,Player_Color,(X,Y,Color),Res),
    Res = 1, 
    append([],[(X,Y,Player_Color)], Cells).

choose_from_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    can_op_player_win(Board,Player_Color,(X,Y,Color),Res),
    Res = 1,
    append([],[(X,Y,Player_Color)], Cells).

choose_from_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    can_player_loose(Board,Player_Color,(X,Y,Color),Res),
    Res = 1,
    choose_from_validMoves(Board, Player_Color,T,Tmp, Cells).

choose_from_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    append(Tmp,[(X,Y,Player_Color)], New_Tmp),
    choose_from_validMoves(Board, Player_Color,T,New_Tmp,Cells).

choose_move_Lvl1(Board,X,Y,Color) :-
    getCurrentPlayer(Player),
    getCurrentPlayerColor(Player_Color),
    valid_moves(Board,Player,ListOfMoves),
    choose_from_validMoves(Board,PLayer_Color,ListOfMoves,[],Cells),
    random_member(Move,Cells),
    getMove(Move,X,Y,Color).

getMove((X,Y, Color),RX,RY,RColor) :-
    RX = X,
    RY = Y,
    RColor = Color.

%TODO
choose_move_Lvl2(Board,X,Y,Color).

%TODO
choose_move_Lvl3(Board,X,Y,Color).

choose_move(Board,Level,X,Y,Color) :-
    Level = 1 -> choose_move_Lvl1(Board,X,Y,Color);
    Level = 2 -> choose_move_Lvl2(Board,X,Y,Color);
    Level = 3 -> choose_move_Lvl3(Board,X,Y,Color).
  
play_game_PvC :-
    initial_board(Board),
    assertPlayers_PvC, %initializes the players
    play_game_loop(Board,0). %passar o lvl aqui

