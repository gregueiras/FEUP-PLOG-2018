
:- ensure_loaded(board).
:- use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    Count visible houses                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


test(X,Y,Count):-
  generateBoard(4,[Board|Frontiers]),
  write(Frontiers), nl,
  draw_board(Board,Frontiers,4),!,
  findAllNeighbors(Board,Frontiers,[(X,Y,'A')],[],0,Count).

getPiece(Board, X, Y, Pout) :-
  member(cell(X, Y, Pout), Board).

neighborVertical(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y,_),
  RX is X+1,
  RY is Y,
  getPiece(Board,RX,RY,_).

neighborVertical(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y,_),
  RX is X-1,
  RY is Y,
  getPiece(Board,RX,RY,_).

neighborHorizontal(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y,_),
  RX is X,
  RY is Y+1,
  getPiece(Board,RX,RY,_).

neighborHorizontal(Board,X,Y,RX,RY) :-
  getPiece(Board,X,Y,_),
  RX is X,
  RY is Y-1,
  getPiece(Board,RX,RY,_).

hasfrontier(X1,Y1,X2,Y2,[FrontCoords|[FrontValues]]) :-
  nth0(Index, FrontCoords, frontier(X1,Y1,X2,Y2)),
  nth0(Index,FrontValues,1).

hasfrontier(X1,Y1,X2,Y2,[FrontCoords|[FrontValues]]) :-
  nth0(Index, FrontCoords, frontier(X2,Y2,X1,Y1)),
  nth0(Index,FrontValues,1).

 
findFirstNeighbors(Board,Frontiers,X,Y, 'A',Processed,ToProcess) :-
  findAllVertical(Board,Frontiers,X,Y,Processed,Vertical),
  findAllHorizontal(Board,Frontiers,X,Y,Processed,Horizontal),
  append(Horizontal,Vertical,ToProcess).

findFirstNeighbors(Board,Frontiers,X,Y,'H',Processed,ToProcess) :-
  findAllHorizontal(Board,Frontiers,X,Y,Processed,ToProcess).


findFirstNeighbors(Board,Frontiers,X,Y,'V',Processed,ToProcess) :-
  findAllVertical(Board,Frontiers,X,Y,Processed,ToProcess).


findAllVertical(Board,Frontiers,X,Y,Processed,Vertical) :-
  findall((FX,FY,'V'),
  (
  !,
  neighborVertical(Board,X,Y,FX,FY),
  \+ hasfrontier(X,Y,FX,FY,Frontiers),
  \+ member((FX,FY), Processed)
  ),
 Vertical).


findAllHorizontal(Board,Frontiers,X,Y,Processed,Horizontal) :-
  findall((FX,FY,'H'),
  (
  !,
  neighborHorizontal(Board,X,Y,FX,FY),
  \+ hasfrontier(X,Y,FX,FY,Frontiers),
  \+ member((FX,FY), Processed)
  ),
  Horizontal).


findAllNeighbors(_Board,_Frontiers,[],_ProcessedCells,Count,Count) :- !.

findAllNeighbors(Board,Frontiers,[(SX,SY,Orientation)|T],ProcessedCells,Count,Res) :-
  findFirstNeighbors(Board,Frontiers,SX,SY,Orientation,ProcessedCells,Tmp),
  append(T,Tmp,ToProcess),
  sort(ToProcess,TP),
  append(ProcessedCells,[(SX,SY)], PC),
  New_Count is Count +1,
  findAllNeighbors(Board,Frontiers,TP, PC,New_Count,Res).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         draw board                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


t:-
  generateBoard(4,[B|[F|_]]),
  draw_board(B,F,4).


getLinesN([],_, _, _, FinalList, FinalList) :- !.

getLinesN([H|T],N, Count, TmpList, FinalList, Res) :-
  append(TmpList,[H],NewTmpList),
  NewCount is Count+1,
  NewCount = N,
  append(FinalList,[NewTmpList], NewFL),
  getLinesN(T,N,0,[],NewFL,Res),!.

getLinesN([H|T],N, Count, TmpList, FinalList, Res) :-
  append(TmpList,[H],NewTmpList),
  NewCount is Count+1,
  getLinesN(T,N,NewCount,NewTmpList,FinalList,Res),!.


draw_board([H|T],Frontiers,N) :-
    nl,
    getLinesN([H|T],N,0,[],[],Lines),
    drawLines(Lines, Frontiers).
 

drawLines([], _).

drawLines([H|T], Frontiers) :-
  draw_line(H,Frontiers),
  draw_horizontal_frontiers(H,Frontiers),
  drawLines(T,Frontiers).

draw_line([],_) :-
      nl.

draw_line([cell(X1,Y1,_)|T],Frontiers) :-

     write(X1), write('-'), write(Y1),
     Y2 is Y1 +1,
     draw_vertical_frontier(Frontiers,X1,Y1,X1,Y2),
     draw_line(T,Frontiers).


draw_horizontal_frontiers([],_) :-
       nl.


draw_horizontal_frontiers([cell(X1,Y1,_)|T],Frontiers) :-
     X2 is X1 +1 ,
    draw_horizontal_frontier(Frontiers,X1,Y1,X2,Y1),
    draw_horizontal_frontiers(T,Frontiers).


draw_horizontal_frontier(Frontiers,X1,Y1,X2,Y2) :-
    hasfrontier(X1,Y1,X2,Y2,Frontiers),
    write('---- ').

draw_horizontal_frontier(_,_,_,_,_) :-
    write('     ').

draw_vertical_frontier(Frontiers,X1,Y1,X2,Y2) :-
    hasfrontier(X1,Y1,X2,Y2,Frontiers),
    write(' |').

draw_vertical_frontier(_,_,_,_,_) :-
  write('  ').


  
