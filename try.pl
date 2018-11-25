/* DEKLARASI RULE DYNAMIC DISINI */

/*MAP*/
:- dynamic(tile/3). %%tile berisi koordinat point(X,Y) dan isi tilenya

/*PLAYER*/
:- dynamic(player_position/2).
:- dynamic(player_total_health/1). %original health + armor_health
:- dynamic(player_original_health/1).
:- dynamic(player_armor_health/1). %health yang di equip , 0 kalo gaada
:- dynamic(player_equipped_armor/1). 
:- dynamic(player_equipped_weapon/2). %Nama dan sisa peluru
:- dynamic(player_inventory/2).
/* Keterangan : */
%player_inventory(<weapon_name>,<weapon_ammo>)
%player_inventory(<armor_name>,<armor_remaining_health>)
%player_inventory(<medicine_name>,<medicine_healing_capacity>)
%player_inventory(<ammo>,<weapon_ammo>) peluru itu universal
:- dynamic(current_inventory/1).
:- dynamic(max_inventory/1).


:- dynamic(enemy_position/2).
:- dynamic(enemy_inventory/4). 
:- dynamic(enemy_equipped_weapon/4). %posisi,Nama dan sisa peluru

:- dynamic(temp_enemy_position/2).
:- dynamic(temp_enemy_inventory/4). 
:- dynamic(temp_enemy_equipped_weapon/4). %posisi,Nama dan sisa peluru
%Musuh sekali attack langsung modar sementara, dan gapake armor
:- dynamic(item_details/4). %Koordinat baris kolom, nama item sama isinya 

/*DETAILS*/ %%nyawa,duit,waktu,dan lain lain
:- dynamic(time/1).


/*ITEM YANG ADA PADA GAME */ %Kalo mau nambah item procedure generate_items yang dibawah juga harus dirubah
%Weapon
item(m416,weapon,1).
item(scar,weapon,2).
item(akm,weapon,3).
item(ump9,weapon,4).
item(shotgun,weapon,5).
item(sks,weapon,6).
item(pistol,weapon,7).
item(sniper,weapon,8).
item(bazooka,weapon,9).
item(grenade,weapon,10).

item(helm,armor,11).
item(kevlar,armor,12).
item(spetnaz,armor,13).

item(bandage,medicine,14).
item(medkit,medicine,15).
item(penicilin,medicine,16).
item(painkiller,medicine,17).
item(tolakangin,medicine,18).
item(madurasa,medicine,19).

item(magazine,ammo,20).
item(bulletpack,ammo,21).

item(ransel,bag,22).
item(bagpack,bag,23).
item(carrier,bag,24).



damage(m416,30).
damage(scar,35).
damage(akm,30).
damage(ump9,25).
damage(shotgun,40).
damage(sks,25).
damage(pistol,15).
damage(sniper,80).
damage(bazooka,99).
damage(grenade,70).

value(m416,3). %1
value(scar,3). %2
value(akm,3). %3
value(ump9,5). %4
value(shotgun,2). %5
value(sks,4). %6
value(pistol,8). %7
value(sniper,3). %8
value(bazooka,1). %9
value(grenade,1). %10


value(helm,10). %11
value(kevlar,20).%12
value(spetnaz,40).%13

value(bandage,15).%14
value(medkit,30).%15
value(penicilin,20).%16
value(painkiller,10).%17
value(tolakangin,50).%18
value(madurasa,25).%19


value(magazine,2).%20
value(bulletpack,1).%21

value(ransel,5).%22
value(bagpack,8).%23
value(carrier,10).%24

%%Mencetak full map
print_map(12,0) :- nl,nl,!.
print_map(X,12) :- nl , nl,  NextRow is X+1,!, print_map(NextRow,0).
print_map(X,Y) :- tile(X,Y,Tile), print_map_tile(X,Y,Tile), NextCol is Y + 1,!, print_map(X, NextCol).

print_tile(_,_,X) :- X == 'x', ! ,  write('  x  ').
print_tile(Row,Col,_) :- player_position(Row,Col), ! , write('  P  ').
print_tile(Row,Col,_) :- enemy_position(Row,Col), ! , write('  E  ').
print_tile(Row,Col,_) :- (  item_details(Row,Col,Item,_) ->   
                                (   item(Item,weapon,_) -> write('  W  ');
                                    item(Item,armor,_) -> write('  A  ');
                                    item(Item,medicine,_) -> write('  M  ');
                                    item(Item,ammo,_) -> write('  O  ');
                                    item(Item,bag,_) -> write('  B  ')
                                );
                            write('  _  ')
                         ). 

/*BUAT PRINT PETA, ICONNYA GAK BOLEH KELIATAN*/
print_map_tile(Row,Col,_)   :- player_position(Row,Col), !, write('  P  ').  
print_map_tile(_,_,Tile)    :- Tile == 'x', ! ,  write('  x  ').
print_map_tile(_,_,_)       :- write('  _  '),!.
                        

load_map(_,_,[]) :- !.
load_map(X,Y,[Head|Tail]) :- assertz(tile(X,Y,Head)), Y1 is Y + 1, load_map(X,Y1,Tail), ! .


