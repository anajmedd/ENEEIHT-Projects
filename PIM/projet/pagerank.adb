
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.float_Text_IO;   use Ada.float_Text_IO;
with Ada.integer_Text_IO;   use Ada.integer_Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with matrice_pleine;
with google_creuse;


procedure pagerank is

function  capacite(fichier : in String ) return integer is 
  C : integer;
  file: file_type; 
begin
  
  open(file,in_File,fichier);
  get(file, C);
  close(file);
  return C;
end capacite;

c : integer := capacite(Argument(Argument_count));


package matrice_N is 
        new matrice_pleine(Capacite => c);
   use matrice_N;


 package matrice_c is 
        new google_creuse(Capacite => c);
   use matrice_c;


V : matrice_N.T_Vecteur_integer;

M : matrice_N.T_matrice;
M_c : matrice_c.matricep;


poids : matrice_N.T_Vecteur_float;
indice : matrice_N.T_Vecteur_integer;

poids_c : matrice_c.Vecteur_float;
indice_c : matrice_c.Vecteur_integer;


  Nombre_iteration : integer := 150;
  alpha : float := 0.85;
  implementation_naive : boolean ;

procedure implementation is
begin

    if Argument_Count = 1 then
        implementation_naive := false;

    elsif Argument_Count = 2 then
        
          if Argument (1) /= "-P" then
          raise constraint_error;
        else
          implementation_naive := (Argument (1) = "-P");
        end if;

    elsif Argument_Count = 3 and Argument (1) = "-A" then
       
       if float'Value(Argument (2)) < 0.0 or float'Value(Argument (2)) > 1.0 then
          raise constraint_error;
        else
          alpha := Float'Value(Argument (2));
        end if;
        

    elsif Argument_Count = 3 and Argument (1) = "-I" then
        
        if Integer'Value(Argument (2)) < 0 then
          raise constraint_error;
        else
          Nombre_iteration := Integer'Value(Argument (2));
        end if;
    
    elsif Argument_Count = 4 and Argument (2) = "-I" then
        
       
         if Integer'Value(Argument (3)) < 0 then
          
          raise constraint_error;
          
        else
          
          Nombre_iteration := Integer'Value(Argument (3));
         
        end if;

         if Argument (1) /= "-P" then
          raise constraint_error;
        else
           implementation_naive := (Argument (1) = "-P");
        end if;
    elsif Argument_Count = 4 and Argument (2) = "-A" then

       
       

       if float'Value(Argument (3)) < 0.0 or float'Value(Argument (3)) > 1.0   then
          raise constraint_error;
        else
         alpha := Float'Value(Argument (3));
        end if;

         if Argument (1) /= "-P" then
          raise constraint_error;
        else
           implementation_naive := (Argument (1) = "-P");
        end if;
       
    elsif Argument_Count = 6 and Argument (2) = "-I" and Argument (4) = "-A" then
        
        
       

        if float'Value(Argument (5)) < 0.0 or float'Value(Argument (5)) > 1.0   then
          raise constraint_error;
        else
         alpha := Float'Value(Argument (5));
        end if;

        if Integer'Value(Argument (3)) < 0 then
          raise constraint_error;
        else
          Nombre_iteration := Integer'Value(Argument (3));
        end if;

         if Argument (1) /= "-P" then
          raise constraint_error;
        else
           implementation_naive := (Argument (1) = "-P");
        end if;
    else
        null;
    end if;

Exception 
  when
  constraint_error => put("Veuillez entrez une valeur de alpha entre 0 et 1 et un nombre d'iteration positif et -P ou non dans le premier paramètre !!!");
end implementation;
begin
if implementation_naive then

  matrice_N.vecteur_hyperliens(Argument(Argument_count),V ,M );
  matrice_N.calculh(M,V);
  matrice_N.calculS(M);
  matrice_N.calculG(M);
  poids := (1..c => 1.0/float(c));


  for i in 1..Nombre_iteration loop
    poids := matrice_N.produit(M,poids);
  end loop;
  

  matrice_N.Trier(poids,indice );

  matrice_N.Ecrire(poids ,"poids.p",alpha,Nombre_iteration);
  matrice_N.Ecrire(indice,"noeuds.net");



else

  
  matrice_c.initialiser(M_c);

  poids := (1..c => 1.0/float(c));
  matrice_c.lire(M_c,Argument(Argument_count));
  matrice_c.calculS(M_c);

  
  for n in 1..Nombre_iteration loop
    matrice_c.Produit(M_c,poids_c,alpha);
  end loop;

  matrice_c.Trier(poids_c,indice_c);
  matrice_c.Ecrire(poids_c ,"poids.p",alpha,Nombre_iteration);
  matrice_c.Ecrire(indice_c,"noeuds.net");

end if;






end pagerank;
            
         
