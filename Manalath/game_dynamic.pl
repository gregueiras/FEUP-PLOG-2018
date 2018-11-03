:- ensure_loaded(includes).

display_game(Board, Player) :-
  print_player(Player),
  print_board(Board).

display_game_winner(Board,Winner) :-
  printWinner(Winner),
  print_board(Board).
  
printInvalidPlay :-
  write('Invalid Play!!!'),nl.

printWinnerPlay :-
  write('Winner Play!!!'),nl.

printLoserPlay :-
  write('Loser Play!!!'),nl.

printIsImpossiblePlay :-
  write('It is impossible for you to play, you must pass your turn....'), nl.

printInvalidInformation :-
  write('Invalid information! Please try again...'), nl.

printWinner(Winner) :-
  write('Winner : '),
  print_player(Winner), nl.

printPlay(Play) :-
  Play = -2 ->printIsImpossiblePlay;
  Play = -1 -> printInvalidPlay;
  Play =  0 -> printWinnerPlay;
  Play =  1 -> printLoserPlay;
  Play =  2.

isValidPlay(Board,X,Y,Color) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  countCellNeighbors(Board,X,Y,Color,Count),
  Count < 6.

%podemos usar na parte da AI
getValidPlays(Board,Color,ValidPlays) :-
  findall((FX,FY),
  (
  !,
  isValidPlay(Board,FX,FY,Color)
  ),
  ValidPlays).

countValidPlays(Board,Color,NrValidPlays) :-
  getValidPlays(Board,Color,VP),
  length(VP, NrValidPlays).

valid_moves(Board,Player,ListOfMoves) :-
  getValidPlays(Board, blackPiece, VP_BP),
  getValidPlays(Board,whitePiece,VP_WP),
  append(VP_BP,VP_WP,ListOfMoves).


playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  setPiece(Board, X, Y, Color, NewBoard). 



%estas vao sair daqui
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%checkPlay(Player,Count, ValidPlay) :-
%  checkCurrentColorPlayer(Player),
%  Count == 4,
%  ValidPlay = 0. %ganhou, arranjar uma cena mais bonitinha maybe

%checkPlay(Player,Count, ValidPlay) :-
%  checkCurrentColorPlayer(Player),
%  Count == 3,
%  ValidPlay = 1. %perdeu, arranjar uma cena mais bonitinha maybe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkPlay(Player,Count, ValidPlay) :-
  Count >= 5,
  ValidPlay = -1. %jogada invalida, arranjar uma cena mais bonitinha maybe

checkPlay(Player,Count, ValidPlay) :-
  %Count < 3,
  ValidPlay = 2. %jogada valida, arranjar uma cena mais bonitinha maybe

value(Board,Player, Color,Count, Value) :-
  checkPlay(Player,Count,VP),
  VP = -1 ,
  checkInvalidPlay(Board,Color, Value).

value(Board,Player,Color, Count, Value) :-
  checkPlay(Player,Count,VP),
  Value = VP.

checkInvalidPlay(Board,Color,ValidPlay) :-
  countValidPlays(Board,Color, NrValidPlays),
  setNrValidPlays(NrValidPlays,ValidPlay).

setNrValidPlays(NrValidPlays,ValidPlay) :-
  NrValidPlays = 0 ,
  ValidPlay = -2.

setNrValidPlays(NrValidPlays,ValidPlay) :-
  NrValidPlays > 0 ,
  ValidPlay = -1.

checkEndGame(OldValidPlay,ValidPlay,End):-
  ValidPlay = 0;
  ValidPlay = 1,
  End = 1. %acaba normalmente

checkEndGame(OldValidPlay,ValidPlay,End):-
  OldValidPlay = -2,
  ValidPlay = -2,
  End = 2. %acaba em empate

checkEndGame(OldValidPlay,ValidPlay,End):-
  End = 0.


