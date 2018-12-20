:- ensure_loaded(auxiliar).
:- use_module(library(clpfd)).
:- use_module(library(lists)).

% generatorAndSolver(+N)
% generates and solves an instance with N size of the puzzle Doors
generatorAndSolver(N) :-
    generateBoard(N, [Board|[C|[V]]]),
    length(Board,L),
    length(CellValues,L),
    MaxValue is N*2,
    domain(CellValues,1,MaxValue),
    restrict(Board,Board,CellValues,C,V),
    labeling([],CellValues),
    solver(Board,CellValues,C,_,N).

% generator(+N)
% generates an instance with N size of the puzzle Doors
generator(N) :-
    generateBoard(N, [Board|[C|[V]]]),
    length(Board,L),
    length(CellValues,L),
    MaxValue is N*2,
    domain(CellValues,1,MaxValue),
    restrict(Board,Board,CellValues,C,V),
    labeling([],CellValues),!.

% solver(+Board,+CellValues,+Frontiers,-Values,+L)
% solves an instance with L size of the puzzle Doors
solver(Board,CellValues,Frontiers,Values,L) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Board, CellValues,Frontiers, Values),!,
    labeling([],Values),
    draw_board(Board,CellValues,[Frontiers, Values],L), !.

% restrict(+Board,+ListCells, +CellValues, +Frontiers, +Values)
% Applies an automaton to all the cells of the board that restricts each cell's visible houses to the
% value of that cell.
restrict(_,[], _,_, _).
restrict(Board,[cell(X, Y) | RemBoard], CellValues,Frontiers, Values) :-
    getDownFrontiers(Board, X,Y, Frontiers, Values, [], DF),
    getUpFrontiers(Board, X,Y, Frontiers, Values, [], UF),
    getLeftFrontiers(Board, X,Y, Frontiers, Values, [], LF),
    getRightFrontiers(Board, X,Y, Frontiers, Values, [], RF),
    append([5], DF, Temp1),
    append(Temp1, [6 | UF], Temp2),
    append(Temp2, [7 | RF], Temp3),
    append(Temp3, [8 | LF], AllFrontiers),
    automaton(AllFrontiers, _, AllFrontiers,
    [source(q0), sink(left), sink(end)],
    [arc(q0, 5, down), arc(down, 6, up), arc(up, 7, right), arc(right, 8, left), arc(down, 1, burn), 
    arc(up, 1, burn), arc(right, 1, burn), arc(end, 0, end), arc(end, 1, end), arc(down, 0, down, [C + 1]), 
    arc(up, 0, up, [C + 1]), arc(left, 0, left, [C + 1]), arc(right, 0, right, [C + 1]), arc(burn, 6, up), 
    arc(burn, 7, right), arc(burn, 8, left), arc(burn, 0, burn), arc(burn, 1, burn), arc(left, 1, end)],
    [C], [1], [Sum]),
    getCellValue(Board,X,Y,CellValues,Value),
    Sum #= Value,
    restrict(Board,RemBoard,CellValues, Frontiers, Values).
