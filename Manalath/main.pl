:- ensure_loaded(menus).
:- use_module(library(random)).
:- use_module(library(system)).

initializeRandomSeed:-
	now(Usec), Seed is Usec mod 30269,
	getrand(random(X, Y, Z, _)),
	setrand(random(Seed, X, Y, Z)), !.

play :-
 % initializeRandomSeed,
  firstMenu.