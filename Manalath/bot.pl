
:- ensure_loaded(includes).

%se jogar aqui ganho? -> conta os vizinhos da minha cor, se forem 4 jogo
%se jogar aqui perco? -> conta os vizinhos da minha cor, se forem 3 nao jogo
%se nao jogar aqui ele ganha? -> conta os vizinhos da cor do outro se forem 4 jogo
can_player_win(Board,Player_Color,(X,Y,_), 1) :-
    countCellNeighbors(Board,X,Y,Player_Color,4).

can_player_win(_,_,(_,_,_), 0).
    
can_op_player_win(Board,Player_Color,(X,Y,_Color),1) :-
    getOppositeColor(Player_Color, OpColor),
    countCellNeighbors(Board,X,Y,OpColor,4).

can_op_player_win(_,_,(_,_,_),0).

can_player_loose(Board,Player_Color,(X,Y,_Color),1) :-
    countCellNeighbors(Board,X,Y,Player_Color,3).

can_player_loose(_,_,(_,_,_),0).

analyse_validMoves(_Board,_Player_Color,[],Cells,Cells) :- !.

%verifies if the player wins, if so the value of the play is -500
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],Tmp,Cells) :-
    can_player_win(Board,Player_Color,(X,Y,Player_Color),1),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[-500, Move] | Tmp], Cells) , !.

%verifies if the player loses, if so the value of the play is 500
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],Tmp,Cells) :-
    can_player_loose(Board,Player_Color,(X,Y,Player_Color),1),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[500, Move] | Tmp], Cells) , !.

analyse_validMoves(Board,Player_Color,[(X,Y,_)|T],Tmp,Cells) :-
    getOppositeColor(Player_Color,OpColor),
    findAllNeighbors(Board,OpColor,[(X,Y)],[],Neighbors),
    length(Neighbors,5),
    process_neighbors(Board,OpColor,Neighbors,X,Y,NX,NY),
    create_move(NX,NY,OpColor,Move),
    analyse_validMoves(Board, Player_Color, T, [[-600, Move] | Tmp], Cells) , !.

    %vou buscar os vizinhos
    %vejo qual e o grupo de 1
    %jogo num vizinho valido e que nao faca o outro ganhar do g1

%verifies if the other player wins, if so the value of the play is -500
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],Tmp,Cells) :-
    can_op_player_win(Board,Player_Color,(X,Y,Player_Color),1),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[-500, Move] | Tmp], Cells) , !.

% se uma celula tiver 1 ou mais vizinhos da cor do adversario jogo nessa
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],Tmp,Cells) :-
    getOppositeColor(Player_Color,OpColor),
    countCellNeighbors(Board,X,Y,OpColor, Count),
    Count >= 1,
    Value is Count * (-20),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[Value, Move] | Tmp], Cells) , !.

analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    findFirstNeighbors(Board,X,Y,_S,Color,[],FN),
    length(FN,N),
    N >= 2,
    findFirstEmptyCellNeighbors(Board,X,Y,EmptyNeighbors),
    findFirstValidNeighbor(Board,EmptyNeighbors,Player_Color,1,Move),
    analyse_validMoves(Board, Player_Color, T, [[-30, Move] | Tmp], Cells) , !.

analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],Tmp,Cells) :-
    countCellNeighbors(Board,X,Y,Player_Color, Count),
    Count > 1,
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[-20, Move] | Tmp], Cells) , !.

%prioritizes? the use of its color over the op player color
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],Tmp,Cells) :-
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[-5, Move] | Tmp], Cells) , !.

analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    create_move(X,Y,Color,Move),
    analyse_validMoves(Board, Player_Color, T, [[0, Move] | Tmp], Cells) , !.

findFirstValidNeighbor(_Board,[],_Color,0,_Move).

findFirstValidNeighbor(Board,[(X,Y)|_T],Color, 1, Move) :-
    isValidPlay(Board,X,Y,Color),
    create_move(X,Y,Color,Move).

findFirstValidNeighbor(Board,[(_X,_Y)|T],Color,MoveFlag, Move) :-
    findFirstValidNeighbor(Board,T,Color,MoveFlag, Move).

