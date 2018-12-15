:- ensure_loaded(auxiliar).
:- use_module(library(clpfd)).

board([
    cell(0,0,1),cell(0,1,1),cell(0,2,1),cell(0,3,1),
    cell(1,0,1),cell(1,1,1),cell(1,2,1),cell(1,3,1),
    cell(2,0,1),cell(2,1,1),cell(2,2,1),cell(2,3,1),
    cell(3,0,1),cell(3,1,1),cell(3,2,1),cell(3,3,1)
]).

frontiers([
    frontier(0,0,1,0),
    frontier(0,0,0,1),
    frontier(0,1,1,1),
    frontier(0,1,0,2),
    frontier(0,2,1,2),
    frontier(0,2,0,3),
    frontier(0,3,1,3),
    frontier(1,0,2,0),
    frontier(1,0,1,1),
    frontier(1,1,2,1),
    frontier(1,1,1,2),
    frontier(1,2,2,2),
    frontier(1,2,1,3),
    frontier(1,3,2,3),
    frontier(2,0,3,0),
    frontier(2,0,2,1),
    frontier(2,1,3,1),
    frontier(2,1,2,2),
    frontier(2,2,3,2),
    frontier(2,2,2,3),
    frontier(2,3,3,3),
    frontier(3,0,3,1),
    frontier(3,1,3,2),
    frontier(3,2,3,3)
]).


solver(Board,Frontiers,Values) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Frontiers, Values),
    labeling([],Values), trace.
    
restrict([], _, _).
restrict([cell(X, Y, Value) | RemBoard], Frontiers, Values) :-
    getDownFrontiers(Board, X, Y, Frontiers, Values, DF),
    getUpFrontiers(Board, X, Y, Frontiers, Values, UF),
    getLeftFrontiers(Board, X, Y, Frontiers, Values, LF),
    getRightFrontiers(Board, X, Y, Frontiers, Values, RF),
    append([5], DF, Temp1),
    append(Temp1, [6, UF], Temp2),
    append(Temp2, [7, RF], Temp3),
    append(Temp3, [8, LF], AllFrontiers),
    automaton(AllFrontiers, _, AllFrontiers,
    [source(q0), sink(left)],
    [arc(q0, 5, down), arc(down, 6, up), arc(up, 7, right), arc(right, 8, left),
    arc(down, 0, down, [C + 1]), arc(up, 0, up, [C + 1]), arc(left, 0, left, [C + 1]), arc(right, 0, right, [C + 1])], [C], [0], [Sum]),
    Sum #= Value,
    write(X-Y), nl,
    restrict(RemBoard, Frontiers, Values).

te :-
    board(B),
    frontiers(F),
    length(F, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    getDownFrontiers(Board, 2,2, F, Values, DF),
    %getFrontier(2, 2, 2, 3, [F, Values], DF),
    write(DF).

getDownFrontiers(Board, X, Y, Frontiers, Values, DownFrontiers) :-
    findall(Frontier,
    (
    !,
    neighborVertical(Board,X,Y,FX,FY),
    FY > Y,
    getFrontier(X, Y, FX, FY, [Frontiers, Values], Frontier)
    ),
    DownFrontiers).

getUpFrontiers(Board, X, Y, Frontiers, Values, UpFrontiers) :-
    findall(Frontier,
    (
    !,
    neighborVertical(Board,X,Y,FX,FY),
    FY < Y,
    getFrontier(X, Y, FX, FY, [Frontiers, Values], Frontier)
    ),
    UpFrontiers).
    
getLeftFrontiers(Board, X, Y, Frontiers, Values, LeftFrontiers) :-
    findall(Frontier,
    (
    !,
    neighborHorizontal(Board,X,Y,FX,FY),
    FX < X,
    getFrontier(X, Y, FX, FY, [Frontiers, Values], Frontier)
    ),
    LeftFrontiers).

getRightFrontiers(Board, X, Y, Frontiers, Values, RightFrontiers) :-
    findall(Frontier,
    (
    !,
    neighborHorizontal(Board,X,Y,FX,FY),
    FX > X,
    getFrontier(X, Y, FX, FY, [Frontiers, Values], Frontier)
    ),
    RightFrontiers).





    