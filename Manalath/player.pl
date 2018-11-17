:-dynamic player/4.

%player(PlayerId, PlayerColor, CurrentlyPlaying, Bot)
player(1,blackPiece,1,0).
player(2,whitePiece,0,0).

% assertPlayers_PvP
% Removes all players from the database and adds two human players 
assertPlayers_PvP :-
    retractall(player(_,_,_,_)),
    asserta(player(1, blackPiece,1,0)),
    asserta(player(2, whitePiece,0,0)).

% assertPlayers_PvC
% Removes all players from the database and adds player 1 as a human player and player 2 as a computer controlled player 
assertPlayers_PvC :-
    retractall(player(_,_,_,_)),
    asserta(player(1, blackPiece,1,0)),
    asserta(player(2, whitePiece,0,1)). %player 2 is a bot

% assertPlayers_CvP
% Removes all players from the database and adds player 1 as a computer controlled player and player 2 as a human player
assertPlayers_CvP :-
    retractall(player(_,_,_,_)),
    asserta(player(1, blackPiece,1,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,0)). 

% assertPlayers_CvC
% Removes all players from the database and adds two computer controlled players 
assertPlayers_CvC :-
    retractall(player(_,_,_,_)),
    asserta(player(1, blackPiece,1,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,1)). %player 2 is a bot

% getPlayerColor(?PlayerId, ?Color)
% True if Color is the color of PlayerId
getPlayerColor(PlayerId, Color) :-
    player(PlayerId, Color, _, _).

% getCurrentPlayer(?Player)
% True if Player is the current player
getCurrentPlayer(Player) :-
    player(Player,_,1,_).


% getCurrentPlayerColor(?Color)
% True if Color is the current player color
getCurrentPlayerColor(Color) :-
    player(_,Color,1,_).

% getCurrentPlayerBot(?Bot)
% True if the bot value of the current player is Bot
getCurrentPlayerBot(Bot) :-
    player(_,_,1,Bot).


% setCurrentPlayer(+Player)
% Set the current player value to 1 of the player with id Player in the database
setCurrentPlayer(Player) :-
    player(Player, Color,_,Bot),
    retract(player(Player,Color,0,Bot)),
    asserta(player(Player, Color,1,Bot)).

% removeCurrentPlayer(+Player)
% Set the current player value to 0 of the player with id Player in the database
removeCurrentPlayer(Player) :-
    player(Player, Color,_,Bot),
    retract(player(Player,Color,1,Bot)),
    asserta(player(Player, Color,0,Bot)).

% getOppositePlayer(?P1, ?P2)
% True if P2 is the next player to play after P1
getOppositePlayer(1, 2).
getOppositePlayer(2, 1).

% getOppositeColor(?C1, ?C2)
% True if C2 is the opposite color of C1
getOppositeColor(whitePiece, blackPiece).
getOppositeColor(blackPiece, whitePiece).

% switchCurrentPlayer
% switch to the next player
switchCurrentPlayer :-
    getCurrentPlayer(CurrentPlayer),
    getOppositePlayer(CurrentPlayer, NewCurrentPlayer),
    removeCurrentPlayer(CurrentPlayer),
    setCurrentPlayer(NewCurrentPlayer).

% print_player(+Player)
% Prints the Player id and his color
print_player(Player) :-
    getPlayerColor(Player, Color),
    write('Player : '),
    write(Player), nl,
    write('color : '), 
    write(Color),
    nl.