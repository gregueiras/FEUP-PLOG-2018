:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_board(Board).

tp :-
  initial_board(_B), print_board(_B).

%mudar de lugar, para ja meti aqui por causa do includes (nao me odeies dps tiro)
%o setPiece nao funciona acho, apaga a celula
%nao valida a jogada ainda
%deve precisar de um cut algures
play(Board, Player, NewBoard, NewPlayer, X,Y,Color) :-
  setPiece(Board, X, Y, Color, NewBoard), %falta validar se a celula esta vazia
  countCellNeighbors(NewBoard,X,Y,Color,Count), %falta validar se ganha, perde ou se e invalida
  switchCurrentPlayer(Player,NewPlayer),%troca o player atual
  display_game(NewBoard,NewPlayer). %imprime o novo tabuleiro