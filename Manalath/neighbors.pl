:- use_module(library(lists)).

% neighbor(+Board, +X, +Y, -F, -FX, -FY)
% Gets one of the neighbors from a cell with X and Y coordinates in Board
% Neighbor has coordinates FX and FY and F color
neighbor(Board, X, Y, F, FX, FY) :-
  getPiece(Board, X, Y, _),
  FX is X - 2,
  FY is Y,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, F, FX, FY) :-
  getPiece(Board, X, Y, _),
  FX is X - 2,
  FY is Y - 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, F, FX, FY) :-
  getPiece(Board, X, Y, _),
  FX is X,
  FY is Y - 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, F, FX, FY) :-
  getPiece(Board, X, Y, _),
  FX is X + 2,
  FY is Y,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, F, FX, FY) :-
  getPiece(Board, X, Y, _),
  FX is X + 2,
  FY is Y + 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, F, FX, FY) :-
  getPiece(Board, X, Y, _),
  FX is X,
  FY is Y + 1,
  getPiece(Board, FX, FY, F).

% findFirstNeighbors(+Board, +X, +Y, +Color, +Processed, +ToProcess)
% Find all direct neighbors (cells who touch each other), with Color, to a cell in X and Y coordinates and stores it in ToProcess
findFirstNeighbors(Board,X,Y,Color,Processed,ToProcess) :-
 findall((FX,FY),
  (
  !,
  neighbor(Board,X,Y, F1,FX,FY),
  F1 == Color,
  \+ member((FX,FY), Processed)
  ),
  ToProcess).

findAllNeighbors(_Board,_Color,[],ProcessedCells,ProcessedCells) :- !.

% findAllNeighbors(+Board, +Color, +ToProcess, +Processed, -Neighbors)
% Process the first element in ToProcess
% saves (SX,SY) on ProcessedCells
% saves the first neighbors of (SX, SY) in ToProcess
% Similar to flood fill algorithm
findAllNeighbors(Board,Color,[(SX,SY)|T],ProcessedCells,Res) :-
  findFirstNeighbors(Board,SX,SY,Color,ProcessedCells,Tmp),
  append(T,Tmp,ToProcess),
  sort(ToProcess,TP), %remove os duplicados
  append(ProcessedCells,[(SX,SY)], PC),
  findAllNeighbors(Board,Color,TP, PC,Res).

% countCellNeighbors(+Board, +X, +Y, +Color, -Count)
% Count is the number of neighbors of the X and Y cell with Color, doesn't include the X, Y cell 
countCellNeighbors(Board,X,Y,Color,Count) :-
  findAllNeighbors(Board,Color,[(X,Y)],[],Neighbors),
  length(Neighbors,C),
  Count is C -1.