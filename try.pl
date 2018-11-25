/* DEKLARASI RULE DYNAMIC DISINI */

/*MAP*/
:- dynamic(tile/3). %%tile berisi koordinat point(X,Y) dan isi tilenya

/*PLAYER*/
:- dynamic(player_position/2).
:- dynamic(player_total_health/1). %original health + armor_health
:- dynamic(player_original_health/1).
:- dynamic(player_armor_health/1). %yang di equip , 0 kalo gaada
:- dynamic(player_equipped_armor/1).
:- dynamic(player_equipped_weapon/2). %Nama dan sisa peluru
:- dynamic(player_inventory/2).
/* Keterangan : */
%player_inventory(<weapon_name>,<weapon_ammo>)
%player_inventory(<armor_name>,<armor_remaining_health>)
%player_inventory(<medicine_name>,<medicine_healing_capacity>)
%player_inventory(<ammo>,<weapon_ammo>) sementara anggep peluru itu universal
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


/*ITEM YANG ADA PADA GAME */
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
item(magazine,ammo,16).

%Fakta kepasitias peluru setiap senjata
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

value(m416,7).
value(scar,7).
value(akm,7).
value(ump9,5).
value(shotgun,5).
value(sks,8).
value(pistol,10).
value(sniper,3).
value(bazooka,1).
value(grenade,1).


value(helm,10).
value(kevlar,20).
value(spetnaz,40).

value(bandage,15).
value(medkit,30).

value(magazine,5).

%%Mencetak full map
print_map(12,0) :- nl,nl,!.
print_map(X,12) :- nl , nl,  NextRow is X+1,!, print_map(NextRow,0).
print_map(X,Y) :- tile(X,Y,Tile), print_tile(X,Y,Tile), NextCol is Y + 1,!, print_map(X, NextCol).

print_tile(_,_,X) :- X == 'X', ! ,  write('  X  ').
print_tile(Row,Col,_) :- player_position(Row,Col), ! , write('  P  ').
print_tile(Row,Col,_) :- enemy_position(Row,Col), ! , write('  E  ').
print_tile(Row,Col,_) :- (  item_details(Row,Col,Item,_) ->   
                                (   item(Item,weapon,_) -> write('  W  ');
                                    item(Item,armor,_) -> write('  A  ');
                                    item(Item,medicine,_) -> write('  M  ');
                                    item(Item,ammo,_) -> write('  O  ')
                                );
                            write('  _  ')
                         ). 

load_map(_,_,[]) :- !.
load_map(X,Y,[Head|Tail]) :- assertz(tile(X,Y,Head)), Y1 is Y + 1, load_map(X,Y1,Tail), ! .


