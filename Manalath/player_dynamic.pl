:-dynamic player/4.

%player(PlayerId, PlayerColor, CurrentlyPlaying, CurrentColor)
player(1,blackPiece,1, blackPiece).
player(2,whitePiece,0, whitePiece).


assertPlayer :-
    retractall(player(_,_,_,_)),
    asserta(player(1, blackPiece,1,blackPiece)),
    asserta(player(2, whitePiece,0, whitePiece)).
    
getCurrentPlayer(Player) :-
    player(Player, _C,1, _P).

getPlayer(PlayerId,Color, Current,CurrentColor) :-
    player(PlayerId, Color,Current, CurrentColor).

checkCurrentColorPlayer(PlayerId):-
    getPlayer(PlayerId,PlayerColor,_C,CurrentColor ),
    CurrentColor = PlayerColor.

getCurrentPlayerCurrentColor(CurrentColor):-
    getPlayer(_,_,_,CurrentColor ).

setCurrentColor(Player, CurrentColor) :-
    getPlayer(Player, Color,Current, _P),
    retract(player(Player,Color,Current, _)),
    asserta(player(Player, Color,Current, CurrentColor)).

setCurrentPlayer(Player) :-
    getPlayer(Player, Color,_C, CurrentColor),
    retract(player(Player,Color,0, _)),
    asserta(player(Player, Color,1, CurrentColor)).

removeCurrentPlayer(Player) :-
    getPlayer(Player, Color,_C,CurrentColor),
    retract(player(Player,Color,1,_)),
    asserta(player(Player, Color,0, CurrentColor)).

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

switchCurrentPlayer(ValidPlay) :-
    ValidPlay = 0.
   %nothing happens, the game ends

switchCurrentPlayer(CurrentPlayer,NextPlayer,ValidPlay) :-
    ValidPlay = 1. %nothing happens, the game ends


getOppositePlayer(PlayerId, OpPlayerId) :-
    PlayerId = 1 -> OpPlayerId = 2;
    PlayerId = 2 -> OpPlayerId = 1.

print_player(Player) :-
    write('Player : '),
    write(Player),
    nl.