----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2024 10:43:23
-- Design Name: 
-- Module Name: RoundingState - Behavioral
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

entity RoundingState is
    port(
        clk, rst, start : in std_logic;
        res_mantissa_in : in std_logic_vector(24 downto 0);
        res_exp_in : in std_logic_vector(8 downto 0);
        res_sgn : in std_logic;
        res : out std_logic_vector(31 downto 0);
        done : out std_logic;
        next_state : out ST
    );
end RoundingState;

architecture Behavioral of RoundingState is
signal man : std_logic_vector (24 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            res <= (others => '0');
            done <= '0';
            next_state <= WAIT_ST;
        elsif rising_edge(clk) then
            -- Logica de rotunjire
            if (res_mantissa_in(2) = '0') then
                 man <= '0' & res_mantissa_in(23 downto 0);
            elsif (res_mantissa_in(2)= '1' and ((res_mantissa_in(1) or res_mantissa_in(0)) = '1')) then
                 man <= std_logic_vector(unsigned('0' & res_mantissa_in(23 downto 0)) + 1);
            elsif (res_mantissa_in(2 downto 0) = "100" and res_mantissa_in(3)='0') then
                 man <= '0' & res_mantissa_in(23 downto 0);
            else 
                 man <= std_logic_vector(unsigned('0' & res_mantissa_in(23 downto 0)) + 1);
            end if;
 
            -- Setarea exponentilor si semnului rezultatului
            res(22 downto 0) <= man(22 downto 0);
            res(30 downto 23) <= res_exp_in(7 downto 0);
            res(31) <= res_sgn;
            
            -- Finalizarea rotunjirii si tranzitia la WAIT_STATE
            done <= '1';     
            if (start = '0') then         
                done <= '0';
                next_state <= WAIT_ST;
            end if;
        end if;
    end process;
end Behavioral;

