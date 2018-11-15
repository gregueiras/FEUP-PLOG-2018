:-dynamic player/5.

%player(PlayerId, PlayerColor, CurrentlyPlaying, GameValue, Bot)
player(1,blackPiece,1,0,0).
player(2,whitePiece,0,0,0).

% assertPlayers_PvP
% Removes all players from the database and adds two human players 
assertPlayers_PvP :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,0)),
    asserta(player(2, whitePiece,0,0,0)).

% assertPlayers_PvC
% Removes all players from the database and adds player 1 as a human player and player 2 as a computer controlled player 
assertPlayers_PvC :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,0)),
    asserta(player(2, whitePiece,0,0,1)). %player 2 is a bot

% assertPlayers_CvP
% Removes all players from the database and adds player 1 as a computer controlled player and player 2 as a human player
assertPlayers_CvP :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,0,0)). 

% assertPlayers_CvC
% Removes all players from the database and adds two computer controlled players 
assertPlayers_CvC :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,0,1)). %player 2 is a bot

% getPlayerColor(?PlayerId, ?Color)
% True if Color is the color of PlayerId
getPlayerColor(PlayerId, Color) :-
    player(PlayerId, Color, _, _, _).

% getCurrentPlayer(?Player)
% True if Player is the current player
getCurrentPlayer(Player) :-
    player(Player,_,1,_,_).


% getCurrentPlayerColor(?Color)
% True if Color is the current player color
getCurrentPlayerColor(Color) :-
    player(_,Color,1,_,_).

% getCurrentPlayerBot(?Bot)
% True if the bot value of the current player is Bot
getCurrentPlayerBot(Bot) :-
    player(_,_,1,_,Bot).

% getCurrentPlayerValue(?Value)
% True if Value is the current player value
getCurrentPlayerValue(Value):-
    player(_,_,1,Value,_).

% setPlayerValue(+Player, +Value)
% Set the current game value to Value of the player with id Player in the database
setPlayerValue(Player, Value) :-
    player(Player, Color,Current,_,Bot),
    retract(player(Player,Color,Current,_,Bot)),
    asserta(player(Player, Color,Current,Value,Bot)).

% setCurrentPlayer(+Player)
% Set the current player value to 1 of the player with id Player in the database
setCurrentPlayer(Player) :-
    player(Player, Color,_, Value,Bot),
    retract(player(Player,Color,0, Value,Bot)),
    asserta(player(Player, Color,1, Value,Bot)).

% removeCurrentPlayer(+Player, +Value)
% Set the current player value to 0 and his game value to Value of the player with id Player in the database
removeCurrentPlayer(Player, Value) :-
    player(Player, Color,_,_,Bot),
    retract(player(Player,Color,1,_,Bot)),
    asserta(player(Player, Color,0, Value,Bot)).

% getOppositePlayer(?P1, ?P2)
% True if P2 is the next player to play after P1
getOppositePlayer(1, 2).
getOppositePlayer(2, 1).

% getOppositeColor(?C1, ?C2)
% True if C2 is the opposite color of C1
getOppositeColor(whitePiece, blackPiece).
getOppositeColor(blackPiece, whitePiece).

% switchPlayer(+Value)
% Set the game value of the current player and switch to the next one 
switchPlayer(Value) :-
    getCurrentPlayer(CurrentPlayer),
    getOppositePlayer(CurrentPlayer, NewCurrentPlayer),
    removeCurrentPlayer(CurrentPlayer, Value),
    setCurrentPlayer(NewCurrentPlayer).

% switchCurrentPlayer(+Value)
% True if it is a valid play and switches the current player to the next one
switchCurrentPlayer(2) :-   
    switchPlayer(2).

% True if it is not a valid play and the current player stays the same
switchCurrentPlayer(-1) :-
    getCurrentPlayer(Player),
    setPlayerValue(Player, -1).

% True if current Player skipped and switches the current player to the next one
switchCurrentPlayer(-2) :- 
    switchPlayer(-2).

% print_player(+Player)
% Prints the Player id and his color
print_player(Player) :-
    getPlayerColor(Player, Color),
    write('Player : '),
    write(Player), nl,
    write('color : '), 
    write(Color),
    nl.