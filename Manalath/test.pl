:- use_module(library(lists)).

initial_board([
  cell( 0, 0,emptyCell),cell( 2, 0,emptyCell),cell( 4, 0,emptyCell),cell( 6, 0,emptyCell),cell( 8, 0,emptyCell),
  cell( 0, 1,emptyCell),cell( 2, 1,emptyCell),cell( 4, 1,emptyCell),cell( 6, 1,emptyCell),cell( 8, 1,emptyCell),
  cell(10, 1,emptyCell),
  cell( 0, 2,emptyCell),cell( 2, 2,emptyCell),cell( 4, 2,emptyCell),cell( 6, 2,emptyCell),cell( 8, 2,emptyCell),
  cell(10, 2,emptyCell),cell(12, 2,emptyCell),
  cell( 0, 3,emptyCell),cell( 2, 3,emptyCell),cell( 4, 3,emptyCell),cell( 6, 3,emptyCell),cell( 8, 3,emptyCell),
  cell(10, 3,emptyCell),cell(12, 3,emptyCell),cell(14, 3,emptyCell),
  cell( 0, 4,emptyCell),cell( 2, 4,emptyCell),cell( 4, 4,emptyCell),cell( 6, 4,emptyCell),cell( 8, 4,emptyCell),
  cell(10, 4,emptyCell),cell(12, 4,emptyCell),cell(14, 4,emptyCell),cell(16, 4,emptyCell),
  cell( 2, 5,emptyCell),cell( 4, 5,emptyCell),cell( 6, 5,emptyCell),cell( 8, 5,emptyCell),cell(10, 5,emptyCell),
  cell(12, 5,emptyCell),cell(14, 5,emptyCell),cell(16, 5,emptyCell),
  cell( 4, 6,emptyCell),cell( 6, 6,emptyCell),cell( 8, 6,emptyCell),cell(10, 6,emptyCell),cell(12, 6,emptyCell),
  cell(14, 6,emptyCell),cell(16, 6,emptyCell),
  cell( 6, 7,emptyCell),cell( 8, 7,emptyCell),cell(10, 7,emptyCell),cell(12, 7,emptyCell),cell(14, 7,emptyCell),
  cell(16, 7,emptyCell),
  cell( 8, 8,emptyCell),cell(10, 8,emptyCell),cell(12, 8,emptyCell),cell(14, 8,emptyCell),cell(16, 8,emptyCell)
]).

inter_board([
    cell( 0, 0, emptyCell),cell( 2, 0, emptyCell),cell( 4, 0,blackPiece),cell( 6, 0,whitePiece),cell( 8, 0,blackPiece),
    cell( 0, 1, emptyCell),cell( 2, 1, emptyCell),cell( 4, 1,whitePiece),cell( 6, 1,blackPiece),cell( 8, 1,whitePiece),
    cell(10, 1,blackPiece),
    cell( 0, 2, emptyCell),cell( 2, 2, emptyCell),cell( 4, 2,whitePiece),cell( 6, 2,whitePiece),cell( 8, 2, emptyCell),
    cell(10, 2, emptyCell),cell(12, 2,whitePiece),
    cell( 0, 3, emptyCell),cell( 2, 3, emptyCell),cell( 4, 3, emptyCell),cell( 6, 3,blackPiece),cell( 8, 3,blackPiece),
    cell(10, 3,whitePiece),cell(12, 3,blackPiece),cell(14, 3,whitePiece),
    cell( 0, 4, emptyCell),cell( 2, 4, emptyCell),cell( 4, 4,whitePiece),cell( 6, 4, emptyCell),cell( 8, 4,blackPiece),
    cell(10, 4, emptyCell),cell(12, 4, emptyCell),cell(14, 4, emptyCell),cell(16, 4, emptyCell),
    cell( 2, 5,whitePiece),cell( 4, 5, emptyCell),cell( 6, 5,whitePiece),cell( 8, 5, emptyCell),cell(10, 5, emptyCell),
    cell(12, 5, emptyCell),cell(14, 5, emptyCell),cell(16, 5, emptyCell),
    cell( 4, 6,whitePiece),cell( 6, 6,blackPiece),cell( 8, 6,whitePiece),cell(10, 6,blackPiece),cell(12, 6,blackPiece),
    cell(14, 6,blackPiece),cell(16, 6, emptyCell),
    cell( 6, 7,whitePiece),cell( 8, 7,blackPiece),cell(10, 7, emptyCell),cell(12, 7,whitePiece),cell(14, 7, emptyCell),
    cell(16, 7, emptyCell),
    cell( 8, 8,blackPiece),cell(10, 8, emptyCell),cell(12, 8, emptyCell),cell(14, 8, emptyCell),cell(16, 8, emptyCell)
  ]).

