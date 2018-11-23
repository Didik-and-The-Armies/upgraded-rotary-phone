/* DEKLARASI RULE DYNAMIC DISINI */

/*MAP*/
:- dynamic(tile/3). %%tile berisi koordinat point(X,Y) dan isi tilenya
/*PLAYER*/
:- dynamic(player_position/2).
/*DETAILS*/ %%nyawa,duit,waktu,dan lain lain
:- dynamic(time/1).


/*DEKLARASI BESAR MAP*/


/*MAP AWAL*/


/*WAKTU*/ %%buat set safezone entar
time(0).

%%Load Map Tiles X = Baris Y = Kolom
print_map(12,12) :- nl,!.
print_map(X,12) :- !, nl , NextRow is X+1, print_map(NextRow,0).
print_map(X,Y) :- player_position(X,Y), ! , write('P '),NextCol is Y + 1,print_map(X, NextCol).
print_map(X,Y) :- tile(X,Y,Tile), (Tile == 'X' -> !,  write('X ') ; Tile == '-'-> !, write('- ')), NextCol is Y + 1, print_map(X, NextCol).

load_map(_,_,[]) :- !.
load_map(X,Y,[Head|Tail]) :- asserta(tile(X,Y,Head)), Y1 is Y + 1, load_map(X,Y1,Tail), ! .


initial_map_r0 :-  load_map(0,0,['X','X','X','X','X','X','X','X','X','X','X','X']).
initial_map_r1 :-  load_map(1,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r2 :-  load_map(2,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r3 :-  load_map(3,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r4 :-  load_map(4,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r5 :-  load_map(5,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r6 :-  load_map(6,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r7 :-  load_map(7,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r8 :-  load_map(8,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r9 :-  load_map(9,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r10 :- load_map(10,0,['X','-','-','-','-','-','-','-','-','-','-','X']).
initial_map_r11 :- load_map(11,0,['X','X','X','X','X','X','X','X','X','X','X','X']).


load_map :- initial_map_r0,
            initial_map_r1,
            initial_map_r2,
            initial_map_r3,
            initial_map_r4,
            initial_map_r5,
            initial_map_r6,
            initial_map_r7,
            initial_map_r8,
            initial_map_r9,
            initial_map_r10,
            initial_map_r11.



update_dead_zone :- time(X), mod(X, 5) =:= 0 , X >= 5 , Res is div(X, 5), ! ,tile(Row,Col,_), update_limit_dead_zone(Row,Col,Res). %karena mulai dari 0
update_dead_zone :- !.


update_limit_dead_zone(Row,Col,Res) :- Row == Res, retract(tile(Row,Col,_)),assert(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Row == 11-Res, retract(tile(Row,Col,_)),assert(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Col == Res, retract(tile(Row,Col,_)),assert(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Col == 11-Res, retract(tile(Row,Col,_)),assert(tile(Row,Col,'X')).
update_limit_dead_zone :- !.

init_player :- assert(player_position(5,5)).

move_player(Direction) :-   Direction == 'n' -> !, player_position(Row,Col), Row1 is Row-1, retractall(player_position(_,_)), asserta(player_position(Row1,Col)).
move_player(Direction) :-   Direction == 's' -> !, player_position(Row,Col), Row1 is Row+1, retractall(player_position(_,_)), asserta(player_position(Row1,Col)).
move_player(Direction) :-   Direction == 'e' -> !, player_position(Row,Col), Col1 is Col+1, retractall(player_position(_,_)), asserta(player_position(Row,Col1)).
move_player(Direction) :-   Direction == 'w' -> !, player_position(Row,Col), Col1 is Col-1, retractall(player_position(_,_)), asserta(player_position(Row,Col1)).

n :-    time(X), X1 is X+1, retractall(time(_)), asserta(time(X1)),update_dead_zone, move_player(n),!,print_map(0,0).
s :-    time(X), X1 is X+1, retractall(time(_)), asserta(time(X1)),update_dead_zone, move_player(s),!,print_map(0,0).
e :-    time(X), X1 is X+1, retractall(time(_)), asserta(time(X1)),update_dead_zone, move_player(e),!,print_map(0,0).
w :-    time(X), X1 is X+1, retractall(time(_)), asserta(time(X1)),update_dead_zone, move_player(w),!,print_map(0,0).



start :-    load_map,
            init_player,
            print_map(0,0).

    


    
    
    