initial_map_r0 :-  load_map(0,0,['x','x','x','x','x','x','x','x','x','x','x','x']).
initial_map_r1 :-  load_map(1,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r2 :-  load_map(2,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r3 :-  load_map(3,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r4 :-  load_map(4,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r5 :-  load_map(5,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r6 :-  load_map(6,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r7 :-  load_map(7,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r8 :-  load_map(8,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r9 :-  load_map(9,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r10 :- load_map(10,0,['x','o','o','o','o','o','o','o','o','o','o','x']).
initial_map_r11 :- load_map(11,0,['x','x','x','x','x','x','x','x','x','x','x','x']).


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



update_dead_zone :- time(X), mod(X, 7) =:= 0 , Res is div(X, 7) ,!, forall(tile(Row,Col,_), update_limit_dead_zone(Row,Col,Res)),!,nl,nl,write('The storm is coming...'),nl,nl. %karena mulai dari 0
update_dead_zone :- !.



update_limit_dead_zone(Row,Col,Res) :- Row == Res, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'x')).
update_limit_dead_zone(Row,Col,Res) :- Temp is 11 - Res,Row == Temp, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'x')).
update_limit_dead_zone(Row,Col,Res) :- Col == Res, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'x')).
update_limit_dead_zone(Row,Col,Res) :- Temp is 11 - Res,Col == Temp, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'x')).
update_limit_dead_zone(_,_,_) :- !.


move_player(Direction) :-   Direction == 'n' -> !, is_enemy_attack,player_position(Row,Col), Row1 is Row-1, retractall(player_position(_,_)), assertz(player_position(Row1,Col)), is_in_dead_zone.
move_player(Direction) :-   Direction == 's' -> !, is_enemy_attack,player_position(Row,Col), Row1 is Row+1, retractall(player_position(_,_)), assertz(player_position(Row1,Col)), is_in_dead_zone.
move_player(Direction) :-   Direction == 'e' -> !, is_enemy_attack,player_position(Row,Col), Col1 is Col+1, retractall(player_position(_,_)), assertz(player_position(Row,Col1)), is_in_dead_zone.
move_player(Direction) :-   Direction == 'w' -> !, is_enemy_attack,player_position(Row,Col), Col1 is Col-1, retractall(player_position(_,_)), assertz(player_position(Row,Col1)), is_in_dead_zone.



/*DAFTAR IMPLEMENTASI COMMAND YANG DIINPUT PEMAIN*/
start :-    /*shell(clear),*/
            show_title,
            write('What do you wanna do ? [new/load/quit] \n'),
			read(Command),
			(
				Command == 'load' -> write('Input the file name\nFilename : '),nl ,read(FileName) , load_facts(FileName), nl, nl, help
			   ;Command == 'new' -> initiliaze_game, nl, nl
			   ;Command == 'quit' -> quit
			).

n :-    /*shell(clear),*/update_time,update_dead_zone, move_player(n),move_enemies,!, delete_enemies_in_dead_zone,add_random_supply,look_nsew,check_game_over.
s :-    /*shell(clear),*/update_time,update_dead_zone, move_player(s),move_enemies,!, delete_enemies_in_dead_zone,add_random_supply,look_nsew,check_game_over.
e :-    /*shell(clear),*/update_time,update_dead_zone, move_player(e),move_enemies,!, delete_enemies_in_dead_zone,add_random_supply,look_nsew,check_game_over.
w :-    /*shell(clear),*/update_time,update_dead_zone, move_player(w),move_enemies,!, delete_enemies_in_dead_zone,add_random_supply,look_nsew,check_game_over.

map:-  shell(clear),print_map(0,0),!.

look :- shell(clear),
        player_position(Row,Col),
        A is Row-1,
        B is Row+1,
        C is Col-1,
        D is Col+1,
        nl,
        tile(A,C,Tile1),print_tile(A,C,Tile1),
        tile(A,Col,Tile2),print_tile(A,Col,Tile2),
        tile(A,D,Tile3),print_tile(A,D,Tile3),nl,nl,
        tile(Row,C,Tile4),print_tile(Row,C,Tile4),
        tile(Row,Col,Tile5),print_tile(Row, Col, Tile5),
        tile(Row,D,Tile6),print_tile(Row, D, Tile6),nl,nl,
        tile(B,C,Tile7),print_tile(B, C, Tile7),
        tile(B,Col,Tile8),print_tile(B, Col, Tile8),
        tile(B,D,Tile9),print_tile(B, D, Tile9),nl,nl,
        /*BAGIAN PESAN*/
        write('You are in Pochinki..'),nl,!,
        look_item_around(A,C),
        look_item_around(A,Col),
        look_item_around(A,D),
        look_item_around(Row,C),
        look_item_around(Row,Col),
        look_item_around(Row,D),
        look_item_around(B,C),
        look_item_around(B,Col),
        look_item_around(B,D).
        
initiliaze_game :-    show_title,
            help,
            load_map,
            init_player,
            init_time,
            init_inventory,
            init_item,
            init_enemy,
            look_enemy.
    
help :-     %shell(clear),
            write('Available commands:'),
            nl,
            write('  initiliaze_game. -- initiliaze_game the game!'),
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

status :- %shell(clear),
           nl,
          show_health,nl,
          show_armor,nl,
          show_weapon,nl,
          show_ammo,
          show_inventory,nl,nl.

take(Item)  :-  player_position(X,Y),item_details(X,Y,Item,Val),
                current_inventory(S),max_inventory(M),
                S < M,!,
                retract(item_details(X,Y,Item,Val)),
                assertz(player_inventory(Item,Val)),
                S1 is S + 1,
                retractall(current_inventory(_)),
                assertz(current_inventory(S1)),!,look,nl,
                format('You take ~w.',[Item]).

take(_)     :-  current_inventory(S),max_inventory(M), S == M, !, write('Your inventory is full !'),nl.
take(Item)  :-  !,
                format('No ~w can be found.',[Item]),nl. 


drop(Item) :-  player_inventory(Item,Val),
               retract(player_inventory(Item,Val)),
               retract(current_inventory(X)),
               X1 is X - 1,
               assertz(current_inventory(X1)),
               player_position(Row,Col),
               assertz(item_details(Row,Col,Item,Val)),
               look,!,nl,
               format('~w has been dropped.',[Item]),nl.

drop(Item)  :-  !, nl,
                format('No ~w in your inventory.',[Item]),nl.


%Asumsi kalo ada barang yang lagi diequip langsung ditaro di inventory
use(Item)   :-  %shell(clear),
                player_inventory(Item,Val),!,
            (
                item(Item,armor,_)->
                    (player_equipped_armor(Armor)->
                                (retractall(player_equipped_armor(_)),
                                 player_armor_health(H),
                                 retractall(player_armor_health(_)),
                                 assertz(player_inventory(Armor,H)),
                                 current_inventory(X),
                                 retractall(current_inventory(_)),
                                 X1 is X + 1,
                                 assertz(current_inventory(X1))
                                );
                                %Kalo gaada armor yang lagi dipake
                                (true)

                    ),
                    player_total_health(H1),
                    retractall(player_armor_health(_)),
                    retractall(player_total_health(_)),
                    retract(player_inventory(Item,Val)),
                    assertz(player_equipped_armor(Item)),
                    assertz(player_armor_health(Val)),
                    TotalHealth is Val+H1,
                    assertz(player_total_health(TotalHealth)),
                    current_inventory(X2),
                    retractall(current_inventory(_)),
                    X3 is X2 - 1,
                    assertz(current_inventory(X3)),
                    status,
                    !,write(Item),write(' equipped.'),nl
                ;
                item(Item,weapon,_)->
                    (player_equipped_weapon(Weapon,Bullet)->
                                retractall(player_equipped_weapon(Weapon,Bullet)),
                                 assertz(player_inventory(Weapon,Bullet)),
                                 current_inventory(X),
                                 retractall(current_inventory(_)),
                                 X1 is X + 1,
                                 assertz(current_inventory(X1))
                                ;
                                %Kalo gaada weapon yang lagi dipake
                                (true)
                                
                    ),
                    retract(player_inventory(Item,Val)),
                    assertz(player_equipped_weapon(Item,Val)),
                    current_inventory(X2),
                    retractall(current_inventory(_)),
                    X3 is X2 - 1,
                    assertz(current_inventory(X3)),status,
                    !,write(Item),write(' equipped, ready to battle?'),nl
                ;
                item(Item,medicine,_)-> heal(Val),
                                      retract(player_inventory(Item,Val)),
                                      current_inventory(C),
                                      retractall(current_inventory(_)),
                                      C1 is C - 1,
                                      assertz(current_inventory(C1)), status, 
                                      !,write(Item),write(' used, now you feel better.'),nl
                ;
                item(Item,ammo,_) ->(
                                        retract(player_equipped_weapon(W,B))->
                                            B1 is B+Val,
                                            assertz(player_equipped_weapon(W,B1)),
                                            current_inventory(X),
                                            retractall(current_inventory(_)),
                                            X1 is X - 1,
                                            assertz(current_inventory(X1)),
                                            retract(player_inventory(Item,_)),
                                            status, 
                                            !,write(Item),write(' used, ready to some shooting?'),nl
                                        ;
                                            !, write('\nYou need to equip weapon first !\n')

                                    )
                ;
                item(Item,bag,_) -> value(Item,Capacity),
                                    retract(player_inventory(Item,_)),
                                    current_inventory(C),
                                    retractall(current_inventory(_)),
                                    C1 is C - 1,
                                    assertz(current_inventory(C1)),
                                    retractall(max_inventory(_)),
                                    assertz(max_inventory(Capacity)), status, 
                                    !,write(Item),write(' equipped, do you feel lighter or heavier ?'),nl
            ).
use(Item)   :- !, format('No ~w in your inventory.',[Item]),nl.


%Asumsi 1: semua musuh yang diserang langsung mati.
%Asumssi 2 : musuh harus bersenjata
attack :- combat, check_game_over.


save(X)   :-  save_facts(X).
%load(X)   :-  load_facts(X).

restart :- reset_game,initiliaze_game.
quit    :- write('Loading..\n'),sleep(2),
           write('See you next time soldier\n'),sleep(2),
           write('Exiting..\n'),sleep(2),
           show_credits_team,
           halt.

/*FUNGSI-FUNGSI DALAM GAME*/
update_time :- time(X), X1 is X+1, retractall(time(_)), assertz(time(X1)).

add_random_supply   :-  time(X),mod(X,5) =:= 0,
                        random(3,8,Row),random(3,8,Col),random(1,24,ItemCode),
                        item(Name,_,ItemCode),
                        value(Name,Value),
                        assertz(item_details(Row,Col,Name,Value)),
                        format('\n\nSupply Incoming !!\n\n',[]),!.
add_random_supply   :-  !.

is_in_dead_zone :- player_position(X,Y), tile(X,Y,Z), Z == 'x', retractall(player_original_health(_)),assertz(player_original_health(0)).
is_in_dead_zone :- !.

delete_enemies_in_dead_zone  :- enemy_position(Row,Col),
                                tile(Row,Col,Tile), Tile == 'x', !,
                                retractall(enemy_position(Row,Col)),
                                retractall(enemy_equipped_weapon(Row,Col,_,_)),
                                retractall(enemy_inventory(Row,Col,_,_)).

delete_enemies_in_dead_zone  :- !.




look_nsew :- player_position(Row,Col),
             RowUp is Row - 1, RowDown is Row + 1, ColLeft is Col - 1, ColRight is Col + 1,
             write('On your north, '),print_nsew(RowUp,Col),
             write('On your south, '),print_nsew(RowDown,Col),
             write('On your east, '),print_nsew(Row,ColRight),
             write('On your west,'),print_nsew(Row,ColLeft),nl,nl,
             look_enemy.

look_enemy :- forall(enemy_position(Row,Col),(player_position(Row,Col)->write('Enemy spotted! Get ready for combat or run !'),nl,!;!)).

is_enemy_attack :-  player_position(Row,Col),enemy_position(Row,Col),
                    enemy_equipped_weapon(Row,Col,EW,_),
                    damage(EW,ED),
                    player_total_health(TH),player_armor_health(AA),player_original_health(OA),
                    retractall(player_total_health(_)),retractall(player_armor_health(_)),retractall(player_original_health(_)),
                    AfterAA is AA - ED,
                    AfterTH is TH - ED,
                    (AfterAA =< 0 ->
                        retractall(player_equipped_armor(_)),
                        assertz(player_armor_health(0)),
                        AfterOA is OA + AfterAA
                        ;
                        assertz(player_armor_health(AfterAA)),
                        AfterOA is OA
                    ),
                    assertz(player_original_health(AfterOA)),
                    assertz(player_total_health(AfterTH)),
                    !,
                    write('You run away after attacked by an enemy'),nl,nl.
is_enemy_attack :- !.

print_nsew(Row,Col) :- enemy_position(Row,Col), !, write(' you can hear enemy nearby, prepare yourself.'),nl.
print_nsew(Row,Col) :- tile(Row,Col,Tile), Tile == 'x', !,  write(' is a dead zone.'),nl.
print_nsew(_,_) :- !, write(' is an open field.'),nl.


look_item_around(Row, Col) :- forall(item_details(Row,Col,Item,Val),
                                        (
                                            item(Item, medicine,_)-> write('You see '), write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, armor,_)-> write('You see '),write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, weapon,_)-> write('You see '),(Val == 0->write('an empty ');write('a ')),write(Item),(player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, ammo,_)-> write('You see  '),write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, bag,_) -> write('You see  '),write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl)
                                        )
                                    ),!.

