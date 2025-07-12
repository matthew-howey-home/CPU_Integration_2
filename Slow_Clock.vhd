library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Slow_Clock is
    Port (
        clk      	  : in  std_logic;
        slow_clock  : out std_logic
    );
end Slow_Clock;

architecture Behavioral of Slow_Clock is
    signal prescaler : unsigned(25 downto 0) := (others => '0');
    signal prev_bit  : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            prescaler <= prescaler + 1;
				if (prev_bit = '0') and (prescaler(25) = '1') then
					slow_clock <= '1';
				else
					slow_clock <= '0';
				end if;
            prev_bit <= prescaler(25);
        end if;
    end process;
end Behavioral;