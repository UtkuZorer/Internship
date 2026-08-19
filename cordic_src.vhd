----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.08.2026 08:47:37
-- Design Name: 
-- Module Name: srcs - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic is
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
end entity cordic;

architecture Behavioral of cordic is
type angles is array(0 to itr-1) of signed(n-1 downto 0);
constant arctans: angles:=(to_signed(12868, n), 
        to_signed(7596, n),  
        to_signed(4014, n),  
        to_signed(2037, n),  
        to_signed(1023, n),  
        to_signed(512, n),   
        to_signed(256, n),   
        to_signed(128, n),   
        to_signed(64, n),    
        to_signed(32, n),    
        to_signed(16, n),    
        to_signed(8, n),     
        to_signed(4, n),     
        to_signed(2, n),     
        to_signed(1, n),     
        to_signed(0, n)     
    );
type registers is array (0 to itr) of signed(n-1 downto 0);
signal regx: registers;
signal regy: registers;
signal regz: registers;    
begin
regx(0)<=xin;
regy(0)<=yin;
regz(0)<=zin;
generator: for i in 0 to itr-1 generate
begin
    process(clk,reset) 
    variable shiftx: signed(n-1 downto 0);
    variable shifty: signed(n-1 downto 0);
    begin
        if reset = '1' then
            regx(i+1)<= (others=>'0');
            regy(i+1)<= (others=>'0');
            regz(i+1)<= (others=>'0');
        elsif rising_edge(clk) then
            shiftx:= shift_right(regx(i),i);
            shifty:= shift_right(regy(i),i);
            if mode = '0' then
                if regz(i)(n-1)= '1' then
                    regx(i+1)<= regx(i) + shifty;
                    regy(i+1)<= regy(i) - shiftx;
                    regz(i+1)<= regz(i)+arctans(i);
                else
                    regx(i+1)<= regx(i) - shifty;
                    regy(i+1)<= regy(i) + shiftx;
                    regz(i+1)<= regz(i) - arctans(i);
                end if;
            else
                if regy(i)(n-1) = '0' then
                    regx(i+1)<= regx(i) + shifty;
                    regy(i+1)<= regy(i) - shiftx;
                    regz(i+1)<= regz(i) + arctans(i);
                else
                regx(i+1)<= regx(i) - shifty;
                regy(i+1)<= regy(i) + shiftx;
                regz(i+1)<= regz(i) - arctans(i);
                end if;
            end if;
         end if;
       end process;
   end generate generator;     
xout<= regx(itr);
yout<= regy(itr);
zout<= regz(itr);
end Behavioral;
