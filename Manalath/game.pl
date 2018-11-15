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

printWinner(-1) :-
  write('the game ended in draw').

printWinner(Winner) :-
  write('Winner: '),
  print_player(Winner), nl.

printPlay(-2) :-
  printIsImpossiblePlay.

printPlay(-1) :-
  printInvalidPlay.

printPlay(2).

isValidPlay(Board,X,Y,Color) :-
  getPiece(Board,X,Y,emptyCell),
  countCellNeighbors(Board,X,Y,Color,Count),
  Count < 5. 

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

valid_moves(Board,_Player,ListOfMoves) :-
  getValidPlays(Board, blackPiece, VP_BP),
  getValidPlays(Board,whitePiece,VP_WP),
  append(VP_BP,VP_WP,ListOfMoves).

countValidMoves(Board, Player, Count) :-
  valid_moves(Board, Player, ListOfMoves),
  length(ListOfMoves, Count).

playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,emptyCell),
  setPiece(Board, X, Y, Color, NewBoard). 


checkPlay(_Player,Count, -1) :-
  Count >= 5. %jogada invalida, arranjar uma cena mais bonitinha maybe

checkPlay(_Player,_Count, 2).
  %Count < 3,
 %jogada valida, arranjar uma cena mais bonitinha maybe

value(Player, Count, VP) :-
  checkPlay(Player,Count,VP).

move(Move, Board, NewBoard, ValidPlay) :-
  read_move(Move, X,Y, Color),
  playPiece(Board, X, Y, Color,TmpBoard),
  countCellNeighbors(TmpBoard,X,Y,Color,NrNeighbors), 
  getCurrentPlayer(Player),
  value(Player,NrNeighbors,ValidPlay),
  updateBoard(TmpBoard,Board,ValidPlay,NewBoard),
  printPlay(ValidPlay).

move(Move,Board, NewBoard, -1) :-
  read_move(Move, X,Y, Color),
  \+ playPiece(Board, X, Y, Color,_TmpBoard),
  NewBoard = Board,
  printInvalidPlay.

%to be improved
read_info(Letter, Number, Color) :-
  write('LetterNumber: '),
  new_read(Play),
  atom_chars(Play, Option),
  parseOption(Option, Letter, Number),
  write('color: '),
  new_read(TmpColor), 
  translate(TmpColor, Color).

parseOption(List, L, N) :-
  length(List, 2),
  nth0(0, List, L),
  atom(L),
  nth0(1, List, TmpAtom),
  atom(TmpAtom),
  atom_chars(TmpAtom, TmpChar),
  number_chars(N, TmpChar),
  number(N).

new_read(Color) :-
  new_read('', Color), !.

new_read(Acc, Color) :-
  get_char(Char),
  processChar(Char, Acc, Color).
  
processChar('\n', Acc, Acc).
processChar(Char, Acc, Color) :-
  atom_concat(Acc, Char, Res),
  new_read(Res, Color).


translate(b, blackPiece).
translate(w, whitePiece).
translate(b, black).
translate(w, white).
translate(black, blackPiece).
translate(white, whitePiece).
translate(_C, _C).

validate_info_Color(blackPiece).
validate_info_Color(whitePiece).

validate_info_coords(Board,X,Y) :-
  getPiece(Board,X,Y,_). %is valid

validate_info(Board,X,Y,Color) :-
  validate_info_coords(Board,X,Y),
  validate_info_Color(Color).

read_validate_info(Board,X,Y,Color) :-
  read_info(Letter,Number,Color),
  userToCoords(Board, Letter, Number, X, Y),
  validate_info(Board,X,Y,Color).


read_validate_info(Board,X,Y,Color) :-
  printInvalidInformation,
  read_validate_info(Board,X,Y,Color).


checkCellNeighborsCount(Board,X,Y,Color, Value,[(X,Y, Color)]) :-
  countCellNeighbors(Board,X,Y,Color,Value), !.

checkCellNeighborsCount(_Board,_X,_Y,_Color,_Value,[]).

check_game_neighbors_value(_Board,_L,_Player_Color,_Value ,Cells, Cells) :-
  length(Cells,1), !.

check_game_neighbors_value(_Board,[],_Player_Color,_Value ,_Cells, []) :- !.


check_game_neighbors_value(Board,[cell(X,Y,Player_Color)| T],Player_Color, Value, _Cells, C) :- 
  checkCellNeighborsCount(Board,X,Y,Player_Color,Value,Res),
  check_game_neighbors_value(Board,T, Player_Color,Value, Res, C).

