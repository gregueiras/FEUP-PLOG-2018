:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_board(Board).

tp :-
  initial_board(_B), print_board(_B).



%mudar de lugar, para ja meti aqui por causa do includes (nao me odeies dps tiro)

printInvalidPlay :-
  write('Invalid Play!!!'),nl.

printWinnerPlay :-
  write('Winner Play!!!'),nl.

printLoserPlay :-
  write('Loser Play!!!'),nl.

playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  setPiece(Board, X, Y, Color, NewBoard). 

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  Count >= 6,
  ValidPlay = -1, %jogada invalida, arranjar uma cena mais bonitinha maybe
  NewBoard = OldBoard, %if the play is not a valid one then the board is not updated
  printInvalidPlay.

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  checkColorPlayer(Player,Color),
  Count == 5,
  ValidPlay = 0, %ganhou, arranjar uma cena mais bonitinha maybe
  NewBoard = Board, %updates the board
  printWinnerPlay.

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  checkColorPlayer(Player,Color),
  Count == 4,
  ValidPlay = 1, %perdeu, arranjar uma cena mais bonitinha maybe
  NewBoard = Board, %updates the board
  printLoserPlay.

checkPlay(Board,Player,Color,Count, ValidPlay,OldBoard,NewBoard) :-
  %Count < 4,
  ValidPlay = 2, %jogada valida, arranjar uma cena mais bonitinha maybe
  NewBoard = Board.  %updates the board

setPlay(Board, Player, X, Y, Color, NewBoard, NewPlayer) :-
  playPiece(Board, X, Y, Color, TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  checkPlay(TmpBoard,Player,Color,NrNeighbors,ValidPlay,Board,NewBoard),
  switchCurrentPlayer(Player,NewPlayer,ValidPlay).

setPlay(Board, Player, X, Y, Color, NewBoard, NewPlayer) :-
  \+ playPiece(Board, X, Y, Color, TmpBoard),
  NewBoard = Board,
  NewPlayer = Player,
  printInvalidPlay.

play(Board, Player, X, Y, Color, NewBoard, NewPlayer) :-
  setPlay(Board, Player, X,Y,Color, NewBoard, NewPlayer),
  display_game(NewBoard,NewPlayer), %prints the new board
  !.