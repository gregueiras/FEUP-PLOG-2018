:- ensure_loaded(game).

% print_InvalidOption
% Prints error message when an invalid option has been chosen
print_InvalidOption :-
    write('Invalid option! Please try again...').

% firstMenu
% Prints the initial menu and reads the user input
firstMenu :-
    print_FirstMenu,
    new_read(Option),
    firstMenu(Option).

firstMenu('1') :-
    playMenu,
    firstMenu.

firstMenu('2').

firstMenu(_) :-
    print_InvalidOption,
    firstMenu.

% print_FirstMenu
% 
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
    new_read(Option),
    playMenu(Option).

playMenu('1') :-
    play_game_PvP,
    playMenu.

playMenu('2') :-
    playPvCMenu,
    playMenu.
playMenu('3') :-
    playCvPMenu,
    playMenu.
playMenu('4') :-
    playCvCMenu,
    playMenu.
playMenu('5').
playMenu(_) :-
    print_InvalidOption,
    playMenu.

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
    new_read(Option),
    playPvCMenu(Option).

playPvCMenu('1') :-
    play_game_PvC(1).
playPvCMenu('2') :-
    play_game_PvC(2).
playPvCMenu('3').
playPvCMenu(_) :-
    print_InvalidOption,
    playPvCMenu.

playCvPMenu :-
    print_playCvPMenu,
    new_read(Option),
    playCvPMenu(Option).

playCvPMenu('1') :-
    play_game_CvP(1).
playCvPMenu('2') :-
    play_game_CvP(2).
playCvPMenu('3').
playCvPMenu(_) :-
    print_InvalidOption,
    playCvPMenu.

playCvCMenu :-
    print_playCvCMenu,
    new_read(Option),
    playCvCMenu(Option).

playCvCMenu('1') :-
    play_game_CvC(1).

playCvCMenu('2') :-
    play_game_CvC(2).

playCvCMenu('3').
playCvCMenu(_) :-
    print_InvalidOption,
    playCvCMenu.

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