:- ensure_loaded(auxiliar).
:- ensure_loaded(solver).
:- ensure_loaded(board).

order_variables([
  ffc,
  first_fail,
  anti_first_fail,
  min,
  max,
  occurrence,
  max_regret,
  leftmost
]).

selection([
  step,
  enum,
  bisect,
  median,
  middle
]).

order_values([
  up,
  down
]).

test :-
  order_variables(OrdVariables),
  selection(Selection),
  order_values(OrdValues),
  findall([X,Y], (member(X, OrdVariables), member(Y, Selection)), Pairs),
  findall(Triple, (member(X, Pairs), member(Y, OrdValues), append(X, [Y], Triple)), Options),
  write(Options).

stats :-
  order_variables(OrdVariables),
  selection(Selection),
  order_values(OrdValues),
  findall([X,Y], (member(X, OrdVariables), member(Y, Selection)), Pairs),
  findall(Triple, (member(X, Pairs), member(Y, OrdValues), append(X, [Y], Triple)), Options),
  stats(
    [8, 16, 24],
    50,
    Options
  ).


stats([], _, _).
stats([Size | RemSizes], NumTimes, LabelingOptions) :-
  t(Size, NumTimes, LabelingOptions),
  stats(RemSizes, NumTimes, LabelingOptions).

t(_, _, []).
t(N, X, [LOption | T]) :-
  number_chars(N, CAtom),
  atom_chars(NAtom, CAtom),
  atom_concat(NAtom, '-', T1),
  atomic_list_concat_(LOption, '-', Options),
  atom_concat(T1, Options, T2),
  atom_concat(T2, '.csv', FileName),
  open(FileName, write, Stream),
  write(Stream, FileName),
  write(Stream, '\n'),
  run(N, X, Stream, LOption),
  close(Stream),
  t(N, X, T).

run(_, 0, _, _).
run(N, X, Stream, LabelingOptions) :-
  statistics(runtime, [T0|_]),
  generatorAndSolver(N, LabelingOptions),
  statistics(runtime, [T1|_]),
  T is T1 - T0,
  write(Stream, T), nl,
  write(Stream, ',\t'),
  format('~3d', [T]),
  NewX is X - 1,
  run(N, NewX, Stream, LabelingOptions).

generatorAndSolver(N, LabelingOptions) :-
  generateBoard(N, [Board|[C|[V]]]),
  length(Board,L),
  length(CellValues,L),
  MaxValue is N*2,
  domain(CellValues,1,MaxValue),
  restrict(Board,Board,CellValues,C,V),
  labeling(LabelingOptions, CellValues),
  solver(Board,CellValues,C,_,N, LabelingOptions).

solver(Board,CellValues,Frontiers,Values, _, LabelingOptions) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Board, CellValues,Frontiers, Values),!,
    labeling(LabelingOptions,Values), !.

%% https://stackoverflow.com/questions/35317539/split-atom-using-sicstus-like-atomic-list-concat-3-in-swi
atomic_list_concat_(L, Sep, Atom) :-
        ( atom(Sep), ground(L), is_list(L) )
    ->  list_atom(L, Sep, Atom)
    ;   ( atom(Sep), atom(Atom) )
    ->  atom_list(Atom, Sep, L)
    ;   instantiation_error(atomic_list_concat_(L, Sep, Atom))
    .

list_atom([Word], _Sep, Word).
list_atom([Word|L], Sep, Atom) :-
    list_atom(L, Sep, Right),
    atom_concat(Sep, Right, Right1),
    atom_concat(Word, Right1, Atom).

atom_list(Atom, Sep, [Word|L]) :-
    sub_atom(Atom, X,N,_, Sep),
    sub_atom(Atom, 0,X,_, Word),
    Z is X+N,
    sub_atom(Atom, Z,_,0, Rest),
    !, atom_list(Rest, Sep, L).
atom_list(Atom, _Sep, [Atom]).