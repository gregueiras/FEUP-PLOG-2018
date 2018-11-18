:- ensure_loaded(includes).
:- ensure_loaded(bot).

% display_game(+Board, +Player)
% displays the given board and the given player
display_game(Board, Player) :-
  print_player(Player),
  print_board(Board).
  
% display_game(+Board, +Winner)
% displays the given board and the given winner
display_game_winner(Board,Winner) :-
  printWinner(Winner),
  print_board(Board).

% printInvalidPlay
% prints in a user friendly way that the play was invalid
printInvalidPlay :-
  write('Invalid Play!!!'),nl.

% printIsImpossiblePlay
% prints in a user friendly way that the player can not play
printIsImpossiblePlay :-
  write('It is impossible for you to play, you must pass your turn....'), nl.

% printInvalidInformation
% prints in a user friendly way that the information received was invalid
printInvalidInformation :-
  write('Invalid information! Please try again...'), nl.

% printWinner
% prints in a user friendly the status of the game's end
printWinner(-1) :-
  write('the game ended in draw').

printWinner(Winner) :-
  write('Winner: '),
  print_player(Winner), nl.


% isValidPlay(+Board, +X, +Y, +Color)
% checks if a play (X,Y and Color) is valid
% a play is valid if it is an empty cell in the specified board and it does not have more than 5 neighbors
isValidPlay(Board,X,Y,Color) :-
  getPiece(Board,X,Y,emptyCell),
  countCellNeighbors(Board,X,Y,Color,Count),
  Count < 5,
  findall(TX-TY, getPiece(Board, TX, TY, Color), Colors),
  length(Colors, NumColors),
  30 > NumColors.

% getValidPlays(+Board, +Color, -ValidPlays)
% retrieves a list (ValidPlays) with all the valid plays in the specified board for the given color
% the plays are in the format (X,Y,Color)
getValidPlays(Board,Color,ValidPlays) :-
  findall((FX,FY, Color),
  (
  !,
  isValidPlay(Board,FX,FY,Color)
  ),
  ValidPlays).

% countValidPlays(+Board, +Color, -NrValidPlays)
% retrieves the number of valid plays for the specified color
countValidPlays(Board,Color,NrValidPlays) :-
  getValidPlays(Board,Color,VP),
  length(VP, NrValidPlays).

% valid_moves(+Board, -ListOfMoves)
% retrieves a list (ValidPlays) with all the valid plays in the specified board 
% the plays are in the format (X,Y,Color)
valid_moves(Board,ListOfMoves) :-
  getValidPlays(Board, blackPiece, VP_BP),
  getValidPlays(Board,whitePiece,VP_WP),
  append(VP_BP,VP_WP,ListOfMoves).

% countValidMoves(+Board, -NrValidPlays)
% retrieves the number of valid plays
countValidMoves(Board, Count) :-
  valid_moves(Board, ListOfMoves),
  length(ListOfMoves, Count).

% playPiece(+Board, +X, +Y, +Color, -NewBoard)
% plays the in X and Y the Color in the given board returning the resulting board (NewBoard)
playPiece(Board, X, Y, Color, NewBoard) :-
  getPiece(Board,X,Y,emptyCell),
  setPiece(Board, X, Y, Color, NewBoard). 


% move(+Move, +Board, -NewBoard) 
% makes the specified move in the specified board returning the resulting board (NewBoard)
move(Move, Board, NewBoard) :-
  read_move(Move, X,Y, Color),
  playPiece(Board, X, Y, Color,NewBoard).

% read_info(-Letter, -Number, -Color)
% retrieves/reads the Letter, Number and Color information from the user's input
read_info(Letter, Number, Color) :-
  write('LetterNumber: '),
  new_read(Play),
  atom_chars(Play, Option),
  parseOption(Option, Letter, Number),
  write('color: '),
  new_read(TmpColor), 
  translate(TmpColor, Color).

% parseOption(+List, -L, -N)
% reads a play in the format LetterNumber from the user
% checks if Letter is a letter and Number is a number
parseOption(List, L, N) :-
  length(List, 2),
  nth0(0, List, L),
  atom(L),
  nth0(1, List, TmpAtom),
  atom(TmpAtom),
  atom_chars(TmpAtom, TmpChar),
  number_chars(N, TmpChar),
  number(N).

% new_read(-Color)
% reads one character at the time 
% ends when a newline is found returning the whole word in Color
new_read(Color) :-
  new_read('', Color), !.

% new_read(+Acc, -Color)
% reads one character at the time 
% ends when a newline is found
new_read(Acc, Color) :-
  get_char(Char),
  processChar(Char, Acc, Color).

