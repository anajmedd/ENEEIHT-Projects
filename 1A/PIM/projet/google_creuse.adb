with Ada.Text_IO;            use Ada.Text_IO;
with Ada.float_Text_IO;   use Ada.float_Text_IO;
with Ada.integer_Text_IO;   use Ada.integer_Text_IO;
with lca;

package body google_creuse is 



procedure initialiser(V : out matricep) is
begin
   for i in 1..Capacite loop
     Lca_integer_float.Initialiser(V(i));
   end loop;
end initialiser; 


procedure  V_hyperliens(V : out Vecteur_integer ; fichier : in string) is
f : file_type;
C : integer;
n : integer;
len : integer;
Nb_Noeud : integer;
l: integer := 1;




begin
V := (1..Capacite => 0);
len := 1;
open(f,in_File,fichier);
get(f, Nb_Noeud);
get(f,C);
n := C;
get(f,C);
while not End_of_File(f) loop 
      get(f,C);
      if n = C then
         get(f,C);
         len := len + 1;
         V(l) := len;
       else
          len :=1;  
          n := C;
          get(f,C);
          l := l + 1;
        end if;
end loop;
V(l) := len;
close(f);
end V_hyperliens;


procedure lire(M : out matricep  ; fichier : in string ) is
   f : file_type;
   C : integer;
   Vect : Vecteur_integer;
   l : integer := 1 ;
   n :integer;
   Nb_Noeud : integer ;
   sda :   Lca_integer_float.T_LCA;
begin
   
   V_hyperliens(Vect ,fichier);
   open(f,in_File,fichier);
   get(f, Nb_Noeud);
   get(f,C);
   n := C;
   get(f,C);
  Lca_integer_float.Enregistrer(M(n+1) ,C+1,1.0/float(Vect(l)));
     while not End_of_File(f) loop 
         get(f,C);
        
         if n = C then
            get(f,C);
            Lca_integer_float.Enregistrer(M(n+1) ,C+1 ,1.0/float(Vect(l)));
         else
            
            l := l +1;  
            n := C;
            get(f,C);
           Lca_integer_float.Enregistrer(M(n+1) ,C+1,1.0/float(Vect(l)));
         end if;
      end loop;
      Lca_integer_float.Enregistrer(M(n+1) ,C+1 ,1.0/float(Vect(l)));
      
      close(f);
      end lire;

procedure calculS(M : in out matricep) is
begin
    for i in 1..Capacite loop
       if Est_Vide(M(i)) then
           for j in 1..Capacite loop
              Lca_integer_float.Enregistrer(M(i) ,j ,1.0/float(Capacite));
            end loop;
         end if;
      end loop;
end calculS;
                
procedure Produit(M : in matricep ;V : in out Vecteur_float ;alpha : float)  is
poids : Vecteur_float;
beta : float  := (1.0 - alpha)/float(Capacite);

begin 

  for i in 1..Capacite loop
      poids(i):= 0.0;
     for k in 1..Capacite loop
         if Cle_Presente(M(k),i) then
            poids(i) := poids(i) + (alpha*La_Donnee(M(k),i) + beta)*V(k);
            
            
         else 
            poids(i) := poids(i) + beta*V(k);
            
            
         end if;
      end loop;
      
      
   end loop;
  
  
   V := poids ;
        
        
        
end Produit;


procedure Ecrire(vect : in Vecteur_float; fichier : in String; alpha : in float;Nb_iteration : in integer) is
        f : FILE_TYPE;
        begin
            Create(f, Out_File, fichier);
            Put(f,Capacite,1);
            Put(f," ");
            Put(f,alpha, Fore=>1, Aft=>10);
            Put(f," ");
            Put(f,nb_iteration,1);
            new_line(f,1);
            for i in 1..Capacite loop
                Put(f,vect(i), Fore=>1, Aft=>10);
                new_line(f,1);
            end loop;
           
            close(f);
        end Ecrire;

    procedure Ecrire(vect : in Vecteur_integer; fichier : in String) is
        f : FILE_TYPE;
        begin
            Create(f, Out_File, fichier);

            for i in 1..Capacite loop
                Put(f,vect(i),1);
                new_line(f,1);
            end loop;
           
            close(f);
        end Ecrire;

procedure Trier(V : in out Vecteur_float ;V_indice : out Vecteur_integer) is
        indice_max : integer ;
        tmp1 : float;
        tmp2 : integer;
    begin
    for i in 1..Capacite loop
        V_indice(i) := i-1;
    end loop;

    for i in 1..(Capacite-1) loop
        indice_max := i;
        for j in i+1..Capacite loop
            if V(j) > V(indice_max) then
                indice_max := j;
            end if;
        end loop;
        tmp1 := V(i) ;
        tmp2 := V_indice(i) ;
        V(i) := V(indice_max);
        V_indice(i) := V_indice(indice_max);
        V(indice_max) := tmp1;
        V_indice(indice_max) := tmp2;

    end loop;

end Trier;


            
end google_creuse;