% Zad�n� �. 40:
% Napi�te program �e��c� �kol dan� predik�tem u40(LIN), kde LIN je vstupn� 
% celo��seln� seznam s nejm�n� dv�ma ��sly. Predik�t je pravdiv� (m� hodnotu 
% true), pokud se v seznamu LIN pravideln� st��daj� lich� a sud� ��sla, 
% jinak je nepravdiv� (m� hodnotu false).

% Testovac� predik�ty:
u40_1:- u40([4,-3,2,1,8,3,8,-1]).			% true
u40_2:- u40([4,-3,2,1,8,4,8,-1]).			% false
u40_3:- u40([-3,2]).					% true
u40_r:- write('Zadej LIN: '),read(LIN),u40(LIN).

u40(LIN):- u40_moje_r(LIN).


head_odd([]).
head_odd([Head|Tail]) :- 1 is mod(Head, 2), head_even(Tail).


head_even([]).
head_even([Head|Tail]) :- 0 is mod(Head, 2), head_odd(Tail).


u40_moje_r([]).
u40_moje_r([Head|Tail]) :- 1 is mod(Head, 2), head_even(Tail).
u40_moje_r([Head|Tail]) :- 0 is mod(Head, 2), head_odd(Tail).
