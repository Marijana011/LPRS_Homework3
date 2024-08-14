
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity lprs1_homework3_tb is
end entity;

architecture arch of lprs1_homework3_tb is
	-- Constants.
	constant A : std_logic_vector(1 downto 0) := "00";
	constant C : std_logic_vector(1 downto 0) := "01";
	constant G : std_logic_vector(1 downto 0) := "10";
	constant T : std_logic_vector(1 downto 0) := "11";
	
	
	constant i_clk_period : time := 10 ns;
	
	signal i_clk            : std_logic;
	signal i_rst            : std_logic;
	signal i_base           : std_logic_vector(1 downto 0);
	signal i_sequence       : std_logic_vector(63 downto 0);
	signal i_load_sequence  : std_logic;
	signal i_base_src_sel   : std_logic;
	signal i_cnt_subseq_sel : std_logic_vector(1 downto 0);
	signal o_cnt_subseq     : std_logic_vector(3 downto 0);
	
begin
	
	uut: entity work.lprs1_homework3
	port map(
		i_clk            => i_clk,
		i_rst            => i_rst,
		i_base           => i_base,
		i_sequence       => i_sequence,
		i_load_sequence  => i_load_sequence,
		i_base_src_sel   => i_base_src_sel,
		i_cnt_subseq_sel => i_cnt_subseq_sel,
		o_cnt_subseq     => o_cnt_subseq
	);
	
	clk_p: process
	begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
	end process;
	
	stim_p: process
	begin
		-- Test cases:
	
		for i in 0 to 63 loop
			i_sequence(i) <= '0';
		end loop;
		
		i_load_sequence <= '1';
		i_base_src_sel <= '0';
		i_cnt_subseq_sel <= "00";
		i_rst <= '0';
		
		--a)
		----CGGT----
		i_base <= C;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		----TACG----
		i_base <= T;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;
	
		i_cnt_subseq_sel <= "01"; ---1. Brojac posle 7 vrednosti---
		
		i_base <= G;
		wait for i_clk_period;
		
		----ACGG----
		i_base <= A;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		
		----GATC----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		
		----CCCG----
		i_base <= C;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		
		----TCCT----
		i_base <= T;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		----GTCT----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		----CGCT----
		i_base <= C;
		wait for i_clk_period;	
		
		i_cnt_subseq_sel <= "00";
		
		i_base <= G;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		wait for i_clk_period;---Posle kraja sekvence sacekati 1 takt---
		
		i_cnt_subseq_sel <= "01";
		
		---Ucitaj sekvencu---
		i_load_sequence <= '1';
		i_base_src_sel <= '0';
		
		
		---Reset i_seq---
		for i in 0 to 63 loop
			i_sequence(i) <= '0';
		end loop;
		
		i_base_src_sel <= '0';
		i_cnt_subseq_sel <= "00";
		
		i_rst <= '1';
		wait for 14 * i_clk_period;
		i_rst <= '0';
		
		
		--b)
		----GTCA----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		i_base <= C;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		
		----CCGT----
		i_base <= C;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		----GTAA----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		
		----GATT----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		----GGTA----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		i_base <= T;
		wait for i_clk_period;	
		i_base <= A;
		wait for i_clk_period;
		
		----GTAC----
		i_base <= G;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		
		
		i_cnt_subseq_sel <= "01";
		
		i_base <= A;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		
		----ATGC----
		i_base <= A;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		i_base <= G;
		wait for i_clk_period;	
		i_base <= C;
		wait for i_clk_period;
		
		
		----CTAG----
		i_base <= C;
		wait for i_clk_period;	
		i_base <= T;
		wait for i_clk_period;
		i_base <= A;
		wait for i_clk_period;	
		i_base <= G;
		wait for i_clk_period;
		
		
		i_load_sequence <= '0';
		i_base_src_sel <= '0';
		
		
		---Reset i_seq---
		for i in 0 to 63 loop
			i_sequence(i) <= '0';
		end loop;
			
		i_rst <= '1';
		wait for 14 * i_clk_period;
		i_rst <= '0';
		
		i_load_sequence <= '0';
		i_base_src_sel <= '0';
		i_cnt_subseq_sel <= "00";
		i_rst <= '1';
		i_base <= "00";
		
		
		
		i_rst <= '1';
		wait for 3.25 * i_clk_period;
		i_rst <= '0';
		
		
		wait;
	end process;
end architecture;
