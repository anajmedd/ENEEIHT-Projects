-- fichier à écraser avec le fichier généré par ISE (New Source)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity MasterJoystick is
  port ( rst : in std_logic;
         clk : in std_logic;
         en : in std_logic;
         miso : in std_logic;
         led1 : in std_logic;
         led2 : in std_logic; 
         x : out std_logic_vector (9 downto 0);
         y : out std_logic_vector(9 downto 0);
         btn1 : out std_logic;
         btn2 : out std_logic;
         btnJ : out std_logic;
         ss   : out std_logic;
         sclk : out std_logic;
         mosi : out std_logic;
         busy : out std_logic);
end MasterJoystick;

architecture behavior of MasterJoystick is
    type t_etat is (idle,attente,envoi1,envoi2,envoi3,envoi4,envoi5);
    signal etat : t_etat;
    
    signal en_er : std_logic;
    signal din_er : std_logic_vector(7 downto 0);
    signal dout_er : std_logic_vector(7 downto 0);
    signal busy_er : std_logic;
    
    component er_1octet
	port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
	end component;
	
begin

    Inst_er_1octet: er_1octet PORT MAP(
            rst => rst,
            clk => clk,
            en => en_er,
            din => din_er,
            miso => miso,
            sclk => sclk,
            mosi => mosi,
            dout => dout_er,
            busy => busy_er
        );
    process(clk, rst)
    
        variable cpt: natural;
        variable octet: natural;
    begin                       
        if (rst = '0') then
            -- réinitialisation des variables du process
            -- et des signaux calculés par le process
            octet := 1;
            -- fonctionnement/occupation
            busy <= '0';
				-- Nettoyer les afficheurs quand on est reset
				x <= ( others => '0');
				y <= ( others => '0');
            ss <= '1';      
            --l'état
            etat <= idle;       
        elsif(rising_edge(clk)) then 
                  case etat is
                        
                        when idle =>                                            -- état d'attente d'un ordre
                            
                                if(en = '1') then
                                    ss <= '0';                                  -- ordre détecté
                                    busy <= '1';                                -- le composant est occupé
                                    cpt := 15;                                 -- on initialise le compteur d'attente pour 15 cycle 
                                    etat <= attente;                            -- on change d'état
                                end if;
                        when attente =>
                                if(cpt = 0) then
                                    en_er <= '1';                               -- on donne un ordre au composent er_1octet  
                                    -- transmission selon les valeurs de octet
                                    if (octet = 1) then
                                        -- envoie 1
                                        
                                        etat <= envoi1;
                                    elsif (octet = 2) then
                                        -- envoie 2
                                        din_er <= (0 => led1, 1 => led2, 7 => '1', others => '0');
                                        etat <= envoi2;
                                    elsif (octet = 3) then
                                        -- envoie 3
                                        din_er <= (0 => led1, 1 => led2, 7 => '1', others => '0');
                                        etat <= envoi3;
                                    elsif (octet = 4) then
                                        -- envoie 4
                                        din_er <= (0 => led1, 1 => led2, 7 => '1', others => '0');
                                        etat <= envoi4;
                                    elsif (octet = 5) then
                                        -- envoie 5
                                        din_er <= (0 => led1, 1 => led2, 7 => '1', others => '0');
                                        etat <= envoi5;
                                    end if;
                                else 
                                    cpt := cpt - 1;                             -- on décrémente le compteur
                                end if;
                        when envoi1 =>
                                en_er <= '0';
                                -- si l'echange est terminé
                                if (busy_er = '0' and en_er ='0') then
                                    -- Affectation de val_nand
                                    x(7 downto 0) <= dout_er;
                                    -- Initialisation du compteur d'attente à 10 cycle
                                    cpt := 10;
                                    -- Passage au deuxième octet
                                    octet := 2;
                                    -- changement à l'état attente
                                    etat <= attente;
                                end if;
                                
                        when envoi2 => 
                                en_er <= '0';
                                -- si l'echange est terminé
                                if (busy_er = '0' and en_er = '0') then
                                    x(9 downto 8) <= dout_er(1 downto 0);
                                    -- Initialisation du compteur d'attente à 10 cycle
                                    cpt := 10;
                                    -- Passage au troisième octet
                                    octet := 3;
                                    -- changement à l'état attente
                                    etat <= attente;
                                end if;
                        when envoi3 => 
                                en_er <= '0';
                                -- si l'echange est terminé
                                if ( busy_er = '0' and en_er = '0') then
                                    y(7 downto 0) <= dout_er;
                                    -- Initialisation du compteur d'attente à 10 cycle
                                    cpt := 10;
                                    -- Passage au quatrieme octet
                                    octet := 4;
                                    -- on change d'état
                                    etat <= attente;
                                end if;
                        when envoi4 => 
                                en_er <= '0';
                                -- si l'echange est terminé
                                if (busy_er = '0' and en_er = '0') then
                                    y(9 downto 8) <= dout_er(1 downto 0);
                                    -- Initialisation du compteur d'attente à 10 cycle
                                    cpt := 10;
                                    -- Passage au cinquieme octet
                                    octet := 5;
                                    -- on change d'état
                                    etat <= attente;
                                end if;
                                                                
                        when envoi5 => 
                                en_er <= '0';
                                -- si l'echange est terminé
                                if (busy_er = '0' and en_er = '0') then
                                    btn2 <= dout_er(2);
                                    btn1 <= dout_er(1);
                                    btnJ <= dout_er(0);
                                    -- Initialisation du compteur d'attente à 10 cycle
                                    cpt := 10;
                                    octet := 1;
                                    -- Fin de l'echange
                                    ss <= '1';
                                    busy <= '0';
                                    -- on change d'état
                                    etat <= idle;
                                end if;
                        end case;                          
        end if;                                     
    end process;        
end behavior;
