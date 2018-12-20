:- use_module(library(random)).
:- use_module(library(system)).

% initializeRandomSeed
% Initializes the random seed using current time 
initializeRandomSeed:-
  now(Time),
  Seed is Time mod 30269, % https://sicstus.sics.se/sicstus/docs/3.7.1/html/sicstus_23.html
  getrand(random(X, Y, Z, _)),
  setrand(random(Seed, X, Y, Z)), !.

% generateBoard(+Size, -Board)
% generates a board of size Size
% Board is a list os lists in the format [Cells, FrontCoords, FrontValues],
% where Cells is a list of cells, FrontCoords is a list of frontiers and FrontValues is
% the list of values from the FrontCoords frontiers
generateBoard(Size, [Board|[C|[V]]]) :-
  initializeRandomSeed,
  generateBoard(0, Size, [], [], [], [Board|[C|[V]]]),!.

% generateBoard(+Size, +Size, +Cells, +FrontCoords, +FrontValues, -Board)
% generates a board of size Size
generateBoard(Size, Size, Cells, FrontCoords, FrontValues, Board) :-
  append([Cells], [FrontCoords], Tmp),
  append(Tmp, [FrontValues], Board) ,!.

generateBoard(Cur, Size, AccCells, AccFrontCoords, AccFrontValues,Board) :-
  generateLine(Cur, Size, C1, FC1, FV1),
  NewCur is Cur + 1,
  append(AccCells, C1, NewCells),
  append(AccFrontCoords, FC1, NewFrontCoords),
  append(AccFrontValues, FV1, NewFrontValues),
  generateBoard(NewCur, Size, NewCells, NewFrontCoords, NewFrontValues, Board), !.

% generateLine(+Cur, +Size, -Cells, -FrontCoords, -FrontValues)
% generates the cells and the frontiers for a specified Cur line of the board
generateLine(Cur, Size, Cells, FrontCoords,FrontValues) :-
  generateCells(Cur, 0, Size, [], Cells),
  generateFrontiers(Cur, 0, Size, [],[], FrontCoords,FrontValues), !.

% generateCells(+X, +Cur, +Size, +AccCells, -Cells) 
% generate the cells for a specified X line of the board
generateCells(_, Size, Size, Cells, Cells).
generateCells(X, Cur, Size, AccCells, Cells) :-
  NewCur is Cur + 1,
  append(AccCells, [cell(X, Cur)], NewAcc),
  generateCells(X, NewCur, Size, NewAcc, Cells), !.

% generateFrontiers(+X, +Cur, +Size, +AccFrontCoords, +AccFrontValues, -FrontCoords, -FrontValues) 
% generates the frontiers and corresponding values for a specified X line of the board, 
generateFrontiers(_, Size, Size, FrontCoords, FrontValues, FrontCoords,FrontValues).
generateFrontiers(X, Cur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues) :-
  NewCur is Cur + 1,
  RightX is X + 1,
  BottomY is Cur + 1,

  RightX < Size,
  BottomY < Size,

  append(AccFrontCoords, 
  [
    frontier(X, Cur, RightX, Cur),
    frontier(X, Cur, X, BottomY)
  ],
  NewAccFC),

  random(0, 2, Value1),
  random(0, 2, Value2),
  append(AccFrontValues, 
  [
    Value1,
    Value2
  ],
  NewAccFV),
  generateFrontiers(X, NewCur, Size, NewAccFC, NewAccFV, FrontCoords, FrontValues), !.

generateFrontiers(X, Cur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues) :-
  NewCur is Cur + 1,
  BottomY is Cur + 1,

  BottomY < Size,

  append(AccFrontCoords, 
  [
    frontier(X, Cur, X, BottomY)
  ],
  NewAccFC),

  random(0, 2, Value1),
  append(AccFrontValues, 
  [
    Value1
  ],
  NewAccFV),
  generateFrontiers(X, NewCur, Size, NewAccFC, NewAccFV, FrontCoords, FrontValues), !.

generateFrontiers(X, Cur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues) :-
  NewCur is Cur + 1,
  RightX is X + 1,

  RightX < Size,

  append(AccFrontCoords, 
  [
    frontier(X, Cur, RightX, Cur)
  ],
  NewAccFC),
  random(0, 2, Value1),
  append(AccFrontValues, 
  [
    Value1
  ],
  NewAccFV),
  generateFrontiers(X, NewCur, Size, NewAccFC, NewAccFV, FrontCoords, FrontValues), !.

generateFrontiers(X, Cur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues) :-
  NewCur is Cur + 1,
  generateFrontiers(X, NewCur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues), !.



