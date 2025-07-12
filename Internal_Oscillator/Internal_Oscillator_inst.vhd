	component Internal_Oscillator is
		port (
			clkout : out std_logic;        -- clk
			oscena : in  std_logic := 'X'  -- oscena
		);
	end component Internal_Oscillator;

	u0 : component Internal_Oscillator
		port map (
			clkout => CONNECTED_TO_clkout, -- clkout.clk
			oscena => CONNECTED_TO_oscena  -- oscena.oscena
		);

