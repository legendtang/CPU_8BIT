library ieee;
use ieee.std_logic_1164.all;

package exp_cpu_components is
    component reg
    port (reset : in std_logic;
          d_input : in std_logic_vector (7 downto 0);
          clk : in std_logic;
          write : in std_logic;
          sel : in std_logic;
          q_output : out std_logic_vector (7 downto 0));
    end component;

    component mux_4_to_1
    port (input0, input1,
          input2, input3 : in std_logic_vector (7 downto 0);
          sel : in std_logic_vector (1 downto 0);
          output : out std_logic_vector (7 downto 0));
    end component;

    component decoder_2_to_4
    port (sel : in std_logic_vector (1 downto 0);
          sel00 : out std_logic;
          sel01 : out std_logic;
          sel02 : out std_logic;
          sel03 : out std_logic);
    end component;

    component regfile
    port (dr : in std_logic_vector (1 downto 0);
          sr : in std_logic_vector (1 downto 0);
          reset : in std_logic;
          write : in std_logic;
          clk : in std_logic;
          d_input : in std_logic_vector (7 downto 0);
          change_z : in std_logic;
          change_c : in std_logic;
          c_in : in std_logic;
          z_in : in std_logic;
          output_dr : out std_logic_vector (7 downto 0);
          output_sr : out std_logic_vector (7 downto 0);
          r0, r1, r2, r3 : out std_logic_vector (7 downto 0);
          c_out : out std_logic;
          z_out : out std_logic;
          c_flag : out std_logic;
          z_flag : out std_logic
          );
    end component;

    component instru_fetch
    port (reset : in std_logic;
          clk : in std_logic;
          data_read : in std_logic_vector (7 downto 0);
          lj_instruct : in std_logic;
          dw_instruct : in std_logic;
          c_z_j_flag : in std_logic;
          sjmp_addr : in std_logic_vector (7 downto 0);
          t1 ,t2, t3 : buffer std_logic;
          pc : buffer std_logic_vector (7 downto 0);
          pc_inc : buffer std_logic_vector (7 downto 0);
          ir : out std_logic_vector (7 downto 0)
          );
    end component;

    component decoder_unit
    port (ir : in std_logic_vector (7 downto 0);
          sr : out std_logic_vector (1 downto 0);
          dr : out std_logic_vector (1 downto 0);
          op_code : out std_logic_vector (2 downto 0);
          zj_instruct : out std_logic;
          cj_instruct : out std_logic;
          lj_instruct : out std_logic;
          drwr : buffer std_logic;
          mem_write : out std_logic;
          dw_instruct : buffer std_logic;
          change_z : out std_logic;
          change_c : out std_logic;
          sel_memdata : out std_logic;
          r_sjmp_addr : out std_logic_vector (7 downto 0)
          );
    end component;

    component exe_unit
    port (t1 : in std_logic;
          op_code : in std_logic_vector (2 downto 0);
          zj_instruct : in std_logic;
          cj_instruct : in std_logic;
          pc : in std_logic_vector (7 downto 0);
          pc_inc : in std_logic_vector (7 downto 0);
          c_in : in std_logic;
          z_in : in std_logic;
          mem_write : in std_logic;
          c_tmp : out std_logic;
          z_tmp : out std_logic;
          c_z_j_flag : out std_logic;
          r_sjmp_addr : in std_logic_vector (7 downto 0);
          dw_instruct : in std_logic;
          sjmp_addr : out std_logic_vector (7 downto 0);
          sr_data : in std_logic_vector (7 downto 0);
          dr_data : in std_logic_vector (7 downto 0);
          mem_addr : out std_logic_vector (7 downto 0);
          result : out std_logic_vector (7 downto 0));
    end component;

    component memory_unit
    port (reset : in std_logic;
          clk, t3 : in std_logic;
          mem_addr : in std_logic_vector (7 downto 0);
          mem_write : in std_logic;
          sel_memdata : in std_logic;
          sr_data : in std_logic_vector (7 downto 0);
          result : in std_logic_vector (7 downto 0);
          rw : out std_logic;
          ob : inout std_logic_vector (7 downto 0);
          ar : out std_logic_vector (7 downto 0);
          data_read : buffer std_logic_vector (7 downto 0);
          dr_data_out : out std_logic_vector (7 downto 0));
    end component;
end exp_cpu_components;