look_item_around(_,_) :- !.        

show_health     :-  write('Health : '), player_original_health(X),!, write(X).
show_armor      :-  write('Armor : '), player_armor_health(X), !, write(X).
show_weapon     :-  write('Weapon : '), player_equipped_weapon(X,_), !, write(X).
show_weapon     :-  write('none'),!.
show_ammo       :-  player_equipped_weapon(_,X), !,write('Ammo : '),  write(X),nl.
show_ammo       :-  !.
show_inventory  :-  current_inventory(C),max_inventory(M),format('Inventory : (~w/~w)',[C,M]),nl,
                    player_inventory(_,_),!,
                    (forall(player_inventory(X,Y),
                        (write('  '),write(X),
                        (X==magazine->write('('),write(Y),write(')');nl)))
                    ).
show_inventory  :-  write('Your inventory is empty !'),nl,!.

/*MASIH KELUAR TRUE?*/
heal(X) :-  player_original_health(S),
            retractall(player_original_health(_)),
            X1 is S + X,
            (X1 >= 100 ->
                 assertz(player_original_health(100));
                 assertz(player_original_health(X1))
            ),
            player_original_health(H),
            player_armor_health(A),
            retractall(player_total_health(_)),
            T is A + H,
            assertz(player_total_health(T)),!.

