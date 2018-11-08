:- ensure_loaded(includes).

% min is player 2
% max is player 1

minimax(Board, CurrPlayer, BestNextBoard, BestNextMove, Val) :-
  valid_moves(Board,CurrPlayer,ListOfMoves), %get all valid moves in ListOfMoves
  %printLongList(ListOfMoves),
  trace,
  %(foreach(Move, ListOfMoves), foreach([NB, Move], NextBoardList)
  %  do
  %    getMove(Move, X, Y, C),
  %    playPiece(Board, X, Y, C, NB)
  %),           % get all resulting boards in NextBoardList
  loop(Board, ListOfMoves, NextBoardList),
  printLongList(NextBoardList),
  best(NextBoardList, CurrPlayer, BestNextBoard, Val), !.

loop(Board, [Move | MoveT], Result) :-
  length(MoveT, L),
  L > 0,
  getMove(Move, X, Y, C),
  playPiece(Board, X, Y, C, NB),
  loop(Board, MoveT, [[NB, Move] | Result]).


minimax(Board, CurrPlayer, _, _, Val) :-
  utility(Board, CurrPlayer, Val).

utility(Board, CurrPlayer, Val) :-
  game_over(Board, CurrPlayer) ->
    Val = 1.

utility(Board, CurrPlayer, Val) :-
  getOppositePlayer(CurrPlayer, OpPlayer),
  game_over(Board, OpPlayer) ->
    Val = -1.

utility(Board, Val) :-
  game_over(Board, -1) ->
    Val = 0.


best([[ [NB, NM] | T]], CurrPlayer, [NB | T], Val) :-                                % There is no more position to compare
  minimax(NB, CurrPlayer, _, NM, Val), !.

best([ [NB | ML] | PosList], CurrPlayer, BestPos, BestVal) :-             % There are other positions to compare
  minimax(NB, CurrPlayer, _, NM, Val1),
  best(PosList, CurrPlayer, Pos2, Val2),
  betterOf([NB | ML], CurrPlayer, Val1, Pos2, Val2, BestPos, BestVal).

betterOf(Pos0, CurrPlayer, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
  min_to_move(Pos0),                           % MIN to move in Pos0
  Val0 > Val1, !.                              % MAX prefers the greater value

min_to_move(CurrPlayer) :-
  getCurrentPlayer(Player),
  getOppositePlayer(Player, OpPlayer),
  player(OpPlayer, _, 1, _, _).

max_to_move(_) :-
  player(1, _, _, 2, _).


betterOf(Pos0, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
  max_to_move(Pos0),                           % MAX to move in Pos0
  Val0 < Val1, !.                              % MIN prefers the lesser value

betterOf(_, _, Pos1, Val1, Pos1, Val1).        % Otherwise Pos1 better than Pos0