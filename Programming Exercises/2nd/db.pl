find_sim_1(X, Y):- genre(X, G1), genre(Y, G1), X \= Y.
common_member(X,Y) :- member(E,X), member(E,Y).
%%%%%%%
%Genre%
%%%%%%%
find_sim_1(X, Y,G1):-  identification(X,Xid), identification(Y,Yid),genre(Xid, G1), genre(Yid, G1), Xid \= Yid.
find_sim_only_0(X, Y):- identification(X,Xid), identification(Y,Yid), genre_count(Xid,Yid,0).
find_sim_only_1(X, Y):- identification(X,Xid), identification(Y,Yid), genre(Xid, G1), genre(Yid, G1), Xid \= Yid, genre_count(Xid,Yid,1).
find_sim_only_2(X, Y):- identification(X,Xid), identification(Y,Yid),genre(Xid, G1), genre(Yid, G1),genre(Xid, G2), genre(Yid, G2), G1 @> G2, Xid \= Yid, genre_count(Xid,Yid,2).
find_sim_only_3(X, Y):- identification(X,Xid), identification(Y,Yid),genre(Xid, G1), genre(Yid, G1),genre(Xid, G2), genre(Yid, G2), genre(Xid, G3), genre(Yid, G3),G1 @> G2, G2 @> G3, G1 @> G3, Xid \= Yid, genre_count(Xid,Yid,3).
find_sim_morethan_2(X,Y):- identification(X,Xid), identification(Y,Yid), Xid \= Yid, \+ find_sim_only_1(X,Y), \+ find_sim_only_2(X,Y), \+ find_sim_only_0(X,Y).

ps_genre(Movie1,L) :- findall(M,find_sim_only_1(Movie1,M),L).
s_genre(Movie1,L) :- findall(M,find_sim_only_2(Movie1,M),L). 
vs_genre(Movie1,L) :- findall(M,find_sim_morethan_2(Movie1,M),L).

genre_count(Movie1,Movie2,L) :- allgenre(Movie1,X),allgenre(Movie2,Y),
findall(true, common_member(X,Y), CommonGenres), length(CommonGenres,L).

allgenre(X,Y):- findall(M,genre(X,M),Y).

%%%%%%%%
%Actors%
%%%%%%%%
char_count(Movie1,Movie2,L) :- allchar(Movie1,X),allchar(Movie2,Y),
findall(true, common_member(X,Y), CommonChars), length(CommonChars,L).

allchar(X,Y):- findall(M,protagonist(X,M),Y).

protagonist(X,Y):-actor_1(X,Y) ; actor_2(X,Y); actor_3(X,Y).

find_char_1(X, Y,G1):- identification(X,Xid), identification(Y,Yid), protagonist(Xid, G1), protagonist(Yid, G1), Xid \= Yid.
find_char_only_1(X, Y,G1):- identification(X,Xid), identification(Y,Yid), protagonist(Xid, G1), protagonist(Yid, G1), Xid \= Yid, char_count(Xid,Yid,1).
find_char_only_2(X, Y,G1,G2):-identification(X,Xid), identification(Y,Yid), protagonist(Xid, G1), protagonist(Yid, G1),protagonist(Xid, G2), protagonist(Yid,G2), G1 @> G2, Xid \= Yid, char_count(Xid,Yid,2).
find_char_only_3(X, Y,G1,G2,G3):- identification(X,Xid), identification(Y,Yid), protagonist(Xid, G1), protagonist(Yid, G1),protagonist(Xid, G2), protagonist(Yid, G2), protagonist(Xid, G3), protagonist(Yid, G3),G1 @> G2, G2 @> G3, G1 @> G3, Xid \= Yid, char_count(Xid,Yid,3).
ps_char(Movie1,L) :- findall(M,find_char_only_1(Movie1,M,_),L).
s_char(Movie1,L) :- findall(M,find_char_only_2(Movie1,M,_,_),L).
vs_char(Movie1,L) :- findall(M,find_char_only_3(Movie1,M,_,_,_),L).

%%%%%%%%%%
%language%++++++
%%%%%%%%%%
check_lang(X,Y,L) :- identification(X,Xid),identification(Y,Yid),language(Xid,L), language(Yid,L), Xid \= Yid.
same_lang(Movie1, L) :- findall(M,check_lang(Movie1,M,_),L).
find_based_on_lang(Language, Movies) :- findall(M,(identification(M,Mid), language(Mid,Language)),Movies).

%%%%%%
%plot%
%%%%%%
plot_count(Movie1,Movie2,L) :- allplot(Movie1,X),allplot(Movie2,Y), findall(true, common_member(X,Y), CommonPlot), length(CommonPlot,L).

allplot(X,Y):- findall(M,plot(X,M),Y).

find_simplot_0(X, Y):- identification(X,Xid), identification(Y,Yid), plot_count(Xid,Yid,0).
find_simplot_1(X, Y):- identification(X,Xid), identification(Y,Yid), plot(Xid, G1), plot(Yid, G1), Xid \= Yid, plot_count(Xid,Yid,1).
find_simplot_2(X, Y):- identification(X,Xid), identification(Y,Yid), plot(Xid, G1), plot(Yid, G1), plot(Xid, G2), plot(Yid, G2), G1 @> G2, Xid \= Yid, plot_count(Xid,Yid,2).
find_simplot_3(X, Y):- identification(X,Xid), identification(Y,Yid), plot(Xid, G1), plot(Yid, G1), plot(Xid, G2), plot(Yid, G2), plot(Xid, G3), plot(Yid, G3),G1 @> G2, G2 @> G3, G1 @> G3, Xid \= Yid, plot_count(Xid,Yid,3).
find_extremelysimplot(X,Y):- identification(X,Xid), identification(Y,Yid), Xid \= Yid, \+ find_simplot_0(X,Y), \+ find_simplot_1(X,Y), \+ find_simplot_2(X,Y).