move_enemies :- time(X), mod(X,3) =:= 0, enemy_position(_,_),!,
                random(1,5,D),!,
                move_enemies_direction(D),
                move_enemies.
move_enemies :- temp_enemy_position(_,_),!,
                set_back_temp,!.
move_enemies :- !.


move_enemies_direction(D)   :-  /*utara*/D == 1,!,
                                enemy_position(Row,Col),
                                Row1 is Row - 1,
                                retract(enemy_position(Row,Col)),
                                retract(enemy_equipped_weapon(Row,Col,EA,EV)),
                                retract(enemy_inventory(Row,Col,EI,IV)), 
                                assertz(temp_enemy_position(Row1,Col)),
                                assertz(temp_enemy_equipped_weapon(Row1,Col,EA,EV)),
                                assertz(temp_enemy_inventory(Row1,Col,EI,IV)).

move_enemies_direction(D)   :-  /*selatan*/D == 2,!,
                                enemy_position(Row,Col),
                                Row1 is Row + 1,
                                retract(enemy_position(Row,Col)),
                                retract(enemy_equipped_weapon(Row,Col,EA,EV)),
                                retract(enemy_inventory(Row,Col,EI,IV)), 
                                assertz(temp_enemy_position(Row1,Col)),
                                assertz(temp_enemy_equipped_weapon(Row1,Col,EA,EV)),
                                assertz(temp_enemy_inventory(Row1,Col,EI,IV)).

