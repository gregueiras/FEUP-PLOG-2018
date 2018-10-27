:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_board(Board).

tp :-
  initial_board(_B), print_board(_B).



%mudar de lugar, para ja meti aqui por causa do includes (nao me odeies dps tiro)

%retorna nao e pronto, tenho de mudar mas nao sei bem como
playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  setPiece(Board, X, Y, Color, NewBoard). 

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  Count >= 6,
  ValidPlay = -1, %jogada invalida, arranjar uma cena mais bonitinha maybe
  NewBoard = OldBoard. %if the play is not a valid one then the board is not updated

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  checkColorPlayer(Player,Color),
  Count == 5,
  ValidPlay = 0, %ganhou, arranjar uma cena mais bonitinha maybe
  NewBoard = Board. %updates the board

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  checkColorPlayer(Player,Color),
  Count == 4,
  ValidPlay = 1, %perdeu, arranjar uma cena mais bonitinha maybe
  NewBoard = Board.  %updates the board

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  %Count < 4,
  ValidPlay = 2, %jogada valida, arranjar uma cena mais bonitinha maybe
  NewBoard = Board.  %updates the board

setPlay(Board, Player, TmpBoard, NewPlayer, X,Y,Color, NewBoard) :-
  playPiece(Board, X, Y, Color, TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  checkPlay(TmpBoard,Player,Color,NrNeighbors,ValidPlay,Board,NewBoard), %usar o validPlay para preparar a proxima jogada ou ver o fim de jogo
  switchCurrentPlayer(Player,NewPlayer,ValidPlay).

%o setPiece nao funciona acho, apaga a celula...so as vezes, estou confusa
play(Board, Player, NewBoard, NewPlayer, X,Y,Color) :-
  setPlay(Board, Player, TmpBoard, NewPlayer, X,Y,Color, NewBoard),
  display_game(NewBoard,NewPlayer), %prints the new board
  !.