----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2024 10:02:28
-- Design Name: 
-- Module Name: WaitState - Behavioral
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
use IEEE.numeric_std.all;
use work.state_types_pkg.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WaitState is
    port(
        clk, rst, start : in std_logic;
        nr1, nr2 : in std_logic_vector(31 downto 0);
        nr1_sgn, nr2_sgn : out std_logic;
        nr1_exp, nr2_exp : out std_logic_vector(8 downto 0);
        nr1_mantissa, nr2_mantissa : out std_logic_vector(24 downto 0);
        next_state : out ST
    );
end WaitState;

architecture Behavioral of WaitState is
begin
    process (clk, rst)
    begin
        if rst = '1' then
            -- Resetarea semnalelor de iesire
            nr1_sgn <= '0';
            nr2_sgn <= '0';
            nr1_exp <= (others => '0');
            nr2_exp <= (others => '0');
            nr1_mantissa <= (others => '0');
            nr2_mantissa <= (others => '0');
            next_state <= WAIT_ST;
        elsif rising_edge(clk) then
            if start = '1' then
                -- Setarea semnalelor de iesire pe baza intrarilor
                nr1_sgn <= nr1(31);
                nr1_exp <= '0' & nr1(30 downto 23);    
                nr1_mantissa <= "01" & nr1(22 downto 0);    
                                 
                nr2_sgn <= nr2(31);
                nr2_exp <= '0' & nr2(30 downto 23);    
                nr2_mantissa <= "01" & nr2(22 downto 0);
                next_state <= ALIGN;
            else
                -- Mentinerea starii curente
                next_state <= WAIT_ST;
            end if;
        end if;
    end process;
end Behavioral;

