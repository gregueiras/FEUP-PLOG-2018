
:- ensure_loaded(board).
:- use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    Auxiliary functions                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getPiece(+Board, +X, +Y)
% True if there is a cell in Board with X and Y coordinates
getPiece(Board, X, Y) :-
  member(cell(X, Y), Board).

% getFrontier(+X1, +Y1, +X2, +Y2, +Frontiers, -Value)
% gets the value from the frontier with coordinates X1,Y1,X2,Y2 (and vice versa)
% Frontiers is a list in the format  [FrontCoords, FrontValues], being FrontCoords the list of 
% coordinates and FrontValues the list of values.
getFrontier(X1, Y1, X2, Y2, [FrontCoords, FrontValues], Value) :-
  nth1(Index, FrontCoords, frontier(X1,Y1,X2,Y2)),
  element(Index, FrontValues, Value),!.

getFrontier(X1, Y1, X2, Y2, [FrontCoords, FrontValues], Value) :-
  nth1(Index, FrontCoords, frontier(X2,Y2,X1,Y1)),
  element(Index, FrontValues, Value), !.


% getFrontierRightDown(+X1, +Y1, +X2, +Y2, +Frontiers, Value) 
% gets the value from the frontier with coordinates X1,Y1,X2,Y2, corresponding to a down or right frontier
% Frontiers is a list in the format  [FrontCoords, FrontValues], being FrontCoords the list of 
% coordinates and FrontValues the list of values.
getFrontierRightDown(X1, Y1, X2, Y2, [FrontCoords, FrontValues], Value) :-
  nth1(Index, FrontCoords, frontier(X1,Y1,X2,Y2)),
  element(Index, FrontValues, Value).

% getFrontierLeftUp(+X1, +Y1, +X2, +Y2, +Frontiers, Value) 
% gets the value from the frontier with coordinates X2,Y2,X1,Y1, corresponding to an up or left frontier
% Frontiers is a list in the format  [FrontCoords, FrontValues], being FrontCoords the list of 
% coordinates and FrontValues the list of values.
getFrontierLeftUp(X1, Y1, X2, Y2, [FrontCoords, FrontValues], Value) :-
  nth1(Index, FrontCoords, frontier(X2,Y2,X1,Y1)),
  element(Index, FrontValues, Value).


% neighborDown(+Board, +X, +Y,-RX,-RY)
% Gets the down neighbor from a cell with X and Y coordinates in Board
% Neighbor has coordinates FX and FY 
neighborDown(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y),
  RX is X+1,
  RY is Y,
  getPiece(Board,RX,RY).

% neighborDown(+Board, +X, +Y,-RX,-RY)
% Gets the above neighbor from a cell with X and Y coordinates in Board
% Neighbor has coordinates FX and FY 
neighborUp(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y),
  RX is X-1,
  RY is Y,
  getPiece(Board,RX,RY).

% neighborDown(+Board, +X, +Y,-RX,-RY)
% Gets the right neighbor from a cell with X and Y coordinates in Board
% Neighbor has coordinates FX and FY 
neighborRight(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y),
  RX is X,
  RY is Y+1,
  getPiece(Board,RX,RY).

% neighborDown(+Board, +X, +Y,-RX,-RY)
% Gets the left neighbor from a cell with X and Y coordinates in Board
% Neighbor has coordinates FX and FY 
neighborLeft(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y),
  RX is X,
  RY is Y-1,
  getPiece(Board,RX,RY).

% getDownFrontiers(+Board,+X,+Y,+Frontiers,+Values, +AccDownFrontiers,-DownFrontiers)
% gets all the down frontiers values visible from the X,Y cell of the Board
getDownFrontiers(Board,X,Y,Frontiers,Values, AccDownFrontiers,DownFrontiers) :-
  neighborDown(Board,X,Y,FX,FY),
  getFrontierRightDown(X,Y,FX,FY,[Frontiers,Values], Frontier),
  append(AccDownFrontiers,[Frontier],NewAccDF),
  getDownFrontiers(Board,FX,FY,Frontiers,Values,NewAccDF,DownFrontiers),!.
getDownFrontiers(_,_,_,_,_, AccDownFrontiers,AccDownFrontiers) :- !.

