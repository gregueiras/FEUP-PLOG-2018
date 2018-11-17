:- ensure_loaded(includes).


% can_player_win(+Board, +Player_Color, +(X,Y,Color), -Res)
% check if the player whose color is Player_Color wins if he plays in the X and Y position of the Board with is color
% Res is 1 if the player wins and 0 otherwise
can_player_win(Board,Player_Color,(X,Y,_), 1) :-
    countCellNeighbors(Board,X,Y,Player_Color,4).

can_player_win(_,_,(_,_,_), 0).

% can_op_player_win(+Board, +Player_Color, +(X,Y,_Color), -Res) 
% check if the opposite player (from the one whose color is Player_Color) can win
% Res is 1 if the opposite player wins and 0 otherwise
can_op_player_win(Board,Player_Color,(X,Y,_Color),1) :-
    getOppositeColor(Player_Color, OpColor),
    countCellNeighbors(Board,X,Y,OpColor,4).

can_op_player_win(_,_,(_,_,_),0).

% can_player_lose(+Board, +Player_Color, +(X,Y,Color), -Res)
% check if the player whose color is Player_Color loses if he plays in the X and Y position of the Board with is color
% Res is 1 if the player loses and 0 otherwise
can_player_lose(Board,Player_Color,(X,Y,_Color),1) :-
    countCellNeighbors(Board,X,Y,Player_Color,3).

can_player_lose(Board,Player_Color,(X,Y,Player_Color),1) :-
    getOppositeColor(Player_Color, OpColor),
    countCellNeighbors(Board,X,Y,OpColor,3).

can_player_lose(_,_,(_,_,_),0).

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% analyse a list of possible moves, ranking them from best to worst by assigning each move an appropriate value
% In the end, Cells contains the valued moves
analyse_validMoves(_Board,_Player_Color,[],_SkipStep,Cells,Cells) :- !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% checks if the move being analised allows the player to win
% if the player wins, the value of the move is -600
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],_SkipStep,Tmp,Cells) :-
    can_player_win(Board,Player_Color,(X,Y,Player_Color),1),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T,0, [[-600, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% check if the move being analised makes the player lose
% if the player loses, the value of the move is 500
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],_SkipStep,Tmp,Cells) :-
    can_player_lose(Board,Player_Color,(X,Y,Player_Color),1),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T,0, [[500, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep, +Tmp, -Cells)
% processes the neighbors for the move being analysed
% if one of the neighbors has one or less neighbors with the color specified 
% creates a move for its first neighbor that is empty, valid and does not have 4 neighbors with the value -550
% only happens if SkipStep is 0 since the move itself was not analyse but one of the neighbors, the cell
% stays to be analysed
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],SkipStep,Tmp,Cells) :-
    SkipStep = 0,
    getPiece(Board, X, Y, emptyCell),
    getOppositeColor(Player_Color,OpColor),
    findAllNeighbors(Board,OpColor,[(X,Y)],[],Neighbors),
    length(Neighbors,5),
    process_neighbors(Board,OpColor,Neighbors,X,Y,NX,NY),
    create_move(NX,NY,OpColor,Move),
    analyse_validMoves(Board, Player_Color,[(X,Y,Color)|T],1, [[-550, Move] | Tmp], Cells) , !.


% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% check if the move being analised allows the other player to win
% if the other player wins, the value of the move is -500
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],_SkipStep,Tmp,Cells) :-
    can_op_player_win(Board,Player_Color,(X,Y,Player_Color),1),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, 0,[[-500, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% check if the analysed move has more than one neighbor with the opponents color
% if it does, the value of the move is the number of neighbors multiplied by -20
% this means that the priority of a move is proportional to the number of neighbors
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],_SkipStep,Tmp,Cells) :-
    getOppositeColor(Player_Color,OpColor),
    countCellNeighbors(Board,X,Y,OpColor, Count),
    Count >= 1,
    Value is Count * (-20),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T,0, [[Value, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep, +Tmp, -Cells)
% check if the move to analyse has more than 2 neighbors of the specified color
% if so, finds the cell's first empty and valid neighbor and creates a move for that neighbor with value -30
% only happens if SkipStep is 0 since the move itself was not analyse but one of the neighbors, the cell
% stays to be analysed
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],SkipStep,Tmp,Cells) :-
    SkipStep = 0,
    findFirstNeighbors(Board,X,Y,Color,[],FN),
    length(FN,2),
    findFirstEmptyCellNeighbors(Board,X,Y,EmptyNeighbors),
    findFirstValidNeighbor(Board,EmptyNeighbors,Player_Color,1,Move),
    analyse_validMoves(Board, Player_Color,[(X,Y,Color)|T], 1,[[-30, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% checks if the analysed move has more than one neighbor with the player color
% if it does, the value of the move is the number of neighbors multiplied by -20
% this means that the priority of a move is proportional to the number of neighbors
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],_SkipStep,Tmp,Cells) :-
    countCellNeighbors(Board,X,Y,Player_Color, Count),
    Count > 1,
    Value is Count * (-20),
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T,0, [[Value, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% prioritize the use of the playe's color of the oponent's color
% the value of the play is -5
analyse_validMoves(Board,Player_Color,[(X,Y,Player_Color)|T],_SkipStep, Tmp,Cells) :-
    create_move(X,Y,Player_Color,Move),
    analyse_validMoves(Board, Player_Color, T, 0,[[-5, Move] | Tmp], Cells) , !.

% analyse_validMoves(+Board, +Player_Color, +ListOfMoves, +SkipStep,+Tmp, -Cells)
% the value of the play is 0
analyse_validMoves(Board,Player_Color,[(X,Y,Color)|T],_SkipStep,Tmp,Cells) :-
    create_move(X,Y,Color,Move),
    analyse_validMoves(Board, Player_Color, T, 0, [[0, Move] | Tmp], Cells) , !.

% findFirstValidNeighbor(+Board, +[(X,Y)|T], +Color, -MoveFlag, -Move)
% finds the first valid neighbor from a list of neighbors and returns move with the neighbor coordinates and the
% specified color, if there is a valid neighbor the MoveFlag is set to 1, otherwise is set to 0
% the neighbors in the list are represented by an (X,Y) position
findFirstValidNeighbor(_Board,[],_Color,0,_Move).

findFirstValidNeighbor(Board,[(X,Y)|_T],Color, 1, Move) :-
    isValidPlay(Board,X,Y,Color),
    create_move(X,Y,Color,Move).

findFirstValidNeighbor(Board,[(_X,_Y)|T],Color,MoveFlag, Move) :-
    findFirstValidNeighbor(Board,T,Color,MoveFlag, Move).

% get_validMoves(+Board, -ListOfMoves)
% retrieves the current player's list of valid moves in the specified Board
get_validMoves(Board,ListOfMoves) :-
    valid_moves(Board,ListOfMoves).

% choose_move_Lvl1(+Board, -X,-Y, -Color)
% chooses the move (X,Y,Color) for the current player (bot) in the first level
choose_move_Lvl1(Board,X,Y,Color) :-
    get_validMoves(Board,ListOfMoves),
    getCurrentPlayerColor(Player_Color),
    analyse_validMoves(Board,Player_Color,ListOfMoves,0,[],Cells),
    sort(Cells, SortedCells),
    select_lvl1_move(SortedCells,X,Y,Color).

% select_lvl1_move(+Cells, -X, -Y, -Color)
% selects from a list of valued moves a move (X,Y,Color)
% if there is a winner move then that is the move chosen, if not, the move is chosen randomly from the list,
% excluding any loser move
select_lvl1_move(Cells,X,Y,Color) :-
    checkForWinnerPlay(Cells,WinnerMove,1),
    read_move(WinnerMove,X,Y,Color).

select_lvl1_move(Cells,X,Y,Color) :-
    checkForWinnerPlay(Cells,_WinnerMove,0),
    getRandomNotLoserMove(Cells,X,Y,Color).

% getRandomNotLoserMove(+Cells, -X, -Y, -Color)
% randomly selects a move (X,Y,Color) from the received list of valued moves (Cells) excluding any loser move
getRandomNotLoserMove(Cells, X,Y,Color) :-
    random_member([500,_Move],Cells),
    length(Cells,N),
    N > 1,
    getRandomNotLoserMove(Cells,X,Y,Color).

getRandomNotLoserMove(Cells, X,Y,Color) :-
    random_member([_Value,Move],Cells),
    read_move(Move,X,Y,Color).

% checkForWinnerPlay(ListOfMoves, WinnerMove, Res)
% checks if the head of a list of moves is a winner play (the value is -500), 
% if so the winnerMove is the one from the head of the list and Res is set to 1,
% if not, Res is set to 0
checkForWinnerPlay(List, WinnerMove, 1) :-
    member([-600,WinnerMove], List).

checkForWinnerPlay(List, WinnerMove, 1) :-
    member([-500,WinnerMove], List).

checkForWinnerPlay(_, _, 0).

% choose_move_Lvl2(+Board, -X,-Y, -Color)
% chooses the move (X,Y,Color) for the current player (bot) in the second level
% analyses all the possible moves and chooses the best, if there is a best, or selects randomly if the moves
% have all the same value
choose_move_Lvl2(Board,X,Y,Color) :-
    get_validMoves(Board,ListOfMoves),
    getCurrentPlayerColor(Player_Color),
    analyse_validMoves(Board,Player_Color,ListOfMoves,0,[],Cells),
    sort(Cells, SortedCells),
    remove_duplicates(SortedCells, FinalCells),
    getBestMove(FinalCells,Move),
    read_move(Move,X,Y,Color).


% getBestMove(+ListOfMoves, -BestMove)
% retrieves the best move from a list of moves
% if all the values from the moves in the list of moves received are 0 and/or -5 the best move is chosen randomly
% from the list
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

% getBestMove(+ListOfMoves, -BestMove)
% retrieves the best move from a list of moves
% if the best value occurs in more than one move, then the best move is chosen randomly between those best moves
getBestMove([[Value,Move]|T], BestMove) :-
    findall(TmpMove,
    (
        member([Value,TmpMove], T)
    ),
    TmpMoves),
    random_member(BestMove, [Move | TmpMoves]).

% getBestMove(+ListOfMoves, -BestMove)
% retrieves the best move from a list of moves
% retrieves the head of the move (ListOfMoves is received organized from best move to worst)
getBestMove([[_Value,Move]|_T], BestMove) :-
    BestMove = Move.

% choose_move(+Board, +Lvl, -X, -Y, -Color)
% chooses and prints the move (X,Y,Color) for the Lvl specified
choose_move(Board,1,X,Y,Color) :-
    choose_move_Lvl1(Board,X,Y,Color),
    print_move(Board, X,Y,Color).

choose_move(Board,2,X,Y,Color) :-
    choose_move_Lvl2(Board,X,Y,Color),
    print_move(Board, X,Y,Color).

% print_move(+Board,+X, +Y, +Color)
% prints a move in a user friendly way
print_move(Board, X,Y,Color) :-
    coordsToUser(Board, X, Y, Letter, Number),
    nl, nl,
    write(Color),
    write(' played on: '),
    write(Letter), write(Number), nl, nl.

% process_neighbors(+Board, +Color, +Neighbors,+X, +Y, -NX, -NY)
% processes the neighbors for the X and Y cell of the board
% if one of the cell neighbors does not have any neighbors with the color specified 
% finds its first neighbor that is empty, valid and does not have 4 neighbors
process_neighbors(Board,Color,Neighbors,X,Y, NX,NY) :-
    select((X,Y), Neighbors, Surrounding),
    member((FX,FY), Surrounding),
    countCellNeighbors(Board,FX,FY,Color,0),
    findFirstEmptyCellNeighbors(Board,FX,FY,FirstN),
    member((NX,NY),FirstN),
    isValidPlay(Board,NX,NY,Color),
    \+ countCellNeighbors(Board,NX,NY,Color,4).

% process_neighbors(+Board, +Color, +Neighbors,+X, +Y, -NX, -NY)
% processes the neighbors for the X and Y cell of the board
% if one of the cell neighbors only has one neighbor with the color specified 
% finds its first neighbors that is empty, valid and does not have 4 neighbors
process_neighbors(Board,Color,Neighbors,X,Y, NX,NY) :-
    select((X,Y), Neighbors, Surrounding),
    member((FX,FY), Surrounding),
    countCellNeighbors(Board,FX,FY,Color,1),
    findFirstEmptyCellNeighbors(Board,FX,FY,FirstN),
    member((NX,NY),FirstN),
    isValidPlay(Board,NX,NY,Color),
    \+ countCellNeighbors(Board,NX,NY,Color,4).

% remove_duplicates(+OldList, -NewList)
% removes, if there is a loser move (value 500) in OldList, its duplicates
remove_duplicates(OldList, NewList) :-
    remove_duplicates(OldList, [], TmpList),
    reverse(TmpList, NewList).

% remove_duplicates(+OldList, +tmp, -NewList)
% removes, if there is a loser move (value 500) in OldList, its duplicates
remove_duplicates([], Res, Res).

remove_duplicates([[_Value, Move] | Tail], Tmp, Res):-
    member([V1,Move],Tail),
    V1 == 500,
    remove_duplicates(Tail, Tmp, Res).

remove_duplicates([[Value, Move] | Tail], Tmp, Res):-
    remove_duplicates(Tail, [[Value, Move] | Tmp], Res).