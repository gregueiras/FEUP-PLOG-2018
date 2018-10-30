
:- ensure_loaded(main).

print_InvalidOption :-
    write('Invalid option! Please try again...').


firstMenu :-
    print_FirstMenu,
    get_char(Option),
    (
        Option = '1' -> playMenu;
        Option = '2';
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
    get_char(Option),
    (
        Option = '1' -> play_game;
        Option = '2';
        print_InvalidOption
    ).

print_playMenu :-
    nl,
    write('******************************'),nl,
    write('**           PLAY           **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** 1- PLAYER VS PLAYER      **'),nl,
    write('** 2- EXIT                  **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.