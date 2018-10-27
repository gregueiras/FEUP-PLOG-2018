:- use_module(library(lists)).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X - 2,
  FY is Y,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X - 2,
  FY is Y - 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X,
  FY is Y - 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X + 2,
  FY is Y,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X + 2,
  FY is Y + 1,
  getPiece(Board, FX, FY, F).

neighbor(Board, X, Y, _P, F, FX, FY) :-
  getPiece(Board, X, Y, _P),
  FX is X,
  FY is Y + 1,
  getPiece(Board, FX, FY, F).

%guarda no ToProcess os vizinhos da cell(X,Y,_P)
findFirstNeighbors(Board,X,Y,_P,Color,Processed,ToProcess) :-
 findall((FX,FY),
  (
  !,
  neighbor(Board,X,Y,_P,F1,FX,FY),
  F1 == Color,
  \+ member((FX,FY), Processed)
  ),
  ToProcess).

%quando ja nao ha mais celulas para processar termina
findAllNeighbors(Board,Color,ToProcess,ProcessedCells,Res) :-
  length(ToProcess,N),
  N == 0, !,
  Res = ProcessedCells.

%processa o primeiro elemento da lista ToProcess ((SX,SY))
%guarda (SX,SY) nos Processed
%guarda o resto no ToProcess
%Funciona? acho que sim....
findAllNeighbors(Board,Color,[(SX,SY)|T],ProcessedCells,Res) :-
  findFirstNeighbors(Board,SX,SY,_S,Color,ProcessedCells,Tmp),
  append(T,Tmp,ToProcess),
  sort(ToProcess,TP), %remove os duplicados
  append(ProcessedCells,[(SX,SY)], PC),
  findAllNeighbors(Board,Color,TP, PC,Res).

findCellNeighbors(Board,X,Y,Color) :-
  findAllNeighbors(Board,Color,[(X,Y)],[],Res),
  printLongList(Res).

printLongList(List) :-
  length(List,N),
  N == 0.
printLongList([L|T]) :-
  write('('),
  write(L),
  write(')'),
  write(' '),
  printLongList(T).

%guardar os ja processados noutra lista e comparar
%no findFirstNeighbors