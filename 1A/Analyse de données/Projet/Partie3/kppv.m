%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de donnees
% TP4 - Reconnaissance de chiffres manuscrits par k plus proches voisins
% fonction kppv.m
%
% Données :
% DataA      : les données d'apprentissage (connues)
% LabelA     : les labels des données d'apprentissage
%
% DataT      : les données de test (on veut trouver leur label)
% Nt_test    : nombre de données tests qu'on veut labelliser
%
% K          : le K de l'algorithme des k-plus-proches-voisins
% ListeClass : les classes possibles (== les labels possibles)
%
% Résultat :
% Partition : pour les Nt_test données de test, le label calculé
%
%--------------------------------------------------------------------------
function classe = kppv(Data, labelA, vectT, K)

[Na,~] = size(Data);

disp(['Classification par la methode des ' num2str(K) ' plus proches voisins:'])


% Calcul des distances entre les vecteurs de test 
% et les vecteurs d'apprentissage (voisins)
dists = sum((Data - repmat(vectT, Na, 1)).^2, 2);

% On ne garde que les indices des K + proches voisins
[~,I] = mink(dists, K);

% Comptage du nombre de voisins appartenant à chaque classe
[GC,GR] = groupcounts(labelA(I));

% Recherche de la classe contenant le maximum de voisins
[mx, ind] = max(GC);

% Si l'image test a le plus grand nombre de voisins dans plusieurs  
% classes différentes, alors on lui assigne celle du voisin le + proche,
% sinon on lui assigne l'unique classe contenant le plus de voisins 
if sum(GC == mx) > 1
    classe = labelA(I(1));
else
    classe = GR(ind);
end