move_enemies_direction(D)   :-  /*barat*/D == 3, !,
                                enemy_position(Row,Col),
                                Col1 is Col - 1,
                                retract(enemy_position(Row,Col)),
                                retract(enemy_equipped_weapon(Row,Col,EA,EV)),
                                retract(enemy_inventory(Row,Col,EI,IV)), 
                                assertz(temp_enemy_position(Row,Col1)),
                                assertz(temp_enemy_equipped_weapon(Row,Col1,EA,EV)),
                                assertz(temp_enemy_inventory(Row,Col1,EI,IV)).

move_enemies_direction(D)   :-  /*timur*/D == 4, !,
                                enemy_position(Row,Col),
                                Col1 is Col + 1,
                                retract(enemy_position(Row,Col)),
                                retract(enemy_equipped_weapon(Row,Col,EA,EV)),
                                retract(enemy_inventory(Row,Col,EI,IV)), 
                                assertz(temp_enemy_position(Row,Col1)),
                                assertz(temp_enemy_equipped_weapon(Row,Col1,EA,EV)),
                                assertz(temp_enemy_inventory(Row,Col1,EI,IV)).


set_back_temp :- temp_enemy_position(Row,Col),!,
                 temp_enemy_equipped_weapon(Row,Col,EW,EA),
                 temp_enemy_inventory(Row,Col,EI,EV),
                 retract(temp_enemy_position(Row,Col)),
                 retract(temp_enemy_equipped_weapon(Row,Col,EW,EA)),
                 retract(temp_enemy_inventory(Row,Col,EI,EV)),
                 assertz(enemy_position(Row,Col)),
                 assertz(enemy_equipped_weapon(Row,Col,EW,EA)),
                 assertz(enemy_inventory(Row,Col,EI,EV)),
                 set_back_temp.
set_back_temp :- !.



generate_enemy(0)   :-  !.
generate_enemy(X)   :-  random(1,10,ERow),random(1,10,ECol), %set posisi
                        assertz(enemy_position(ERow,ECol)),
                        random(1,11,WeaponCode),%set senjata
                        item(WeaponName,_,WeaponCode),
                        random(1,4,EA), %set peluru
                        assertz(enemy_equipped_weapon(ERow,ECol,WeaponName,EA)),
                        random(1, 17, EI), %set isi inventori
                        item(ItemName,_,EI),
                        value(ItemName,Val),
                        assertz(enemy_inventory(ERow,ECol,ItemName,Val)),
                        Next is X - 1,
                        generate_enemy(Next),!.

generate_items(0) :-    !.
generate_items(X) :-    random(1,24,I),
                        item(Name,_,I),
                        value(Name,Val),
                        random(1,10,Row),random(1,10,Col),
                        assertz(item_details(Row,Col,Name,Val)),
                        Next is X - 1,
                        generate_items(Next),!.



combat_story(PW) :-     (
                        PW == m416->
                            write('\n\nYou can hear enemy voices up ahead ..\n'),sleep(2),
                            write('\nYou send him to his creator with a shot through the heart !'),sleep(2),
                            write('\nThe sky looks so beatiful now..\n'),sleep(2);
                        PW == scar->
                            write('\n\nThe shots heard through the hills..\n'),sleep(2),
                            write('\nPanting and trying to hold his wounds, your opponent finally fall to the ground..\n'),sleep(2),
                            write('\nHow long we have to fight in this war?..\n'),sleep(2);
                        PW == shotgun->
                            write('\n\nYour enemy\'s guts spread all over the ground\n'),sleep(2),
                            write('\nYou feel disgusted.. \n'),sleep(2),
                            write('\nBut you\'re the one who make him like that in the first place..\n'),sleep(2);
                        PW == sniper->
                            write('\n\n\'I feel somebody is watching me\',he said..\n'),sleep(2),
                            write('\nThen he saw a brief light blink from across the hill\n'),sleep(2),
                            write('\nRealizing what\'s coming, he try to run as fast as possible\n'),sleep(2),
                            write('\nAlas, his running speed is nothing compared to my bullet flying to his head\n'),sleep(2);
                        PW == bazooka->
                            write('\n\nTarget terminated !\n'),sleep(2),
                            write('\nGod damn it! Is it really necessary to blow him up?\n'),sleep(2);
                        PW == grenade->
                            write('\n\n\'Grenade! Take Cover !\',he said \n'),sleep(2),
                            write('\nBut it was too late, all he can heard was a massive terrifying blast..\n'),sleep(2);
                        %sisanya
                            write('\n\nThe fight was bloody and felt so long\n'),sleep(2),
                            write('\nYou just hope can end this war and leave this hellhole as fast as possible..\n'),sleep(2)
                        ).




                    

