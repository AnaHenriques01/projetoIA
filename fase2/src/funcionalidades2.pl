:- consult('baseConhecimento2.pl').
:- consult('auxiliares2.pl').

:- set_prolog_flag(discontiguous_warnings,off).
:- set_prolog_flag(single_var_warnings,off).
:- set_prolog_flag(global, 10 000 000 000).

:- style_check(-singleton).

%----------------------------------------Funcionalidade 1----------------------------------------
% Gerar os circuitos de entrega, caso existam, que cubram um determinado território. 

todosOsCaminhosTerritorio(Territorio,L) :- 
    solucoes(Ponto,pontoEntrega(Ponto),Pts),
    todosOsCaminhosAux(Territorio,Pts,L).

%----------------------------------------Funcionalidade 2----------------------------------------
% Identificar quais os circuitos com maior número de entregas.

circuitosMaiorNumEntregas(L) :- 
    allCaminhos('Green Distribuition',R),
    maiorNumEntregasCircuito(R,MaxE),
    circuitosMaiorNumEntregasAux(R,MaxE,L).

%----------------------------------------Funcionalidade 3----------------------------------------
% Comparar circuitos de entrega tendo em conta os indicadores de produtividade (distância e quantidade).

% # 1 - DFS
% # 2 - BFS
% # 3 - Limitada em Profundidade
% # 4 - Gulosa
% # 5 - A*
produtividade(Nodo,Distancia,Quantidade,1) :-
    resolveDFS(Nodo,Caminho,Distancia,Quantidade).

produtividade(Nodo,Distancia,Quantidade,2) :- 
    resolveBFS(Nodo,Caminho,Distancia,Quantidade).

produtividade(Nodo,Distancia,Quantidade,3) :- 
    resolveLimitada(Nodo,Caminho,Distancia,Quantidade,5).

produtividade(Nodo,Distancia,Quantidade,4) :-
    resolveGulosa(Nodo,Caminho/Distancia,Quantidade).

produtividade(Nodo,Distancia,Quantidade,5) :-
    resolveAEstrela(Nodo,Caminho/Distancia,Quantidade).

%----------------------------------------Funcionalidade 4----------------------------------------
% Escolher o circuito mais rápido (usando o critério da distância).

circuitoMaisRapido(C) :-
    allCaminhos('Green Distribuition',L), % se for em geral
    %todosOsCaminhosTerritorio('Territorio',L) % se for de um determinado território
    %distanciaCircuitoMaisRapido(L,D),
    circuitoMaisRapidoAux(L,D,C1),
    inverso(C1,CAux),
    apagaCabeca(CAux,CV),
    append(C1,CV,C).

%----------------------------------------Funcionalidade 5----------------------------------------
% Escolher o circuito mais ecológico (usando critério de tempo).

circuitoMaisEficiente(C) :-
    allCaminhos('Green Distribuition',L), % se for em geral
    %todosOsCaminhosTerritorio('Territorio',L) % se for de um determinado território
    %tempoCircuitoMaisEficiente(L,T),
    circuitoMaisEficiente(L,T,C1),
    inverso(C1,CAux),
    apagaCabeca(CAux,CV),
    append(C1,CV,C).