% processChar(+Char, -Acc, -Color)
% reads one character at the time and adds it to Acc
% ends when a newline is found
processChar('\n', Acc, Acc).
processChar(Char, Acc, Color) :-
  atom_concat(Acc, Char, Res),
  new_read(Res, Color).

% translate (+ToTranslate, -Translated)
% obtains the accurate correspondent of ToTranslate
% used to facilitate the user's input for the color
translate(b, blackPiece).
translate(w, whitePiece).
translate(b, black).
translate(w, white).
translate(black, blackPiece).
translate(white, whitePiece).
translate(_C, _C).

% validate_info_Color(+Color)
% validates the specified color
% is true if the color is blackPiece or whitePiece
validate_info_Color(blackPiece).
validate_info_Color(whitePiece).

% validate_info_coords(+Board, +X, +Y)
% validates X and Y is the given Board
% is true if there ia a cell with coordinates X and Y
validate_info_coords(Board,X,Y) :-
  getPiece(Board,X,Y,_). %is valid

% validate_info(+Board, +X, +Y, +Color)
% validates the received X, Y and Color
validate_info(Board,X,Y,Color) :-
  validate_info_coords(Board,X,Y),
  validate_info_Color(Color).

% read_validate_info(+Board,-X, -Y, -Color)
% reads the information from the user in the format LetterNumber and Color,
% converts the information to the coordinates used and validates them and the color
read_validate_info(Board,X,Y,Color) :-
  read_info(Letter,Number,Color),
  userToCoords(Board, Letter, Number, X, Y),
  validate_info(Board,X,Y,Color).

read_validate_info(Board,X,Y,Color) :-
  printInvalidInformation,
  read_validate_info(Board,X,Y,Color).

% checkCellNeighborsCount(+Board, +X, +Y, +Color, +Value, +[(X,Y, Color)])
% checks if the specified cell (represented by X,Y and Color) has Value number of neighbors of the color Color
checkCellNeighborsCount(Board,X,Y,Color, Value,[(X,Y, Color)]) :-
  countCellNeighbors(Board,X,Y,Color,Value), !.

checkCellNeighborsCount(_Board,_X,_Y,_Color,_Value,[]).

% check_game_neighbors_value(+Board,+ListOfCells,+Player_Color, +Value, +Cells, -C) 
% checks for the ListOfCells list (in format [cell(X,Y,Player_Color)| T]), if there is any cell with
% Value number of neighbors
check_game_neighbors_value(_Board,_L,_Player_Color,_Value ,Cells, Cells) :-
  length(Cells,1), !.

check_game_neighbors_value(_Board,[],_Player_Color,_Value ,_Cells, []) :- !.

check_game_neighbors_value(Board,[cell(X,Y,Player_Color)| T],Player_Color, Value, _Cells, C) :- 
  checkCellNeighborsCount(Board,X,Y,Player_Color,Value,Res),
  check_game_neighbors_value(Board,T, Player_Color,Value, Res, C).

check_game_neighbors_value(Board,[cell(_X,_Y,_Color)| T], Player_Color,Value, Cells, C) :- 
  check_game_neighbors_value(Board,T,Player_Color, Value, Cells, C).


% value(+Board,-Value)
% evaluates the specified board state
% if one of the players wins the game then the Value is that player's id 
% if there are no more valid moves in the board, Value is -1
% otherwise Value is 0
value(Board,-1) :-
  countValidMoves(Board,0).

value(Board,Value) :-
  player(Value, Color, 1,_),
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,1).

value(Board,Value) :-
  player(PlayerId, Color, 1,_),
  check_game_neighbors_value(Board, Board, Color, 3, [], LoserList),
  length(LoserList,1),
  getOppositePlayer(PlayerId,Value).

value(Board,Value) :-
  player(Value, Color, 0,_),
  check_game_neighbors_value(Board, Board, Color, 4, [], WinnerList),
  length(WinnerList,1).

value(_Board,0).


% game_over(+Board, -Winner)
% checks if the game is over
% if one of the players wins the game then the Winner value is that player's id 
% if the game ends in a draw then the Winner value is -1
% if the game has not ended yet, Winner is 0
game_over(Board,Winner) :-
  value(Board,Winner).

% getInfo(+Board,+Lvl, -X, -Y, -Color) 
% gets the X,Y and Color values according to the current player bot value
getInfo(Board,_Lvl, X,Y,Color) :-
  getCurrentPlayerBot(0),
  read_validate_info(Board,X,Y,Color).

getInfo(Board,Lvl, X,Y,Color) :-
  getCurrentPlayerBot(1),
  choose_move(Board, Lvl, X, Y, Color).

