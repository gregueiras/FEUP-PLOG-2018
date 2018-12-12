:- use_module(library(random)).

generateBoard(Size, Board) :-
  generateBoard(0, Size, [], [], Board), !.

generateBoard(Size, Size, Cells, Frontiers, Board) :-
  append([Cells], [Frontiers], Board), !.

generateBoard(Cur, Size, AccCells, AccFrontiers, Board) :-
  generateLine(Cur, Size, C1, F1),
  NewCur is Cur + 1,
  append(AccCells, C1, NewCells),
  append(AccFrontiers, F1, NewFrontiers),
  generateBoard(NewCur, Size, NewCells, NewFrontiers, Board), !.

generateLine(Cur, Size, Cells, Frontiers) :-
  generateCells(Cur, 0, Size, [], Cells),
  generateFrontiers(Cur, 0, Size, [], Frontiers), !.


generateCells(_, Size, Size, Cells, Cells).
generateCells(X, Cur, Size, AccCells, Cells) :-
  NewCur is Cur + 1,
  Upper is round(Size * 1.5) + 2,
  random(0, Upper, Value),
  append(AccCells, [cell(X, Cur, Value)], NewAcc),
  generateCells(X, NewCur, Size, NewAcc, Cells), !.
  
generateFrontiers(_, Size, Size, Frontiers, Frontiers).
generateFrontiers(X, Cur, Size, AccFrontiers, Frontiers) :-
  NewCur is Cur + 1,
  RightX is X + 1,
  BottomY is Cur + 1,

  RightX < Size,
  BottomY < Size,

  append(AccFrontiers, 
  [
    frontier(X, Cur, RightX, Cur, 0),
    frontier(X, Cur, X, BottomY, 0)
  ],
  NewAcc),
  generateFrontiers(X, NewCur, Size, NewAcc, Frontiers), !.

generateFrontiers(X, Cur, Size, AccFrontiers, Frontiers) :-
  NewCur is Cur + 1,
  BottomY is Cur + 1,

  BottomY < Size,

  append(AccFrontiers, 
  [
    frontier(X, Cur, X, BottomY, 0)
  ],
  NewAcc),
  generateFrontiers(X, NewCur, Size, NewAcc, Frontiers), !.

generateFrontiers(X, Cur, Size, AccFrontiers, Frontiers) :-
  NewCur is Cur + 1,
  RightX is X + 1,

  RightX < Size,

  append(AccFrontiers, 
  [
    frontier(X, Cur, RightX, Cur, 0)
  ],
  NewAcc),
  generateFrontiers(X, NewCur, Size, NewAcc, Frontiers), !.

generateFrontiers(X, Cur, Size, AccFrontiers, Frontiers) :-
  NewCur is Cur + 1,
  generateFrontiers(X, NewCur, Size, AccFrontiers, Frontiers), !.
