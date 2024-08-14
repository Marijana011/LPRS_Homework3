
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- Libraries.

entity lprs1_homework3 is
	port(
		i_clk            :  in std_logic;
		i_rst            :  in std_logic;
		i_base           :  in std_logic_vector(1 downto 0);
		i_sequence       :  in std_logic_vector(63 downto 0);
		i_load_sequence  :  in std_logic;
		i_base_src_sel   :  in std_logic;
		i_cnt_subseq_sel :  in std_logic_vector(1 downto 0);
		o_cnt_subseq     : out std_logic_vector(3 downto 0)
	);
end entity;


architecture arch of lprs1_homework3 is
	-- Constants.
	constant A : std_logic_vector(1 downto 0) := "00";
	constant C : std_logic_vector(1 downto 0) := "01";
	constant G : std_logic_vector(1 downto 0) := "10";
	constant T : std_logic_vector(1 downto 0) := "11";
	
	---Automat---
	type tSTATE is (IDLE, C0S012, C0A1, C0G1, C0A1A2, C0A1C2, C0G1A2);
	signal s_state, s_next_state : tSTATE;
	
	---Brojaci---
	signal s_cnt_subseq0 : std_logic_vector(3 downto 0);
	signal s_en_subseq0 : std_logic;
	signal s_cnt_subseq1 : std_logic_vector(3 downto 0);
	signal s_en_subseq1 : std_logic;
	signal s_cnt_subseq2 : std_logic_vector(3 downto 0);
	signal s_en_subseq2 : std_logic;
	
	
	signal s_base : std_logic_vector(1 downto 0);
	signal s_sh_base : std_logic_vector(1 downto 0);
	signal s_sh_reg : std_logic_vector(63 downto 0);
	signal s_n_sh_reg : std_logic_vector(63 downto 0);
	
	-- Signals.
	
begin
	-- Body.
	
	----Automat----
	process(i_clk) begin
		if(i_clk'event and i_clk = '1') then
			if(i_rst = '1') then
				s_state <= IDLE;
			else
				s_state <= s_next_state;
			end if;
		end if;
	end process;
	
	process(s_state, s_base) begin
		case s_state is
			when IDLE =>
				if(s_base = C) then
					s_next_state <= C0S012;
				else
					s_next_state <= IDLE;
				end if;			
			when C0S012 =>
				if(s_base = A) then	
					s_next_state <= C0A1;
				elsif(s_base = G) then
					s_next_state <= C0G1;
				else
					s_next_state <= IDLE;
				end if;
			when C0A1 =>
				if(s_base = A) then	
					s_next_state <= C0A1A2;
				elsif(s_base = C) then
					s_next_state <= C0A1C2;
				else
					s_next_state <= IDLE;
				end if;
			when C0G1 =>
				if(s_base = A) then
					s_next_state <= C0G1A2;
				else
					s_next_state <= IDLE;
				end if;
			when C0A1A2 =>
				if(s_base = C) then
					s_next_state <= C0S012;
				else
					s_next_state <= IDLE;
				end if;
			when C0A1C2 =>
				if(s_base = C) then
					s_next_state <= C0S012;
				else
					s_next_state <= IDLE;
				end if;
			when C0G1A2 =>
				if(s_base = C) then
					s_next_state <= C0S012;
				else
					s_next_state <= IDLE;
				end if;
			when others =>
				s_next_state <= IDLE;
		end case;
	end process;
	
	s_en_subseq0 <= '1' when s_state = C0A1A2 else '0';
	s_en_subseq1 <= '1' when s_state = C0A1C2 else '0';
	s_en_subseq2 <= '1' when s_state = C0G1A2 else '0';
	
	
	----Brojac 0. (SINHRONI) podsekvence----
	process(i_clk) begin
		if(i_clk'event and i_clk = '1') then
			if(i_rst = '1') then
				s_cnt_subseq0 <= (others => '0');
			elsif(s_en_subseq0 = '1') then
					if(s_cnt_subseq0 = 7) then
						s_cnt_subseq0 <= (others => '0');
					else
						s_cnt_subseq0 <= s_cnt_subseq0 + 1;	
					end if;	
			end if;
		end if;
	end process;	
	
	----Brojac 1. (SINHRONI) podsekvence----
	process(i_clk) begin
		if(i_clk'event and i_clk = '1') then
			if(i_rst = '1') then
				s_cnt_subseq1 <= (others => '0');
			elsif(s_en_subseq1 = '1') then
					if(s_cnt_subseq1 = 6) then
						s_cnt_subseq1 <= (others => '0');
					else
						s_cnt_subseq1 <= s_cnt_subseq1 + 1;	
					end if;	
			end if;
		end if;
	end process;
	
	----Brojac 2. podsekvence (ASINHRONI)----
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt_subseq2 <= (others => '0');
		elsif(i_clk'event and i_clk = '1') then
			if(s_en_subseq2 = '1') then
				if(s_cnt_subseq2 = 4) then
					s_cnt_subseq2 <= (others => '0');
				else
					s_cnt_subseq2 <= s_cnt_subseq2 + 1;
				end if;
			end if;
		end if;
	end process;
	
	----MUX (when-else)----
	o_cnt_subseq <= s_cnt_subseq0 when i_cnt_subseq_sel = "00" else
						 s_cnt_subseq1 when i_cnt_subseq_sel = "01" else
						 s_cnt_subseq2 when i_cnt_subseq_sel = "10" else
						 "0000";
						 
	----MUX (when-else)----			
	s_base <= i_base when i_base_src_sel = '0' else
				 s_sh_base when i_base_src_sel = '1' else
				 "00";
	
	
	----Registar (ASINHRONI)----
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_sh_base <= (others => '0');
		elsif(i_clk'event and i_clk = '1') then
			s_sh_base <= s_sh_reg(1 downto 0);
		end if;
	end process;
	
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_sh_reg <= (others => '0');
		elsif(i_clk'event and i_clk = '1') then
			s_sh_reg <= s_n_sh_reg;
		end if;
	end process;
	
	----Kombinacioni deo----
	process(i_load_sequence, i_sequence) begin
		case(i_load_sequence) is
			 when '1' => s_n_sh_reg <= i_sequence;
			 when others => s_n_sh_reg <= "00" & s_sh_reg(63 downto 2);
		end case;
	end process;
end architecture;
