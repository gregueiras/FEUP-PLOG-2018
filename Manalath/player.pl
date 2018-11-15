:-dynamic player/5.

%player(PlayerId, PlayerColor, CurrentlyPlaying, Value, Bot)
player(1,blackPiece,1,0,0).
player(2,whitePiece,0,0,0).


assertPlayers_PvP :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,0)),
    asserta(player(2, whitePiece,0,0,0)).

assertPlayers_PvC :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,0)),
    asserta(player(2, whitePiece,0,0,1)). %player 2 is a bot

assertPlayers_CvP :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,0,0)). 

assertPlayers_CvC :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,0,1)). %player 2 is a bot

getPlayer(PlayerId,Color, Current,Value, Bot) :-
    player(PlayerId, Color,Current, Value, Bot).

getPlayerColor(PlayerId, Color) :-
    getPlayer(PlayerId, Color, _, _, _).

getCurrentPlayer(Player) :-
    getPlayer(Player,_,1,_,_).

getCurrentPlayerColor(Color) :-
    getPlayer(_,Color,1,_,_).

getCurrentPlayerBot(Bot) :-
    getPlayer(_,_,1,_,Bot).

getCurrentPlayerValue(Value):-
    getPlayer(_,_,1,Value,_).

setPlayerValue(Player, Value) :-
    getPlayer(Player, Color,Current,_,Bot),
    retract(player(Player,Color,Current,_,Bot)),
    asserta(player(Player, Color,Current,Value,Bot)).

setCurrentPlayer(Player) :-
    getPlayer(Player, Color,_, Value,Bot),
    retract(player(Player,Color,0, Value,Bot)),
    asserta(player(Player, Color,1, Value,Bot)).

removeCurrentPlayer(Player, Value) :-
    getPlayer(Player, Color,_,_,Bot),
    retract(player(Player,Color,1,_,Bot)),
    asserta(player(Player, Color,0, Value,Bot)).

getNewCurrentPlayer(1, 2).
getNewCurrentPlayer(2, 1).

switchPlayer(Value) :-
    getCurrentPlayer(CurrentPlayer),
    getNewCurrentPlayer(CurrentPlayer, NewCurrentPlayer),
    removeCurrentPlayer(CurrentPlayer, Value),
    setCurrentPlayer(NewCurrentPlayer).

% if it is a valid play the current player switches
switchCurrentPlayer(2) :-   
    switchPlayer(2).

% if it is not a valid play the current player stays the same
switchCurrentPlayer(-1) :-
    getCurrentPlayer(Player),
    setPlayerValue(Player, -1).
    
switchCurrentPlayer(-2) :- 
    switchPlayer(-2).

getOppositePlayer(1, 2).
getOppositePlayer(2, 1).

getOppositeColor(whitePiece, blackPiece).
getOppositeColor(blackPiece, whitePiece).

getPlayerColorById(Id, Color) :-
    player(Id, Color, _, _, _).

print_player(Player) :-
    getPlayerColor(Player, Color),
    write('Player : '),
    write(Player), nl,
    write('color : '), 
    write(Color),
    nl.