get_validMoves(Board,ListOfMoves) :-
    getCurrentPlayer(Player),
    valid_moves(Board,Player,ListOfMoves).

choose_move_Lvl1(Board,X,Y,Color) :-
    get_validMoves(Board,ListOfMoves),
    getCurrentPlayerColor(Player_Color),
    analyse_validMoves(Board,Player_Color,ListOfMoves,[],Cells),
    sort(Cells, SortedCells),
    select_lvl1_move(SortedCells,X,Y,Color).

select_lvl1_move(Cells,X,Y,Color) :-
    checkForWinnerPlay(Cells,WinnerMove,1),
    read_move(WinnerMove,X,Y,Color).

select_lvl1_move(Cells,X,Y,Color) :-
    checkForWinnerPlay(Cells,_WinnerMove,0),
    getRandomNotLoserMove(Cells,X,Y,Color).


getRandomNotLoserMove(Cells, X,Y,Color) :-
    random_member([500,_Move],Cells),
    length(Cells,N),
    N > 1,
    getRandomNotLoserMove(Cells,X,Y,Color).

getRandomNotLoserMove(Cells, X,Y,Color) :-
    random_member([_Value,Move],Cells),
    read_move(Move,X,Y,Color).
   
checkForWinnerPlay([[-500,WinnerMove]|_T], WinnerMove, 1).
checkForWinnerPlay([[_Value,_Move]|_T], _WinnerMove, 0).

choose_move_Lvl2(Board,X,Y,Color) :-
    get_validMoves(Board,ListOfMoves),
    getCurrentPlayerColor(Player_Color),
    analyse_validMoves(Board,Player_Color,ListOfMoves,[],Cells),
    sort(Cells, SortedCells),
    remove_duplicates(SortedCells, FinalCells),
    getBestMove(FinalCells,Move),
    read_move(Move,X,Y,Color).



getBestMove(ListOfMoves,BestMove) :-
    length(ListOfMoves,Len),
    findall(0,
    (
        member([0,_], ListOfMoves);
        member([-5,_], ListOfMoves)
    ),
    TmpValues),
    length(TmpValues,Len),
    random_member([_,BestMove],ListOfMoves).

getBestMove([[Value,Move]|T], BestMove) :-
    findall(TmpMove,
    (
        member([Value,TmpMove], T)
    ),
    TmpMoves),
    random_member(BestMove, [Move | TmpMoves]).

getBestMove([[_Value,Move]|_T], BestMove) :-
    BestMove = Move.

choose_move(Board,1,X,Y,Color) :-
    choose_move_Lvl1(Board,X,Y,Color),
    print_move(Board, X,Y,Color).

choose_move(Board,2,X,Y,Color) :-
    choose_move_Lvl2(Board,X,Y,Color),
    print_move(Board, X,Y,Color).

print_move(Board, X,Y,Color) :-
    coordsToUser(Board, X, Y, Letter, Number),
    nl, nl,
    write(Color),
    write(' played on: '),
    write(Letter), write(Number), nl, nl.


process_neighbors(Board,Color,Neighbors,X,Y, NX,NY) :-
    select((X,Y), Neighbors, Surrounding),
    member((FX,FY), Surrounding),
    countCellNeighbors(Board,FX,FY,Color,0),
    findFirstEmptyCellNeighbors(Board,FX,FY,FirstN),
    member((NX,NY),FirstN),
    isValidPlay(Board,NX,NY,Color),
    \+ countCellNeighbors(Board,NX,NY,Color,4).

remove_duplicates(OldList, NewList) :-
    remove_duplicates(OldList, [], TmpList),
    reverse(TmpList, NewList).
    

remove_duplicates([], Res, Res).
remove_duplicates([[_Value, Move] | Tail], Tmp, Res):-
    member([_,Move],Tail),
    remove_duplicates(Tail, Tmp, Res).

remove_duplicates([[Value, Move] | Tail], Tmp, Res):-
    remove_duplicates(Tail, [[Value, Move] | Tmp], Res).