combat  :-  player_position(Row,Col),enemy_position(Row,Col),
                    player_equipped_weapon(PW,Ammo),
                    Ammo > 0,!,
                    enemy_equipped_weapon(Row,Col,EW,EAmmo),
                    damage(EW,ED),
                    player_total_health(TH),player_armor_health(AA),player_original_health(OA),
                    retractall(player_total_health(_)),retractall(player_armor_health(_)),retractall(player_original_health(_)),
                    AfterAA is AA - ED,
                    AfterTH is TH - ED,
                    (AfterAA =< 0 ->
                        retractall(player_equipped_armor(_)),
                        assertz(player_armor_health(0)),
                        AfterOA is OA + AfterAA
                        ;
                        assertz(player_armor_health(AfterAA)),
                        AfterOA is OA
                    ),
                    assertz(player_original_health(AfterOA)),
                    assertz(player_total_health(AfterTH)),
                    retractall(player_equipped_weapon(_,_)),
                    AfterAmmo is Ammo - 1,
                    assertz(player_equipped_weapon(PW,AfterAmmo)),
                    retract(enemy_equipped_weapon(Row,Col,EW,EAmmo)),
                    retract(enemy_position(Row,Col)),
                    assertz(item_details(Row,Col,EW,EAmmo)),
                    forall(enemy_inventory(Row,Col,_,_),(enemy_inventory(Row,Col,Item,Val),assertz(item_details(Row,Col,Item,Val)),retract(enemy_inventory(Row,Col,Item,Val)))),
                    combat_story(PW),
                    format('\nYou killed your enemy with ~w ! \n',[PW]),!.
        
combat  :-  player_position(Row,Col),enemy_position(Row,Col),!,
                    (
                        player_equipped_weapon(_,_)->player_equipped_weapon(_,Ammo),Ammo == 0, !,write('You have no ammunition, please reload !'),nl;
                        !,write('You can\'t combat your enemy with bare hands, that\'s suicide !'),nl
                    ).
        
combat  :-  player_position(Row,Col),
                    RowUp is Row - 1,
                    RowDown is Row + 1,
                    ColLeft is Col - 1,
                    ColRight is Col + 1,
                    enemy_position(ERow,ECol),
                    (
                        ERow == RowUp,ECol == ColLeft;
                        ERow == RowUp,ECol == Col;
                        ERow == RowUp,ECol == ColRight;
                        ERow == Row,ECol == ColLeft;
                        ERow == Row,ECol == ColRight;
                        ERow == RowDown,ECol == ColLeft;
                        ERow == RowDown,ECol == Col;
                        ERow == RowDown,ECol == ColRight
                    ),
                    write('Can\'t reach the enemy, you need to go closer !'),nl,!.
        
combat  :- !, write('\nNo enemy in sight.'),nl.




/*INISIALISASI*/
init_player :-  random(1,10,Row),random(1,10,Col),
                assertz(player_position(Row,Col)),
                assertz(player_total_health(100)),
                assertz(player_original_health(100)),
                assertz(player_armor_health(0)).
                %assertz(player_equipped_weapon(sks,5)).
                
init_time   :-  assertz(time(0)).

init_inventory :- assertz(current_inventory(0)),assertz(max_inventory(3)).

init_item   :-  random(1,11,ItemNumber),generate_items(ItemNumber).

init_enemy  :-  random(4,11,EnemyNumber),generate_enemy(EnemyNumber).





/*PERMAINAN SELESAI*/
check_game_over :- player_original_health(H), H =< 0, show_credits_lose,
                restart.
check_game_over :- enemy_position(_,_),!. %Belum selesai gamenya
check_game_over :- show_credits_win,
                restart.

show_credits_win :- write('\nAfter a hard fought battle, finally you stand as lone survivor of the war \n'),sleep(3),
                    write('\nAfter this day, the world remember you as.. \n'),sleep(2),
                    write('\nWINNER WINNER CHICKEN DINNER\n'),sleep(2),
                    write('\nCongrats and don\'t forget..\n'),sleep(5),
                    write('\n\n\nBelajar buat UAS..\n'),sleep(2),!.
show_credits_lose :- write('\nYou lose..\n'),sleep(2),
                     write('\nCupu cok\n'),sleep(1),
                     write('\nMending belajar sono buat uas\n'),sleep(1),!.

