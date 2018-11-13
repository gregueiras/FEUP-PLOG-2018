
:- ensure_loaded(includes).

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

analyse_validMoves(Board,Player_Color,List,Tmp,Cells) :-
    length(List,N),
    N = 0,
    Cells = Tmp , !.

%verifies if the player wins, if so the value of the play is -500
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    Player_Color = Color,
    can_player_win(Board,Player_Color,(X,Y,Color),Res),
    Res = 1, 
    create_move(X,Y,Player_Color,Move),
    append(Tmp,[[-500,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp, Cells) , !.

%verifies if the player loses, if so the value of the play is 500
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    Player_Color = Color,
    can_player_loose(Board,Player_Color,(X,Y,Color),Res),
    Res = 1,
    create_move(X,Y,Player_Color,Move),
    append(Tmp,[[500,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp, Cells), !.

analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    getOppositeColor(Player_Color,OpColor),
    findAllNeighbors(Board,OpColor,[(X,Y)],[],Neighbors),
    length(Neighbors,N),
    N1 is N-1,
    N1 == 4,
    %trace,
    process_neighbors(Board,OpColor,Neighbors,X,Y,NX,NY),
    %trace,
    create_move(NX,NY,OpColor,Move),
    append(Tmp,[[-600,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp, Cells), !.

    %vou buscar os vizinhos
    %vejo qual e o grupo de 1
    %jogo num vizinho valido e que nao faca o outro ganhar do g1

%verifies if the other player wins, if so the value of the play is -500
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    Player_Color = Color,
    can_op_player_win(Board,Player_Color,(X,Y,Color),Res),
    Res = 1,
    create_move(X,Y,Player_Color,Move),
    append(Tmp,[[-500,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color, T, NewTmp, Cells) , !.

% se uma celula tiver 1 ou mais vizinhos da cor do adversario jogo nessa
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    Color = Player_Color,
    getOppositeColor(Player_Color,OpColor),
    countCellNeighbors(Board,X,Y,OpColor, Count),
    Count >= 1,
    Value is Count * (-20),
    create_move(X,Y,Player_Color,Move),
    append(Tmp,[[Value,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp, Cells) , !.

analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    findFirstNeighbors(Board,X,Y,_S,Color,[],FN),
    length(FN,N),
    N >= 2,
    findFirstEmptyCellNeighbors(Board,X,Y,EmptyNeighbors),
    findFirstValidNeighbor(Board,EmptyNeighbors,Player_Color,MoveFlag,Move),
    MoveFlag = 1,
    append(Tmp,[[-30,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp, Cells) , !.


analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    Color = Player_Color,
    countCellNeighbors(Board,X,Y,Player_Color, Count),
    Count > 1,
    create_move(X,Y,Player_Color,Move),
    append(Tmp,[[-20,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp, Cells) , !.


%prioritizes? the use of its color over the op player color
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    Color = Player_Color,
    create_move(X,Y,Color,Move),
    append(Tmp,[[-5,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp,Cells) , !.


analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],Tmp,Cells) :-
    create_move(X,Y,Color,Move),
    append(Tmp,[[0,Move]], NewTmp),
    analyse_validMoves(Board, Player_Color,T,NewTmp,Cells) , !.


findFirstValidNeighbor(Board,[],Color,0,Move).

findFirstValidNeighbor(Board,[(X,Y)|T],Color, MoveFlag, Move) :-
    isValidPlay(Board,X,Y,Color),
    create_move(X,Y,Color,Move),
    MoveFlag = 1.

findFirstValidNeighbor(Board,[(X,Y)|T],Color,MoveFlag, Move) :-
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
    checkForWinnerPlay(Cells,WinnerMove,WinnerFlag),
    WinnerFlag = 1,
    read_move(WinnerMove,X,Y,Color).

select_lvl1_move(Cells,X,Y,Color) :-
    checkForWinnerPlay(Cells,WinnerMove,WinnerFlag),
    WinnerFlag = 0,
    getRandomNotLoserMove(Cells,X,Y,Color).


getRandomNotLoserMove(Cells, X,Y,Color) :-
    random_member([Value,Move],Cells),
    length(Cells,N),
    N > 1,
    Value == 500,
    getRandomNotLoserMove(Cells,X,Y,Color).

getRandomNotLoserMove(Cells, X,Y,Color) :-
    random_member([Value,Move],Cells),
    read_move(Move,X,Y,Color).
   
checkForWinnerPlay([[Value,Move]|T], WinnerMove, WinnerFlag) :-
    Value = -500,
    WinnerMove = Move,
    WinnerFlag = 1.

checkForWinnerPlay([[Value,Move]|T], WinnerMove, WinnerFlag) :-
    WinnerFlag = 0.

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
    append(TmpMoves,[Move], NewMoves),
    random_member(BestMove,NewMoves).

getBestMove([[Value,Move]|T], BestMove) :-
    BestMove = Move.



choose_move(Board,Level,X,Y,Color) :-
    (Level = 1 -> choose_move_Lvl1(Board,X,Y,Color);
    Level = 2 -> choose_move_Lvl2(Board,X,Y,Color)),
    print_move(X,Y,Color).

print_move(X,Y,Color) :-
    write('x-coordinate: '),
    write(X), nl,
    write('y-coordinate: '),
    write(Y), nl,
    write('color: '),
    write(Color), nl.


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
remove_duplicates([[Value, Move] | Tail], Tmp, Res):-
    member([_,Move],Tail),
    remove_duplicates(Tail, Tmp, Res).

remove_duplicates([[Value, Move] | Tail], Tmp, Res):-
    remove_duplicates(Tail, [[Value, Move] | Tmp], Res).




