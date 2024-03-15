----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2024 10:38:29
-- Design Name: 
-- Module Name: NormalizeState - Behavioral
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

entity NormalizeState is
    port(
        clk, rst : in std_logic;
        res_mantissa_in : in std_logic_vector(24 downto 0);
        res_exp_in : in std_logic_vector(8 downto 0);
        res_mantissa_out : out std_logic_vector(24 downto 0);
        res_exp_out : out std_logic_vector(8 downto 0);
        next_state : out ST
    );
end NormalizeState;

architecture Behavioral of NormalizeState is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            -- Resetarea ie?irilor
            res_mantissa_out <= (others => '0');
            res_exp_out <= (others => '0');
            next_state <= WAIT_ST;
        elsif rising_edge(clk) then
            -- Logica de normalizare
            if unsigned(res_mantissa_in) = TO_UNSIGNED(0, 25) then
                res_mantissa_out <= (others => '0');  
                res_exp_out <= (others => '0');
                next_state <= ROUNDING;  
            elsif(res_mantissa_in(24) = '1') then  
                res_mantissa_out <= '0' & res_mantissa_in(24 downto 1);  
                res_exp_out  <= std_logic_vector(unsigned(res_exp_in) + 1);
                next_state <= ROUNDING; 
            elsif(res_mantissa_in(23) = '0') then  
                res_mantissa_out <= res_mantissa_in(23 downto 0) & '0';  
                res_exp_out <= std_logic_vector(unsigned(res_exp_in) - 1);
                next_state<= NORMALIZE; 
            else
                res_mantissa_out <= res_mantissa_in;
                res_exp_out <= res_exp_in;
                next_state <= ROUNDING;  
            end if;
        end if;
    end process;
end Behavioral;