initial_map_r0 :-  load_map(0,0,['X','X','X','X','X','X','X','X','X','X','X','X']).
initial_map_r1 :-  load_map(1,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r2 :-  load_map(2,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r3 :-  load_map(3,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r4 :-  load_map(4,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r5 :-  load_map(5,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r6 :-  load_map(6,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r7 :-  load_map(7,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r8 :-  load_map(8,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r9 :-  load_map(9,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r10 :- load_map(10,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
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



update_dead_zone :- time(X), mod(X, 5) =:= 0 , Res is div(X, 5) ,!, forall(tile(Row,Col,_), update_limit_dead_zone(Row,Col,Res)),!,nl,nl,write('The storm is coming...'),nl,nl. %karena mulai dari 0
update_dead_zone :- !.



update_limit_dead_zone(Row,Col,Res) :- Row == Res, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Temp is 11 - Res,Row == Temp, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Col == Res, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Temp is 11 - Res,Col == Temp, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(_,_,_) :- !.


move_player(Direction) :-   Direction == 'n' -> !, is_enemy_attack,player_position(Row,Col), Row1 is Row-1, retractall(player_position(_,_)), assertz(player_position(Row1,Col)), is_in_dead_zone.
move_player(Direction) :-   Direction == 's' -> !, is_enemy_attack,player_position(Row,Col), Row1 is Row+1, retractall(player_position(_,_)), assertz(player_position(Row1,Col)), is_in_dead_zone.
move_player(Direction) :-   Direction == 'e' -> !, is_enemy_attack,player_position(Row,Col), Col1 is Col+1, retractall(player_position(_,_)), assertz(player_position(Row,Col1)), is_in_dead_zone.
move_player(Direction) :-   Direction == 'w' -> !, is_enemy_attack,player_position(Row,Col), Col1 is Col-1, retractall(player_position(_,_)), assertz(player_position(Row,Col1)), is_in_dead_zone.



/*DAFTAR IMPLEMENTASI COMMAND YANG DIINPUT PEMAIN*/

n :-    shell(clear),update_time,update_dead_zone, move_player(n),move_enemies,!, delete_enemies_in_dead_zone,look_nsew,check_game_over.
s :-    shell(clear),update_time,update_dead_zone, move_player(s),move_enemies,!, delete_enemies_in_dead_zone,look_nsew,check_game_over.
e :-    shell(clear),update_time,update_dead_zone, move_player(e),move_enemies,!, delete_enemies_in_dead_zone,look_nsew,check_game_over.
w :-    shell(clear),update_time,update_dead_zone, move_player(w),move_enemies,!, delete_enemies_in_dead_zone,look_nsew,check_game_over.

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
        
start :-    show_title,
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

status :- %shell(clear),
          show_health,nl,
          show_armor,nl,
          show_weapon,nl,
          show_ammo,
          show_inventory,nl,nl.

take(Item)  :-  player_position(X,Y),item_details(X,Y,Item,Val),
                current_inventory(S),
                S < 10,!,
                retract(item_details(X,Y,Item,Val)),
                assertz(player_inventory(Item,Val)),
                S1 is S + 1,
                retractall(current_inventory(_)),
                assertz(current_inventory(S1)),!,look,nl,
                format('You take ~w.',[Item]).

take(_)     :-  current_inventory(S), S == 10, !, write('Your inventory is full !'),nl.
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
use(Item)   :-  shell(clear),
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
                    assertz(current_inventory(X3)),
                    !,write(Item),nl,write(' equipped, ready to battle?'),nl
                ;
                item(Item,medicine,_)-> heal(Val),
                                      retract(player_inventory(Item,Val)),
                                      current_inventory(C),
                                      retractall(current_inventory(_)),
                                      C1 is C - 1,
                                      assertz(current_inventory(C1)),
                                      !,write(Item),write(' used, now you feel better.'),nl
                ;
                item(Item,ammo,_) -> retract(player_equipped_weapon(W,B)),
                                   B1 is B+Val,
                                   assertz(player_equipped_weapon(W,B1)),
                                   current_inventory(X),
                                   retractall(current_inventory(_)),
                                   X1 is X - 1,
                                   assertz(current_inventory(X1)),
                                   !,write(Item),write(' used, ready to some shooting?'),nl
            ).
use(Item)   :- !, format('No ~w in your inventory.',[Item]),nl.


%Asumsi 1: semua musuh yang diserang langsung mati.
%Asumssi 2 : musuh harus bersenjata
attack :- combat, check_game_over.

quit :- reset_game,start.

/*FUNGSI-FUNGSI DALAM GAME*/
update_time :- time(X), X1 is X+1, retractall(time(_)), assertz(time(X1)).

is_in_dead_zone :- player_position(X,Y), tile(X,Y,Z), Z == 'X', retractall(player_original_health(_)),assertz(player_original_health(0)).
is_in_dead_zone :- !.

delete_enemies_in_dead_zone  :- enemy_position(Row,Col),
                                tile(Row,Col,Tile), Tile == 'X', !,
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
print_nsew(Row,Col) :- tile(Row,Col,Tile), Tile == 'X', !,  write(' is a dead zone.'),nl.
print_nsew(_,_) :- !, write(' is an open field.'),nl.


look_item_around(Row, Col) :- forall(item_details(Row,Col,Item,Val),
                                        (
                                            item(Item, medicine,_)-> write('You see '), write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, armor,_)-> write('You see '),write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, weapon,_)-> write('You see '),(Val == 0->write('an empty ');write('a ')),write(Item),(player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl);
                                            item(Item, ammo,_)-> write('You see  '),write(Item), (player_position(Row,Col)->write(' lying on the ground.'),nl;write(' nearby.'),nl)
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

/*INISIALISASI*/
init_player :-  random(1,10,Row),random(1,10,Col),
                assertz(player_position(Row,Col)),
                assertz(player_total_health(75)),
                assertz(player_original_health(75)),
                assertz(player_armor_health(0)).
                %assertz(player_equipped_weapon(sks,5)).
                
init_time   :-  assertz(time(0)).

init_inventory :- assertz(current_inventory(0)),assertz(max_inventory(10)).

init_item   :-  random(1,11,ItemNumber),generate_items(ItemNumber).

init_enemy  :-  random(1,11,EnemyNumber),generate_enemy(EnemyNumber).

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
generate_items(X) :-    random(1,17,I),
                        item(Name,_,I),
                        value(Name,Val),
                        random(1,10,Row),random(1,10,Col),
                        assertz(item_details(Row,Col,Name,Val)),
                        Next is X - 1,
                        generate_items(Next),!.

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
                    forall(enemy_inventory(_,_,_,_),(enemy_inventory(Row,Col,Item,Val),assertz(item_details(Row,Col,Item,Val)),retract(enemy_inventory(Row,Col,Item,Val)))),!.
        
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
                    enemy_position(ERow,ECol),!,
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
        
combat  :- !, write('No enemy in sight.'),nl.



/*PERMAINAN SELESAI*/
check_game_over :- player_original_health(H), H =< 0, show_credits_lose,
                quit.
check_game_over :- enemy_position(_,_),!. %Belum selesai gamenya
check_game_over :- show_credits_win,
                quit.

show_credits_win :- write('Game over,you win !'),nl,nl.
show_credits_lose :- write('YOU LOSE :( '),nl,nl.

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