s_plot(X,Y):- findall(M, find_simplot_1(X,M),Y).
vs_plot(X,Y):- findall(M, find_simplot_2(X,M),Y).
es_plot(X,Y):- findall(M, find_extremelysimplot(X,M),Y).

%%%%%%%%%%%%%%%%%%%
%Color or no color%
%%%%%%%%%%%%%%%%%%%
black_white(X):- identification(X,Xid), plot(Xid, 'black and white'), X \= 'The Phantom of the Opera'.
black_white(X):- identification(X,Xid), plot(Xid, 'black and white and color'), X \= 'The Waterboy'.
colored(X):- identification(X,Xid), forall(plot(Xid, Z), (Z \= 'black and white', Z \= 'black and white and color')).
%colored(X):- X = 'The Phantom of the Opera'.
%colored(X):- X = 'The Waterboy'.

find_black_and_white(L):- findall(M, black_white(M),L).
find_colored(L):- findall(M, colored(M), L).

%%%%%%%%%%%%%%%%%%%%%%
%Production companies%
%%%%%%%%%%%%%%%%%%%%%%
companies_count(Movie1,Movie2,L) :- allcompanies(Movie1,X),allcompanies(Movie2,Y),
findall(true, common_member(X,Y), CommonCompanies), length(CommonCompanies,L).

allcompanies(X,Y):- findall(M,production_company(X,M),Y).

check_common_company(M1,M2) :- identification(M1,Movie1),identification(M2,Movie2), \+ companies_count(Movie1,Movie2,0), Movie1 \= Movie2.
find_sim_comp(Movie1,L) :- findall(M,check_common_company(Movie1,M),L).

%%%%%%%%%%%%%%%%%%%%
%Production country%
%%%%%%%%%%%%%%%%%%%%
country_count(Movie1,Movie2,L) :- allcountries(Movie1,X),allcountries(Movie2,Y),
findall(true, common_member(X,Y), CommonCountries), length(CommonCountries,L).

allcountries(X,Y):- findall(M,production_country(X,M),Y).

check_common_country(M1,M2) :- identification(M1,Movie1),identification(M2,Movie2), \+ country_count(Movie1,Movie2,0), Movie1 \= Movie2.
find_sim_country(Movie1,L) :- findall(M,check_common_country(Movie1,M),L).

%%%%%%%%%%%%%
%Same dacade%
%%%%%%%%%%%%%
same_decade(M1,M2):- identification(M1,Mid1), identification(M2,Mid2), title_year(Mid1,X), title_year(Mid2,Y), atom_number(X, Floatx), atom_number(Y, Floaty),
Intx is round(Floatx), Inty is round(Floaty), Cx is Intx div 10, Cy is Inty div 10, Cx == Cy.

all_same_dec(M1,L):- findall(M,same_decade(M1,M),L).

%%%%%%%%%%%%%%%%%%%%%%
%O andreas einai cool%
%%%%%%%%%%%%%%%%%%%%%%
q_esp_vg(Movie1,X) :- find_extremelysimplot(Movie1,X),find_sim_morethan_2(Movie1,X).
esp_vg(Movie1,L) :- findall(X,q_esp_vg(Movie1,X),L).

q_esp_sg(Movie1,X) :- find_extremelysimplot(Movie1,X),find_sim_only_2(Movie1,X).
esp_sg(Movie1,L) :- findall(X,q_esp_sg(Movie1,X),L).

q_esp_pg(Movie1,X) :- find_extremelysimplot(Movie1,X),find_sim_only_1(Movie1,X).
esp_pg(Movie1,L) :- findall(X,q_esp_pg(Movie1,X),L).

q_vsp_vg(Movie1,X) :- find_simplot_2(Movie1,X),find_sim_morethan_2(Movie1,X).
vsp_vg(Movie1,L) :- findall(X,q_vsp_vg(Movie1,X),L).

q_vsp_sg(Movie1,X) :- find_simplot_2(Movie1,X),find_sim_only_2(Movie1,X).
vsp_sg(Movie1,L) :- findall(X,q_vsp_sg(Movie1,X),L).

q_vsp_pg(Movie1,X) :- find_simplot_2(Movie1,X),find_sim_only_1(Movie1,X).
vsp_pg(Movie1,L) :- findall(X,q_vsp_pg(Movie1,X),L).

q_sp_sg(Movie1,X) :- find_simplot_1(Movie1,X),find_sim_only_2(Movie1,X).
sp_sg(Movie1,L) :- findall(X,q_sp_sg(Movie1,X),L).

q_sp_vg(Movie1,X) :- find_simplot_1(Movie1,X),find_sim_morethan_2(Movie1,X).
sp_vg(Movie1,L) :- findall(X,q_sp_vg(Movie1,X),L).

q_sp_pg(Movie1,X) :- find_simplot_1(Movie1,X),find_sim_only_1(Movie1,X).
sp_pg(Movie1,L) :- findall(X,q_sp_pg(Movie1,X),L).