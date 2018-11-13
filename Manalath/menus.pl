:- ensure_loaded(game).

print_InvalidOption :-
    write('Invalid option! Please try again...').


firstMenu :-
    print_FirstMenu,
    read(Option),
    (
        Option = 1 -> playMenu;
        Option = 2;
        print_InvalidOption
    ),
    firstMenu.

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
        Option = 3 -> playCvPMenu;
        Option = 4 -> playCvCMenu;
        Option = 5 ->firstMenu;
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
    write('** 3- COMPUTER VS PLAYER    **'),nl,
    write('** 4- COMPUTER VS COMPUTER  **'),nl,
    write('** 5- GO BACK               **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.

playPvCMenu :-
    print_playPvCMenu,
    read(Option),
    (
        Option = 1 -> play_game_PvC(1);
        Option = 2 -> play_game_PvC(2);
        Option = 3 -> playMenu;
        print_InvalidOption
    ). 


playCvPMenu :-
    print_playCvPMenu,
    read(Option),
    (
        Option = 1 -> play_game_CvP(1);
        Option = 2 -> play_game_CvP(2);
        Option = 3 -> playMenu;
        print_InvalidOption
    ). 

playCvCMenu :-
    print_playCvCMenu,
    read(Option),
    (
        Option = 1 -> play_game_CvC(1);
        Option = 2 -> play_game_CvC(2);
        Option = 3 -> playMenu;
        print_InvalidOption
    ). 

print_playPvCMenu :-
    nl,
    write('******************************'),nl,
    write('**     PLAYER VS COMPUTER   **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- EASY                  **'),nl,
    write('** 2- HARD                  **'),nl,
    write('** 3- GO BACK               **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.

print_playCvPMenu :-
    nl,
    write('******************************'),nl,
    write('**     COMPUTER VS PLAYER   **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- EASY                  **'),nl,
    write('** 2- HARD                  **'),nl,
    write('** 3- GO BACK               **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.

print_playCvCMenu :-
    nl,
    write('******************************'),nl,
    write('**   COMPUTER VS COMPUTER   **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- EASY                  **'),nl,
    write('** 2- HARD                  **'),nl,
    write('** 3- GO BACK               **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.