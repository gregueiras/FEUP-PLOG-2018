:- ensure_loaded(solver).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                             Menus                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
  firstMenu :-
    print_FirstMenu,
    new_read(Option),
    firstMenu(Option).
  
  
  print_FirstMenu :-
    nl,
    write('******************************'),nl,
    write('**          DOORS           **'),nl,
    write('******************************'),nl,
    write('**                          **'),nl,
    write('** Board Size:              **'),nl,
    write('** 1- 8x8                   **'),nl,
    write('** 2- 16x16                 **'),nl,
    write('** 3- 24x24                 **'),nl,
    write('** 4- quit                  **'),nl,
    write('**                          **'),nl,
    write('******************************'),nl,
    write('Choose : '), nl.
  
  
  firstMenu('1') :-
    nl,
    generatorAndSolver(8),
    firstMenu.
  
  firstMenu('2') :-
    nl,
    generatorAndSolver(16),
    firstMenu.
  
  firstMenu('3') :-
    nl,
    generatorAndSolver(24),
    firstMenu.

  firstMenu('4').

  firstMenu(_) :-
    print_InvalidOption,
    firstMenu.