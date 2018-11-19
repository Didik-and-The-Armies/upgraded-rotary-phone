
init :-
	assertz(health(100)),
	assertz(armor(0)),
	assertz(weapon(0)),
	assertz(inventory([ak47, p90])),
	assertz(map_list([[-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -], [-, -, -, -, -, -, -, -, -, -]])).

start :-
	write('    _/_/_/    _/    _/  _/_/_/      _/_/_/'),
	nl,
	write('   _/    _/  _/    _/  _/    _/  _/       '),
	nl,
	write('  _/_/_/    _/    _/  _/_/_/    _/  _/_/  '),
	nl,
	write(' _/        _/    _/  _/    _/  _/    _/   '),
	nl,
	write('_/          _/_/    _/_/_/      _/_/_/    '),
	nl,
	nl,
	write('Welcome to the battlefield!'),
	nl,
	write('You have been chosen as one of the lucky contestants. Be the last man standing and you will be remembered as one of the victors'),
	nl,
	nl,
	help,
	init,
	input.

help :-
	write('Available commands:'),
	nl,
	write('  start. -- start the game!'),
	nl,
	write('  help. -- show available commands'),
	nl,
	write('  quit. -- quit the game'),
	nl,
	write('  look. -- look around you'),
	nl,
	write('  n. s. e. w. -- move'),
	nl,
	write('  map. -- look at the map and detect enemies'),
	nl,
	write('  take(Object). -- pick up an object'),
	nl,
	write('  drop(Object), -- drop an object'),
	nl,
	write('  use(Object), -- use an object'),
	nl,
	write('  attack. -- attack enemy that crosses your path'),
	nl,
	write('  status. -- show your status'),
	nl,
	write('  save(Filename). -- save your game'),
	nl,
	write('  load(Filename). -- load previously saved game'),
	nl,
	nl,
	write('Legends:'),
	nl,
	write('W = weapon\tP = player'),
	nl,
	write('A = armor\tE = enemy'),
	nl,
	write('M = medicine\t- = accessible'),
	nl,
	write('O = ammo\tX = inaccessible'),
	nl,
	nl.

quit.

status :-
	health(A),
	armor(B),
	weapon(C),
	inventory(D),
	length(D, E),
	write('Health: '),
	write(A),
	nl,
	write('Armor: '),
	write(B),
	nl,
	write('Weapon: '),
	(   C =:= 0 ->
	    write('None')
	;   write(B)
	),
	nl,
	(   E =:= 0 ->
	    write('Your inventory is empty!')
	;   print_inventory(D), !
	),
	nl.

input :-
	write('> '),
	read(A),
	(   A == quit ->
	    quit
	;   A == start ->
	    start
	;   A == help ->
	    help,
	    input
	;   A == status ->
	    status,
	    input
	;   A == map ->
	    map,
	    input
	).

map :-
	map_list(A),
	write('XXXXXXXXXXXXXXXXXXXXXXX'),
	nl,
	print_map(A), !,
	write('XXXXXXXXXXXXXXXXXXXXXXX'),
	nl,
	nl.

print_inventory([]).
print_inventory([A|B]) :-
	write(A),
	nl,
	print_inventory(B).

print_map([]).
print_map([A|B]) :-
	format('X ~w ~w ~w ~w ~w ~w ~w ~w ~w ~w X~n', A),
	print_map(B).
