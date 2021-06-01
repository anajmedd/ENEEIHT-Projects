

generic 
   Capacite : Integer ;
   
package matrice_pleine is 
   type T_Vecteur_float is array(1..Capacite) of float ;
   type T_Vecteur_integer is array(1..Capacite) of integer ;
   type T_Matrice is array(1..Capacite) of T_Vecteur_float;
   
    -- nom : Initialiser
    -- Sémantique : initialiser une matrice pleine. 
    -- Parametres : M out T_Matrice
procedure initialiser(M : out T_Matrice);
    
    -- Nom : Est_Ligne_Null 
    -- Sémantique : savoir si une ligne d'une matrice pleine est nulle ou non.
    -- Paramétres :
    --            M      : in T_Matrice la matrice pleine à examiner.
    --            indice : in entier est l'indice de la ligne de la matrice.
    -- Pre-condition : 0=<indice <= Capacite 
    -- Post-condition : retourner true si la ligne est nulle et false sinon. 
    --Est ce qu'une ligne d'une matrice pleine est nulle?
function Est_Ligne_Nulle(M : in T_Matrice ; indice : integer) return boolean ;
    -- Ecrire un vecteur reel dans un fichier. 
procedure Ecrire(vect : in T_Vecteur_float; fichier : in String; alpha : in float;Nb_iteration : in integer);
    -- Ecrire un vecteur entier dans un fichier.
procedure Ecrire(vect : in T_Vecteur_integer; fichier : in String);

    
    -- Realiser le produit d'une matrice avec un vecteur.
function Produit(Mat : in T_Matrice ;V : in T_Vecteur_float) return T_Vecteur_float;

    -- Calculer la matrice des hyperliens contenant l'entier 1 dans chaque position de lien du réseaux
    -- ainsi que le vecteur contenant le nombre des hyperliens de chque noeud.
procedure  vecteur_hyperliens(fichier : in String ;V : out T_Vecteur_integer ;M : out T_Matrice) ;
    -- Calculer la matrice H.
procedure calculh(M : in out T_Matrice ;V : T_Vecteur_integer) ;

    -- Transformer la matrice H en S.
procedure calculS(H : in out T_Matrice);

    -- Transformer S en G.
procedure calculG(S : in out T_Matrice);

    -- Trier le vecteur poids ainsi que le vecteur des indices.
procedure Trier(V : in out T_Vecteur_float ;V_indice : out T_Vecteur_integer);


end matrice_pleine;



