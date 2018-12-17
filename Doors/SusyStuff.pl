:- ensure_loaded(auxiliar).
:- use_module(library(clpfd)).
:- use_module(library(lists)).

board([
    cell(0,0,4),cell(0,1,2),cell(0,2,4),cell(0,3,2),
    cell(1,0,5),cell(1,1,3),cell(1,2,5),cell(1,3,3),
    cell(2,0,4),cell(2,1,3),cell(2,2,4),cell(2,3,4),
    cell(3,0,2),cell(3,1,3),cell(3,2,2),cell(3,3,4)
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



print_long_list([]) .  
print_long_list([H|T]) :-
    write(H), write('  '),
    print_long_list(T).



solver(Board,Frontiers,Values) :-
    length(Frontiers, N),
    length(Values,N),
    %Values ins 0..1,
    domain(Values, 0, 1),
    restrict(Board, Board, Frontiers, Values),
    labeling([],Values),
    draw_board(Board,[Frontiers, Values],4),
    print_long_list(Values), nl.

restrict(_,[], _, _).
restrict(Board,[cell(X, Y, Value) | RemBoard], Frontiers, Values) :-
    /*getDownFrontiers([cell(X, Y, Value) | RemBoard], [cell(X,Y,_)], Frontiers, Values, [],[], DF),
    getUpFrontiers([cell(X, Y, Value) | RemBoard], [cell(X,Y,_)], Frontiers, Values, [],[], UF),
    getLeftFrontiers([cell(X, Y, Value) | RemBoard], [cell(X,Y,_)], Frontiers, Values, [],[], LF),
    getRightFrontiers([cell(X, Y, Value) | RemBoard], [cell(X,Y,_)], Frontiers, Values, [],[], RF),*/
    getDownFrontiers(Board, X,Y, Frontiers, Values, [], DF),
    getUpFrontiers(Board, X,Y, Frontiers, Values, [], UF),
    getLeftFrontiers(Board, X,Y, Frontiers, Values, [], LF),
    getRightFrontiers(Board, X,Y, Frontiers, Values, [], RF),
    write(X-Y), nl,
    write(DF), nl,
    write(UF), nl,
    write(LF), nl,
    write(RF), nl, nl,nl,nl,
    S1 #= 6,
    S2 #= 7,
    S3 #= 8,
    append([5], DF, Temp1),
    append(Temp1, [S1 | UF], Temp2),
    append(Temp2, [S2 | RF], Temp3),
    append(Temp3, [S3 | LF], AllFrontiers),
    automaton(AllFrontiers, _, AllFrontiers,
    [source(q0), sink(left), sink(end)],
    [arc(q0, 5, down), arc(down, 6, up), arc(up, 7, right), arc(right, 8, left), arc(down, 1, burn), 
    arc(up, 1, burn), arc(right, 1, burn), arc(end, 0, end), arc(end, 1, end), arc(down, 0, down, [C + 1]), 
    arc(up, 0, up, [C + 1]), arc(left, 0, left, [C + 1]), arc(right, 0, right, [C + 1]), arc(burn, 6, up), 
    arc(burn, 7, right), arc(burn, 8, left), arc(burn, 0, burn), arc(burn, 1, burn), arc(left, 1, end)],
     [C], [1], [Sum]),
    Sum #= Value,
    restrict(Board,RemBoard, Frontiers, Values).


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



getDownFrontiers(Board,X,Y,Frontiers,Values, AccDownFrontiers,DownFrontiers) :-
    neighborDown(Board,X,Y,FX,FY),
    getFrontierRightDown(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(AccDownFrontiers,[Frontier],NewAccDF),
    getDownFrontiers(Board,FX,FY,Frontiers,Values,NewAccDF,DownFrontiers),!.
getDownFrontiers(_,_,_,_,_, AccDownFrontiers,AccDownFrontiers) :- !.

getUpFrontiers(Board,X,Y,Frontiers,Values, AccUpFrontiers,UpFrontiers) :-
    neighborUp(Board,X,Y,FX,FY),
    getFrontierLeftUp(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(AccUpFrontiers,[Frontier],NewAccUF),
    getUpFrontiers(Board,FX,FY,Frontiers,Values,NewAccUF,UpFrontiers).
getUpFrontiers(_,_,_,_,_, AccUpFrontiers,AccUpFrontiers) .

getLeftFrontiers(Board,X,Y,Frontiers,Values, AccLeftFrontiers,LeftFrontiers) :-
    neighborLeft(Board,X,Y,FX,FY),
    getFrontierLeftUp(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(AccLeftFrontiers,[Frontier],NewAccLF),
    getLeftFrontiers(Board,FX,FY,Frontiers,Values,NewAccLF,LeftFrontiers),!.
getLeftFrontiers(_,_,_,_,_, AccLeftFrontiers,AccLeftFrontiers) :- !.

getRightFrontiers(Board,X,Y,Frontiers,Values, AccRightFrontiers,RightFrontiers) :-
    neighborRight(Board,X,Y,FX,FY),
    getFrontierRightDown(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(AccRightFrontiers,[Frontier],NewAccRF),
    getRightFrontiers(Board,FX,FY,Frontiers,Values,NewAccRF,RightFrontiers),!.
getRightFrontiers(_,_,_,_,_, AccRightFrontiers,AccRightFrontiers) :- !.


/*getDownFrontiers(_,[],_,_, _,DF, DF) :- !.
getDownFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpDF, DownFrontiers) :-
    neighborDown(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpDF,[Frontier],DF),
    getDownFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,DF, DownFrontiers),!.
getDownFrontiers(_,_,_,_,_,DF,DF) :-!.


getUpFrontiers(_,[],_,_, _,UF, UF) :- !.
getUpFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpUF, UpFrontiers) :-
    neighborUp(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpUF,[Frontier],UF),
    getUpFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,UF, UpFrontiers), !.
getUpFrontiers(_,_,_,_,_,UF,UF) :- !.
    

getLeftFrontiers(_,[],_,_, _,LF, LF) :- !.
getLeftFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpLF, LeftFrontiers) :-
    neighborLeft(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpLF,[Frontier],LF),
    getLeftFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,LF, LeftFrontiers) ,!.
getLeftFrontiers(_,_,_,_,_,LF,LF) :-!.


getRightFrontiers(_,[],_,_, _,RF, RF) :- !.
getRightFrontiers(Board,[cell(X,Y,_)|T],Frontiers,Values, Processed, TmpRF, RightFrontiers) :-
    neighborRight(Board,X,Y,FX,FY),
    append(Processed, [cell(X,Y,_)], NewProcessed),
    append(T, [cell(FX,FY,_)], TmpProcess),
    sort(TmpProcess,ToProcess),
    getFrontier(X,Y,FX,FY,[Frontiers,Values], Frontier),
    append(TmpRF,[Frontier],RF),
    getRightFrontiers(Board,ToProcess,Frontiers,Values,NewProcessed,RF, RightFrontiers), !.
getRightFrontiers(_,_,_,_,_,RF,RF) :- !.*/
