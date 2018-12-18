:- ensure_loaded(auxiliar).
:- ensure_loaded(solver).
:- ensure_loaded(board).

t(N, X) :-
  open('results.csv', write, Stream),
  run(N, X, Stream).

run(_, 0, Stream):- close(Stream).
run(N, X, Stream) :-
  statistics(runtime, [T0|_]),
  generatorAndSolver(N, _),
  statistics(runtime, [T1|_]),
  T is T1 - T0,
  write(Stream, T), nl,
  write(Stream, '\n'),
  format('~3d', [T]),
  NewX is X - 1,
  run(N, NewX, Stream).

generatorAndSolver(N, _) :-
  generateBoard(N, [Board|[C|[V]]]),
  length(Board,L),
  length(CellValues,L),
  MaxValue is N*2,
  domain(CellValues,1,MaxValue),
  restrict(Board,Board,CellValues,C,V),
  labeling([],CellValues),
  solver(Board,CellValues,C,_,N, _).

solver(Board,CellValues,Frontiers,Values, _, _) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Board, CellValues,Frontiers, Values),!,
    labeling([],Values), !.