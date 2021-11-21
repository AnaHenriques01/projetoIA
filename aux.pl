:- consult('baseConhecimento.pl').

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).

:- style_check(-singleton).

%-----------------------------------------Exclusivamente sobre datas-----------------------------------------

% Verifica se a segunda data é anterior à primeira
comparaDatas(datime(AH,MH,DH,HH,MINH,_),data(AP,MP,DP,HP,MINP)) :-
    AP < AH;
    (AP =:= AH, (MP < MH;
    (MP =:= MH, (DP < DH;
    (HP =:= HH, MINP < MINH))))).

%--------------------------------------Usadas em várias funcionalidades--------------------------------------

% Devolve a lista dos ids das encomendas de um estafeta
encomendasDoEstafeta(IdEstaf,Lista) :-
    estafeta(IdEstaf,Lista0),
	encomendasDaLista(Lista0,Lista).

% Devolve a lista dos ids das encomendas a partir da lista de encomendas de um estafeta: [(IdEnc,Nota,Rua,Freguesia)|T]
encomendasDaLista([],[]).
encomendasDaLista([(X,_,_,_)],[X]).
encomendasDaLista([(X,_,_,_)|T],Lista) :-
	encomendasDaLista(T,Lista0),
	adiciona(X,Lista0,Lista).

%--------------------------------------Auxiliares para Funcionalidade 1--------------------------------------

% Conta o número de encomendas cujo transporte foi mais ecológico, ou seja, por bicicleta
estafetaEncomendasEcologicas( IdEstaf, Conta ) :-
	encomendasDoEstafeta( IdEstaf, Lista ),
	encomendasPorBicicleta( Lista, Conta ).

% Devolve o número de encomendas (duma lista) transportadas pelo meio de transporte bicicleta
encomendasPorBicicleta([],0).
encomendasPorBicicleta([IdEnc|T],Conta) :-
	nao(encomenda(IdEnc,_,_,_,_,_,_,'Bicicleta')),
	encomendasPorBicicleta( T, Conta ).
encomendasPorBicicleta([IdEnc|T],Conta) :-
	encomenda(IdEnc,_,_,_,_,_,_,'Bicicleta'),
	encomendasPorBicicleta(T,Conta0),
	Conta is Conta0 + 1.

%--------------------------------------Auxiliares para Funcionalidade 2--------------------------------------

% Devolve os estafetas que entregaram determinada encomenda 
 
estafetasEncCliente(IdEnc,L) :-
	solucoes(IdEstf,estafetaFezEncomenda(IdEstf,IdEnc),R),
	sort(R,L).

estafetaFezEncomenda(IdEstf, IdEnc) :- 
	encomendasDoEstafeta(IdEstf,L),
	membro(IdEnc,L).

%--------------------------------------Auxiliares para Funcionalidade 3--------------------------------------

% Devolve a lista dos ids dos clientes que estão associados aos ids das encomendas
listaClientesDasEnc([],[]).
listaClientesDasEnc([IdEnc|T],Lista) :-
    clienteDaEncomenda(IdEnc,IdCliente),
    listaClientesDasEnc(T,Lista1),
    adiciona(IdCliente,Lista1,Lista).

% Devolve o id do cliente de uma encomenda
clienteDaEncomenda( IdEnc, IdClient ) :-
    encomenda(IdEnc,X,_,_,_,_,_,_),
    IdClient is X.

%--------------------------------------Auxiliares para Funcionalidade 4--------------------------------------

% Falta completar
% Devolve o preço associado ao serviço de entrega de uma encomenda
% precoEncomenda(IdEnc,P) :- encomenda(IdEnc,_,Peso,Vol,Prazo,_,_,Trspt),
%	P is 5*Peso + 4*Vol + 

% Devolve a lista com os preços relativos a uma lista de encomendas
precosListaEncomendas([],[]).
precosListaEncomendas([IdEnc|T],L) :- 
	precoEncomenda(IdEnc,P),
	adiciona(P,L1,L).

% Devolve a soma dos preços das encomendas
totalEncomendas(L,V) :- soma(L,V).

% Devolve todas as encomendas entregues num determinado dia
encomendasDia(A,M,D,L) :- solucoes(IdEnc, encomenda(IdEnc,_,_,_,_,_,data(A,M,D,_,_),_), L).

%--------------------------------------Auxiliares para Funcionalidade 5--------------------------------------

freguesiaDoEstafeta(IdEstaf,Freguesia) :-
	estafeta(IdEstaf,Lista0),
	freguesiaDaLista(Lista0,Freguesia).

freguesiaDaLista([(_,_,_,X)|T],X).

%--------------------------------------Auxiliares para Funcionalidade 6--------------------------------------

% Devolve a lista das classificações de um estafeta
classificacoesDoEstafeta(IdEstaf,L) :-
	estafeta(IdEstaf,L1),
	classificacoesDaLista(L1,L).

% Devolve a lista das classificações a partir da lista de encomendas de um estafeta: [(IdEnc,Nota,Rua,Freguesia)|T]
classificacoesDaLista([],[]).
classificacoesDaLista([(_,C,_,_)], [C]).
classificacoesDaLista([(_,C,_,_)|T],L) :-
	classificacoesDaLista(T,L1),
	adiciona(C,L1,L).    

%--------------------------------------Auxiliares para Funcionalidade 10--------------------------------------

% Devolve o peso de uma encomenda 
pesoEstaf(IdEnc,Peso) :- 
   encomenda(IdEnc,_,P,_,_,_,_,_),
   Peso is P.

% Devolve a lista dos pesos 
 pesoEstafLista([],[]).
 pesoEstafLista([IdEnc|R],L) :- 
    pesoEstaf(IdEnc,P),
	pesoEstafLista(R,L1),
	adiciona(P,L1,L).



% Devolve a soma dos pesos das encomendas
totalPesoEnc(L,V) :- soma(L,V).
%---------------------------------------------------Extras---------------------------------------------------

% Converte uma string para uma data
stringParaDateTime(String,Ano,Mes,Dia) :-
	read_string(Birthday),
    parse_time(Birthday, Stamp),
    stamp_date_time(Stamp, DateTime, 'UTC'),
    DateTime = date(Year, Month, Day, _, _, _, _, _, _).
	
% Lê uma string dada como input
read_string(String) :-
    current_input(Input),
    read_line_to_codes(Input, Codigos),
    string_codes(String, Codigos).

% Adiciona um elemento a uma lista caso este ainda não pertença
adiciona( X,[],[X] ).
adiciona( X,L,[X|L] ) :- nao( membro(X,L) ).
adiciona( X,L,L ) :- membro( X,L ).

% Extensao do meta-predicado nao: Questao -> {V,F}
nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

% Extensao do meta-predicado membro: Elemento,Lista -> {V,F}
membro(X, [X|_]).
membro(X, [_|Xs]):- membro(X, Xs).

% Devolve todas as soluções que respeitam uma determinada condição
solucoes(X,Y,Z) :- findall(X,Y,Z).

% Comprimento de uma lista
comprimento(S,N) :- length(S,N).

% Soma os elementos de uma lista 
soma([],0).
soma([X|Y],Total) :- soma(Y, Ac), Total is X + Ac.