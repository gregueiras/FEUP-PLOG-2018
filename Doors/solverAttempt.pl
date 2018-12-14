:- ensure_loaded(auxiliar).
:- use_module(library(clpfd)).

board([
    cell(0,0,4),cell(0,1,2),cell(0,2,4),cell(0,3,2),
    cell(1,0,5),cell(1,1,3),cell(1,2,5),cell(1,3,3),
    cell(2,0,4),cell(2,1,3),cell(2,2,4),cell(2,3,4),
    cell(0,0,2),cell(0,1,3),cell(0,2,2),cell(0,3,4)
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
    domain(Values,0,1),

    append([Frontiers], [Values], NF),
    restrictCellVisibility(Board,Board,NF),
    
    labeling([],Values).
    


restrictCellVisibility(Board,[cell(X,Y,Value)|T], [Frontiers|[Values]]) :-
    findAllNeighbors(Board,[Frontiers|[Values]],[(X,Y,'A')],[],0,Count),
    Value #= Count,
    restrictCellVisibility(Board,T,[Frontiers|[Values]]).
    






    