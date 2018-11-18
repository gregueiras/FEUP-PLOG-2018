% A Board is a list of cell atoms, with X and Y coordinates and a the state (emptyCell, blackPiece or whitePiece)

% initial_board(-Board)
% Empty board with all cells empty
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

% inter_board(-Board)
% Intermediate board some pieces laid.

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

% final_board(-Board)
% Final board with a game winning state, whitePiece win because there is a group of 4 black pieces.

final_board([
    cell( 0, 0, emptyCell),cell( 2, 0, emptyCell),cell( 4, 0,blackPiece),cell( 6, 0,whitePiece),cell( 8, 0,blackPiece),
    cell( 0, 1, emptyCell),cell( 2, 1, emptyCell),cell( 4, 1,whitePiece),cell( 6, 1,blackPiece),cell( 8, 1,whitePiece),
    cell(10, 1,blackPiece),
    cell( 0, 2, blackPiece),cell( 2, 2, emptyCell),cell( 4, 2,whitePiece),cell( 6, 2,whitePiece),cell( 8, 2, emptyCell),
    cell(10, 2, emptyCell),cell(12, 2,whitePiece),
    cell( 0, 3, emptyCell),cell( 2, 3, emptyCell),cell( 4, 3, emptyCell),cell( 6, 3,blackPiece),cell( 8, 3,blackPiece),
    cell(10, 3,whitePiece),cell(12, 3,blackPiece),cell(14, 3,whitePiece),
    cell( 0, 4, whitePiece),cell( 2, 4, emptyCell),cell( 4, 4,whitePiece),cell( 6, 4, emptyCell),cell( 8, 4,blackPiece),
    cell(10, 4,blackPiece),cell(12, 4,whitePiece),cell(14, 4,blackPiece),cell(16, 4,blackPiece),
    cell( 2, 5,whitePiece),cell( 4, 5, emptyCell),cell( 6, 5,whitePiece),cell( 8, 5, emptyCell),cell(10, 5, whitePiece),
    cell(12, 5, emptyCell),cell(14, 5, emptyCell),cell(16, 5,whitePiece),
    cell( 4, 6,whitePiece),cell( 6, 6,blackPiece),cell( 8, 6,whitePiece),cell(10, 6,blackPiece),cell(12, 6,blackPiece),
    cell(14, 6,blackPiece),cell(16, 6, emptyCell),
    cell( 6, 7,whitePiece),cell( 8, 7,blackPiece),cell(10, 7, emptyCell),cell(12, 7,whitePiece),cell(14, 7, emptyCell),
    cell(16, 7, emptyCell),
    cell( 8, 8,blackPiece),cell(10, 8, emptyCell),cell(12, 8, emptyCell),cell(14, 8, emptyCell),cell(16, 8, emptyCell)
  ]).

% getPiece(+Board, +X, +Y, -Pout)
% True if there is a cell in Board with X and Y coordinates with Pout state 
getPiece(Board, X, Y, Pout) :-
  member(cell(X, Y, Pout), Board).

% setPiece(+Board, +X, +Y, +Pin, -NewBoard)
% Changes state of the cell in Board with X and Y coordinates to Pin and saves it in NewBoard
setPiece(Board, X, Y, Pin, NewBoard) :-
  select(cell(X, Y, _), Board, B1),
  append([cell(X, Y, Pin)], B1, NB),
  sort(NB,NewBoard). %keeps the initial order of the list

% indices(+List, +E, -Is)
% Gets the indices of every element in List that matches E and stores it in Is
indices(List, E, Is) :-
  findall(N, nth0(N, List, E), Is).

% getIndexs(+ElemList, +IndexList, -ResultList)
% Gets all elements from ElemList with indices in IndexList and stores it in ResultList
getIndexs(_, [], []).
getIndexs(Board, [H | T], [Elem | List]) :-
  nth0(H, Board, Elem),
  getIndexs(Board, T, List).

% getLine(+Board, +LineNumber, -List)
% Gets line number LineNumber from Board and stores it in List 
getLine(Board, LineNumber, List) :-
  indices(Board, cell(_, LineNumber, _), I),
  getIndexs(Board, I, List).

% numLines(+Board, -NumLines)
% NumLines is the number of lines in an hexagon board with Board size
% numberTiles = 3 * Math.pow(n, 2) - 3 * n + 1
% Original formula for calculating the number of tiles in a hexagon board given the number of hexagons in the board side
numLines(Board, NumLines) :-
  length(Board, NumTiles),
  Temp is (sqrt(3) * sqrt(4 * NumTiles - 1) + 3)/6,
  NumLines is Temp * 2 - 1.

