:- use_module(library(random)).

generateBoard(Size, [Board|[C|[V]]]) :-
  generateBoard(0, Size, [], [], [], [Board|[C|[V]]]),!.

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



generateLine(Cur, Size, Cells, FrontCoords,FrontValues) :-
  generateCells(Cur, 0, Size, [], Cells),
  generateFrontiers(Cur, 0, Size, [],[], FrontCoords,FrontValues), !.


generateCells(_, Size, Size, Cells, Cells).
generateCells(X, Cur, Size, AccCells, Cells) :-
  NewCur is Cur + 1,
  Upper is round(Size * 1.5) + 2,
  random(0, Upper, Value),
  append(AccCells, [cell(X, Cur, Value)], NewAcc),
  generateCells(X, NewCur, Size, NewAcc, Cells), !.
  
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

  append(AccFrontValues, 
  [
    0,
    0
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
  append(AccFrontValues, 
  [
    0
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
  append(AccFrontValues, 
    [
      0
    ],
  NewAccFV),
  generateFrontiers(X, NewCur, Size, NewAccFC, NewAccFV, FrontCoords, FrontValues), !.

generateFrontiers(X, Cur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues) :-
  NewCur is Cur + 1,
  generateFrontiers(X, NewCur, Size, AccFrontCoords, AccFrontValues,FrontCoords, FrontValues), !.



