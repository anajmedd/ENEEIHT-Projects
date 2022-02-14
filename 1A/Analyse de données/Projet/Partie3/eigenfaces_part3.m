clear all;
close all;

%%%%%%%% CHOIX DES DONNEES
%%%%%%%%%%%%%%%%%%%%%%%%%%

% liste des differentes personnes
liste_personnes = {
 'f01', 'f02', 'f03', 'f04', 'f05', 'f06', 'f07', 'f08', 'f09', 'f10', 'f11', 'f12', 'f13', 'f14', 'f15', 'f16', 'm01', 'm02', 'm03', 'm04', 'm05', 'm06', 'm07', 'm08', 'm09', 'm10', 'm11', 'm12', 'm13', 'm14', 'm15', 'm16'
                   };
nb_personnes = length(liste_personnes);

% liste des differentes postures 
liste_postures = {'v1e1','v3e1','v1e2','v3e2','v1e3','v3e3'};
nb_postures = length(liste_postures);

nb_lignes = 400;
nb_colonnes = 300;

% personnes constituant la base d'apprentissage (A FAIRE EVOLUER)
liste_personnes_base = {'f01', 'f10', 'm01', 'm08'}
%       personnes          1     10     17     24     
%liste_personnes_base = {'f01', 'f10', 'm10', 'm08'} clusters mieux séparés
nb_personnes_base = length(liste_personnes_base); 

% postures de la base d'apprentissage (A FAIRE EVOLUER)
liste_postures_base = [1 2 3 4];
nb_postures_base = length(liste_postures_base);

%%%%%%%% LECTURE DES DONNES SANS MASQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = [];
liste_base = [];

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Personnes','Position',[0,0,0.67*L,0.67*H]);
colormap(gray(256));

% Affichage des images sous forme de planche-contact 
% (une personne par ligne, une posture par colonne) :
for j = 1:nb_personnes_base,
    no_posture = 0;
	for k = liste_postures_base,
        no_posture = no_posture + 1;
        
        ficF = strcat('./Data/', liste_personnes_base{j}, liste_postures{k}, '-300x400.gif')
        liste_base = [liste_base ; ficF];
        img = imread(ficF);
        % Remplissage de la matrice X :
        X = [X ; double(transpose(img(:)))];
        
        % Affichage
		subplot(nb_personnes_base, nb_postures_base, (j-1)*nb_postures_base + no_posture);
		imagesc(img);
		hold on;
		axis image;
		title(['Personne ' liste_personnes_base{j} ', posture ' num2str(k)]);
        
	end
end

%%%%%%%% CALCUL ET AFFICHAGE DES EIGENFACES SANS MASQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcul de l'individu moyen :
n = size(X,1);
individu_moyen = ones(1,n)*X/n;

% Calcul de la matrice X_moyen de meme taille que X, 
% telle que chaque ligne contienne l'individu moyen :
X_moyen = ones(n,1)*individu_moyen;

% Centrage de la matrice X :
X_centre = X - X_moyen;

% Calcul de la matrice de covariance (impossible a calculer ainsi a cause de sa taille) :
% Sigma = transpose(X_centre)*X_centre/n;

% Calcul de la matrice resultant du calcul inverse :
Sigma2 = X_centre*transpose(X_centre)/n;

% Calcul des vecteurs/valeurs propres de la matrice Sigma2 :
%%%%%%%%%%%%%%%
% VOUS POUVEZ REMPLACER L'APPEL À EIG PAR UN APPEL À L'UNE DE VOS FONCTIONS
% SUBSPACE ITERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[V_2, D] = eig(Sigma2);

% Les vecteurs propres de Sigma (les eigenfaces) se deduisent de ceux de Sigma2 :
V = transpose(X_centre)*V_2;

% Tri par ordre decroissant des valeurs propres de Sigma_barre :
[lambda, ind] = sort(diag(D),'descend');

% Tri des eigenfaces dans le meme ordre 
% (on enleve la derniere eigenface, qui appartient au noyau de Sigma) :
W = V(:, ind);
W = W(:, 1:size(W,2)-1);

% Normalisation des eigenfaces :
normes_eigenfaces = ones(size(W,1), 1)*sqrt(sum(W.*W));
W = W./normes_eigenfaces;

