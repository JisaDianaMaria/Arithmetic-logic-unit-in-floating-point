----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2024 10:12:38
-- Design Name: 
-- Module Name: AlignState - Behavioral
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

entity AlignState is
    port(
        clk, rst : in std_logic;
        nr1_exp, nr2_exp : in std_logic_vector(8 downto 0);
        nr1_mantissa, nr2_mantissa : in std_logic_vector(24 downto 0);
        aligned_nr1_mantissa, aligned_nr2_mantissa : out std_logic_vector(24 downto 0);
        res_exp : out std_logic_vector(8 downto 0);
        next_state : out ST
    );
end AlignState;

architecture Behavioral of AlignState is
begin
    process(clk, rst)
    variable diff : signed(8 downto 0);
    variable shift_amount: integer;
    begin
        if rst = '1' then
            -- Resetarea iesirilor
            aligned_nr1_mantissa <= (others => '0');
            aligned_nr2_mantissa <= (others => '0');
            res_exp <= (others => '0');
            next_state <= WAIT_ST;
        elsif rising_edge(clk) then
            -- Logica de aliniere
            if unsigned(nr1_exp) > unsigned(nr2_exp) then
                diff := signed(nr1_exp) - signed(nr2_exp); 
                shift_amount := to_integer(diff);      
                res_exp <= nr1_exp;
                if (shift_amount < 24) then
                    aligned_nr1_mantissa <= nr1_mantissa;
                    aligned_nr2_mantissa <= std_logic_vector(unsigned(nr2_mantissa) srl shift_amount);
                end if;
                next_state <= OPERATION;          
            elsif unsigned(nr1_exp) < unsigned(nr2_exp) then
                diff := signed(nr2_exp) - signed(nr1_exp); 
                shift_amount := to_integer(diff);
                res_exp <= nr2_exp;
                if (shift_amount < 24) then
                    aligned_nr1_mantissa <= std_logic_vector(unsigned(nr1_mantissa) srl shift_amount);
                    aligned_nr2_mantissa <= nr2_mantissa;
                end if;
                next_state <= OPERATION;          

            else
                res_exp <= nr1_exp;
                aligned_nr1_mantissa <= nr1_mantissa;
                aligned_nr2_mantissa <= nr2_mantissa;
                next_state <= OPERATION;          

            end if;
        end if;
    end process;
end Behavioral;