show_credits_team :- %shell(clear),
                     write('\nCREATED BY : \n\n'),
                     write('\nAbda Shaffan Diva 13517021\n\n'),
                     write('\nDidik Supriadi 13517069\n\n'),
                     write('\nJuniardi Akbar 13517075\n\n'),
                     write('\nM. Hendry Prasetya 13517105\n\n').

show_title :-   %shell(clear),
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
                nl.

/*PROSEDUR RESET FAKTA DI GAME*/

reset_game  :-  reset_tiles.
reset_tiles :-  tile(_,_,_),!,retract(tile(_,_,_)),!,reset_tiles.
reset_tiles :- !,reset_PP. 
reset_PP    :-  retractall(player_position(_,_)),reset_PTH.
reset_PTH  :-  retractall(player_total_health(_)),reset_POA.
reset_POA  :-  retractall(player_original_health(_)),reset_PAH.
reset_PAH  :-  retractall(player_armor_health(_)),reset_PEA.
reset_PEA  :-  retractall(player_equipped_armor(_)),reset_PEW.
reset_PEW  :-  retractall(player_equipped_weapon(_,_)),reset_PI.
reset_PI  :-  retractall(player_inventory(_,_)),reset_CI.
reset_CI  :-  retractall(current_inventory(_)),reset_MI.
reset_MI  :-  retractall(max_inventory(_)),reset_EP.
reset_EP  :-  retractall(enemy_position(_,_)),reset_EI.
reset_EI  :-  retractall(enemy_inventory(_,_,_,_)),reset_EEW. 
reset_EEW  :-  retractall(enemy_equipped_weapon(_,_,_,_)),reset_ID.
reset_ID  :-  retractall(item_details(_,_,_,_)),reset_time.
reset_time  :-  retractall(time(_)),reset_TEP,!.
reset_time :- !.
reset_TEP  :-  retractall(temp_enemy_position(_,_)),reset_TEI.
reset_TEI  :-  retractall(temp_enemy_inventory(_,_,_,_)),reset_TEEW. 
reset_TEEW  :-  retractall(temp_enemy_equipped_weapon(_,_,_,_)),!.







/* PROSEDUR SAVE DAN LOAD FAKTA DARI FILE */

/*SAVE*/

save_facts(FileName)  :-  open(FileName,write,Out),
                          %Save Tile
                          findall(Row,tile(Row,_,_),ListTileRow),
                          findall(Col,tile(_,Col,_),ListTileCol),
                          findall(Tile,tile(_,_,Tile),ListTileTile),
                          write(Out,ListTileRow),write(Out,'. '),
                          write(Out,ListTileCol),write(Out,'. '),
                          write(Out,ListTileTile),write(Out,'. '),
                          nl(Out),
                          %Save Player Position
                          player_position(PRow,PCol),
                          write(Out,PRow), write(Out,'. '),
                          write(Out,PCol), write(Out,'. '),
                          nl(Out),
                          %Save player total health
                          player_total_health(TH),
                          write(Out,TH),write(Out,'. '),
                          nl(Out),
                          %Save player original health
                          player_original_health(OH),
                          write(Out,OH),write(Out,'. '),
                          nl(Out),
                          %Armor Health
                          player_armor_health(AH),
                          write(Out,AH),write(Out,'. '),
                          nl(Out),
                          %Player equipped armor
                          (player_equipped_armor(Armor)->
                          write(Out,Armor)
                          ;write(Out,0)
                          ),
                          write(Out,'. '),
                          nl(Out),
                          %Player equipped weapon
                          (player_equipped_weapon(W,Ammo)->
                          write(Out,W),
                          write(Out,'. '),
                          write(Out,Ammo);
                          write(Out,0)
                          ),
                          write(Out,'. '),
                          nl(Out),
                          %Player inventory
                          findall(PI,player_inventory(PI,_),ListItem),
                          findall(PV,player_inventory(_,PV),ListValue),
                          write(Out,ListItem),write(Out,'. '),
                          write(Out,ListValue),write(Out,'. '),
                          nl(Out),
                          %Save kapasitas inventori sekarang
                          current_inventory(CI),
                          write(Out,CI),write(Out,'. '),
                          nl(Out),
                          %Save kapasitas inventori maksimum
                          max_inventory(MI),
                          write(Out,MI),write(Out,'. '),
                          nl(Out),
                          %Koordinat musuh
                          findall(ER,enemy_position(ER,_),ListERow),
                          findall(EC,enemy_position(_,EC),ListECol),
                          write(Out,ListERow),write(Out,'. '),
                          write(Out,ListECol),write(Out,'. '),
                          nl(Out),
                          %Inventori musuh
                          findall(EIR,enemy_inventory(EIR,_,_,_),ListEIR),
                          findall(EIC,enemy_inventory(_,EIC,_,_),ListEIC),
                          findall(EII,enemy_inventory(_,_,EII,_),ListEII),
                          findall(EIV,enemy_inventory(_,_,_,EIV),ListEIV),
                          write(Out,ListEIR),write(Out,'. '),
                          write(Out,ListEIC),write(Out,'. '),
                          write(Out,ListEII),write(Out,'. '),
                          write(Out,ListEIV),write(Out,'. '),
                          nl(Out),
                          %Equipped weapon musuh
                          findall(EER,enemy_equipped_weapon(EER,_,_,_),ListEER),
                          findall(EEC,enemy_equipped_weapon(_,EEC,_,_),ListEEC),
                          findall(EEI,enemy_equipped_weapon(_,_,EEI,_),ListEEI),
                          findall(EEV,enemy_equipped_weapon(_,_,_,EEV),ListEEV),
                          write(Out,ListEER),write(Out,'. '),
                          write(Out,ListEEC),write(Out,'. '),
                          write(Out,ListEEI),write(Out,'. '),
                          write(Out,ListEEV),write(Out,'. '),
                          nl(Out),
                          %Daftar Item di map
                          findall(IR,item_details(IR,_,_,_),ListIR),
                          findall(IC,item_details(_,IC,_,_),ListIC),
                          findall(II,item_details(_,_,II,_),ListII),
                          findall(IV,item_details(_,_,_,IV),ListIV),
                          write(Out,ListIR),write(Out,'. '),
                          write(Out,ListIC),write(Out,'. '),
                          write(Out,ListII),write(Out,'. '),
                          write(Out,ListIV),write(Out,'. '),
                          nl(Out),
                          %Waktu
                          time(Time),
                          write(Out,Time),
                          write(Out,'. '),
                          nl(Out),
                          close(Out),
                          write('\nSaving your file\n'),sleep(2),
                          write('\nFinish loading files.. \n'),sleep(2),
                          write('\nYour data has been saved.\n'),!.

