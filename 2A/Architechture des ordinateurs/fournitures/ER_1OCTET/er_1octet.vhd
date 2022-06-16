library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity er_1octet is
  port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
end er_1octet;

architecture behavioral_3 of er_1octet is
   -- Type etat permettant de définir les états possibles de l'automate
   type t_etat is (idle,bits_emis,bits_recu);
   -- Signaux 
   signal etat : t_etat;
begin
    process(clk, rst)
        variable cpt: natural;
        variable registre : std_logic_vector(7 downto 0);
    begin
        if(rst = '0') then
            -- réinitialisation des variables du process
            
            -- les compteurs
            cpt := 7;
            
            -- le registre d'envoi
            registre := (others => 'U');
            
            -- l'indicateur de fonctionnement/occupation
            busy <= '0';
            
            sclk <= '1';
            -- la ligne serie
            mosi <= '0';
            
            
            dout <= (others => '0');
            --l'état
            etat <= idle;
        elsif(rising_edge(clk)) then 
                  case etat is
                  
                        when idle =>
                        -- état d'attente d'un ordre d'envoi

                          if(en = '1') then
                          -- un ordre est détecté
                            -- on signale qu'on est occupé
                            busy <= '1';
                            
                            -- stockage l'octet à envoyer
                            registre := din;
                            -- initialisation le compteur de bits 
                            cpt := 7;
                            -- valeur de sclk au repos
                            sclk <= '0';
                            -- envoie le bit de poids fort
                            mosi <= registre(cpt);
                            -- on change d'état
                            etat <= bits_emis;
                          else
                            -- aucun ordre : on ne fait rien
                            null;
                          end if;
                          
                        when bits_recu => 
                                --Décrementation de cpt                       
                                cpt := cpt - 1;
                                sclk <= '0';
                                mosi <= registre(cpt);
                                -- on change d'état
                                etat <= bits_emis;
                                            
                        when bits_emis =>
                            -- état d'envoi des données    
                            if(cpt > 0) then
                                -- on stock la valeur du bits reçu
                                registre(cpt) := miso;
                                sclk <='1';
                                -- on change d'état
                                etat <= bits_recu;
                            else 
                                -- remise du cpt à 0
                                --cpt := 0;
                                registre(cpt) := miso;
                                sclk <= '1';
                                busy <= '0';
                                dout <= registre;
                                -- on change d'état
                                etat <= idle;
                            end if;
                        
                  end case;
        end if;
    end process;                                        
end behavioral_3;
