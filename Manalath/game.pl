:- ensure_loaded(includes).
:- ensure_loaded(bot).

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
  Winner = -1,
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

valid_moves(Board,_,ListOfMoves) :-
  getValidPlays(Board, blackPiece, VP_BP),
  getValidPlays(Board,whitePiece,VP_WP),
  append(VP_BP,VP_WP,ListOfMoves).

countValidMoves(Board, Player, Count) :-
  valid_moves(Board, Player, ListOfMoves),
  length(ListOfMoves, Count).

playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,_S),
  _S = emptyCell,
  setPiece(Board, X, Y, Color, NewBoard). 


checkPlay(_,Count, ValidPlay) :-
  Count >= 5,
  ValidPlay = -1. %jogada invalida, arranjar uma cena mais bonitinha maybe

checkPlay(_,Count, ValidPlay) :-
  %Count < 3,
  ValidPlay = 2. %jogada valida, arranjar uma cena mais bonitinha maybe

value(Player, Count, Value) :-
  checkPlay(Player,Count,VP),
  Value = VP.

move(Move, Board, NewBoard) :-
  read_move(Move, X,Y, Color),
  playPiece(Board, X, Y, Color,TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  getCurrentPlayer(Player),
  value(Player,NrNeighbors,ValidPlay),
  setPlayerValue(Player,ValidPlay),
  updateBoard(TmpBoard,Board,ValidPlay,NewBoard),
  printPlay(ValidPlay).

move(Move,Board, NewBoard) :-
  read_move(Move, X,Y, Color),
  \+ playPiece(Board, X, Y, Color,_),
  NewBoard = Board,
  ValidPlay = -1,
  setPlayerValue(_,ValidPlay),
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

validate_info_coords(_,_,_, Valid) :-
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
  getPlayer(Player1,_,_,Value1,_),
  Value1 = -2,
  getPlayer(Player2,_,_,Value2,_),
  Value2 = -2,
  Winner = -1.

game_over(Board, Winner) :-
  getPlayer(PlayerId, Color, 1,Value,_),
  Value = 2,
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,N),
  N == 1,
  Winner = PlayerId.

game_over(Board, Winner) :-
  getPlayer(PlayerId, Color, 1,Value,_),
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
  Bot = 1 -> choose_move(Board, 2, X, Y, Color).


play_game_loop(Board,Winner) :-
  (Winner = 1; Winner = 2; Winner = -1),
  display_game_winner(Board,Winner), !.

%needs testing
play_game_loop(Board,Winner) :-
  getCurrentPlayer(Player),
  countValidMoves(Board, Player, Count),
  Count = 0,
  setPlayerValue(Player, -2),
  switchCurrentPlayer,
  printIsImpossiblePlay,
  play_game_loop(Board, Winner).

play_game_loop(Board,Winner) :-
 getCurrentPlayer(Player),
 display_game(Board,Player), !,
 getCurrentPlayerBot(Bot),
 Bot = 1, 
 minimaxBoard(Board, NewBoard), %retornar value e usar no switchCurrentPlayer como estava anteriormente
 game_over(NewBoard, New_Winner),
 setPlayerValue(Player, 2),
 switchCurrentPlayer, 
 play_game_loop(NewBoard, New_Winner).

play_game_loop(Board,Winner) :-
 getCurrentPlayer(Player),
 display_game(Board,Player), !,
 getInfo(Board, X,Y,Color),
 create_move(X,Y,Color, Move),
 move(Move, Board,NewBoard), %retornar value e usar no switchCurrentPlayer como estava anteriormente
 game_over(NewBoard, New_Winner),
 switchCurrentPlayer, 
 play_game_loop(NewBoard, New_Winner).


create_move(X,Y,Color, Move) :-
  Move = [X,Y,Color].

read_move([X,Y,Color], RX, RY, RColor) :-
  RX = X,
  RY = Y,
  RColor = Color.



%%%%%%%%%%%%%

play_game_PvP :-
  initial_board(Board),
  assertPlayers_PvP, %initializes the players
  play_game_loop(Board,0).

  
play_game_PvC :-
  initial_board(Board),
  assertPlayers_PvC, %initializes the players
  play_game_loop(Board,0). %passar o lvl aqui


play_game_CvC :-
  initial_board(Board),
  assertPlayers_CvC, %initializes the players
  play_game_loop(Board,0). %passar o lvl aqui

