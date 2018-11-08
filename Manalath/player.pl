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

assertPlayers_CvC :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,0,1)), %player 1 is a bot
    asserta(player(2, whitePiece,0,0,1)). %player 2 is a bot

getPlayer(PlayerId,Color, Current,Value, Bot) :-
    player(PlayerId, Color,Current, Value, Bot).

getPlayerColor(PlayerId, Color) :-
    player(Player, Color, _, _, _).
    
getCurrentPlayer(Player) :-
    getPlayer(Player,_,1,_,_).

getCurrentPlayerColor(Color) :-
    getPlayer(_,Color,1,_,_).

getCurrentPlayerBot(Bot) :-
    getPlayer(_,_,1,_,Bot).

%checkCurrentColorPlayer(PlayerId):-
%    getPlayer(PlayerId,PlayerColor,_C,CurrentColor,_,_),
%    CurrentColor = PlayerColor.

%getCurrentPlayerCurrentColor(CurrentColor):-
%    getPlayer(_,_,1,CurrentColor,_,_).

getCurrentPlayerValue(Value):-
    getPlayer(_,_,1,Value,_).

%setCurrentColor(Player, CurrentColor) :-
%    getPlayer(Player, Color,Current, _,Value,Bot),
%    retract(player(Player,Color,Current, _,Value,Bot)),
%    asserta(player(Player, Color,Current, CurrentColor,Value,Bot)).

setPlayerValue(Player, Value) :-
    getPlayer(Player, Color,Current,_,Bot),
    retract(player(Player,Color,Current,_,Bot)),
    asserta(player(Player, Color,Current,Value,Bot)).

setCurrentPlayer(Player) :-
    getPlayer(Player, Color,_, Value,Bot),
    retract(player(Player,Color,0, Value,Bot)),
    asserta(player(Player, Color,1, Value,Bot)).

removeCurrentPlayer(Player) :-
    getPlayer(Player, Color,_, Value,Bot),
    retract(player(Player,Color,1, Value,Bot)),
    asserta(player(Player, Color,0, Value,Bot)).

getNewCurrentPlayer(CurrentPlayer, NewCurrentPlayer) :-
    CurrentPlayer = 1,
    NewCurrentPlayer = 2.

getNewCurrentPlayer(CurrentPlayer, NewCurrentPlayer) :-
    CurrentPlayer = 2,
    NewCurrentPlayer = 1.  

switchPlayer :-
    getCurrentPlayer(CurrentPlayer),
    getNewCurrentPlayer(CurrentPlayer, NewCurrentPlayer),
    removeCurrentPlayer(CurrentPlayer),
    setCurrentPlayer(NewCurrentPlayer).

switchCurrentPlayer :-
    getCurrentPlayerValue(ValidPlay),
    switchCurrentPlayer(ValidPlay).

switchCurrentPlayer(ValidPlay) :-
    ValidPlay = 2, %if it is a valid play the current player switches
    switchPlayer.

switchCurrentPlayer(ValidPlay) :-
    ValidPlay = -1. %if it is not a valid play the current player stays the same

switchCurrentPlayer(ValidPlay) :-
    ValidPlay = -2,  
    switchPlayer.

getOppositePlayer(PlayerId, OpPlayerId) :-
    PlayerId = 1 -> OpPlayerId = 2;
    PlayerId = 2 -> OpPlayerId = 1.

getOppositeColor(Color, OpColor) :-
    Color = whitePiece -> OpColor = blackPiece;
    Color = blackPiece -> OpColor = whitePiece.

print_player(Player) :-
    write('Player : '),
    write(Player),
    nl.