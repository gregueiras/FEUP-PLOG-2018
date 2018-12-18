:- ensure_loaded(auxiliar).
:- use_module(library(clpfd)).
:- use_module(library(lists)).

board([
    cell(0,0),cell(0,1),cell(0,2),cell(0,3),
    cell(1,0),cell(1,1),cell(1,2),cell(1,3),
    cell(2,0),cell(2,1),cell(2,2),cell(2,3),
    cell(3,0),cell(3,1),cell(3,2),cell(3,3)
]).


cellValues([
        4,2,4,2,
        5,3,5,3,
        4,3,4,4,
        2,3,2,4
]).

frontiers([
    frontier(0,0,1,0), %1
    frontier(0,0,0,1), %2
    frontier(0,1,1,1), %3
    frontier(0,1,0,2), %4
    frontier(0,2,1,2), %5
    frontier(0,2,0,3), %6
    frontier(0,3,1,3), %7
    frontier(1,0,2,0), %8
    frontier(1,0,1,1), %9
    frontier(1,1,2,1), %10
    frontier(1,1,1,2), %11
    frontier(1,2,2,2), %12
    frontier(1,2,1,3), %13
    frontier(1,3,2,3), %14
    frontier(2,0,3,0), %15  
    frontier(2,0,2,1), %16
    frontier(2,1,3,1), %17
    frontier(2,1,2,2), %18
    frontier(2,2,3,2), %19
    frontier(2,2,2,3), %20
    frontier(2,3,3,3), %21
    frontier(3,0,3,1), %22
    frontier(3,1,3,2), %23
    frontier(3,2,3,3)  %24
]).

values([
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24
    ]).


generatorAndSolver(N) :-
    generateBoard(N, [Board|[C|[V]]]),
    length(Board,L),
    length(CellValues,L),
    MaxValue is N*2,
    domain(CellValues,1,MaxValue),
    restrict(Board,Board,CellValues,C,V),
    labeling([],CellValues),
    solver(Board,CellValues,C,_,N).


generator(N) :-
    generateBoard(N, [Board|[C|[V]]]),
    length(Board,L),
    length(CellValues,L),
    MaxValue is N*2,
    domain(CellValues,1,MaxValue),
    restrict(Board,Board,CellValues,C,V),
    labeling([],CellValues),!.



solver(Board,CellValues,Frontiers,Values,L) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Board, CellValues,Frontiers, Values),!,
    labeling([],Values),
    draw_board(Board,CellValues,[Frontiers, Values],L), !.

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










