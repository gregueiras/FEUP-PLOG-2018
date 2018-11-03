:-dynamic player/6.

%player(PlayerId, PlayerColor, CurrentlyPlaying, CurrentColor, Value, Bot)
player(1,blackPiece,1, blackPiece,0,0).
player(2,whitePiece,0, whitePiece,0,0).


assertPlayers_PvP :-
    retractall(player(_,_,_,_,_,_)),
    asserta(player(1, blackPiece,1,blackPiece,0,0)),
    asserta(player(2, whitePiece,0, whitePiece,0,0)).

assertPlayers_PvC :-
    retractall(player(_,_,_,_,_,_)),
    asserta(player(1, blackPiece,1,blackPiece,0,0)),
    asserta(player(2, whitePiece,0, whitePiece,0,1)). %player 2 is a bot


getPlayer(PlayerId,Color, Current,CurrentColor,Value, Bot) :-
    player(PlayerId, Color,Current, CurrentColor, Value, Bot).

getCurrentPlayer(Player) :-
    getPlayer(Player,_,1,_,_,_).

getCurrentPlayerColor(Color) :-
    getPlayer(_,Color,1,_,_,_).

getCurrentPlayerBot(Bot) :-
    getPlayer(_,_,1,_,_,Bot).

checkCurrentColorPlayer(PlayerId):-
    getPlayer(PlayerId,PlayerColor,_C,CurrentColor,_,_),
    CurrentColor = PlayerColor.

getCurrentPlayerCurrentColor(CurrentColor):-
    getPlayer(_,_,1,CurrentColor,_,_).

getCurrentPlayerValue(Value):-
    getPlayer(_,_,1,_,Value,_).

setCurrentColor(Player, CurrentColor) :-
    getPlayer(Player, Color,Current, _,Value,Bot),
    retract(player(Player,Color,Current, _,Value,Bot)),
    asserta(player(Player, Color,Current, CurrentColor,Value,Bot)).

setValue(Player, Value) :-
    getPlayer(Player, Color,Current, CurrentColor,_,Bot),
    retract(player(Player,Color,Current,CurrentColor,_,Bot)),
    asserta(player(Player, Color,Current, CurrentColor,Value,Bot)).

setCurrentPlayer(Player) :-
    getPlayer(Player, Color,_, CurrentColor, Value,Bot),
    retract(player(Player,Color,0, CurrentColor, Value,Bot)),
    asserta(player(Player, Color,1, CurrentColor, Value,Bot)).

removeCurrentPlayer(Player) :-
    getPlayer(Player, Color,_,CurrentColor, Value,Bot),
    retract(player(Player,Color,1,CurrentColor, Value,Bot)),
    asserta(player(Player, Color,0, CurrentColor, Value,Bot)).

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

print_player(Player) :-
    write('Player : '),
    write(Player),
    nl.