:- consult('baseConhecimento.pl').
:- consult('aux.pl').
:- consult('invariantes.pl').

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).

:- style_check(-singleton).

%Funcionalidades
		
%---------------------------------------------Funcionalidade 1---------------------------------------------
% Extensão do predicado estafetaMaisEcologico: Lista,Maximo,Id -> {V,F}
% Identifica o estafeta que utilizou mais vezes um meio de transporte mais ecológico

estafetaMaisEcologico(Id) :-
	solucoes(IdEstaf,estafeta(IdEstaf,_),ListaEstaf),
	estafetaMaisEcologico(ListaEstaf,Max,Id).

estafetaMaisEcologico([],0,_).
estafetaMaisEcologico([IdEstaf],Max,IdEstaf) :-
	encomendasPorBicicleta(IdEstaf,Contador),
	Max = Contador.	
estafetaMaisEcologico([IdEstaf|T],Max,IdMax) :-
	encomendasPorBicicleta(IdEstaf,Contador),
	estafetaMaisEcologico(T,ContadorMax,Id),
	(Contador > ContadorMax -> Max = Contador, IdMax = IdEstaf;
	 Max = ContadorMax, IdMax = Id).
	 
%---------------------------------------------Funcionalidade 2---------------------------------------------
% Extensao do predicado estafetasEncomendasCliente: Lista,Lista -> {V,F}
% Identifica que estafetas entregaram determinada(s) encomenda(s) a um determinado cliente
	
estafetasEncomendasCliente([],[]).
estafetasEncomendasCliente([IdEnc],L) :- estafetasEncCliente(IdEnc,L).
estafetasEncomendasCliente([IdEnc|Es],L) :- 
	estafetasEncCliente(IdEnc,R),
	estafetasEncomendasCliente(Es,L1),
	append([R],[L1],L).

%---------------------------------------------Funcionalidade 3---------------------------------------------
% Extensão do predicado clientesPorEstafeta: Id,Lista -> {V,F}
% Identifica os clientes servidos por um determinado estafeta

clientesPorEstafeta(IdEstaf,ListaR) :-
    encomendasDoEstafeta(IdEstaf,Lista0),
    listaClientesDasEnc(Lista0,Lista1),
    sort(0,@<,Lista1,ListaR).

%---------------------------------------------Funcionalidade 4---------------------------------------------
% Extensão do predicado valorFaturadoDia: Ano,Mes,Dia,Valor -> {V,F}

valorFaturadoDia(A,M,D,V) :- 
	encomendasDia(A,M,D,L),
	precosListasEncomendas(L,R),
	totalEncomendas(R,V).

%---------------------------------------------Funcionalidade 5---------------------------------------------
% Extensão do predicado freguesiasComMaisEnc: Lista,Max, Lista -> {V,F}
% Identifica quais as zonas (e.g., rua ou freguesia) com maior volume de entregas por parte da Green Distribution

freguesiasComMaisEnc(ListaFreg) :-
	solucoes(IdEstaf,estafeta(IdEstaf,_),ListaEstaf),
	freguesiasComMaisEnc(ListaEstaf,Max,ListaFreg).

freguesiasComMaisEnc([],0,[]).
freguesiasComMaisEnc([IdEstaf],Max,[Freguesia]) :-
	encomendasDoEstafeta(IdEstaf,ListaEnc0),
	comprimento(ListaEnc0,Contador),
	freguesiaDoEstafeta(IdEstaf,Freguesia),
	Max = Contador.
freguesiasComMaisEnc([IdEstaf|T],Max,ListaFreg) :-
	encomendasDoEstafeta(IdEstaf,ListaEnc0),
	comprimento(ListaEnc0,Contador),
	freguesiaDoEstafeta(IdEstaf,Freguesia),
	freguesiasComMaisEnc(T,ContadorMax,ListaFreg0),
	(Contador > ContadorMax -> Max = Contador, ListaFreg = [Freguesia];
	 Contador == ContadorMax -> Max = ContadorMax, adiciona(Freguesia,ListaFreg0,ListaFreg);
	 Max = ContadorMax, ListaFreg = ListaFreg0).

%---------------------------------------------Funcionalidade 6---------------------------------------------
% Extensão do predicado mediaSatisfacaoEstafeta : Id, Media -> {V,F}
% Calcular a classificação media de satisfação de cliente para um determinado estafeta

mediaSatisfacaoEstafeta(IdEstf,Media) :- 
	classificacoesDoEstafeta(IdEstf,L),
	soma(L,S),
	comprimento(L,C),
	Media is S / C.

%---------------------------------------------Funcionalidade 7---------------------------------------------
% Extensão do predicado numeroTotalEntregas : DataInicio, DataFim, Contador-> {V,F}
% Identifica o número total de entregas pelos diferentes meios de transporte, num determinado intervalo de tempo

numeroTotalEntregasTransporte(data(AI,MI,DI,HI,MinI),data(AF,MF,DF,HF,MinF),ContaCarro,ContaMota,ContaBicicleta) :-
    solucoes(IdEstaf,estafeta(IdEstaf,_),ListaEstaf),
    contaPorTransporteIntervalo(ListaEstaf,data(AI,MI,DI,HI,MinI),data(AF,MF,DF,HF,MinF),ContaCarro,ContaMota,ContaBicicleta).

%---------------------------------------------Funcionalidade 9---------------------------------------------
% Extensão do predicado numEntregasNaoEntregas : DataInicio, DataFim, ContadorEntregas, ContadorNaoEntregas-> {V,F}
% Calcula o número de encomendas entregues e não entregues pela Green Distribution, num determinado período de tempo.

numEntregasNaoEntregas(data(AI,MI,DI,HI,MinI),data(AF,MF,DF,HF,MinF),Contador0,Contador1,Contador2) :-
    listaTodasEncomendas(ListaEnc),
    contaEntregasIntervalo(ListaEnc,data(AI,MI,DI,HI,MinI),data(AF,MF,DF,HF,MinF),Contador0,Contador1,Contador2).

%---------------------------------------------Funcionalidade 10---------------------------------------------
% Extensão do predicado : Ano,Mes,Dia,Lista -> {V,F}
% Calcula o peso total transportado por estafeta num determinado dia.

pesoTotalEstafetasDia(A,M,D,L) :-
  encomendasDia(A,M,D,L1),
  listaPesoTotalDia(L1,[],R),
  sort(R,L).