final_board([
    cell( 0, 0, emptyCell),cell( 2, 0, emptyCell),cell( 4, 0,blackPiece),cell( 6, 0,whitePiece),cell( 8, 0,blackPiece),
    cell( 0, 1, emptyCell),cell( 2, 1, emptyCell),cell( 4, 1,whitePiece),cell( 6, 1,blackPiece),cell( 8, 1,whitePiece),
    cell(10, 1,blackPiece),
    cell( 0, 2, emptyCell),cell( 2, 2, emptyCell),cell( 4, 2,whitePiece),cell( 6, 2,whitePiece),cell( 8, 2, emptyCell),
    cell(10, 2, emptyCell),cell(12, 2,whitePiece),
    cell( 0, 3, emptyCell),cell( 2, 3, emptyCell),cell( 4, 3, emptyCell),cell( 6, 3,blackPiece),cell( 8, 3,blackPiece),
    cell(10, 3,whitePiece),cell(12, 3,blackPiece),cell(14, 3,whitePiece),
    cell( 0, 4, emptyCell),cell( 2, 4, emptyCell),cell( 4, 4,whitePiece),cell( 6, 4, emptyCell),cell( 8, 4,blackPiece),
    cell(10, 4,blackPiece),cell(12, 4,whitePiece),cell(14, 4,blackPiece),cell(16, 4,blackPiece),
    cell( 2, 5,whitePiece),cell( 4, 5, emptyCell),cell( 6, 5,whitePiece),cell( 8, 5, emptyCell),cell(10, 5, emptyCell),
    cell(12, 5, emptyCell),cell(14, 5, emptyCell),cell(16, 5,whitePiece),
    cell( 4, 6,whitePiece),cell( 6, 6,blackPiece),cell( 8, 6,whitePiece),cell(10, 6,blackPiece),cell(12, 6,blackPiece),
    cell(14, 6,blackPiece),cell(16, 6, emptyCell),
    cell( 6, 7,whitePiece),cell( 8, 7,blackPiece),cell(10, 7, emptyCell),cell(12, 7,whitePiece),cell(14, 7, emptyCell),
    cell(16, 7, emptyCell),
    cell( 8, 8,blackPiece),cell(10, 8, emptyCell),cell(12, 8, emptyCell),cell(14, 8, emptyCell),cell(16, 8, emptyCell)
  ]).

mini([
  cell(0, 0, emptyCell),
  cell(2, 0, blackPiece),
  cell(4, 0, whitePiece),
  cell(4, 1, whitePiece),
  cell(4, 2, whitePiece)
]).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X - 2,
  FY is Y,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X - 2,
  FY is Y - 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X,
  FY is Y - 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X + 2,
  FY is Y,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X + 2,
  FY is Y + 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X,
  FY is Y + 1,
  getPiece(Board, FX, FY, F).

findAllNeighbors(Board, X, Y, Color, Res) :-
  findNeighbors(Board, X, Y, Color, [], Res).

%findNeighbors(Board, X, Y, Color, Res, Res) :-
%  length(Res, N),
%  N > 3.9.
 %:-
 % \+ neighbor(Board, X, Y, _P, RColor, RX, RY).

