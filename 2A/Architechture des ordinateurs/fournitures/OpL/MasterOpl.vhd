library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MasterOpl is
  port ( rst : in std_logic;
         clk : in std_logic;
         en : in std_logic;
         v1 : in std_logic_vector (7 downto 0);
         v2 : in std_logic_vector(7 downto 0);
         miso : in std_logic;
         ss   : out std_logic;
         sclk : out std_logic;
         mosi : out std_logic;
         val_nand : out std_logic_vector (7 downto 0);
         val_nor : out std_logic_vector (7 downto 0);
         val_xor : out std_logic_vector (7 downto 0);
         busy : out std_logic);
end MasterOpl;

architecture behavior of MasterOpl is
    -- Etats possibles du Master
    type t_etat is (repos, attente, echange);
    -- Etat actuel
    signal etat : t_etat;

    -- Echange d'un octet
    component er_1octet port(
        rst : in std_logic ;
        clk : in std_logic ;
        en : in std_logic ;
        din : in std_logic_vector (7 downto 0);     -- L’octet en entrée.
        miso : in std_logic ;
        sclk : out std_logic ;
        mosi : out std_logic ;
        dout : out std_logic_vector (7 downto 0);   -- L’octet en recéption.
        busy : out std_logic
    );
    end component;
    
    -- L'octet à émettre (v1, v2, ou 0)
    signal din_er : std_logic_vector(7 downto 0) := (others => 'U');
    
    -- L’octet reçu une fois l’émission/réception terminée
    signal dout_er : std_logic_vector(7 downto 0) := (others => 'U');
    
    -- Indique que le composant est occupé à émettre/réceptionner (actif à ’1’)
    signal busy_er : std_logic;

    -- Entrée de er_1octet
    signal en_er : std_logic := '0';
    

begin
 
    -- Emission et réception de chaque octet
    er_1octet_Inst: er_1octet port map(
        rst=>rst,
        clk=>clk,
        en=>en_er,
        din=>din_er,
        miso=>miso,
        sclk=>sclk,
        mosi=>mosi,
        dout=>dout_er,
        busy=>busy_er
    );
        

    
    master: process (clk, rst)
    
        
        variable cpt : natural := 0;
        
        variable num_octet : natural := 0;
        
        constant NB_OCTETS : natural := 3;
        
        constant ATTENTE_ESCLAVE : natural := 10;
        
        constant ATTENTE_ENVOI : natural := 2;
    
    begin

        if (rst = '0') then

            -- Réinitialisation des variables du process
            -- l'état
            etat <= repos;
            -- L'indicateur de fonctionnement/occupation
            busy <= '0';
            ss <= '1';
            
            val_nand <= "00000000";
            val_nor <= "00000000";
            val_xor <= "00000000";
			en_er <= '0';

        elsif (rising_edge(clk)) then
    
            case (etat) is
            
                when repos =>

                    if (en = '1') then
                    -- Un ordre a été passé au composant
                        -- Initialiser la transmission
                        ss <= '0';                     
                        -- On signal que le composant est occupé 
                        busy <= '1';                    
                        -- Attendre que l'esclave soit prêt
                        cpt := ATTENTE_ESCLAVE;         
                        num_octet := 0;
                        etat <= attente;
                        
                    end if;                            

                when attente =>
                
                    if (cpt = 0) then
                        -- on donne un ordre au composant er_1octet
                        en_er <= '1';  
                        -- Fin de l'attente
                        case num_octet is
                            when 0 =>
                              -- Envoi de v1
                                din_er <= v1;           
                            when 1 =>
                              -- Envoi de v2
                                din_er <= v2;           
                            when others => null;
                        end case;
                        
                        etat <= echange;
                        
                    else
                        -- On décrémente le compteur
                        cpt := cpt - 1;                 
                        
                    end if;
                        
                when echange =>
                    -- On vérifie que er_1octet a bien terminé l'échange
                    if (busy_er = '0' and en_er = '0') then 
                        case num_octet is
                            when 0 =>
                                -- Réception du 1er octet
                                val_nand <= dout_er;     
                                etat <= attente;
                            when 1 =>
                                -- Réception du 2ème octet
                                val_nor <= dout_er;     
                                etat <= attente;
                            when 2 =>
                                -- Réception du 3ème octet
                                val_xor <= dout_er;     
                                -- Terminaison de l'échange
                                ss <= '1';              
                                -- Le maitre n'est plus occupé
                                busy <= '0';            
                                -- On change d'état
                                etat <= repos;          
                                -- Fin de l'échange
                                en_er <= '0';           
                            when others => null;
                        end case;
                    
                        num_octet := num_octet + 1;
                        -- Attendre avant l'échange du prochain octet
                        cpt := ATTENTE_ENVOI;           
                            
                    else
                        -- Différencier le début et la fin de l'échange
                        en_er <= '0';                   
                    end if;
                    
            end case;
            
        end if;
    
    end process;
end behavior;
