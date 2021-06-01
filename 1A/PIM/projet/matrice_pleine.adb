with Ada.Text_IO;            use Ada.Text_IO;
with Ada.float_Text_IO;   use Ada.float_Text_IO;
with Ada.integer_Text_IO;   use Ada.integer_Text_IO;


package body matrice_pleine is
     
procedure initialiser(M : out T_Matrice) is 
begin 
    M(1..Capacite)(1..Capacite) := (1..Capacite =>(1..Capacite => 0.0));
end initialiser;



function Est_Ligne_Nulle(M : in T_Matrice ; indice : integer) return boolean is
begin 
     return M(indice)(1..Capacite) = (1..Capacite => 0.0);
    
end Est_Ligne_Nulle;





procedure Ecrire(vect : in T_Vecteur_float; fichier : in String; alpha : in float;Nb_iteration : in integer) is
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

    procedure Ecrire(vect : in T_Vecteur_integer; fichier : in String) is
        f : FILE_TYPE;
        begin
            Create(f, Out_File, fichier);

            for i in 1..Capacite loop
                Put(f,vect(i),1);
                new_line(f,1);
            end loop;
           
            close(f);
        end Ecrire;




function Produit(Mat : in T_Matrice ;V : in T_Vecteur_float) return T_Vecteur_float is
poids : T_Vecteur_float := (1..Capacite => 0.0);
begin 
    for i in 1..Capacite loop
        
        for m in 1..Capacite loop 
          poids(i) := poids(i) + Mat(m)(i)*V(m);
        end loop;
    end loop;
    return poids;
    

end Produit;


procedure  vecteur_hyperliens(fichier : in String ;V : out T_Vecteur_integer ;M : out T_Matrice) is 
f : file_type;
C : integer;
n : integer;
len : integer;
Nb_Noeud : integer;
begin
  initialiser(M);
  V := (1..Capacite => 0);
  len := 1;
  open(f,in_File,fichier);
  get(f, Nb_Noeud);
  get(f,C);
  n := C;
  get(f,C);
  M(n+1)(C+1) := 1.0;
  while not End_of_File(f) loop 
      get(f,C);
      if n = C then
         get(f,C);
         M(n+1)(C+1) := 1.0;
         len := len + 1;
         V(n+1) := len;
       else
          len :=1;  
          n := C;
          get(f,C);
          M(n+1)(C+1) := 1.0;
          
        end if;
    end loop;
    V(n+1) := len;
    close(f);
end vecteur_hyperliens;




procedure calculh(M : in out T_Matrice ;V : T_Vecteur_integer) is
p : integer ;
begin
   p:= 1;
   for i  in 1..Capacite loop
       p := V(i);
       for k in 1..Capacite loop
           if p /= 0 then 
           M(i)(k) := M(i)(k)/float(p);
           else 
              null;
            end if;
       end loop;
   end loop;
end calculh;         

procedure calculS(H : in out T_Matrice) is 
begin 
    for i in 1..Capacite loop 
        if Est_Ligne_Nulle(H,i) then 
             H(i)(1..Capacite) := (1..Capacite => 1.0/float(Capacite));
        end if;
    end loop;
end calculS;


procedure calculG(S : in out T_Matrice) is 
alpha : float;
begin
alpha := 0.85;
for i in 1..Capacite loop
    for j in 1..Capacite loop
    S(i)(j) := alpha*S(i)(j) + (1.0 - alpha)/float(Capacite);
    end loop;
end loop;
end calculG;


procedure Trier(V : in out T_Vecteur_float ;V_indice : out T_Vecteur_integer) is
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

end matrice_pleine;



