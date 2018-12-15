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
    getUpFrontiers(B, [cell(2,2,_)], F, Values,[],[], DF),
    %getFrontier(2, 3, 2, 4, [F, Values], DF),
    write(DF).


neighborDown(Board,X,Y,RX,RY) :-
    getPiece(Board,X,Y,_),
    RX is X+1,
    RY is Y,
    getPiece(Board,RX,RY,_).
  
  neighborUp(Board,X,Y,RX,RY) :-
    getPiece(Board,X,Y,_),
    RX is X-1,
    RY is Y,
    getPiece(Board,RX,RY,_).
  
  neighborRight(Board,X,Y,RX,RY) :-
    getPiece(Board,X,Y,_),
    RX is X,
    RY is Y+1,
    getPiece(Board,RX,RY,_).
  
  neighborLeft(Board,X,Y,RX,RY) :-
    getPiece(Board,X,Y,_),
    RX is X,
    RY is Y-1,
    getPiece(Board,RX,RY,_).


getDownFrontiers(Board,[],Frontiers,Values, Processed,DF, DF).
getDownFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpDF, DownFrontiers) :-
    neighborDown(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpDF,[Frontier],DF),
    getDownFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,DF, DownFrontiers).
getDownFrontiers(_,H,_,_,Processed,DF,DF).


getUpFrontiers(Board,[],Frontiers,Values, Processed,UF, UF).
getUpFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpUF, UpFrontiers) :-
    neighborUp(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpUF,[Frontier],UF),
    getUpFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,UF, UpFrontiers).
getUpFrontiers(_,[H|T],_,_,Processed,UF,UF).
    

getLeftFrontiers(Board,[],Frontiers,Values, Processed,LF, LF).
getLeftFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpLF, LeftFrontiers) :-
    neighborLeft(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpLF,[Frontier],LF),
    getLeftFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,LF, LeftFrontiers).
getLeftFrontiers(_,H,_,_,Processed,LF,LF).


getRightFrontiers(Board,[],Frontiers,Values, Processed,RF, RF).
getRightFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpRF, RightFrontiers) :-
    neighborRight(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpRF,[Frontier],RF),
    getRightFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,RF, RightFrontiers).
getRightFrontiers(_,H,_,_,Processed,RF,RF).








    