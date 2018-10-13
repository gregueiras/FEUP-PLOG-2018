initial_tab([
  [buffrCell, buffrCell, invalCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell, invalCell],
  [buffrCell, invalCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell, invalCell],
  [buffrCell, buffrCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell],
  [buffrCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell],
  [emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell],
  [buffrCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell],
  [buffrCell, buffrCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell],
  [buffrCell, invalCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell, invalCell],
  [buffrCell, buffrCell, invalCell, emptyCell, emptyCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell, invalCell]
]).

inter_tab([
  [buffrCell, buffrCell, invalCell, emptyCell, emptyCell, whiteCell, blackCell, whiteCell, invalCell, invalCell, invalCell],
  [buffrCell, invalCell, emptyCell, emptyCell, blackCell, whiteCell, blackCell, whiteCell, invalCell, invalCell, invalCell],
  [buffrCell, buffrCell, emptyCell, emptyCell, blackCell, blackCell, emptyCell, emptyCell, blackCell, invalCell, invalCell],
  [buffrCell, emptyCell, emptyCell, emptyCell, whiteCell, whiteCell, blackCell, whiteCell, blackCell, invalCell, invalCell],
  [emptyCell, emptyCell, blackCell, emptyCell, whiteCell, blackCell, whiteCell, whiteCell, whiteCell, invalCell, invalCell],
  [buffrCell, blackCell, emptyCell, blackCell, emptyCell, blackCell, emptyCell, blackCell, blackCell, invalCell, invalCell],
  [buffrCell, buffrCell, blackCell, whiteCell, blackCell, whiteCell, whiteCell, whiteCell, blackCell, invalCell, invalCell],
  [buffrCell, invalCell, blackCell, whiteCell, emptyCell, blackCell, blackCell, emptyCell, invalCell, invalCell, invalCell],
  [buffrCell, buffrCell, invalCell, whiteCell, blackCell, emptyCell, emptyCell, emptyCell, invalCell, invalCell, invalCell]
]).


print_tab([]).

  print_tab([L | T]) :-
    print_line(L),
    nl,
    print_tab(T).

  print_line([]).
  print_line([L | T]) :-
    print_cell(L),
    write(' '), %separacao
    print_line(T).

  print_cell(emptyCell) :-
    write('O').

  print_cell(invalCell) :-
    write(' ').
  
  print_cell(buffrCell) :-
    write('').

  print_cell(blackCell) :-
    write('1').

  print_cell(whiteCell) :-
    write('2').

  display_game(Board, Player) :-
    print_tab(Board).