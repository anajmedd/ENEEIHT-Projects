
with lca;
generic
   Capacite : integer ;



package google_creuse is
   type Vecteur_float is array(1..Capacite) of float ;
   type Vecteur_integer is array(1..Capacite) of integer ;

--- Instanciation d'un module Lca avec une clé entiere et une donnée reele .
   package Lca_integer_float is 
    new LCA( T_Cle => integer , T_Donnee => float);
    use Lca_integer_float;

-- Instanciation d'un module Lca avec une clé entiere et une donnée entiére.
     package Lca_integer is 
     new LCA( T_cle => integer , T_Donnee => integer ); 
     use Lca_integer_float;

-- Définition d'un module matricep représentant la matrice des hyperliens sous forme d'un tableau d'Lca. 
  type matricep is array(1..Capacite) of T_LCA;

-- Nom : Initialiser. 
-- Sémantique : Initialiser un vecteur de pointeur nulls de capacite eguale au nombre de noeuds.
-- Parametres : 
--            V : out matrice le vecteur à initialiser.
procedure initialiser(V : out matricep );

-- Nom : V_hyperliens.      
-- Sémantique : Calcule du vecteur creux contenant le nombre des hyperliens de chaque noeuds.
-- Parametres : 
--            V : out Vecteur_integer le vecteur contenant le nombre des hyperliens de chaque noeuds du réseaux.
--            fichier : in string le fichier graphe des hyperliens.
-- Pré-condition : le fichier doit contenir au moins un hyperlien
-- Post-condition : retourner le vecteur des occurences de chaque noeuds dans les hyperliens
procedure V_hyperliens(V : out Vecteur_integer ; fichier : in string);
-- Nom        : lire 
-- Sémantique : Construire la matrice creuse H.
-- Parametres : 
--            fichier : in string le graphe du reseaux.
--            M       : out matricep la matrice creuse H.
--Pre-condition : le fichier doit contenir au moins un hyperliens.
--Post-condition : constuction de la matrice H.

procedure lire(M : out matricep  ; fichier : in string );

-- Nom : calculS.
--Sémantique : Produire la matrice S à partir de la matrice en remplacant les pointeurs null par des Lca contenant
-- à chaque position 1/N.        -- N : nombre de noeuds
-- Parametres : 
--          M : out matricep la matrice H à convertir.
-- Post-condition : calcule de la matrice S.

procedure calculS(M : in out matricep);
-- Nom : Produit 
-- Sémantique : Calculer le produit de la matrice creuse avec un vecteur.
-- Parametres :
--            M : in matricep 
--            V : in out Vecteur_float le vecteur à faire multiplier par la matrice creuse. 
-- Pre-condition : rien
-- Post-condition : V est le vecteur produit de la matrice et V. 
procedure  Produit(M : in matricep ;V : in out Vecteur_float ;alpha : float) ;

-- Trier un vecteur et calculer les vecteur des indices correspond.
procedure Trier(V : in out Vecteur_float ;V_indice : out Vecteur_integer);
-- Ecrire un vecteur reel dans un fichier. 
procedure Ecrire(vect : in Vecteur_float; fichier : in String; alpha : in float;Nb_iteration : in integer);
-- Ecrire un vecteur entier dans un fichier.
procedure Ecrire(vect : in Vecteur_integer; fichier : in String);
 


end google_creuse;