% Affichage de l'individu moyen et des eigenfaces sous la forme de "pseudo-images" 
% (leurs coordonnees sont interpretees comme des niveaux de gris) :
figure('Name','Individu moyen et eigenfaces', 'Position', [0,0,0.67*L,0.67*H]);
colormap(gray(256)); 
img = reshape(individu_moyen, nb_lignes, nb_colonnes);
subplot(nb_personnes_base, nb_postures_base, 1)
imagesc(img); 
hold on; 
axis image; 
title(['Individu moyen']);
for k = 1:n-1,
	img = reshape(W(:,k), nb_lignes,nb_colonnes);
	subplot(nb_personnes_base, nb_postures_base,k+1);
	imagesc(img); 
	hold on; 
	axis image; 
	title(['Eigenface ', num2str(k)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AVEC MASQUE
%%%%%%%%%%%%%


% Dimensions du masque
ligne_min = 200;
ligne_max = 350;
colonne_min = 60;
colonne_max = 290;

%%%%%%%% LECTURE DES DONNES ET AJOUT DU MASQUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X_masque = [];

figure('Name','Personnes avec Masque','Position',[0,0,0.67*L,0.67*H]);
colormap(gray(256));

for j = 1:nb_personnes_base,
    no_posture = 0;
	for k = liste_postures_base,
        no_posture = no_posture + 1;
        
        ficF = strcat('./Data/', liste_personnes_base{j}, liste_postures{k}, '-300x400.gif')
        img = imread(ficF);
        
        % Degradation de l'image
        img(ligne_min:ligne_max,colonne_min:colonne_max) = 0;
        % Remplissage de la matrice X_masque :
        X_masque= [X_masque; double(transpose(img(:)))];
        
        % Affichage
		subplot(nb_personnes_base, nb_postures_base, (j-1)*nb_postures_base + no_posture);
		imagesc(img);
		hold on;
		axis image;
		title(['Personne ' liste_personnes_base{j} ', posture ' num2str(k)]);
        
	end
end

%%%%%% REFAIRE LE CALCUL ET L'AFFICHAGE DES EIGENFACES AVEC MASQUE
% ....
% les eigenfaces avec masque
% W_masque =
% Calcul de l'individu moyen :
m = size(X_masque,1);
individu_moyen_masque = ones(1,m)*X_masque/m;
% Calcul de la matrice X_moyen_masque de meme taille que X_masque, 
% telle que chaque ligne contienne l'individu moyen_masque :
X_moyen_masque = ones(m,1)*individu_moyen_masque;

% Centrage de la matrice X :
X_centre_masque = X_masque - X_moyen_masque;

% Calcul de la matrice resultant du calcul inverse :
Sigma2_masque = X_centre_masque*transpose(X_centre_masque)/m;

% Calcul des vecteurs/valeurs propres de la matrice Sigma2_masque :
%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[V_2_masque, D_masque] = eig(Sigma2_masque);

% Les vecteurs propres de Sigma_masque (les eigenfaces avec masque) se deduisent de ceux de Sigma2 :
V_masque = transpose(X_centre_masque)*V_2_masque;

% Tri par ordre decroissant des valeurs propres de Sigma_barre_masque :
[lambda_masque, ind_masque] = sort(diag(D_masque),'descend');

% Tri des eigenfaces dans le meme ordre 
% (on enleve la derniere eigenface, qui appartient au noyau de Sigma) :
W_masque = V_masque(:, ind_masque);
W_masque = W_masque(:, 1:size(W_masque,2)-1);

% Normalisation des eigenfaces :
normes_eigenfaces_masque = ones(size(W_masque,1), 1)*sqrt(sum(W_masque.*W_masque));
W_masque = W_masque./normes_eigenfaces_masque;

% Affichage de l'individu moyen et des eigenfaces sous la forme de "pseudo-images" 
% (leurs coordonnees sont interpretees comme des niveaux de gris) :
figure('Name','Individu moyen et eigenfaces avec masque', 'Position', [0,0,0.67*L,0.67*H]);
colormap(gray(256)); 
img = reshape(individu_moyen_masque, nb_lignes, nb_colonnes);
subplot(nb_personnes_base, nb_postures_base, 1)
imagesc(img); 
hold on; 
axis image; 
title(['Individu moyen']);
for k = 1:m-1,
	img = reshape(W_masque(:,k), nb_lignes,nb_colonnes);
	subplot(nb_personnes_base, nb_postures_base,k+1);
	imagesc(img); 
	hold on;
	axis image;
	title(['Eigenface avec masque ', num2str(k)]);
end

% calcul du contraste des 3 premiers composantes sans masque
  contrast_1 = Sigma2(1,1)/sum(diag(Sigma2))
  contrast_2 = Sigma2(2,2)/sum(diag(Sigma2))
  contrast_3 = Sigma2(3,3)/sum(diag(Sigma2))
% calcul du contrast des 3 premiers composantes avec masque
contrast_1_masque = Sigma2_masque(1,1)/sum(diag(Sigma2_masque))
contrast_2_masque = Sigma2_masque(2,2)/sum(diag(Sigma2_masque))
contrast_3_masque = Sigma2_masque(3,3)/sum(diag(Sigma2_masque))
%total_contrast_masque = 
save eigenfaces;