setPlay(Board, X, Y, NewBoard,ValidPlay) :-
  getCurrentPlayerCurrentColor(Color),
  playPiece(Board, X, Y, Color,TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  getCurrentPlayer(Player),
  value(TmpBoard,Player,Color,NrNeighbors,ValidPlay),
  updateBoard(TmpBoard,Board,ValidPlay,NewBoard),
  printPlay(ValidPlay).

setPlay(Board, X, Y, NewBoard,ValidPlay) :-
  getCurrentPlayerCurrentColor(Color),
  \+ playPiece(Board, X, Y, Color,TmpBoard),
  NewBoard = Board,
  ValidPlay = -1,
  printInvalidPlay.

play_PvP(Board, X, Y, NewBoard, OldValidPlay, ValidPlay,End) :-
  setPlay(Board, X, Y, NewBoard, ValidPlay),
  checkEndGame(OldValidPlay,ValidPlay,End).

%to be improved
read_info(X,Y, Color) :-
  write('x-coordinate: '),
  read(X),
  write('y-coordinate: '),
  read(Y),
  write('color: '),
  read(Color).

validate_info_Color(Color,Valid) :-
  Color = blackPiece -> Valid = 1;
  Color = whitePiece -> Valid = 1;
  Valid = 0.

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


play_game_loop_PvP(Board,Winner, OldValidPlay) :-
  (Winner = 1; Winner = 2),
  display_game_winner(Board,Winner), !.


play_game_loop_PvP(Board,Winner, OldValidPlay) :-
 getCurrentPlayer(Player),
 display_game(Board,Player), !,
 read_validate_info(Board,X,Y,Color),
 setCurrentColor(Player, Color),
 play_PvP(Board,X,Y,NewBoard, OldValidPlay,ValidPlay, New_End),
 game_over(NewBoard, New_Winner),
 switchCurrentPlayer(ValidPlay),
 play_game_loop_PvP(NewBoard, New_Winner,ValidPlay).

play_game_PvP :-
  initial_board(Board),
  assertPlayer, %initializes the players
  play_game_loop_PvP(Board,0,0).



checkCellNeighborsCount(Board,X,Y,Color, Value,Res) :-
  countCellNeighbors(Board,X,Y,Color,Count),
  Count == Value,
  Res = [(X,Y, Color)], !.

checkCellNeighborsCount(Board,X,Y,Color, Value,Res) :-
  Res = [].

check_game_neighbors_value(Board,L,Player_Color,Value ,Cells, C) :-
  length(Cells,N),
  N == 1,
  C = Cells, !.

check_game_neighbors_value(Board,L,Player_Color,Value ,Cells, C) :-
  length(L,N),
  N == 0,
  C = [], !.


check_game_neighbors_value(Board,[cell(X,Y,Color)| T],Player_Color, Value, Cells, C) :- 
  Color = Player_Color,
  checkCellNeighborsCount(Board,X,Y,Color,Value,Res),
  check_game_neighbors_value(Board,T, Player_Color,Value, Res, C).

check_game_neighbors_value(Board,[cell(X,Y,Color)| T], Player_Color,Value, Cells, C) :- 
  check_game_neighbors_value(Board,T,Player_Color, Value, Cells, C).


%get_Winner([(X,Y, Color)|T],WinnerOrLoser, Winner) :-
%  WinnerOrLoser = 0, %winner
%  getPlayer(PlayerId, Color, Current, _C),
%  Current = 1 -> (Winner = PlayerId);
%  Winner  = 0.


game_over(Board, Winner) :-
  getPlayer(PlayerId, Color, 1, _C),
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,N),
  N == 1,
  Winner = PlayerId.

game_over(Board, Winner) :-
  getPlayer(PlayerId, Color, 1, _C),
  check_game_neighbors_value(Board, Board, Color, 3, [], LoserList),
  length(LoserList,N),
  N == 1,
  getOppositePlayer(PlayerId,Winner).

game_over(Board, Winner) :-
  Winner = 0.



