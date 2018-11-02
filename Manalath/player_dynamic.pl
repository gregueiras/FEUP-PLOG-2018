:-dynamic player/3.

player(1,blackPiece,1).
player(2,whitePiece,0).


assertPlayer :-
    retractall(player(_,_,_)),
    asserta(player(1, blackPiece,1)),
    asserta(player(2, whitePiece,0)).
    

getCurrentPlayer(Player) :-
    player(Player, _C,1).

getPlayer(PlayerId,Color, Current) :-
    player(PlayerId, Color,Current).

checkColorPlayer(PlayerId, Color):-
    getPlayer(PlayerId,PlayerColor,_C),
    Color = PlayerColor.

setCurrentPlayer(Player) :-
    getPlayer(Player, Color,_C),
    retract(player(Player,Color,0)),
    asserta(player(Player, Color,1)).

removeCurrentPlayer(Player) :-
    getPlayer(Player, Color,_C),
    retract(player(Player,Color,1)),
    asserta(player(Player, Color,0)).

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

print_player(Player) :-
    write('Player : '),
    write(Player),
    nl.