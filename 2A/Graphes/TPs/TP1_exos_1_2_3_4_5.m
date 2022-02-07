close all;
%%%%% SET ENV %%%%%

addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

load TPgraphe.mat;          %load data

%%%%%% DISPLAY INPUT DATA ON TERMINAL %%%%%
cities %names of cities
D      %distance matrix bw cities
pos    %x-y pos of the cities

%% EXO 1 (modeliser et afficher le graphe) %%%%%
portee = 500; %km
A = D < portee & D ~= 0; %adj matrix
viz_adj(D,A,pos,cities);
viz_adj(D,graphPower(A, 10),pos,cities);

%% EXO 2 %%%%%

%Q1 - existence d'un chemin de longueur 3
chemins3 = bmul(A, bmul(A, A));
existence = isequal(chemins3, zeros(size(chemins3)))

%Q2 - nb de chemins de 3 sauts
nbChemins3 = sum(sum(chemins3));
nbChemins3

%Q3 - nb de chemins <=3
nbCheminsI3 = sum(sum(graphPower(A, 3)));
nbCheminsI3


%% EXO 3 %%%%%
c=[18 13 9]; %la chaine 18 13 9 est t dans le graphe?
possedechaine(A,c)
c=[18 6 3]; %la chaine 18 6 3 est t dans le graphe?
possedechaine(A,c)
c=[26 5 17]; %la chaine 26 5 17 est t dans le graphe?
possedechaine(A,c)

%% EXO 4%%%%%
isEulerien(A)

%% EXO 5%%%%%
porteeEulerien(D)