library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4Joystick is
    port (
        -- les 16 switchs
        swt : in std_logic_vector (15 downto 0);
        -- les 5 boutons noirs
        btnC, btnU, btnL, btnR, btnD : in std_logic;
        -- horloge
        mclk : in std_logic;
        -- Master Input Slave Output
        miso : in std_logic;
        -- les 16 leds
        led : out std_logic_vector (15 downto 0);
        -- les anodes pour sélectionner les afficheurs 7 segments à utiliser
        an : out std_logic_vector (7 downto 0);
        -- valeur affichée sur les 7 segments (point décimal compris, segment 7)
        ssg : out std_logic_vector (7 downto 0);
        -- Slave Select (actif à '0')
        ss : out std_logic;
        -- Master Output Slave Input
        mosi : out std_logic;
        -- Serial clock
        sclk : out std_logic
    );
end Nexys4Joystick;

architecture synthesis of Nexys4Joystick is

    COMPONENT MasterJoystick
    PORT(
        rst : IN std_logic;
        clk : IN std_logic;
        en : IN std_logic;
        led1 : IN std_logic;
        led2 : IN std_logic;
        miso : IN std_logic;          
        ss : OUT std_logic;
        sclk : OUT std_logic;
        mosi : OUT std_logic;
        x : OUT std_logic_vector(15 downto 0);
        y : OUT std_logic_vector(15 downto 0);
        btn1 : OUT std_logic;
        btn2 : OUT std_logic;
        btnj : OUT std_logic;
        busy : OUT std_logic
    );
    END COMPONENT;

    COMPONENT diviseurClk
    generic(facteur : natural);
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;          
        nclk : OUT std_logic
    );
    END COMPONENT;
    
    COMPONENT dec7seg
	PORT(
		value: IN std_logic_vector(3 downto 0);          
		seg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

    COMPONENT All7Segments
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        e0 : IN std_logic_vector(3 downto 0);
        e1 : IN std_logic_vector(3 downto 0);
        e2 : IN std_logic_vector(3 downto 0);
        e3 : IN std_logic_vector(3 downto 0);
        e4 : IN std_logic_vector(3 downto 0);
        e5 : IN std_logic_vector(3 downto 0);
        e6 : IN std_logic_vector(3 downto 0);
        e7 : IN std_logic_vector(3 downto 0);          
        an : OUT std_logic_vector(7 downto 0);
        ssg : OUT std_logic_vector(7 downto 0)
    );
    END COMPONENT;

    signal x : std_logic_vector(15 downto 0);
    signal y : std_logic_vector(15 downto 0);
    
    signal my_clk : std_logic;

begin

    -- valeurs des sorties

    -- leds éteintes
    led(15 downto 4) <= (others => '0');

    -- connexion du (des) composant(s) avec les ports de la carte

    Inst_MasterJoystick: MasterJoystick PORT MAP(
        rst => swt(0),
        clk => my_clk,
        en => swt(1),
        miso => miso,
        led1 => btnD,
        led2 => btnU, 
        x => x,
        y => y,
        btn1 => led(1),
        btn2 => led(2),
        btnj => led(0),
        ss => ss,
        sclk => sclk,
        mosi => mosi,
        busy => led(15) 
	);

    Inst_diviseurClk: diviseurClk
    GENERIC MAP(100)
    PORT MAP(
		clk => mclk,
		reset => swt(0),
		nclk => my_clk
	);

    Inst_All7Segments: All7Segments PORT MAP(
        clk => mclk,
		reset => swt(0),
		e0 => x(3 downto 0),
		e1 => x(7 downto 4), 
		e2 => "00" & x(9 downto 8),
		e3 => "0000",
		e4 => y(3 downto 0),
		e5 => y(7 downto 4),
		e6 => "00" & y(9 downto 8),
		e7 => "0000",
		an => an,
		ssg => ssg
	);

end synthesis;
