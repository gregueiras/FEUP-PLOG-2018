:-dynamic player/5.

%player(PlayerId, PlayerColor, CurrentlyPlaying, CurrentColor, HasPassed)
player(1,blackPiece,1, blackPiece,0).
player(2,whitePiece,0, whitePiece,0).


assertPlayer :-
    retractall(player(_,_,_,_,_)),
    asserta(player(1, blackPiece,1,blackPiece,0)),
    asserta(player(2, whitePiece,0, whitePiece,0)).

getPlayer(PlayerId,Color, Current,CurrentColor,HasPassed) :-
    player(PlayerId, Color,Current, CurrentColor, HasPassed).

getCurrentPlayer(Player) :-
    getPlayer(Player, _,1, _,_).

getCurrentPlayerColor(Color) :-
    getPlayer(_,Color,1, _,_).

checkCurrentColorPlayer(PlayerId):-
    getPlayer(PlayerId,PlayerColor,_C,CurrentColor,_),
    CurrentColor = PlayerColor.

getCurrentPlayerCurrentColor(CurrentColor):-
    getPlayer(_,_,_,CurrentColor,_).

setCurrentColor(Player, CurrentColor) :-
    getPlayer(Player, Color,Current, _,HasPassed),
    retract(player(Player,Color,Current, _,HasPassed)),
    asserta(player(Player, Color,Current, CurrentColor,HasPassed)).

setCurrentPlayer(Player) :-
    getPlayer(Player, Color,_, CurrentColor, HasPassed),
    retract(player(Player,Color,0, _, HasPassed)),
    asserta(player(Player, Color,1, CurrentColor, HasPassed)).

removeCurrentPlayer(Player) :-
    getPlayer(Player, Color,_,CurrentColor, HasPassed),
    retract(player(Player,Color,1,_, HasPassed)),
    asserta(player(Player, Color,0, CurrentColor, HasPassed)).

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
    switchPlayer, !.

switchCurrentPlayer(ValidPlay) :-
    ValidPlay = -1.  %if it is not a valid play the current player stays the same

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