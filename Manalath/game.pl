:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_player(Player),
  print_board(Board).

printInvalidPlay :-
  write('Invalid Play!!!'),nl.

printWinnerPlay :-
  write('Winner Play!!!'),nl.

printLoserPlay :-
  write('Loser Play!!!'),nl.

printInvalidInformation :-
  write('Invalid information! Please try again...'), nl.

printPlay(Play) :-
  Play = -1 -> printInvalidPlay;
  Play = 0  -> printWinnerPlay;
  Play = 1  -> printLoserPlay;
  Play = 2.


playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  setPiece(Board, X, Y, Color, NewBoard). 

checkPlay(Player,Color,Count, ValidPlay) :-
  Count >= 6,
  ValidPlay = -1. %jogada invalida, arranjar uma cena mais bonitinha maybe

checkPlay(Player,Color,Count, ValidPlay) :-
  checkColorPlayer(Player,Color),
  Count == 5,
  ValidPlay = 0. %ganhou, arranjar uma cena mais bonitinha maybe

checkPlay(Player,Color,Count, ValidPlay) :-
  checkColorPlayer(Player,Color),
  Count == 4,
  ValidPlay = 1. %perdeu, arranjar uma cena mais bonitinha maybe

checkPlay(Player,Color,Count, ValidPlay) :-
  %Count < 4,
  ValidPlay = 2. %jogada valida, arranjar uma cena mais bonitinha maybe

checkValidPlay(ValidPlay,End):-
  ValidPlay = 0;
  ValidPlay = 1,
  End = 1.

checkValidPlay(ValidPlay,End):-
  End = 0.

play(Board, Player, X, Y, Color, NewBoard, NewPlayer,End) :-
  playPiece(Board, X, Y, Color, TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  checkPlay(Player,Color,NrNeighbors,ValidPlay),
  switchCurrentPlayer(Player,NewPlayer,ValidPlay),
  updateBoard(TmpBoard,Board,ValidPlay,NewBoard),
  printPlay(ValidPlay),
  checkValidPlay(ValidPlay,End).

play(Board, Player, X, Y, Color, NewBoard, NewPlayer,End) :-
  \+ playPiece(Board, X, Y, Color, TmpBoard),
  NewBoard = Board,
  NewPlayer = Player,
  End = 0,
  printInvalidPlay.


%to be improved
read_info(X,Y, Color) :-
  write('x-coordinate: '),
  read(X),
  write('y-coordinate: '),
  read(Y),
  write('color: '),
  read(Color).

validate_info_Color(Color, Valid) :-
  Color = blackPiece,
  Valid = 1. %is valid

validate_info_Color(Color, Valid) :-
  Color = whitePiece,
  Valid = 1. %is valid

validate_info_Color(Color, Valid) :-
  Valid = 0. %is not valid

validate_info_coords(Board,X,Y, Valid) :-
  getPiece(Board,X,Y,_C),
  Valid = 1. %is valid

validate_info_coords(Board,X,Y, Valid) :-
  Valid = 0. %is not valid

validate_info(Board,X,Y,Color) :-
  validate_info_coords(Board,X,Y,Vcoor),
  validate_info_Color(Color,Vcol),
  Vcoor = 1,
  Vcol = 1.

read_validate_info(Board,X,Y,Color) :-
  read_info(X_tmp,Y_tmp,Color_tmp),
  (
    (validate_info(Board,X_tmp,Y_tmp,Color_tmp)) ->
      (X = X_tmp, Y = Y_tmp, Color = Color_tmp);
      (printInvalidInformation, read_validate_info(Board,X,Y,Color))  
  ).

play_game_loop(Board,Player,End) :-
   End = 1,
   display_game(Board,Player), !.

play_game_loop(Board, Player, End) :-
  display_game(Board,Player), !,
  read_validate_info(Board,X,Y,Color),
  play(Board,Player,X,Y,Color,NewBoard,NewPlayer, New_End),
  play_game_loop(NewBoard,NewPlayer,New_End).

play_game :-
  initial_board(Board),
  play_game_loop(Board,1,0).
