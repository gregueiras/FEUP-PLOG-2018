:- ensure_loaded(menus).
:- use_module(library(random)).
:- use_module(library(system)).

% initializeRandomSeed
% Initializes the random seed using current time 
initializeRandomSeed:-
	now(Time),
	Seed is Time mod 30269, % https://sicstus.sics.se/sicstus/docs/3.7.1/html/sicstus_23.html
	getrand(random(X, Y, Z, _)),
	setrand(random(Seed, X, Y, Z)), !.

% play
% Initializes the random seed and calls the first menu
play :-
  initializeRandomSeed,
  firstMenu.