% play_game_loop(+Board, +Lvl, +Winner)
% implements the game loop
% the game loop ends where one of the players wins or a draw occurs
play_game_loop(Board,_Lvl, 1) :-
  display_game_winner(Board, 1), !.

play_game_loop(Board,_Lvl, 2) :-
  display_game_winner(Board, 2), !.

play_game_loop(Board,_Lvl, -1) :-
  display_game_winner(Board, -1), !.

play_game_loop(Board,Lvl,Winner) :-
  countValidMoves(Board, 0),
  switchCurrentPlayer,
  printIsImpossiblePlay,
  play_game_loop(Board, Lvl,Winner).

play_game_loop(Board,Lvl,_Winner) :-
  getCurrentPlayer(Player),
  display_game(Board,Player), !,
  getInfo(Board,Lvl, X,Y,Color),
  play(Board,X,Y,Color,NewBoard,NewWinner),
  play_game_loop(NewBoard,Lvl,NewWinner).

% play(+Board,+X,+Y,+Color,-NewBoard,-Winner) 
% executes a play if possible
play(Board,X,Y,Color,NewBoard,Winner) :-
 valid_moves(Board,ListOfMoves),
 member((X,Y,Color), ListOfMoves),
 create_move(X,Y,Color, Move),
 move(Move, Board,NewBoard), 
 game_over(NewBoard, Winner),
 switchCurrentPlayer.

play(Board,_,_,_,NewBoard,Winner) :-
  printInvalidPlay,
  NewBoard = Board,
  Winner = 0.

% create_move(X,Y,Color, Move)
% creates a move (list [X,Y,Color]) with the X,Y and Color values received
create_move(X,Y,Color, [X,Y,Color]).

% read_move(Move, X, Y, Color)
% retrieves the X,Y,and Color values from the move (list [X,Y,Color]) received 
read_move([X,Y,Color], X, Y, Color).


% play_game_PvP
% plays the game in the 'Player vs Player' mode
% both players are initalized as humans (not bots)
play_game_PvP :-
  initial_board(Board),
  assertPlayers_PvP, %initializes the players
  play_game_loop(Board,1,0).

% play_game_PvC
% plays the game in the 'Player vs Computer' mode
% the first player is initalizesd as a human (not bot) and the second player is initalized as a bot
play_game_PvC(Lvl) :-
  initial_board(Board),
  assertPlayers_PvC, %initializes the players
  play_game_loop(Board,Lvl,0).

% play_game_CvP
% plays the game in the 'Computer vs Player' mode
% the first player is initalizes as bot and the second player is initalized as a human (not bot)
play_game_CvP(Lvl) :-
  initial_board(Board),
  assertPlayers_CvP, %initializes the players
  play_game_loop(Board,Lvl,0).

% play_game_CvC
% plays the game in the 'Computer vs Computer'
% both players are initalized as bots
play_game_CvC(Lvl) :-
  initial_board(Board),
  assertPlayers_CvC, %initializes the players
  play_game_loop(Board,Lvl,0). 


% findAllColorOcpCells(+Board, +Color, -Res)
% finds all the occupied cells of a given color in the specified board
findAllColorOcpCells(Board, Color, Res) :-
  findall((FX,FY),
  (
  member(cell(FX,FY,Color), Board)
  ),
  Res).

% findAllOcpCells(+Board,-Res)
% finds all the occupied cells in the specified board
findAllOcpCells(Board, Res) :-
  findAllColorOcpCells(Board, blackPiece, BP),
  findAllColorOcpCells(Board, whitePiece, WP),
  append(BP,WP,Res).

% findFirstEmptyCellNeighbors(+Board,+X,+Y,-Res)
% finds a cell first empty neighbors 
findFirstEmptyCellNeighbors(Board,X,Y,Res) :-
  findFirstNeighbors(Board,X,Y,emptyCell,[],Res).

% findFirstEmptyCellNeighborsList(+Board,+ListOfCells,+TmpRes,-Res)
% finds a list of cells first neighbors that are empty
% the list of cells comes in the format [(X,Y)|T], being X and Y the cell coordinates
findFirstEmptyCellNeighborsList(_Board,[],TmpRes,TmpRes).

findFirstEmptyCellNeighborsList(Board,[(X,Y)|T],TmpRes,Res) :-
  findFirstEmptyCellNeighbors(Board,X,Y,EmpN),
  append(TmpRes,EmpN,NewTmpRes),
  sort(NewTmpRes,NTR),
  findFirstEmptyCellNeighborsList(Board,T,NTR,Res).



  