% getUpFrontiers(+Board,+X,+Y,+Frontiers,+Values, +AccDownFrontiers,-DownFrontiers)
% gets all the up frontiers values visible from the X,Y cell of the Board
getUpFrontiers(Board,X,Y,Frontiers,Values, AccUpFrontiers,UpFrontiers) :-
  neighborUp(Board,X,Y,FX,FY),
  getFrontierLeftUp(X,Y,FX,FY,[Frontiers,Values], Frontier),
  append(AccUpFrontiers,[Frontier],NewAccUF),
  getUpFrontiers(Board,FX,FY,Frontiers,Values,NewAccUF,UpFrontiers).
getUpFrontiers(_,_,_,_,_, AccUpFrontiers,AccUpFrontiers) .

% getLeftFrontiers(+Board,+X,+Y,+Frontiers,+Values, +AccDownFrontiers,-DownFrontiers)
% gets all the left frontiers values visible from the X,Y cell of the Board
getLeftFrontiers(Board,X,Y,Frontiers,Values, AccLeftFrontiers,LeftFrontiers) :-
  neighborLeft(Board,X,Y,FX,FY),
  getFrontierLeftUp(X,Y,FX,FY,[Frontiers,Values], Frontier),
  append(AccLeftFrontiers,[Frontier],NewAccLF),
  getLeftFrontiers(Board,FX,FY,Frontiers,Values,NewAccLF,LeftFrontiers),!.
getLeftFrontiers(_,_,_,_,_, AccLeftFrontiers,AccLeftFrontiers) :- !.

% getRightFrontiers(+Board,+X,+Y,+Frontiers,+Values, +AccDownFrontiers,-DownFrontiers)
% gets all the right frontiers values visible from the X,Y cell of the Board
getRightFrontiers(Board,X,Y,Frontiers,Values, AccRightFrontiers,RightFrontiers) :-
  neighborRight(Board,X,Y,FX,FY),
  getFrontierRightDown(X,Y,FX,FY,[Frontiers,Values], Frontier),
  append(AccRightFrontiers,[Frontier],NewAccRF),
  getRightFrontiers(Board,FX,FY,Frontiers,Values,NewAccRF,RightFrontiers),!.
getRightFrontiers(_,_,_,_,_, AccRightFrontiers,AccRightFrontiers) :- !.

% getCellValue(+Board,+X,+Y,+CellValues,-Value)
% gets the corresponding value of the cell X,Y in the Board in CellValues list
getCellValue(Board,X,Y,CellValues,Value) :-
  nth1(Index, Board, cell(X,Y)),
  element(Index, CellValues, Value).

% print_long_list(+List)
% prints a long list
print_long_list([]) .  
print_long_list([H|T]) :-
    write(H), write('  '),
    print_long_list(T).

% new_read(-Option)
% reads one character at the time 
% ends when a newline is found returning the whole word in Option
new_read(Option) :-
  new_read('', Option), !.

% new_read(+Acc, -Option)
% reads one character at the time 
% ends when a newline is found
new_read(Acc, Option) :-
  get_char(Char),
  processChar(Char, Acc, Option).

% processChar(+Char, -Acc, -Option)
% reads one character at the time and adds it to Acc
% ends when a newline is found
processChar('\n', Acc, Acc).
processChar(Char, Acc, Option) :-
  atom_concat(Acc, Char, Res),
  new_read(Res, Option).

% getInteger(+List, +Acc, -Integer) 
% gets and Integer from a List of codes (format: ['1','2','3'])
getInteger([], Acc, Acc).
getInteger([H|T], Acc, Integer) :-
  length([H|T], L),
  L1 is L-1,
  char_code(H,CC),
  CC1 is CC - 48,
  validate_code(CC1),
  power(10,L1, Factor),
  Acc1 is Acc + CC1*Factor,
  getInteger(T,Acc1,Integer).

% validate_code(+Code)
% Validates if a Code is a digit between 0 and 9
validate_code(Code) :-
  Code = 0.
validate_code(Code) :-
  Code = 1.
validate_code(Code) :-
  Code = 2.
validate_code(Code) :-
  Code = 3.
validate_code(Code) :-
  Code = 4.
validate_code(Code) :-
  Code = 5.
validate_code(Code) :-
  Code = 6.
validate_code(Code) :-
  Code = 7.
validate_code(Code) :-
  Code = 8.
validate_code(Code) :-
  Code = 9.