check_game_neighbors_value(Board,[cell(_X,_Y,_Color)| T], Player_Color,Value, Cells, C) :- 
  check_game_neighbors_value(Board,T,Player_Color, Value, Cells, C).

game_over(_Board,-1) :-
  player(_Player1,_,_,-2,_),
  player(_Player2,_,_,-2,_).

game_over(Board, Winner) :-
  player(Winner, Color, 1,2,_),
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,1).

game_over(Board, Winner) :-
  player(PlayerId, Color, 1,2,_),
  check_game_neighbors_value(Board, Board, Color, 3, [], LoserList),
  length(LoserList,1),
  getOppositePlayer(PlayerId,Winner).

game_over(Board, Winner) :-
  player(Winner, Color, 0,_Value,_),
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,1).
  
game_over(_Board, 0).

getInfo(Board,_Lvl, X,Y,Color) :-
  getCurrentPlayerBot(0),
  read_validate_info(Board,X,Y,Color).

getInfo(Board,Lvl, X,Y,Color) :-
  getCurrentPlayerBot(1),
  choose_move(Board, Lvl, X, Y, Color).

play_game_loop(Board,_Lvl, 1) :-
  display_game_winner(Board, 1), !.

play_game_loop(Board,_Lvl, 2) :-
  display_game_winner(Board, 2), !.

play_game_loop(Board,_Lvl, -1) :-
  display_game_winner(Board, -1), !.

%needs testing
play_game_loop(Board,Lvl,Winner) :-
  getCurrentPlayer(Player),
  countValidMoves(Board, Player, 0),
  switchCurrentPlayer(-2),
  printIsImpossiblePlay,
  play_game_loop(Board, Lvl,Winner).

play_game_loop(Board,Lvl,_Winner) :-
 getCurrentPlayer(Player),
 display_game(Board,Player), !,
 getInfo(Board,Lvl, X,Y,Color),
 create_move(X,Y,Color, Move),
 move(Move, Board,NewBoard, ValidPlay), 
 game_over(NewBoard, New_Winner),
 switchCurrentPlayer(ValidPlay), 
 play_game_loop(NewBoard, Lvl, New_Winner).


create_move(X,Y,Color, [X,Y,Color]).

read_move([X,Y,Color], X, Y, Color).



%%%%%%%%%%%%%

play_game_PvP :-
  initial_board(Board),
  assertPlayers_PvP, %initializes the players
  play_game_loop(Board,1,0).

  
play_game_PvC(Lvl) :-
  initial_board(Board),
  assertPlayers_PvC, %initializes the players
  play_game_loop(Board,Lvl,0). %passar o lvl aqui

play_game_CvP(Lvl) :-
  initial_board(Board),
  assertPlayers_CvP, %initializes the players
  play_game_loop(Board,Lvl,0). %passar o lvl aqui


play_game_CvC(Lvl) :-
  initial_board(Board),
  assertPlayers_CvC, %initializes the players
  play_game_loop(Board,Lvl,0). %passar o lvl aqui


%finds all the occupied cells of a given color
findAllColorOcpCells(Board, Color, Res) :-
  findall((FX,FY),
  (
  member(cell(FX,FY,Color), Board)
  ),
  Res).

%NAO SEI ONDE POR ISTO :(
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%finds all the occupied cells 
findAllOcpCells(Board, Res) :-
  findAllColorOcpCells(Board, blackPiece, BP),
  findAllColorOcpCells(Board, whitePiece, WP),
  append(BP,WP,Res).

%finds a cell first neighbors that are empty
findFirstEmptyCellNeighbors(Board,X,Y,Res) :-
  findFirstNeighbors(Board,X,Y,_P,emptyCell,[],Res).

%finds a list of  cells first neighbors that are empty
findFirstEmptyCellNeighborsList(_Board,[],TmpRes,TmpRes).

%finds a list of  cells first neighbors that are empty
findFirstEmptyCellNeighborsList(Board,[(X,Y)|T],TmpRes,Res) :-
  findFirstEmptyCellNeighbors(Board,X,Y,EmpN),
  append(TmpRes,EmpN,NewTmpRes),
  sort(NewTmpRes,NTR),
  findFirstEmptyCellNeighborsList(Board,T,NTR,Res).



  