findNeighbors(Board, X, Y, Color, Old, Res) :-
  findall((RX, RY), 
  (
    neighbor(Board, X, Y, _P, RColor, RX, RY),
    RColor == Color,
    \+ member( (RX, RY), Old)
  ),
  R),
 % neighbor(Board, X, Y, _P, RColor, RX, RY),
 % RColor == Color,
 % \+ member( (RX, RY), Old),
 % append(Old, [(RX, RY)], Temp),
  append(Old, R, Temp),
 % findNeighbors(Board, RX, RY, Color, Temp, Res).
  findListNeighbors(Board, R, Color, Temp, Res).


findListNeighbors(Board, [], Color, Res, Res).

findListNeighbors(Board, [(X, Y) | TT], Color, Old, Res) :-
  findNeighbors(Board, X, Y, Color, Old, Temp),
  append(Old, Temp, NewL),
  findListNeighbors(Board, TT, Color, NewL, Res).

findNeighbors(_Board, _X, _Y, Color, Res, Res).

getPiece(Board, X, Y, Pout) :-
  member(cell(X, Y, Pout), Board).

setPiece(Board, X, Y, Pin, NewBoard) :-
  select(cell(X, Y, _), Board, B1),
  append([cell(X, Y, Pin)], B1, NewBoard).

indices(List, E, Is) :-
    findall(N, nth0(N, List, E), Is).

getIndexs(_, [], []).
getIndexs(Board, [H | T], [Elem | List]) :-
  nth0(H, Board, Elem),
  getIndexs(Board, T, List).

getLine(Board, LineNumber, List) :-
  indices(Board, cell(_, LineNumber, _), I),
  getIndexs(Board, I, List).


%  getLine([], _, _).
%  getLine([H | T], LineNumber, List) :-
%  H == cell(_, LineNumber,_) ->
%  (write('eq'), nl,
%  getLine(T, LineNumber, [List | H])) ;
%  H \== cell(_, LineNumber,_) ->
%  (write('neq'), nl,
%  getLine(T, LineNumber, List)).

%numberTiles = 3 * Math.pow(n, 2) - 3 * n + 1;

%Counts number of columns in the bigger row 
numLines(Board, NumLines) :-
  length(Board, NumTiles),
  Temp is (sqrt(3) * sqrt(4 * NumTiles - 1) + 3)/6,
  NumLines is Temp * 2 - 1.

print_board(Board) :-
  numLines(Board, NL),
  print_lines(Board, 0, NL).

print_lines(_, LineNum, NL) :-
  round(LineNum) =:= round(NL).

print_lines(Board, LineNum, NL) :- 
  getLine(Board, LineNum, Line),
  length(Line, LineLength),
  BufSize is NL - LineLength,
  print_buffer(BufSize),
  print_line(Line), 
  write('|'), nl,
  print_buffer(BufSize), 
  write('|'),
  print_coords(Line),  nl,
  L is LineNum + 1,
  print_lines(Board, L, NL).

print_buffer(0.0).
print_buffer(-1.0).
print_buffer(N) :-
  write('    '),
  L is N - 1,
  print_buffer(L).

print_line([]).
print_line([L | T]) :-
  write('|   '),
  print_cell(L),
  write('   '),
  print_line(T).

print_top([]).
print_top([_ | T]) :-
  write('\\  /'),
  write(' '),
  print_top(T).

print_coords([]).
print_coords([ cell(X, Y, _) | T]) :-
  write_coord(X),
  write(' -'),
  write_coord(Y),
  write(' |'),
  print_coords(T).

write_coord(X) :-
  X < 10, 
  format(' ~d', [X]).
write_coord(X) :-
  X >= 10,
  format('~d', [X]).

print_cell(cell(_, _, blackPiece)) :-
    write('1').

print_cell(cell(_, _, whitePiece)) :-
    write('2').

print_cell(cell(_, _, emptyCell)) :-
    write('O').

tp :-
  initial_board(_B), print_board(_B).

display_game(Board, Player) :-
  print_board(Board).