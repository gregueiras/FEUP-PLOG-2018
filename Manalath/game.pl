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
  Winner = -1.
  write('the game ended in draw').

printWinner(Winner) :-
  write('Winner : '),
  print_player(Winner), nl.

printPlay(Play) :-
  Play = -2 ->printIsImpossiblePlay;
  Play = -1 -> printInvalidPlay;
  Play =  2.

isValidPlay(Board,X,Y,Color) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  countCellNeighbors(Board,X,Y,Color,Count),
  Count < 6.

%podemos usar na parte da AI
getValidPlays(Board,Color,ValidPlays) :-
  findall((FX,FY, Color),
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


checkPlay(Player,Count, ValidPlay) :-
  Count >= 5,
  ValidPlay = -1. %jogada invalida, arranjar uma cena mais bonitinha maybe

checkPlay(Player,Count, ValidPlay) :-
  %Count < 3,
  ValidPlay = 2. %jogada valida, arranjar uma cena mais bonitinha maybe

value(Board,Player, Color,Count, Value) :-
  checkPlay(Player,Count,VP),
  VP = -1 ,
  checkInvalidPlay(Board,Color, Value),
  Value = -1.

value(Board,Player, Color,Count, Value) :-
  checkPlay(Player,Count,VP),
  VP = -1 ,
  checkInvalidPlay(Board,Color, Value),
  Value = -2.

value(Board,Player,Color, Count, Value) :-
  checkPlay(Player,Count,VP),
  Value = VP.

checkInvalidPlay(Board,Color,ValidPlay) :-
  countValidPlays(Board,Color, NrValidPlays), %ve quantas valid plays existem
  setNrValidPlays(NrValidPlays,ValidPlay).

setNrValidPlays(NrValidPlays,ValidPlay) :-
  NrValidPlays = 0 ,
  ValidPlay = -2.

setNrValidPlays(NrValidPlays,ValidPlay) :-
  NrValidPlays > 0 ,
  ValidPlay = -1.

move(X, Y, Board, NewBoard) :-
  getCurrentPlayerCurrentColor(Color),
  playPiece(Board, X, Y, Color,TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  getCurrentPlayer(Player),
  value(TmpBoard,Player,Color,NrNeighbors,ValidPlay),
  setValue(Player,ValidPlay),
  updateBoard(TmpBoard,Board,ValidPlay,NewBoard),
  printPlay(ValidPlay).

move(X, Y,Board, NewBoard) :-
  getCurrentPlayerCurrentColor(Color),
  \+ playPiece(Board, X, Y, Color,TmpBoard),
  NewBoard = Board,
  ValidPlay = -1,
  setValue(Player,ValidPlay),
  printInvalidPlay.

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

game_over(Board,Winner) :-
  getPlayer(Player1,_,_,_,Value1,_),
  Value1 = -2,
  getPlayer(Player2,_,_,_,Value2,_),
  Value2 = -2,
  Winner = -1.

game_over(Board, Winner) :-
  getPlayer(PlayerId, Color, 1, _,Value,_),
  Value = 2,
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,N),
  N == 1,
  Winner = PlayerId.

game_over(Board, Winner) :-
  getPlayer(PlayerId, Color, 1, _,Value,_),
  Value = 2,
  check_game_neighbors_value(Board, Board, Color, 3, [], LoserList),
  length(LoserList,N),
  N == 1,
  getOppositePlayer(PlayerId,Winner).
  
game_over(Board, Winner) :-
  Winner = 0.


getInfo(Board, X,Y,Color) :-
  getCurrentPlayerBot(Bot),
  Bot = 0 -> read_validate_info(Board,X,Y,Color);
  Bot = 1 -> choose_move(Board, 1, X, Y, Color).

play_game_loop(Board,Winner) :-
  (Winner = 1; Winner = 2; Winner = -1),
  display_game_winner(Board,Winner), !.


play_game_loop(Board,Winner) :-
 getCurrentPlayer(Player),
 display_game(Board,Player), !,
 getInfo(Board, X,Y,Color),
 setCurrentColor(Player, Color),
 move(X,Y, Board,NewBoard),
 game_over(NewBoard, New_Winner),
 getCurrentPlayerValue(ValidPlay),
 switchCurrentPlayer(ValidPlay),
 play_game_loop(NewBoard, New_Winner).