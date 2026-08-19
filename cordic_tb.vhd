library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_cordic is

end tb_cordic;

architecture Behavioral of tb_cordic is

    
    component cordic
        generic ( n : integer:=16;
                  itr: integer:= 16);
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               mode : in STD_LOGIC;
               xin : in signed(n-1 downto 0);
               yin : in signed(n-1 downto 0);
               zin : in signed(n-1 downto 0);
               xout : out signed(n-1 downto 0);
               yout : out signed(n-1 downto 0);
               zout : out signed(n-1 downto 0));
    end component;

    
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal mode  : std_logic := '0';
    
    
    signal xin   : signed(15 downto 0) := (others => '0');
    signal yin   : signed(15 downto 0) := (others => '0');
    signal zin   : signed(15 downto 0) := (others => '0');
    
    signal xout  : signed(15 downto 0);
    signal yout  : signed(15 downto 0);
    signal zout  : signed(15 downto 0);

    
    constant CLK_PERIOD : time := 10 ns;

begin

    
    uut: cordic
        generic map ( n => 16, itr => 16 )
        port map (
            clk   => clk,
            reset => reset,
            mode  => mode,
            xin   => xin,
            yin   => yin,
            zin   => zin,
            xout  => xout,
            yout  => yout,
            zout  => zout
        );

    
    clk_process :process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    
    stim_proc: process
    begin
        
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;

        
        --mode <= '0'; 
        xin  <= to_signed(9949, 16); 
        yin  <= to_signed(0, 16);
        zin  <= to_signed(8579, 16);

        mode <= '1'; 
        xin  <= to_signed(8192, 16); 
        yin  <= to_signed(8192, 16);
        zin  <= to_signed(0, 16); 


        wait for 16 * CLK_PERIOD;

        
        wait for 50 ns;

        
        wait;
    end process;

end Behavioral;