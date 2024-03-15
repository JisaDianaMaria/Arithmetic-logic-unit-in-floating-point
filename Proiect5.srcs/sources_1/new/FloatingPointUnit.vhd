----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2024 11:29:57
-- Design Name: 
-- Module Name: FloatingPointUnit - Behavioral
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

entity FloatingPointUnit is
    port(
        clk, rst, start, op : in std_logic;
        nr1, nr2 : in std_logic_vector(31 downto 0);
        done : out std_logic;
        res : out std_logic_vector(31 downto 0)
    );
end FloatingPointUnit;

architecture Behavioral of FloatingPointUnit is
    signal next_state, next_state_wait, next_state_align, next_state_operation, next_state_normalize, next_state_rounding: ST;
    signal state : ST := WAIT_ST;
    
    -- Semnale intermediare
    signal nr1_sgn, nr2_sgn, res_sgn : std_logic;
    signal nr1_exp, nr2_exp, res_exp : std_logic_vector(8 downto 0);
    signal nr1_mantissa, nr2_mantissa, aligned_nr1_mantissa, aligned_nr2_mantissa, res_mantissa, res_mantissa_out : std_logic_vector(24 downto 0);
    signal res_out : std_logic_vector(31 downto 0);
    signal rounding_done : std_logic;
    signal res_exp_out : std_logic_vector(8 downto 0);

begin
    WaitStateInst: entity work.WaitState
        port map(
            clk => clk,
            rst => rst,
            start => start,
            nr1 => nr1,
            nr2 => nr2,
            nr1_sgn => nr1_sgn,
            nr2_sgn => nr2_sgn,
            nr1_exp => nr1_exp,
            nr2_exp => nr2_exp,
            nr1_mantissa => nr1_mantissa,
            nr2_mantissa => nr2_mantissa,
            next_state => next_state_wait
        );

    AlignStateInst: entity work.AlignState
        port map(
            clk => clk,
            rst => rst,
            nr1_exp => nr1_exp,
            nr2_exp => nr2_exp,
            nr1_mantissa => nr1_mantissa,
            nr2_mantissa => nr2_mantissa,
            aligned_nr1_mantissa => aligned_nr1_mantissa,
            aligned_nr2_mantissa => aligned_nr2_mantissa,
            res_exp => res_exp,
            next_state => next_state_align
        );

    OperationStateInst: entity work.OperationState
        port map(
            clk => clk,
            rst => rst,
            op => op,
            nr1_sgn => nr1_sgn,
            nr2_sgn => nr2_sgn,
            nr1_mantissa => aligned_nr1_mantissa,
            nr2_mantissa => aligned_nr2_mantissa,
            res_sgn => res_sgn,
            res_mantissa => res_mantissa,
            next_state => next_state_operation
        );

    NormalizeStateInst: entity work.NormalizeState
        port map(
            clk => clk,
            rst => rst,
            res_mantissa_in => res_mantissa,
            res_exp_in => res_exp,
            res_mantissa_out => res_mantissa_out,
            res_exp_out => res_exp_out,
            next_state => next_state_normalize
        );

    RoundingStateInst: entity work.RoundingState
        port map(
            clk => clk,
            rst => rst,
            start => start,
            res_mantissa_in => res_mantissa_out,
            res_exp_in => res_exp_out,
            res_sgn => res_sgn,
            res => res_out,
            done => rounding_done,
            next_state => next_state_rounding
        );

    StateControl: process(clk, rst)
    begin
        if rst = '1' then
            state <= WAIT_ST;
        elsif rising_edge(clk) then
            case state is
               when WAIT_ST =>
                   state <= next_state_wait;
               when ALIGN =>
                    state <= next_state_align;
               when OPERATION =>
                    state <= next_state_operation;
               when NORMALIZE =>
                    state <= next_state_normalize;
               when ROUNDING =>
                    state <= next_state_rounding;
               when others =>
                   state <= WAIT_ST;
                end case;
        end if;
    end process;

    FinalLogic: process(clk)
    begin
        if rising_edge(clk) then
            if rounding_done = '1' then
                done <= '1';
                res <= res_out;
            else
                done <= '0';
            end if;
        end if;
    end process;

end Behavioral;
