library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
    generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 18
    );
    port (
        clk      				: in  std_logic;
        write_enable       : in  std_logic; -- active low, 0 means enable
		  read_enable  		: in  std_logic; -- active low, 0 means enable
        address  				: in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        data_in  				: in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        data_out 				: out std_logic_vector(DATA_WIDTH - 1 downto 0)
    );
end entity RAM;

architecture Behavioral of RAM is
    -- Define memory type
    type ram_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Example program initialization
    constant INIT_MEM : ram_type := (
        16#0000# => x"00",  -- LD A, 0x42
        16#0001# => x"00",
        16#0002# => x"00",  -- LD B, 0x05
        16#0003# => x"00",
        16#0004# => x"00",  -- NOP
        16#0005# => x"00",  -- HALT
        others   => (others => '0')  -- Fill rest with zero
    );

    -- Internal memory initialized with program
    signal RAM : ram_type := INIT_MEM;
	 
	 signal read_data : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin
    -- Synchronous write
    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '0' then
                RAM(to_integer(unsigned(address))) <= data_in;
            end if;
        end if;
    end process;

    -- Combinational read
    read_data <= RAM(to_integer(unsigned(address)));

    -- Tri-state bus drive logic (read_enable is active low, so 0 means enable)
    data_out <= read_data when read_enable = '0' else (others => 'Z');

end architecture Behavioral;