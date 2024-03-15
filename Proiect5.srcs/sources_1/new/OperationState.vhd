----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2024 10:29:43
-- Design Name: 
-- Module Name: OperationState - Behavioral
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

entity OperationState is
    port(
        clk, rst, op : in std_logic;
        nr1_sgn, nr2_sgn : in std_logic;
        nr1_mantissa, nr2_mantissa : in std_logic_vector(24 downto 0);
        res_sgn : out std_logic;
        res_mantissa : out std_logic_vector(24 downto 0);
        next_state : out ST
    );
end OperationState;

architecture Behavioral of OperationState is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            -- Resetarea iesirilor
            res_mantissa <= (others => '0');
            res_sgn <= '0';
            next_state <= WAIT_ST;
        elsif rising_edge(clk) then
            -- Logica operatiei
            next_state <= NORMALIZE; 
            if op = '0' then
               if (nr1_sgn = nr2_sgn) then  
                   res_mantissa <= std_logic_vector((unsigned(nr1_mantissa) + unsigned(nr2_mantissa)));    
                   res_sgn <= nr1_sgn;      
               elsif unsigned(nr1_mantissa) >= unsigned(nr2_mantissa) then
                   res_mantissa <= std_logic_vector((unsigned(nr1_mantissa) - unsigned(nr2_mantissa)));    
                   res_sgn <= nr1_sgn;
               else
                   res_mantissa <= std_logic_vector((unsigned(nr2_mantissa) - unsigned(nr1_mantissa)));    
                   res_sgn <= nr2_sgn;
               end if;
            else
               if (nr1_sgn /= nr2_sgn) then
                   res_mantissa <= std_logic_vector((unsigned(nr1_mantissa) + unsigned(nr2_mantissa)));
                   res_sgn <= nr1_sgn;      
               elsif unsigned(nr1_mantissa) >= unsigned(nr2_mantissa) then
                    res_mantissa <= std_logic_vector((unsigned(nr1_mantissa) - unsigned(nr2_mantissa)));
                    res_sgn <= nr1_sgn;
               else
                    res_mantissa <= std_logic_vector((unsigned(nr2_mantissa) - unsigned(nr1_mantissa)));
                    res_sgn <= not nr1_sgn;
               end if;
            end if;        
        end if;
    end process;
end Behavioral;

