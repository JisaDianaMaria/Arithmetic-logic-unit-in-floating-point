----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2023 23:53:58
-- Design Name: 
-- Module Name: aabc - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FloatingPointUnit_sim is
end FloatingPointUnit_sim;

architecture Behavioral of FloatingPointUnit_sim is
-- Signals for testbench
    signal A, B : std_logic_vector(31 downto 0);
    signal clk, reset, start, op : std_logic;
    signal done : std_logic;
    signal res : std_logic_vector(31 downto 0);

begin
    -- Instantiate the aab entity
    uut: entity work.FloatingPointUnit
        port map (
            clk => clk,
            rst => reset,
            start => start,
            op => op,
            nr1 => A,
            nr2 => B,
            done => done,
            res => res 
        );

    -- Clock generation
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        op <= '0';
        A <= "11000000110010000000000000000000"; -- 6.25
        B <= "01000000100001011100001010001111";  -- 4.179999828338623046875
        
        --A <= "11000001100001000000000000000000";  --16.5
        --B <= "11000010000011110000000000000000";  --35.75

        --A <= "00111111010000000000000000000000"; --0.75
        --B <= "00111110011011111001110110110010"; --0.2339999973773956298828125
        
        --A <= "01000100100000110000111110010110"; --1048.487060546875
        --B <= "11000110000101010110101111110010"; --9562.986328125
        
        --A <= "01000000011000000000000000000000"; --3.5
        --B <= "01000000011000000000000000000000";
        
        --A <= "01000110001110101101000001111011"; --11956.1201171875
        --B <= "00111110111001100110011001100110"; --0.45
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        start <= '1';
        wait for 100 ns;
        start <= '0';
        wait for 500 ns;
        assert done = '1' report "Error: Result is not ready." severity error;
        wait;
    end process;
end Behavioral;