% print_board(+Board)
% Prints the Board in the layout suggested in Manalath website (https://spielstein.com/games/manalath/rules)
print_board(Board) :-
  numLines(Board, NL),
  print_buffer(NL + 2, ' '),
  print_columns(NL/2, '   '), nl,
  print_buffer(NL + 3, ' '),
  print_buffer(NL / 2, '__  '), nl,
  print_lines(Board, 0, NL).

% print_lines(+Board, +TotalNumberLines, +CurrentLineNumber)
% Prints all lines of the Board
print_lines(_, LineNum, NL) :-
  round(LineNum) =:= round(NL).

print_lines(Board, LineNum, NL) :- 
  getLine(Board, LineNum, Line),
  length(Line, LineLength),
  BufSize is NL - LineLength + 2,
  print_coordsBegin(Line),
  print_buffer(BufSize - 1, '  '),
  print_line(Line),
  write('  '), print_top_half(LineNum + 1, NL, LineLength),  write_unicode(space), nl,
  write(' '),
  print_buffer(BufSize - 2, '  '),
  print_bottom_half(LineNum + 1, NL, '  '),
  print_top_half(LineNum + 1, NL, ' _'),
  print_buffer(LineLength, '\\__/'),
  print_top_half(LineNum + 1, NL, '_'), 
  nl,
  L is LineNum + 1,
  print_lines(Board, L, NL).

% print_top_half(+LineNumber, +NumberOfLines, +CharsToPrint)
% Writes CharsToPrint to the buffer, if it is a line in the top half of the board
print_top_half(LineNum, NL, Chars) :-
  LineNum * 2 < NL,
  write(Chars).

print_top_half(_, _, _).

% print_bottom_half(+LineNumber, +NumberOfLines, +CharsToPrint)
% Writes CharsToPrint to the buffer, if it is a line in the bottom half of the board
print_bottom_half(LineNum, NL, Chars) :-
  LineNum * 2 > NL,
  write(Chars).

print_bottom_half(_, _, _).


% print_buffer(+BufferSize, +Character)
% Prints BufferSize Characters, useful for formatting the board
print_buffer(N, _) :-
  round(N) =:= 0.

print_buffer(N, _) :-
  round(N) < 0.

print_buffer(N, Character) :-
  write(Character),
  L is N - 1,
  print_buffer(L, Character).

% print_columns(+NumColumns, +Buffer)
% Auxiliary method, calls print_columns with CurrentNumber as 0
print_columns(N, Buffer) :-
  print_columns(N, 0, Buffer).

% print_columns(+NumColumns, +CurrentNumber, +Buffer)
% Prints the column numbers, separated by Buffer, stops when CurrentNumber is Equal to NumColumns
print_columns(N, C, _) :-
  round(N) =:= round(C).

print_columns(N, Curr, Buffer) :-
  write(Buffer),
  write(Curr),
  L is Curr + 1,
  print_columns(N, L, Buffer).

% print_line(+Line)
% Prints a Line of the board
print_line([]).
print_line([L | T]) :-
  write('/'),
  print_cell(L),
  %write('  )('),
  write('\\'),
  print_line(T).

% coordsToUser(+Board, +X, +Y, -Letter, -Number)
% Converts a pair of the internal X and Y coordinates to the more user-friendly Letter and Number notation
% Checks if there is a cell in board with this coordinates
coordsToUser(Board, X, Y, Letter, Number) :- % Bottom half of the board
  member(cell(X, Y, _), Board),
  char_code(a, CodeA),
  CodeLetter is CodeA + Y,
  char_code(Letter, CodeLetter),
  Number is round(X / 2).

% userToCoords(+Board, +Letter, +Number, -X, -Y)
% Converts the user-friendly Letter and number notation to the internal X and Y coordinates
% Checks if there is a cell in board with this coordinates
userToCoords(Board, Letter, Number, X, Y) :- % Bottom half of the board
  char_code(Letter, CodeLetter),
  char_code(a, CodeA),
  NumLetter is CodeLetter - CodeA,
  X1 is Number * 2,
  X = X1,
  Y = NumLetter,
  member(cell(X, Y, _), Board).

% print_coordsBegin(+Line)
% Prints the coordinates left of the board in LetterNumber notation 
print_coordsBegin([ cell(_, Y, _) | _]) :-
  char_code(a, CodeA),
  CodeLetter is CodeA + Y,
  char_code(Letter, CodeLetter),
  write(Letter).
  %write(0).

% write_unicode(+Piece)
% Writes a unicode character, representing a certain Piece
write_unicode(blackPiece) :- char_code(_Char,11044), write(_Char). % Black Circle
write_unicode(whitePiece) :- char_code(_Char,11093), write(_Char). % White Circle
write_unicode(space) :- char_code(_Char,8291), write(_Char). % Invisible character, fixes a bug on the last line of the board when blackCircle is the last printed piece 

% print_cell(+Cell)
% Writes the representation of a cell
% White space for empty cells
% Black or White circle for blackPiece and whitePiece, respectively
print_cell(cell(_, _, emptyCell)) :-
  write('  ').

print_cell(cell(_, _, Piece)) :-
  write_unicode(Piece), write(' ').

