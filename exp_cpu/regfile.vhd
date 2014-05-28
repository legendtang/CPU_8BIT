library ieee;
use ieee.std_logic_1164.all;
use work.exp_cpu_components.all;

entity regfile is
port (  DR: 	  in std_logic_vector(1 downto 0);  --源寄存器号
		SR: 	  in std_logic_vector(1 downto 0);  --目的寄存器号   
		reset: 	  in std_logic;
		write: 	  in std_logic;	--写寄存器信号                           
		clk:	  in std_logic;	
		d_input:  in  std_logic_vector(7 downto 0);  --写寄存器的数据
		change_z: in std_logic;			--如果为1，则重新设置z标志
		change_c: in std_logic;
	       c_in:     in std_logic;
	       z_in:     in std_logic;
		R0,R1,R2,R3: out std_logic_vector(7 downto 0);--调试用
		output_DR:   out std_logic_vector(7 downto 0);        
		output_SR:   out std_logic_vector(7 downto 0);
		c_out:	     out std_logic;
		z_out:	     out std_logic;  
        c_flag: 	out std_logic;
        z_flag: 	out std_logic 
	  );
end regfile;


architecture struct of regfile is
signal reg00, reg01, reg02,reg03: std_logic_vector(7 downto 0);
signal sel00, sel01, sel02, sel03: std_logic;

begin
R0 <= reg00;--调试用
R1 <= reg01;--调试用
R2 <= reg02;--调试用
R3 <= reg03;--调试用

z_c_proc: process(reset,clk)  --对指令执行结束后的z、c标志进行处理
begin
   if reset = '0' then
		z_out <= '0';
		c_out <= '0';
	elsif clk'event and clk = '0' then
	    if change_z = '1' then
			z_out <= z_in;
        end if;
		if change_c = '1' then
			c_out <= c_in;
        end if;
	end if;
end process;

Areg00: reg port map(				--寄存器R0
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel00,	
		q_output	=> reg00
		);

Areg01: reg port map(				--寄存器R1
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel01,	
		q_output	=> reg01	
		);

Areg02: reg port map(				--寄存器R2
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel02,	
		q_output	=>  reg02
		);

Areg03: reg port map(				--寄存器R3
		reset		=> reset,
		d_input		=> d_input,
		clk			=> clk,		
		write		=> write,
	    sel			=> sel03,	
		q_output	=> reg03
		);

des_decoder: decoder_2_to_4 port map(	--2 — 4译码器
		sel 	=> DR,
    	sel00 	=> sel00,
		sel01 	=> sel01,
		sel02 	=> sel02,
		sel03 	=> sel03 
		);

muxB: mux_4_to_1 port map(				--目的寄存器读出4选1选择器
		input0  => reg00,
    	input1  => reg01,
		input2  => reg02,
		input3  => reg03,
		sel     => DR,
		output => output_DR
		);
	
muxA: mux_4_to_1 PORT MAP(				--源寄存器读出4选1选择器
		input0 	=> reg00,
   	 	input1 	=> reg01,
		input2 	=> reg02,
		input3 	=> reg03,
		sel 	=> SR,
		output => output_SR
		);

end struct;