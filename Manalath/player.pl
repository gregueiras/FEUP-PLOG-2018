player(1,blackPiece).
player(2,whitePiece).


getPlayer(PlayerId, PlayerColor) :-
    player(PlayerId, PlayerColor).

%nao sei se e necessaria, talvez nao
checkColorPlayer(PlayerId, Color):-
    getPlayer(PlayerId,PlayerColor),
    Color = PlayerColor.

switchCurrentPlayer(CurrentPlayer,NextPlayer) :-
    CurrentPlayer = 1,
    NextPlayer = 2.

switchCurrentPlayer(CurrentPlayer,NextPlayer) :-
    CurrentPlayer = 2,
    NextPlayer = 1.
