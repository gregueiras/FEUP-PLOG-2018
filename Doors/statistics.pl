:- ensure_loaded(auxiliar).
:- ensure_loaded(solver).
:- ensure_loaded(board).

% All variables order labeling options
% order_variables(-ListOfOptions)
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

% All values selection labeling options
% selection(-ListOfOptions)
selection([
  step,
  enum,
  bisect,
  median,
  middle
]).

% All values order labeling options
% order_values(-ListOfOptions)
order_values([
  up,
  down
]).

% Runs the algorithm 50 times, for boards of size 8, 16 and 24, for every combination of labeling options 
% stats/0
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


% Launch the statistic test for each size, the given number of times
% stats(+SizesList, +NumberOfTimes, +LabelingOptions).
stats([], _, _).
stats([Size | RemSizes], NumTimes, LabelingOptions) :-
  test(Size, NumTimes, LabelingOptions),
  stats(RemSizes, NumTimes, LabelingOptions).

% Converts the head of the list of labeling options lists to a string, opens a file with the board size and that string and prints the running times in it
% test(+BoardSize, +NumOfTimes, +ListOfLabelingOptionsLists).
test(_, _, []).
test(N, X, [LOption | T]) :-
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
  test(N, X, T).

% Test how much time does it take to generate and solve a puzzle with the given LabelingOptions and prints it to Stream
% run(+BoardSize, +NumOfTimes, +OutputStream, +LabelingOptionsList).
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

% Modified version of generatorAndSolver/1, to handle custom LabelingOptions
% generatorAndSolver(+N, +LabelingOptions) :-
generatorAndSolver(N, LabelingOptions) :-
  generateBoard(N, [Board|[C|[V]]]),
  length(Board,L),
  length(CellValues,L),
  MaxValue is N*2,
  domain(CellValues,1,MaxValue),
  restrict(Board,Board,CellValues,C,V),
  labeling(LabelingOptions, CellValues),
  solver(Board,CellValues,C, LabelingOptions).

% Modified version of solver/5, to handle custom LabelingOptions
% solver(+Board, +CellValues, +Frontiers, +LabelingOptions) :-
solver(Board,CellValues,Frontiers, LabelingOptions) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Board, CellValues,Frontiers, Values),!,
    labeling(LabelingOptions,Values), !.

%%%%%% NOT OUR CODE %%%%%%%
%Code responsible from converting a list of atoms to a string, used to convert the labeling options list to a string, to be the name of a results file
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