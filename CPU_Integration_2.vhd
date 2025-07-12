library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU_Integration_2 is

    Port (
        oscena : in std_logic := '1';
		  reset	: in std_logic;
        leds   : out std_logic_vector(7 downto 0)
    );
end CPU_Integration_2;

architecture Behavioral of CPU_Integration_2 is

    signal clk_int   : std_logic;
    signal slow_clock_out : std_logic;
	 signal memory_out	: std_logic_vector(7 downto 0);
	 signal memory_address: std_logic_vector(15 downto 0);
	 signal memory_read_enable: std_logic;
	 signal not_memory_read_enable: std_logic;
	 signal memory_write_enable: std_logic;
	 signal not_memory_write_enable: std_logic;
	 signal Memory_Data_Out: std_logic_vector(7 downto 0);
	 signal A_Reg_External_Output: std_logic_vector(7 downto 0);
	 signal X_Reg_External_Output: std_logic_vector(7 downto 0);
	 signal Y_Reg_External_Output: std_logic_vector(7 downto 0);

    component Internal_Oscillator
        port (
            oscena : in  std_logic;
            clkout : out std_logic
        );
    end component;

    component Slow_Clock
        port (
            clk      : in  std_logic;
            slow_clock  : out std_logic
        );
    end component;
	 
	 component RAM
			generic (
				DATA_WIDTH : integer := 8;
				ADDR_WIDTH : integer := 16
			);
			port (
				clk      		: in  std_logic;
				write_enable   : in  std_logic;
				read_enable   	: in  std_logic;
				address     	: in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
				data_in  		: in  std_logic_vector(DATA_WIDTH - 1 downto 0);
				data_out 		: out std_logic_vector(DATA_WIDTH - 1 downto 0)
			);
	 end component;
	 
	 component CPU is
		port (
			Clock						: in std_logic; -- fast clock used for rising edge in registers
			Slow_Clock				: in std_logic; -- all inputs will be enabled only when Slow Clock is on
			Reset						: in std_logic;

			Memory_In				: in std_logic_vector(7 downto 0);
	

			Memory_Out_Low			: out std_logic_vector(7 downto 0);
			Memory_Out_High		: out std_logic_vector(7 downto 0);
			Memory_Read_Enable	: out std_logic;
			Memory_Write_Enable	: out std_logic;
			Memory_Data_Out		: out std_logic_vector(7 downto 0);

			A_Reg_External_Output	: out std_logic_vector(7 downto 0);
			X_Reg_External_Output	: out std_logic_vector(7 downto 0);
			Y_Reg_External_Output	: out std_logic_vector(7 downto 0)
		);
	end component;

begin

    -- Internal oscillator
    u_osc: Internal_Oscillator
        port map (
            oscena => oscena,
            clkout => clk_int
        );

    -- Clock divider
    u_slow_clock: Slow_Clock
        port map (
            clk     => clk_int,
            slow_clock => slow_clock_out
        );

 
		
		not_memory_read_enable <= not memory_read_enable;
		not_memory_write_enable <= not memory_write_enable;
		
		-- RAM:
		u_ram: RAM
		  port map (
				clk				=> clk_int,
				read_enable 	=> not_memory_read_enable, -- active low so invert!
				write_enable 	=> not_memory_write_enable, -- active low so invert!
				address			=> memory_address,
				data_in 			=> (7 downto 0 => '0'),
				data_out			=> memory_out
		  );
	  
	  u_cpu: CPU
		port map (
			Clock			=> clk_int,
			Slow_Clock	=> slow_clock_out,
			Reset			=> reset,

			Memory_In	=> memory_out,
	

			Memory_Out_Low			=> memory_address(7 downto 0),	
			Memory_Out_High		=> memory_address(15 downto 8),
			Memory_Read_Enable	=> memory_read_enable,
			Memory_Write_Enable	=> memory_write_enable,
			Memory_Data_Out		=> Memory_Data_Out,

			A_Reg_External_Output	=> A_Reg_External_Output,
			X_Reg_External_Output	=> X_Reg_External_Output,
			Y_Reg_External_Output	=> Y_Reg_External_Output
		);

    -- leds <= not count;
	 leds <= not memory_out;

end Behavioral;