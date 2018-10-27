:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_board(Board).

tp :-
  initial_board(_B), print_board(_B).



%mudar de lugar, para ja meti aqui por causa do includes (nao me odeies dps tiro)

checkPlay(Board,Player,Color,Count, ValidPlay) :-
  Count >= 6,
  ValidPlay = -1. %jogada invalida, arranjar uma cena mais bonitinha maybe

checkPlay(Board,Player,Color,Count, ValidPlay) :-
  checkColorPlayer(Player,Color),
  Count == 5,
  ValidPlay = 0. %ganhou, arranjar uma cena mais bonitinha maybe

checkPlay(Board,Player,Color,Count, ValidPlay) :-
  checkColorPlayer(Player,Color),
  Count == 4,
  ValidPlay = 1. %perdeu, arranjar uma cena mais bonitinha maybe

checkPlay(Board,Player,Color,Count, ValidPlay) :-
  ValidPlay = 2. %jogada valida, arranjar uma cena mais bonitinha maybe

%o setPiece nao funciona acho, apaga a celula...
%nao valida a jogada ainda
play(Board, Player, NewBoard, NewPlayer, X,Y,Color) :-
  setPiece(Board, X, Y, Color, NewBoard), %falta validar se a celula esta vazia
  countCellNeighbors(NewBoard,X,Y,Color,NrNeighbors), %falta validar se ganha, perde ou se e invalida
  checkPlay(NewBoard,Player,Color,NrNeighbors,ValidPlay), %usar o validPlay para preparar a proxima jogada ou ver o fim de jogo
  switchCurrentPlayer(Player,NewPlayer),%troca o player atual se a jogada for valida
  display_game(NewBoard,NewPlayer), %imprime o novo tabuleiro
  !.