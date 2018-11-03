:- ensure_loaded(gamePvP).
:- ensure_loaded(gamePvC).

print_InvalidOption :-
    write('Invalid option! Please try again...').


firstMenu :-
    print_FirstMenu,
    read(Option),
    (
        Option = 1 -> playMenu;
        Option = 2;
        print_InvalidOption
    ).

print_FirstMenu :-
    nl,
    write('******************************'),nl,
    write('**         MANALATH         **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- PLAY                  **'),nl,
    write('** 2- EXIT                  **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.

playMenu :-
    print_playMenu,
    read(Option),
    (
        Option = 1 -> play_game_PvP;
        Option = 2 -> playPvCMenu;
        Option = 3;
        Option = 4 ->firstMenu;
        print_InvalidOption
    ).

print_playMenu :-
    nl,
    write('******************************'),nl,
    write('**           PLAY           **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- PLAYER VS PLAYER      **'),nl,
    write('** 2- PLAYER VS COMPUTER    **'),nl,
    write('** 3- COMPUTER VS COMPUTER  **'),nl,
    write('** 4- GO BACK               **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.

playPvCMenu :-
    print_playPvCMenu,
    read(Option),
    (
        Option = 1 -> play_game_PvC;
        Option = 2 ;
        Option = 3;
        Option = 4 -> playMenu;
        print_InvalidOption
    ).

print_playPvCMenu :-
    nl,
    write('******************************'),nl,
    write('**     PLAYER VS COMPUTER   **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- EASY                  **'),nl,
    write('** 2- MEDIUM                **'),nl,
    write('** 3- HARD                  **'),nl,
    write('** 4- GO BACK               **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.