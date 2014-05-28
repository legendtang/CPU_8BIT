library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.exp_cpu_components.all;

entity exe_unit is
	port(
	  	t1 : in std_logic;
		op_code : in std_logic_vector(2 downto 0);
		zj_instruct : in std_logic;
	  	cj_instruct : in std_logic;
	    pc : in std_logic_vector(7 downto 0);
		pc_inc : in std_logic_vector(7 downto 0);
		c_in : in std_logic;  --以前指令产生的进位C
	    z_in : in std_logic;  --以前指令产生的Z
		Mem_Write : in std_logic;  --为1时，写存储器
		c_tmp : out std_logic;
		z_tmp : out std_logic;
		c_z_j_flag : out std_logic; --为1时进行条件转移
		r_sjmp_addr : in std_logic_vector(7 downto 0); --相对转移地址
		DW_instruct : in std_logic;
		sjmp_addr : out std_logic_vector(7 downto 0); --条件转移指令的转移地址
		SR_data : in std_logic_vector(7 downto 0);
		DR_data : in std_logic_vector(7 downto 0);
		Mem_Addr : out std_logic_vector(7 downto 0);
		result : out std_logic_vector(7 downto 0)  --运算结果
	    );

end exe_unit;

architecture behav of exe_unit is
signal A, B : std_logic_vector(7 downto 0);
signal result_t : std_logic_vector(8 downto 0);

begin
c_z_j_flag <= ((not c_in) and cj_instruct) or
              ((not z_in) and zj_instruct) ;

A <= DR_data;
B <= SR_data;

sjmp_addr <= pc_inc + r_sjmp_addr;	

Mem_Addr_proc : process(t1, SR_data, pc, dw_instruct)
begin
	if t1 = '1' then
		Mem_Addr <= pc;
	else
		if dw_instruct = '1' then
			Mem_Addr <= pc_inc;
		elsif Mem_Write = '1' then
			Mem_Addr <= DR_data;
		else
			Mem_Addr <= SR_data;
		end if;
	end if;
end process;

alu_proc : process(op_code, A, B)
begin
	case op_code is
		when "000" => 
			result_t <= ('0' & A) + ('0' & B);
        when "111" => 
            result_t <= ('0' & B);
		when others=>
			result_t <= ('0' & A);
	end case;
end process;

result <= result_t(7 downto 0);
c_tmp <= result_t(8);
z_tmp <= (not result_t(7)) and (not result_t(6)) and
		 (not result_t(5)) and (not result_t(4)) and
		 (not result_t(3)) and (not result_t(2)) and
		 (not result_t(1)) and (not result_t(0));

end behav;

