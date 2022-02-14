clear;
close all;

load eigenfaces;

% Tirage aleatoire d'une image de test :
personne = randi(nb_personnes)
posture = randi(nb_postures)
% si on veut tester/mettre au point, on fixe l'individu
%individu = 10
%posture = 6

ficF = strcat('./Data/', liste_personnes{personne}, liste_postures{posture}, '-300x400.gif');
img = imread(ficF);
img(ligne_min:ligne_max,colonne_min:colonne_max) = 0;
image_test = double(transpose(img(:)));
 

% Pourcentage d'information 
per = 0.95;

% Nombre N de composantes principales a prendre en compte 
% [dans un second temps, N peut etre calcule pour atteindre le pourcentage
% d'information avec N valeurs propres (contraste)] :
N = 8;

C = X_centre_masque*W_masque;
C = C(:,1:N);

L_perso = 1:nb_personnes_base;
L_perso = repelem(L_perso, 1, nb_postures_base)';
L_postu = 1:nb_postures_base;
L_postu = repmat(L_postu, 1, nb_personnes_base)';

Data_test = (image_test-individu_moyen_masque)*W_masque(:,1:N);

personne_proche = kppv(C, L_perso, Data_test, 1);
posture_proche = kppv(C, L_postu, Data_test, 1);


figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.8*L,0.5*H]);

subplot(1, 2, 1);
% Affichage de l'image de test :
colormap gray;
imagesc(img);
title({['Individu de test : posture ' num2str(posture) ' de ', liste_personnes{personne}]}, 'FontSize', 20);
axis image;


ficF = strcat('./Data/', liste_personnes_base{personne_proche}, liste_postures{posture_proche}, '-300x400.gif')
img = imread(ficF);
        
subplot(1, 2, 2);
imagesc(img);
title({['Individu la plus proche : posture ' num2str(posture_proche) ' de ', liste_personnes_base{personne_proche}]}, 'FontSize', 20);
axis image;

%% Recherche des valeurs optimales...

X_test_personnes = [];
L_test_personnes = [];
X_test_postures = [];
L_test_postures = [];
for j=1:nb_personnes
	for k = 1:length(liste_postures)
        ficF = strcat('./Data/', liste_personnes{j}, liste_postures{k}, '-300x400.gif');
        img = imread(ficF);
        img(ligne_min:ligne_max,colonne_min:colonne_max) = 0;
        if ismember(liste_personnes{j}, liste_personnes_base) && ~ismember(k, liste_postures_base)
            X_test_personnes = [X_test_personnes; double(transpose(img(:)))];
            L_test_personnes = [L_test_personnes; find(strcmp(liste_personnes_base, liste_personnes{j}))];
        elseif ismember(k, liste_postures_base)
            X_test_postures = [X_test_postures; double(transpose(img(:)))];
            L_test_postures = [L_test_postures; k];
        end
	end
end

Data_test_personnes = (X_test_personnes-individu_moyen_masque)*W_masque(:,1:N);
Data_test_postures = (X_test_postures-individu_moyen_masque)*W_masque(:,1:N);

E_perso = [];
E_postu = [];
for k=1:4
    [p_perso, c_perso, e_perso] = kppv_avec_erreur(C, L_perso, L_test_personnes,...
                                        Data_test_personnes, length(Data_test_personnes), k);
    [p_postu, c_postu, e_postu] = kppv_avec_erreur(C, L_postu, L_test_postures,...
                                        Data_test_postures, length(Data_test_postures), k);
    E_perso = [E_perso e_perso];
    E_postu = [E_postu e_postu];
end

figure('Name','Erreurs pour differents valeurs de k');
hold on;
plot(1:4, E_perso, 'r');
plot(1:4, E_postu, 'b');
legend('même personne avec posture differente', 'differente personne avec même posture');
xlabel('K');
ylabel('erreur');

E_perso = [];
E_postu = [];
for N=1:15
    C = X_centre_masque*W_masque(:,1:N);
    Data_test_personnes = (X_test_personnes-individu_moyen_masque)*W_masque(:,1:N);
    Data_test_postures = (X_test_postures-individu_moyen_masque)*W_masque(:,1:N);
    [p_perso, c_perso, e_perso] = kppv_avec_erreur(C, L_perso, L_test_personnes,...
                                        Data_test_personnes, length(Data_test_personnes), 1);
    [p_postu, c_postu, e_postu] = kppv_avec_erreur(C, L_postu, L_test_postures,...
                                        Data_test_postures, length(Data_test_postures), 1);
    E_perso = [E_perso e_perso];
    E_postu = [E_postu e_postu];
                                    
end

figure('Name','Erreurs pour differents valeurs de N');
hold on;
plot(1:15, E_perso, 'r');
plot(1:15, E_postu, 'b');
legend('même personne avec posture differente', 'differente personne avec même posture');
xlabel('N');
ylabel('erreur');
