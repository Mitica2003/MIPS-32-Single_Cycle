library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port( sw : in STD_LOGIC_VECTOR(7 downto 0);
          btn : in STD_LOGIC_VECTOR(4 downto 0);
          clk : in STD_LOGIC;
          cat : out STD_LOGIC_VECTOR(6 downto 0);
          an : out STD_LOGIC_VECTOR(7 downto 0);
          led : out STD_LOGIC_VECTOR (15 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component iFetch is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           branch_address : in STD_LOGIC_VECTOR(31 downto 0);
           pc_src : in STD_LOGIC;         
           jump_address : in STD_LOGIC_VECTOR(31 downto 0);
           jump : in STD_LOGIC;
           pc : out STD_LOGIC_VECTOR(31 downto 0);
           instruction : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component ID is
    Port(RD1 : out std_logic_vector(31 downto 0);
        RD2 : out std_logic_vector(31 downto 0);
        Ext_Imm : out std_logic_vector(31 downto 0);
        func : out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0);
        WD : in std_logic_vector(31 downto 0);
        Instr : in std_logic_vector(25 downto 0);
        clk:in std_logic;
        en: in std_logic;
        regWrite: in std_logic;
        regDst: in std_logic;
        ExtOp: in std_logic);
end component;

component UC is
    Port (Instr : in STD_LOGIC_VECTOR(5 downto 0);
          RegDst : out STD_LOGIC;
          ExtOp : out STD_LOGIC;
          ALUSrc : out STD_LOGIC;
          Branch : out STD_LOGIC;
          Br_ne: out STD_LOGIC;
          Br_gtz: out STD_LOGIC;
          Jump : out STD_LOGIC;
          ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
          MemWrite : out STD_LOGIC;
          MemtoReg : out STD_LOGIC;
          RegWrite : out STD_LOGIC);
end component;

component EX is
    Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_imm : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           PC : in STD_LOGIC_VECTOR (31 downto 0);
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           GTZ: out STD_LOGIC);
end component;

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal WD : STD_LOGIC_VECTOR(31 downto 0);
signal FuncExt : STD_LOGIC_VECTOR(31 downto 0);
signal RegDst : STD_LOGIC;
signal ExtOp : STD_LOGIC;
signal ALUSrc : STD_LOGIC;
signal Branch : STD_LOGIC;
signal Br_ne: STD_LOGIC;
signal Br_gtz: STD_LOGIC;
signal Jump : STD_LOGIC;
signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
signal MemWrite : STD_LOGIC;
signal MemtoReg : STD_LOGIC;
signal RegWrite : STD_LOGIC;
signal PCSrc : STD_LOGIC;
signal en : STD_LOGIC;
signal ALURes : STD_LOGIC_VECTOR(31 downto 0);
signal BranchAddress : STD_LOGIC_VECTOR(31 downto 0);
signal Zero : STD_LOGIC;
signal Gtz: STD_LOGIC;
signal JumpAddress : STD_LOGIC_VECTOR(31 downto 0);  
signal MemData : STD_LOGIC_VECTOR(31 downto 0);
signal ALUResOut : STD_LOGIC_VECTOR(31 downto 0);
signal Instruction : STD_LOGIC_VECTOR(31 downto 0);
signal RD1 : STD_LOGIC_VECTOR(31 downto 0);
signal Func : STD_LOGIC_VECTOR(5 downto 0);
signal RD2 : STD_LOGIC_VECTOR(31 downto 0);
signal Ext_imm : STD_LOGIC_VECTOR(31 downto 0);
signal PC : STD_LOGIC_VECTOR(31 downto 0);
signal mux : STD_LOGIC_VECTOR(31 downto 0);
signal SAExt : STD_LOGIC_VECTOR(31 downto 0);
signal SA : STD_LOGIC_VECTOR(4 downto 0);

begin

    monoPulseGenerator : MPG port map (en, btn(0), clk);
    
    extragere_instructiuni : iFetch port map (clk, btn(1), en, BranchAddress, PCSrc, JumpAddress, Jump, PC, Instruction);

    JumpAddress <= PC(31 downto 28) & Instruction(25 downto 0) & "00";
    
    PCSrc <= (Branch AND Zero) OR (Br_ne AND NOT(Zero)) OR (Br_gtz AND Gtz);
    
    control : UC port map (Instruction(31 downto 26), RegDst, ExtOp, ALUSrc, Branch, Br_ne, Br_gtz, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    
    led(11 downto 0) <= RegDst & ExtOp & ALUSrc & Branch & Br_ne & Br_gtz & Jump & ALUOp & MemWrite & MemtoReg & RegWrite;  
    
    decodificare : ID port map (RD1, RD2, Ext_imm, Func, SA, WD, Instruction(25 downto 0), clk, en, RegWrite, RegDst, ExtOp);
    
    unitateDeExecutie : EX port map(RD1, RD2, Ext_imm, ALUSrc, SA, Func, ALUOp, PC, ALURes, BranchAddress, Zero, Gtz);
    
    unitateDeMemorie : MEM port map(MemWrite, ALURes, RD2, clk, en, MemData, ALUResOut);
    
    --unitatea de writeBack
    with MemtoReg SELECT 
        WD <= ALUResOut when '0',
              MemData when '1',
              (others => 'X') when others;
    
    with sw(7 downto 5) SELECT
        mux <= Instruction when "000",
               PC when "001",
               RD1 when "010",
               RD2 when "011",
               Ext_imm when "100",
               ALURes when "101",
               MemData when "110",
               WD when "111",
               (others => 'X') when others;
    
    afisor : SSD port map (clk, mux, an, cat);
    
end Behavioral;

