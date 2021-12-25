:- consult('baseConhecimento2.pl').
:- consult('auxiliares2.pl').

:- set_prolog_flag(discontiguous_warnings,off).
:- set_prolog_flag(single_var_warnings,off).
:- set_prolog_flag(global, 10 000 000 000).

:- style_check(-singleton).

%-------------------------------------------Pesquisa---------------------------------------------
% Executa um dos algoritmos de pesquisa, dependendo do valor recebido.

% # 1 - DFS
% # 2 - BFS
% # 3 - Limitada em Profundidade
% # 4 - Gulosa
% # 5 - A*

estrategiaProcura(Nodo,Caminho,Distancia,1) :-
    resolveDFS(Nodo,Caminho,Distancia).

estrategiaProcura(Nodo,Caminho,Distancia,2) :-
    resolveBFS(Nodo,Caminho,Distancia).

estrategiaProcura(Nodo,Caminho,Distancia,3) :-
    resolveLimitada(Nodo,Caminho,Distancia,5).

estrategiaProcura(Nodo,Caminho,Distancia,4) :-
    resolveGulosa(Nodo,Caminho/Distancia).

estrategiaProcura(Nodo,Caminho,Distancia,5) :-
    resolveAEstrela(Nodo,Caminho/Distancia).

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
% Comparar circuitos de entrega tendo em conta os indicadores de produtividade (distância e tempo).

% # 1 - DFS
% # 2 - BFS
% # 3 - Limitada em Profundidade
% # 4 - Gulosa
% # 5 - A*

/*
APARENTEMENTE VÃO SER CONSTRUÍDOS ALGORITMOS PARA CALCULAR O TEMPO QUE DEVERÁ USAR A VELOCIDADE.
*/
produtividade(Nodo,Distancia,Tempo,1) :-
    resolveDFS(Nodo,Caminho,Distancia),
    tempoCircuito(Caminho,Distancia,Tempo).

produtividade(Nodo,Distancia,Tempo,2) :- 
    resolveBFS(Nodo,Caminho,Distancia),
    tempoCircuito(Caminho,Distancia,Tempo).

produtividade(Nodo,Distancia,Tempo,3) :- 
    resolveLimitada(Nodo,Caminho,Distancia,5),
    tempoCircuito(Caminho,Distancia,Tempo).

produtividade(Nodo,Distancia,Tempo,4) :-
    resolveGulosa(Nodo,Caminho/Distancia),
    tempoCircuito(Caminho,Distancia,Tempo).

produtividade(Nodo,Distancia,Tempo,5) :-
    resolveAEstrela(Nodo,Caminho/Distancia),
    tempoCircuito(Caminho,Distancia,Tempo).

%----------------------------------------Funcionalidade 4----------------------------------------
% Escolher o circuito mais rápido (usando o critério da distância).

circuitoMaisRapido(IdEnc,Alg,C) :-
    encomenda(IdEnc,_,_,_,Territorio),
    estrategiaProcura(Territorio,C,Distancia,Alg).
    %circuitoMaisRapidoAux(L,D,C1)

%----------------------------------------Funcionalidade 5----------------------------------------
% Escolher o circuito mais ecológico (usando critério de tempo).

/*
SERÁ ALTERADO !!!!!
*/
circuitoMaisEficiente(C) :-
    allCaminhos('Green Distribuition',L), % se for em geral
    %todosOsCaminhosTerritorio('Territorio',L) % se for de um determinado território
    circuitoMaisEficienteAux(L,T,C1),
    inverso(C1,CAux),
    apagaCabeca(CAux,CV),
    append(C1,CV,C).

%------------------------------------------Estatísticas------------------------------------------
% Analisar comparativamente as diferentes estratégias de procura.

% # 1 - DFS
% # 2 - BFS
% # 3 - Limitada em Profundidade
% # 4 - Gulosa
% # 5 - A*

obterEstatisticas(1) :-
    statistics(global_stack,[M1,L1]),
    time(resolveDFS('Lamas',Caminho,Distancia)),
    statistics(global_stack,[M2,L2]),
    Mem is M2 - M1,
    write("Memória usada: "),write(Mem),nl,
	write("Custo: "),write(Distancia).

obterEstatisticas(2) :-
    statistics(global_stack,[M1,L1]),
    time(resolveBFS('Lamas',Caminho,Distancia)),
    statistics(global_stack,[M2,L2]),
    Mem is M2 - M1,
    write("Memória usada: "),write(Mem),nl,
	write("Custo: "),write(Distancia).

obterEstatisticas(3) :-
    statistics(global_stack, [M1,L1]),
    time(resolveLimitada('Lamas',Caminho,Distancia,5)),
    statistics(global_stack, [M2,L2]),
    Mem is M2 - M1,
    write("Memória usada: "),write(Mem),nl,
	write("Custo: "),write(Distancia).

obterEstatisticas(4) :-
    statistics(global_stack, [M1,L1]),
    time(resolveGulosa('Lamas',C/Distancia)),
    statistics(global_stack, [M2,L2]),
    Mem is M2 - M1,
    write("Memória usada: "),write(Mem),nl,
	write("Custo: "),write(Distancia).

obterEstatisticas(5) :-
    statistics(global_stack, [M1,L1]),
    time(resolveAEstrela('Lamas',C/Distancia)),
    statistics(global_stack, [M2,L2]),
    Mem is M2 - M1,
    write("Memória usada: "),write(Mem),nl,
	write("Custo: "),write(Distancia).