
:- ensure_loaded(board).

test(X,Y,Count):-
  generateBoard(4,[Board|[Frontiers|_]]),
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
  \+ member(frontier(X,Y,FX,FY,1),Frontiers),
  \+ member((FX,FY), Processed)
  ),
 Vertical).


findAllHorizontal(Board,Frontiers,X,Y,Processed,Horizontal) :-
  findall((FX,FY,'H'),
  (
  !,
  neighborHorizontal(Board,X,Y,FX,FY),
  \+ member(frontier(X,Y,FX,FY,1),Frontiers),
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

/*countCellVisibleNeighbors([Board|[Frontiers|T]],X,Y,Count) :-
  findAllNeighbors(Board,Frontiers,[(X,Y,'A')],[],Neighbors),
  length(Neighbors,C),
  Count is C.*/





  
  