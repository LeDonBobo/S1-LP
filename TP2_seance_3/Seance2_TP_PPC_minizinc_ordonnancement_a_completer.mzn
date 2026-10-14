% ============================================================================
% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 6
% Ordonnancement ExedBike en MiniZinc — même instance qu'au TP2 (Exercice 4,
% CP-SAT/OR-Tools) : 3 lots sur une même ligne, non-chevauchement, minimiser
% le makespan. En MiniZinc, la contrainte globale de non-chevauchement
% d'intervalles est "disjunctive".
% ============================================================================

include "disjunctive.mzn";

int: horizon = 15;
array[1..3] of string: noms = ["Urban", "Cargo", "Sport"];
array[1..3] of int: dur = [3, 5, 4];  % durées en heures

array[1..3] of var 0..horizon: s;  % dates de début
array[1..3] of var 0..horizon: e;  % dates de fin

% --- ETAPE 1 : lier début, durée et fin (déjà écrit) ------------------------
constraint forall(i in 1..3)(e[i] = s[i] + dur[i]);

% --- ETAPE 2 : non-chevauchement --------------------------------------------
% La ligne ne peut traiter qu'un lot à la fois : utilisez la contrainte
% globale "disjunctive(s, dur)" (elle prend directement les tableaux de
% débuts et de durées).
%
constraint disjunctive(s, dur);

% --- ETAPE 3 : objectif = minimiser la date de fin du dernier lot ----------
var 0..horizon: makespan;
%
% A COMPLETER (2 lignes : contrainte liant makespan à max(e), puis solve minimize) :
constraint makespan = max(e);
solve minimize makespan;

output [ noms[i] ++ " : début=" ++ show(s[i]) ++ "h, fin=" ++ show(e[i]) ++ "h\n" | i in 1..3 ]
      ++ ["makespan = ", show(makespan), "h"];


% Question 2:
% Le solveur trouve un makespan optimal de 12h correspondant à la somme des durées des trois lots (3 + 4 + 5 = 12), soit la borne inférieur du problème. Ils sont exécutés successivement, sans chevauchement ni temps d'inactivité. Cela confirme donc l'optimalité du programme.

% l'ordonnancement est : 
% Urban : début=9h, fin=12h
% Cargo : début=0h, fin=5h
% Sport : début=5h, fin=9h

% Question 3 :
% MiniZinc m'a semblé plus simple et plus concis pour modéliser ce problème grâce à la contrainte disjunctive. L'API Python d'OR-Tools nécessite de créer des variables d'intervalle (IntervalVar) avant d'utiliser NoOverlap. Les deux méthodes se distinguent sur la manière de formuler le problème mais elles donnent le même résultat.