%kalo gak valid
save_facts(_) :- write('Saving Failed. Please try again'),!.

/*LOAD*/


%Prosedur pembantu
load_tile([],[],[]) :-  !.
load_tile([H1|T1],[H2|T2],[H3|T3]) :- assertz(tile(H1,H2,H3)),load_tile(T1,T2,T3),!.

load_player_inventory([],[]) :-  !.
load_player_inventory([H1|T1],[H2|T2]) :- assertz(player_inventory(H1,H2)),load_player_inventory(T1,T2),!.

load_enemy_position([],[]) :-  !.
load_enemy_position([H1|T1],[H2|T2]) :- assertz(enemy_position(H1,H2)),load_enemy_position(T1,T2),!.

load_enemy_inventory([],[],[],[]) :-  !.
load_enemy_inventory([H1|T1],[H2|T2],[H3|T3],[H4|T4]) :- assertz(enemy_inventory(H1,H2,H3,H4)),load_enemy_inventory(T1,T2,T3,T4),!.

load_enemy_equipped_weapon([],[],[],[]) :-  !.
load_enemy_equipped_weapon([H1|T1],[H2|T2],[H3|T3],[H4|T4]) :- assertz(enemy_equipped_weapon(H1,H2,H3,H4)),load_enemy_equipped_weapon(T1,T2,T3,T4),!.

load_item_details([],[],[],[]) :-  !.
load_item_details([H1|T1],[H2|T2],[H3|T3],[H4|T4]) :- assertz(item_details(H1,H2,H3,H4)),load_item_details(T1,T2,T3,T4),!.


load_facts(FileName)  :-    open(FileName,read,In),
                            shell(clear),
                            %reset_game,%penting,supaya gak ada double facts
                            read(In,ListTileRow),
                            read(In,ListTileCol),
                            read(In,ListTileTile),
                            load_tile(ListTileRow,ListTileCol,ListTileTile),
                            read(In,PRow),read(In,PCol),
                            assertz(player_position(PRow,PCol)),
                            read(In,PTH),
                            assertz(player_total_health(PTH)),
                            read(In,POH),
                            assertz(player_original_health(POH)),
                            read(In,PAH),
                            assertz(player_armor_health(PAH)),
                            read(In,PEA),
                            (PEA \= 0->
                                assertz(player_equipped_armor(PEA));
                                true %kosong
                            ),
                            read(In,PW),
                            (PW \= 0 ->
                                read(In,PV),
                                assertz(player_equipped_weapon(PW,PV));
                                true %kosong
                            ),
                            read(In,ListItem),read(In,ListVal),
                            load_player_inventory(ListItem,ListVal),
                            read(In,CurrInv),
                            assertz(current_inventory(CurrInv)),
                            read(In,MaxInv),
                            assertz(max_inventory(MaxInv)),
                            read(In,ERow),read(In,ECol),
                            load_enemy_position(ERow,ECol),
                            read(In,EIR),read(In,EIC),
                            read(In,EIN),read(In,EIV),
                            load_enemy_inventory(EIR,EIC,EIN,EIV),
                            read(In,EER),read(In,EEC),
                            read(In,EEN),read(In,EEV),
                            load_enemy_equipped_weapon(EER,EEC,EEN,EEV),
                            read(In,IR),read(In,IC),
                            read(In,IN),read(In,IV),
                            load_item_details(IR,IC,IN,IV),
                            read(In,Time),
                            assertz(time(Time)),
                            close(In),
                            write('\nLoading your files \n'),sleep(2),
                            write('\nDikit lagi libur boss! \n'),sleep(2),
                            write('\nLoad successful, opening game..\n'),sleep(1),!.

		
load_facts(_) :- write('Load Failed. Please try again'),!. 









