player(1,blackPiece).
player(2,whitePiece).


getPlayer(PlayerId, PlayerColor) :-
    player(PlayerId, PlayerColor).

checkColorPlayer(PlayerId, Color):-
    getPlayer(PlayerId,PlayerColor),
    Color = PlayerColor.

switchPlayer(CurrentPlayer,NextPlayer) :-
    CurrentPlayer = 1,
    NextPlayer = 2.

switchPlayer(CurrentPlayer,NextPlayer) :-
    CurrentPlayer = 2,
    NextPlayer = 1.

switchCurrentPlayer(CurrentPlayer,NextPlayer,ValidPlay) :-
    ValidPlay = 2, %if it is a valid play the current player switches
    switchPlayer(CurrentPlayer,NextPlayer).

switchCurrentPlayer(CurrentPlayer,NextPlayer,ValidPlay) :-
    ValidPlay = -1,  %if it is not a valid play the current player stays the same
    NextPlayer = CurrentPlayer.

switchCurrentPlayer(CurrentPlayer,NextPlayer,ValidPlay) :-
    ValidPlay = 0; ValidPlay = 1.  %nothing happens, the game ends