% power(+B,+P,-R)
% calculates the B power to P
power(_,0,1) :-!.
power(B,1,B) :-!.
power(B,P,R) :-
  power(B,B,P,1,R), !.
% power(B,Bc,P,Acc,R)
% auxiliary function of power(B,P,R), calculates the B power to P
power(_,Bc,P,P,Bc).
power(B,Bc,P,Acc,R) :-
    B1 is Bc*B,
    Acc1 is Acc+1,
    power(B,B1,P,Acc1,R).

% print_InvalidOption
% Prints error message when an invalid option has been chosen
print_InvalidOption :-
  write('Invalid option! Please try again...').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         draw board                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% getLinesN(+List,+N, +Count, +TmpList, +FinalList, -Res)
% divides a List in sublist of N lenght
getLinesN([],_, _, _, FinalList, FinalList) :- !.

getLinesN([H|T],N, Count, TmpList, FinalList, Res) :-
  append(TmpList,[H],NewTmpList),
  NewCount is Count+1,
  NewCount = N,
  append(FinalList,[NewTmpList], NewFL),
  getLinesN(T,N,0,[],NewFL,Res),!.

getLinesN([H|T],N, Count, TmpList, FinalList, Res) :-
  append(TmpList,[H],NewTmpList),
  NewCount is Count+1,
  getLinesN(T,N,NewCount,NewTmpList,FinalList,Res),!.

% draw_board(+CellCoordinates,+CellValues,+Frontiers,+N)
% Prints the puzzle Board
% CellCoordinates is the list of cells in the format cell(X,Y)
% CellValues is the list of corresponding values for the cells in the previous list
% Frontiers is a list in the format  [FrontCoords, FrontValues], being FrontCoords the list of 
% coordinates and FrontValues the list of values.
draw_board([H|T],CellValues,Frontiers,N) :-
    nl,
    getLinesN([H|T],N,0,[],[],Lines),
    drawLines([H|T],Lines, CellValues, Frontiers), !.
 
% drawLines(+Board,+Lines, +CellValues,+Frontiers)
% draws a list of Lines from the board Board
drawLines(_,[],_, _).

drawLines(Board,[H|T], CellValues,Frontiers) :-
  draw_line(Board,H,CellValues,Frontiers),
  draw_horizontal_frontiers(H,Frontiers),
  drawLines(Board,T,CellValues,Frontiers).

% draw_line(+Board,+Line,+CellValues,+Frontiers) 
% draws all the cells and vertical frontiers from a Line of the board Board
draw_line(_,[],_,_) :-
      nl.

draw_line(Board,[cell(X1,Y1)|T],CellValues,Frontiers) :-
     getCellValue(Board,X1,Y1,CellValues,Value),
     draw_cell(Value),
     Y2 is Y1 +1,
     draw_vertical_frontier(Frontiers,X1,Y1,X1,Y2),
     draw_line(Board,T,CellValues,Frontiers).

% draw_cell(+Value)
% draws a cell of value Value
draw_cell(Value) :-
  Value < 10,
  write(' ') ,write(Value), write(' ').
draw_cell(Value) :-
  write(' ') ,write(Value), write('').

% draw_horizontal_frontiers(+Line,+Frontiers)
% draws all the horizontal frontiers from a Line
draw_horizontal_frontiers([],_) :-
       nl.

draw_horizontal_frontiers([cell(X1,Y1)|T],Frontiers) :-
     X2 is X1 +1 ,
    draw_horizontal_frontier(Frontiers,X1,Y1,X2,Y1),
    draw_horizontal_frontiers(T,Frontiers).

draw_horizontal_frontier(Frontiers,X1,Y1,X2,Y2) :-
    getFrontier(X1,Y1,X2,Y2,Frontiers, 1),
    write('---- ').

draw_horizontal_frontier(_,_,_,_,_) :-
    write('     ').

% draw_vertical_frontier(+Frontiers, +X1, +Y1, +X2,+Y2)
% draws the horizontal frontiers between the cell(X1,Y1) and the cell(X2,Y2)
draw_vertical_frontier(Frontiers,X1,Y1,X2,Y2) :-
    getFrontier(X1,Y1,X2,Y2,Frontiers, 1),
    write(' |').

draw_vertical_frontier(_,_,_,_,_) :-
  write('  ').
