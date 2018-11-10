:- ensure_loaded(includes).

nextPlayer(1, 2).
nextPlayer(2, 1).

won(PlayerColor, Board) :-
  check_game_neighbors_value(Board, Board, PlayerColor, 3, [], _), % 4 of your color -> Lose
  !, fail.
  %write('WON').

won(PlayerColor, Board) :-
  check_game_neighbors_value(Board, Board, PlayerColor, 4, [], _), % 5 of your color -> Win
  nl,
  print(PlayerColor), nl,
  %print_board(Board), nl.
  write('WON').

%won(PlayerColor, Board) :-
%  getOppositeColor(PlayerColor, OpColor),
%  check_game_neighbors_value(Board, Board, OpColor, 4, [], WinnerList), % 5 of opponent's color -> Win
%  length(WinnerList, N),
%  N = 1,
%  nl,
%  print(PlayerColor), nl,
%  print_board(Board), nl.
  %write('WON').

move([X1, play, Board], [X2, win, NextBoard]) :-
    nextPlayer(X1, X2),
    valid_moves(Board, X1, MovesList),
    move_aux(Board, MovesList, NextBoard),
    \+  check_game_neighbors_value(Board, Board, _, 5, [], _), % 6 of your color -> Lose
    getPlayerColor(X1, Color),
    won(Color, NextBoard), !.

move([X1, play, Board], [X2, draw, NextBoard]) :-
    nextPlayer(X1, X2),
    valid_moves(Board, X1, MovesList),
    move_aux(Board, MovesList, NextBoard),
    valid_moves(NextBoard, _, AvailableMoves),  %trace,
    length(AvailableMoves, N),
    N == 0, !.

move([X1, play, Board], [X2, play, NextBoard]) :-
    nextPlayer(X1, X2),
    valid_moves(Board, X1, MovesList),
    move_aux(Board, MovesList, NextBoard),
    \+ check_game_neighbors_value(Board, Board, _, 5, [], _). % 6 of your color -> Lose


move_aux([cell(X , Y, emptyCell) | Bs], ValidMoves, [cell(X, Y, R) | Bs]) :-
	member((X, Y, R), ValidMoves).

move_aux([B | Bs], ValidMoves, [B | B2s]) :-
	move_aux(Bs, ValidMoves, B2s).
	
min_to_move([P, _, _]):-
  min(P).

max_to_move([P, _, _]):-
  max(P).

% utility(+Pos, -Val) :-
% True if Val the the result of the evaluation function at Pos.
% We will only evaluate for final position.
% So we will only have MAX win, MIN win or draw.
% We will use  1 when MAX win
%             -1 when MIN win
%              0 otherwise.
utility([P, win, _], 1) :-
  max(P).       % Previous player (MAX) has win.
utility([P, win, _], -1) :-
  min(P).      % Previous player (MIN) has win.
utility([_, play, _], 0).

minimax(Pos, BestNextPos, Val) :-                     % Pos has successors
    %trace,
	bagof(NextPos, move(Pos, NextPos), NextPosList),
    best(NextPosList, BestNextPos, Val), !.

minimax(Pos, _, Val) :-                     % Pos has no successors
    utility(Pos, Val).

best([Pos], Pos, Val) :-
    minimax(Pos, _, Val), !.

best([Pos1 | PosList], BestPos, BestVal) :-
    minimax(Pos1, _, Val1),
    best(PosList, Pos2, Val2),
    betterOf(Pos1, Val1, Pos2, Val2, BestPos, BestVal).


betterOf(Pos0, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
    min_to_move(Pos0),                         % MIN to move in Pos0
    Val0 > Val1, !                             % MAX prefers the greater value
    ;
    max_to_move(Pos0),                         % MAX to move in Pos0
    Val0 < Val1, !.                            % MIN prefers the lesser value

betterOf(_, _, Pos1, Val1, Pos1, Val1).        % Otherwise Pos1 better than Pos0
