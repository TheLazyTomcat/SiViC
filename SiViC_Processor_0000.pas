unit SiViC_Processor_0000;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Instructions,
  SiViC_Processor,
  SiViC_Processor_Base;

const
  // CPU info
  SVC_PCS_INFOPAGE_CPU_REVISION = $0002;

type
  TSVCProcessor_0000 = class(TSVCProcessor_Base)
  protected
    // processor info engine
    Function GetInfoPage(Page: TSVCProcessorInfoPage; Param: TSVCProcessorInfoData): TSVCProcessorInfoData; override;
    // instruction decoding
    procedure PrefixSelect(Prefix: TSVCInstructionPrefix); override;
    procedure InstructionSelect_L1(InstructionByte: TSVCByte); override;
    procedure InstructionSelect_L2_D0(InstructionByte: TSVCByte); virtual;
    procedure InstructionSelect_L2_D1(InstructionByte: TSVCByte); virtual;
    procedure InstructionSelect_L2_D2(InstructionByte: TSVCByte); virtual;
    // repeat prefix helpers
    Function RepeatPrefixActive: Boolean; virtual;
    Function RepeatNextCycle: Boolean; virtual;
    // arithmetic and logical helpers
    Function FlaggedADD_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedADD_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedSUB_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedSUB_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedADC_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedADC_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedSBB_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedSBB_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedMUL_B(A,B: TSVCByte; out High: TSVCByte): TSVCByte; virtual;
    Function FlaggedMUL_W(A,B: TSVCWord; out High: TSVCWord): TSVCWord; virtual;
    Function FlaggedIMUL_B(A,B: TSVCSByte; out High: TSVCSByte): TSVCSByte; virtual;
    Function FlaggedIMUL_W(A,B: TSVCSWord; out High: TSVCSWord): TSVCSWord; virtual;
    Function FlaggedDIV_B(AL,AH,B: TSVCByte; out High: TSVCByte): TSVCByte; virtual;
    Function FlaggedDIV_W(AL,AH,B: TSVCWord; out High: TSVCWord): TSVCWord; virtual;
    Function FlaggedIDIV_B(AL,AH,B: TSVCSByte; out High: TSVCSByte): TSVCSByte; virtual;
    Function FlaggedIDIV_W(AL,AH,B: TSVCSWord; out High: TSVCSWord): TSVCSWord; virtual;
    Function FlaggedMOD_B(AL,AH,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedMOD_W(AL,AH,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedIMOD_B(AL,AH,B: TSVCSByte): TSVCSByte; virtual;
    Function FlaggedIMOD_W(AL,AH,B: TSVCSWord): TSVCSWord; virtual;
    Function FlaggedAND_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedAND_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedOR_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedOR_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedXOR_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedXOR_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedSHR_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedSHR_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedSAR_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedSAR_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedSHL_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedSHL_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedROR_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedROR_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedROL_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedROL_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedRCR_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedRCR_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedRCL_B(A: TSVCByte; Count: TSVCByte): TSVCByte; virtual;
    Function FlaggedRCL_W(A: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedSHRD_W(AL,AH: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    Function FlaggedSHLD_W(AL,AH: TSVCWord; Count: TSVCByte): TSVCWord; virtual;
    // instructions implementation
    procedure ImplementationXCHG_B; virtual;
    procedure ImplementationXCHG_W; virtual;
    procedure ImplementationINC_B; virtual;
    procedure ImplementationINC_W; virtual;
    procedure ImplementationDEC_B; virtual;
    procedure ImplementationDEC_W; virtual;
    procedure Instruction_50; virtual;    // LEA        reg16,  mem
    procedure Instruction_51; virtual;    // LEA        reg16,  rel8
    procedure Instruction_52; virtual;    // LEA        reg16,  rel16
    procedure Instruction_53; virtual;    // CMP        reg8,   imm8
    procedure Instruction_54; virtual;    // CMP        reg16,  imm16
    procedure Instruction_55; virtual;    // CMP        reg8,   reg8
    procedure Instruction_56; virtual;    // CMP        reg16,  reg16
    procedure Instruction_57; virtual;    // CMP        reg8,   mem8
    procedure Instruction_58; virtual;    // CMP        reg16,  mem16
    procedure Instruction_59; virtual;    // CMP        mem8,   reg8
    procedure Instruction_5A; virtual;    // CMP        mem16,  reg16
    procedure Instruction_5B; virtual;    // TEST       reg8,   imm8
    procedure Instruction_5C; virtual;    // TEST       reg16,  imm16
    procedure Instruction_5D; virtual;    // TEST       reg8,   reg8
    procedure Instruction_5E; virtual;    // TEST       reg16,  reg16
    procedure Instruction_5F; virtual;    // TEST       reg8,   mem8
    procedure Instruction_60; virtual;    // TEST       reg16,  mem16
    procedure Instruction_61; virtual;    // TEST       mem8,   reg8
    procedure Instruction_62; virtual;    // TEST       mem16,  reg16
    procedure Instruction_63; virtual;    // JMP        rel8
    procedure Instruction_64; virtual;    // JMP        rel16
    procedure Instruction_65; virtual;    // JMP        reg16
    procedure Instruction_66; virtual;    // JMP        mem16
    procedure Instruction_67; virtual;    // Jcc        rel8
    procedure Instruction_68; virtual;    // Jcc        rel16
    procedure Instruction_69; virtual;    // Jcc        reg16
    procedure Instruction_6A; virtual;    // Jcc        mem16
    procedure Instruction_6B; virtual;    // SETcc      reg8
    procedure Instruction_6C; virtual;    // SETcc      reg16
    procedure Instruction_6D; virtual;    // SETcc      mem8
    procedure Instruction_6E; virtual;    // SETcc      mem16
    procedure Instruction_6F; virtual;    // CMOVcc     reg8,   imm8
    procedure Instruction_70; virtual;    // CMOVcc     reg16,  imm16
    procedure Instruction_71; virtual;    // CMOVcc     reg8,   reg8
    procedure Instruction_72; virtual;    // CMOVcc     reg16,  reg16
    procedure Instruction_73; virtual;    // CMOVcc     reg8,   mem8
    procedure Instruction_74; virtual;    // CMOVcc     reg16,  mem16
    procedure Instruction_75; virtual;    // CMOVcc     mem8,   reg8
    procedure Instruction_76; virtual;    // CMOVcc     mem16,  reg16
    procedure Instruction_77; virtual;    // LOOP       rel8
    procedure Instruction_78; virtual;    // LOOP       rel16
    procedure Instruction_79; virtual;    // LOOPcc     rel8
    procedure Instruction_7A; virtual;    // LOOPcc     rel16
    procedure Instruction_7B; virtual;    // MOV        reg8,   imm8
    procedure Instruction_7C; virtual;    // MOV        reg16,  imm16
    procedure Instruction_7D; virtual;    // MOV        reg8,   reg8
    procedure Instruction_7E; virtual;    // MOV        reg16,  reg16
    procedure Instruction_7F; virtual;    // MOV        reg8,   mem8
    procedure Instruction_80; virtual;    // MOV        reg16,  mem16
    procedure Instruction_81; virtual;    // MOV        mem8,   reg8
    procedure Instruction_82; virtual;    // MOV        mem16,  reg16
    procedure Instruction_83; virtual;    // MOVZX      reg16,  reg8
    procedure Instruction_84; virtual;    // MOVZX      reg16,  mem8
    procedure Instruction_85; virtual;    // MOVSX      reg16,  reg8
    procedure Instruction_86; virtual;    // MOVSX      reg16,  mem8
    procedure Instruction_87; virtual;    // XCHG       reg8,   reg8
    procedure Instruction_88; virtual;    // XCHG       reg16,  reg16
    procedure Instruction_89; virtual;    // XCHG       reg8,   mem8
    procedure Instruction_8A; virtual;    // XCHG       reg16,  mem16
    procedure Instruction_8B; virtual;    // XCHG       mem8,   reg8
    procedure Instruction_8C; virtual;    // XCHG       mem16,  reg16
    procedure Instruction_8D; virtual;    // CVTSX      reg16,  reg8
    procedure Instruction_8E; virtual;    // CVTSX      reg16,  mem8
    procedure Instruction_8F; virtual;    // CVTSX      mem16,  reg8
    // arithmetic operations
    procedure Instruction_D0_01; virtual; // INC        reg8
    procedure Instruction_D0_02; virtual; // INC        reg16
    procedure Instruction_D0_03; virtual; // INC        mem8
    procedure Instruction_D0_04; virtual; // INC        mem16
    procedure Instruction_D0_05; virtual; // DEC        reg8
    procedure Instruction_D0_06; virtual; // DEC        reg16
    procedure Instruction_D0_07; virtual; // DEC        mem8
    procedure Instruction_D0_08; virtual; // DEC        mem16
    procedure Instruction_D0_09; virtual; // NEG        reg8
    procedure Instruction_D0_0A; virtual; // NEG        reg16
    procedure Instruction_D0_0B; virtual; // NEG        mem8
    procedure Instruction_D0_0C; virtual; // NEG        mem16
    procedure Instruction_D0_0D; virtual; // ADD        reg8,   imm8
    procedure Instruction_D0_0E; virtual; // ADD        reg16,  imm16
    procedure Instruction_D0_0F; virtual; // ADD        reg8,   reg8
    procedure Instruction_D0_10; virtual; // ADD        reg16,  reg16
    procedure Instruction_D0_11; virtual; // ADD        reg8,   mem8
    procedure Instruction_D0_12; virtual; // ADD        reg16,  mem16
    procedure Instruction_D0_13; virtual; // ADD        mem8,   reg8
    procedure Instruction_D0_14; virtual; // ADD        mem16,  reg16
    procedure Instruction_D0_15; virtual; // SUB        reg8,   imm8
    procedure Instruction_D0_16; virtual; // SUB        reg16,  imm16
    procedure Instruction_D0_17; virtual; // SUB        reg8,   reg8
    procedure Instruction_D0_18; virtual; // SUB        reg16,  reg16
    procedure Instruction_D0_19; virtual; // SUB        reg8,   mem8
    procedure Instruction_D0_1A; virtual; // SUB        reg16,  mem16
    procedure Instruction_D0_1B; virtual; // SUB        mem8,   reg8
    procedure Instruction_D0_1C; virtual; // SUB        mem16,  reg16
    procedure Instruction_D0_1D; virtual; // ADC        reg8,   imm8
    procedure Instruction_D0_1E; virtual; // ADC        reg16,  imm16
    procedure Instruction_D0_1F; virtual; // ADC        reg8,   reg8
    procedure Instruction_D0_20; virtual; // ADC        reg16,  reg16
    procedure Instruction_D0_21; virtual; // ADC        reg8,   mem8
    procedure Instruction_D0_22; virtual; // ADC        reg16,  mem16
    procedure Instruction_D0_23; virtual; // ADC        mem8,   reg8
    procedure Instruction_D0_24; virtual; // ADC        mem16,  reg16
    procedure Instruction_D0_25; virtual; // SBB        reg8,   imm8
    procedure Instruction_D0_26; virtual; // SBB        reg16,  imm16
    procedure Instruction_D0_27; virtual; // SBB        reg8,   reg8
    procedure Instruction_D0_28; virtual; // SBB        reg16,  reg16
    procedure Instruction_D0_29; virtual; // SBB        reg8,   mem8
    procedure Instruction_D0_2A; virtual; // SBB        reg16,  mem16
    procedure Instruction_D0_2B; virtual; // SBB        mem8,   reg8
    procedure Instruction_D0_2C; virtual; // SBB        mem16,  reg16
    procedure Instruction_D0_2D; virtual; // MUL        reg8,   imm8
    procedure Instruction_D0_2E; virtual; // MUL        reg16,  imm16
    procedure Instruction_D0_2F; virtual; // MUL        reg8,   reg8
    procedure Instruction_D0_30; virtual; // MUL        reg16,  reg16
    procedure Instruction_D0_31; virtual; // MUL        reg8,   mem8
    procedure Instruction_D0_32; virtual; // MUL        reg16,  mem16
    procedure Instruction_D0_33; virtual; // MUL        mem8,   reg8
    procedure Instruction_D0_34; virtual; // MUL        mem16,  reg16
    procedure Instruction_D0_35; virtual; // MUL        reg8,   reg8,   imm8
    procedure Instruction_D0_36; virtual; // MUL        reg16,  reg16,  imm16
    procedure Instruction_D0_37; virtual; // MUL        mem8,   reg8,   imm8
    procedure Instruction_D0_38; virtual; // MUL        mem16,  reg16,  imm16
    procedure Instruction_D0_39; virtual; // MUL        reg8,   mem8,   imm8
    procedure Instruction_D0_3A; virtual; // MUL        reg16,  mem16,  imm16
    procedure Instruction_D0_3B; virtual; // MUL        reg8,   reg8,   reg8
    procedure Instruction_D0_3C; virtual; // MUL        reg16,  reg16,  reg16
    procedure Instruction_D0_3D; virtual; // MUL        reg8,   reg8,   mem8
    procedure Instruction_D0_3E; virtual; // MUL        reg16,  reg16,  mem16
    procedure Instruction_D0_3F; virtual; // MUL        reg8,   mem8,   reg8
    procedure Instruction_D0_40; virtual; // MUL        reg16,  mem16,  reg16
    procedure Instruction_D0_41; virtual; // MUL        mem8,   reg8,   reg8
    procedure Instruction_D0_42; virtual; // MUL        mem16,  reg16,  reg16
    procedure Instruction_D0_43; virtual; // IMUL       reg8,   imm8
    procedure Instruction_D0_44; virtual; // IMUL       reg16,  imm16
    procedure Instruction_D0_45; virtual; // IMUL       reg8,   reg8
    procedure Instruction_D0_46; virtual; // IMUL       reg16,  reg16
    procedure Instruction_D0_47; virtual; // IMUL       reg8,   mem8
    procedure Instruction_D0_48; virtual; // IMUL       reg16,  mem16
    procedure Instruction_D0_49; virtual; // IMUL       mem8,   reg8
    procedure Instruction_D0_4A; virtual; // IMUL       mem16,  reg16
    procedure Instruction_D0_4B; virtual; // IMUL       reg8,   reg8,   imm8
    procedure Instruction_D0_4C; virtual; // IMUL       reg16,  reg16,  imm16
    procedure Instruction_D0_4D; virtual; // IMUL       mem8,   reg8,   imm8
    procedure Instruction_D0_4E; virtual; // IMUL       mem16,  reg16,  imm16
    procedure Instruction_D0_4F; virtual; // IMUL       reg8,   mem8,   imm8
    procedure Instruction_D0_50; virtual; // IMUL       reg16,  mem16,  imm16
    procedure Instruction_D0_51; virtual; // IMUL       reg8,   reg8,   reg8
    procedure Instruction_D0_52; virtual; // IMUL       reg16,  reg16,  reg16
    procedure Instruction_D0_53; virtual; // IMUL       reg8,   reg8,   mem8
    procedure Instruction_D0_54; virtual; // IMUL       reg16,  reg16,  mem16
    procedure Instruction_D0_55; virtual; // IMUL       reg8,   mem8,   reg8
    procedure Instruction_D0_56; virtual; // IMUL       reg16,  mem16,  reg16
    procedure Instruction_D0_57; virtual; // IMUL       mem8,   reg8,   reg8
    procedure Instruction_D0_58; virtual; // IMUL       mem16,  reg16,  reg16
    procedure Instruction_D0_59; virtual; // DIV        reg8,   imm8
    procedure Instruction_D0_5A; virtual; // DIV        reg16,  imm16
    procedure Instruction_D0_5B; virtual; // DIV        reg8,   reg8
    procedure Instruction_D0_5C; virtual; // DIV        reg16,  reg16
    procedure Instruction_D0_5D; virtual; // DIV        reg8,   mem8
    procedure Instruction_D0_5E; virtual; // DIV        reg16,  mem16
    procedure Instruction_D0_5F; virtual; // DIV        mem8,   reg8
    procedure Instruction_D0_60; virtual; // DIV        mem16,  reg16
    procedure Instruction_D0_61; virtual; // DIV        reg8,   reg8,   imm8
    procedure Instruction_D0_62; virtual; // DIV        reg16,  reg16,  imm16
    procedure Instruction_D0_63; virtual; // DIV        mem8,   reg8,   imm8
    procedure Instruction_D0_64; virtual; // DIV        mem16,  reg16,  imm16
    procedure Instruction_D0_65; virtual; // DIV        reg8,   mem8,   imm8
    procedure Instruction_D0_66; virtual; // DIV        reg16,  mem16,  imm16
    procedure Instruction_D0_67; virtual; // DIV        reg8,   reg8,   reg8
    procedure Instruction_D0_68; virtual; // DIV        reg16,  reg16,  reg16
    procedure Instruction_D0_69; virtual; // DIV        reg8,   reg8,   mem8
    procedure Instruction_D0_6A; virtual; // DIV        reg16,  reg16,  mem16
    procedure Instruction_D0_6B; virtual; // DIV        reg8,   mem8,   reg8
    procedure Instruction_D0_6C; virtual; // DIV        reg16,  mem16,  reg16
    procedure Instruction_D0_6D; virtual; // DIV        mem8,   reg8,   reg8
    procedure Instruction_D0_6E; virtual; // DIV        mem16,  reg16,  reg16
    procedure Instruction_D0_6F; virtual; // IDIV       reg8,   imm8
    procedure Instruction_D0_70; virtual; // IDIV       reg16,  imm16
    procedure Instruction_D0_71; virtual; // IDIV       reg8,   reg8
    procedure Instruction_D0_72; virtual; // IDIV       reg16,  reg16
    procedure Instruction_D0_73; virtual; // IDIV       reg8,   mem8
    procedure Instruction_D0_74; virtual; // IDIV       reg16,  mem16
    procedure Instruction_D0_75; virtual; // IDIV       mem8,   reg8
    procedure Instruction_D0_76; virtual; // IDIV       mem16,  reg16
    procedure Instruction_D0_77; virtual; // IDIV       reg8,   reg8,   imm8
    procedure Instruction_D0_78; virtual; // IDIV       reg16,  reg16,  imm16
    procedure Instruction_D0_79; virtual; // IDIV       mem8,   reg8,   imm8
    procedure Instruction_D0_7A; virtual; // IDIV       mem16,  reg16,  imm16
    procedure Instruction_D0_7B; virtual; // IDIV       reg8,   mem8,   imm8
    procedure Instruction_D0_7C; virtual; // IDIV       reg16,  mem16,  imm16
    procedure Instruction_D0_7D; virtual; // IDIV       reg8,   reg8,   reg8
    procedure Instruction_D0_7E; virtual; // IDIV       reg16,  reg16,  reg16
    procedure Instruction_D0_7F; virtual; // IDIV       reg8,   reg8,   mem8
    procedure Instruction_D0_80; virtual; // IDIV       reg16,  reg16,  mem16
    procedure Instruction_D0_81; virtual; // IDIV       reg8,   mem8,   reg8
    procedure Instruction_D0_82; virtual; // IDIV       reg16,  mem16,  reg16
    procedure Instruction_D0_83; virtual; // IDIV       mem8,   reg8,   reg8
    procedure Instruction_D0_84; virtual; // IDIV       mem16,  reg16,  reg16
    procedure Instruction_D0_85; virtual; // MOD        reg8,   imm8
    procedure Instruction_D0_86; virtual; // MOD        reg16,  imm16
    procedure Instruction_D0_87; virtual; // MOD        reg8,   reg8
    procedure Instruction_D0_88; virtual; // MOD        reg16,  reg16
    procedure Instruction_D0_89; virtual; // MOD        reg8,   mem8
    procedure Instruction_D0_8A; virtual; // MOD        reg16,  mem16
    procedure Instruction_D0_8B; virtual; // MOD        mem8,   reg8
    procedure Instruction_D0_8C; virtual; // MOD        mem16,  reg16
    procedure Instruction_D0_8D; virtual; // MOD        reg8,   reg8,   imm8
    procedure Instruction_D0_8E; virtual; // MOD        reg16,  reg16,  imm16
    procedure Instruction_D0_8F; virtual; // MOD        mem8,   reg8,   imm8
    procedure Instruction_D0_90; virtual; // MOD        mem16,  reg16,  imm16
    procedure Instruction_D0_91; virtual; // MOD        reg8,   mem8,   imm8
    procedure Instruction_D0_92; virtual; // MOD        reg16,  mem16,  imm16
    procedure Instruction_D0_93; virtual; // MOD        reg8,   reg8,   reg8
    procedure Instruction_D0_94; virtual; // MOD        reg16,  reg16,  reg16
    procedure Instruction_D0_95; virtual; // MOD        reg8,   reg8,   mem8
    procedure Instruction_D0_96; virtual; // MOD        reg16,  reg16,  mem16
    procedure Instruction_D0_97; virtual; // MOD        reg8,   mem8,   reg8
    procedure Instruction_D0_98; virtual; // MOD        reg16,  mem16,  reg16
    procedure Instruction_D0_99; virtual; // MOD        mem8,   reg8,   reg8
    procedure Instruction_D0_9A; virtual; // MOD        mem16,  reg16,  reg16
    procedure Instruction_D0_9B; virtual; // IMOD       reg8,   imm8
    procedure Instruction_D0_9C; virtual; // IMOD       reg16,  imm16
    procedure Instruction_D0_9D; virtual; // IMOD       reg8,   reg8
    procedure Instruction_D0_9E; virtual; // IMOD       reg16,  reg16
    procedure Instruction_D0_9F; virtual; // IMOD       reg8,   mem8
    procedure Instruction_D0_A0; virtual; // IMOD       reg16,  mem16
    procedure Instruction_D0_A1; virtual; // IMOD       mem8,   reg8
    procedure Instruction_D0_A2; virtual; // IMOD       mem16,  reg16
    procedure Instruction_D0_A3; virtual; // IMOD       reg8,   reg8,   imm8
    procedure Instruction_D0_A4; virtual; // IMOD       reg16,  reg16,  imm16
    procedure Instruction_D0_A5; virtual; // IMOD       mem8,   reg8,   imm8
    procedure Instruction_D0_A6; virtual; // IMOD       mem16,  reg16,  imm16
    procedure Instruction_D0_A7; virtual; // IMOD       reg8,   mem8,   imm8
    procedure Instruction_D0_A8; virtual; // IMOD       reg16,  mem16,  imm16
    procedure Instruction_D0_A9; virtual; // IMOD       reg8,   reg8,   reg8
    procedure Instruction_D0_AA; virtual; // IMOD       reg16,  reg16,  reg16
    procedure Instruction_D0_AB; virtual; // IMOD       reg8,   reg8,   mem8
    procedure Instruction_D0_AC; virtual; // IMOD       reg16,  reg16,  mem16
    procedure Instruction_D0_AD; virtual; // IMOD       reg8,   mem8,   reg8
    procedure Instruction_D0_AE; virtual; // IMOD       reg16,  mem16,  reg16
    procedure Instruction_D0_AF; virtual; // IMOD       mem8,   reg8,   reg8
    procedure Instruction_D0_B0; virtual; // IMOD       mem16,  reg16,  reg16
    // logical operations
    procedure Instruction_D1_01; virtual; // NOT        reg8
    procedure Instruction_D1_02; virtual; // NOT        reg16
    procedure Instruction_D1_03; virtual; // NOT        mem8
    procedure Instruction_D1_04; virtual; // NOT        mem16
    procedure Instruction_D1_05; virtual; // AND        reg8,   imm8
    procedure Instruction_D1_06; virtual; // AND        reg16,  imm16
    procedure Instruction_D1_07; virtual; // AND        reg8,   reg8
    procedure Instruction_D1_08; virtual; // AND        reg16,  reg16
    procedure Instruction_D1_09; virtual; // AND        reg8,   mem8
    procedure Instruction_D1_0A; virtual; // AND        reg16,  mem16
    procedure Instruction_D1_0B; virtual; // AND        mem8,   reg8
    procedure Instruction_D1_0C; virtual; // AND        mem16,  reg16
    procedure Instruction_D1_0D; virtual; // OR         reg8,   imm8
    procedure Instruction_D1_0E; virtual; // OR         reg16,  imm16
    procedure Instruction_D1_0F; virtual; // OR         reg8,   reg8
    procedure Instruction_D1_10; virtual; // OR         reg16,  reg16
    procedure Instruction_D1_11; virtual; // OR         reg8,   mem8
    procedure Instruction_D1_12; virtual; // OR         reg16,  mem16
    procedure Instruction_D1_13; virtual; // OR         mem8,   reg8
    procedure Instruction_D1_14; virtual; // OR         mem16,  reg16
    procedure Instruction_D1_15; virtual; // XOR        reg8,   imm8
    procedure Instruction_D1_16; virtual; // XOR        reg16,  imm16
    procedure Instruction_D1_17; virtual; // XOR        reg8,   reg8
    procedure Instruction_D1_18; virtual; // XOR        reg16,  reg16
    procedure Instruction_D1_19; virtual; // XOR        reg8,   mem8
    procedure Instruction_D1_1A; virtual; // XOR        reg16,  mem16
    procedure Instruction_D1_1B; virtual; // XOR        mem8,   reg8
    procedure Instruction_D1_1C; virtual; // XOR        mem16,  reg16
    // bit operations
    procedure Instruction_D1_1D; virtual; // SHR        reg8
    procedure Instruction_D1_1E; virtual; // SHR        reg16
    procedure Instruction_D1_1F; virtual; // SHR        mem8
    procedure Instruction_D1_20; virtual; // SHR        mem16
    procedure Instruction_D1_21; virtual; // SHR        reg8,   imm8
    procedure Instruction_D1_22; virtual; // SHR        reg16,  imm8
    procedure Instruction_D1_23; virtual; // SHR        mem8,   imm8
    procedure Instruction_D1_24; virtual; // SHR        mem16,  imm8
    procedure Instruction_D1_25; virtual; // SHR        reg8,   reg8
    procedure Instruction_D1_26; virtual; // SHR        reg16,  reg8
    procedure Instruction_D1_27; virtual; // SHR        mem8,   reg8
    procedure Instruction_D1_28; virtual; // SHR        mem16,  reg8
    procedure Instruction_D1_29; virtual; // SAR        reg8
    procedure Instruction_D1_2A; virtual; // SAR        reg16
    procedure Instruction_D1_2B; virtual; // SAR        mem8
    procedure Instruction_D1_2C; virtual; // SAR        mem16
    procedure Instruction_D1_2D; virtual; // SAR        reg8,   imm8
    procedure Instruction_D1_2E; virtual; // SAR        reg16,  imm8
    procedure Instruction_D1_2F; virtual; // SAR        mem8,   imm8
    procedure Instruction_D1_30; virtual; // SAR        mem16,  imm8
    procedure Instruction_D1_31; virtual; // SAR        reg8,   reg8
    procedure Instruction_D1_32; virtual; // SAR        reg16,  reg8
    procedure Instruction_D1_33; virtual; // SAR        mem8,   reg8
    procedure Instruction_D1_34; virtual; // SAR        mem16,  reg8
    procedure Instruction_D1_35; virtual; // SHL        reg8
    procedure Instruction_D1_36; virtual; // SHL        reg16
    procedure Instruction_D1_37; virtual; // SHL        mem8
    procedure Instruction_D1_38; virtual; // SHL        mem16
    procedure Instruction_D1_39; virtual; // SHL        reg8,   imm8
    procedure Instruction_D1_3A; virtual; // SHL        reg16,  imm8
    procedure Instruction_D1_3B; virtual; // SHL        mem8,   imm8
    procedure Instruction_D1_3C; virtual; // SHL        mem16,  imm8
    procedure Instruction_D1_3D; virtual; // SHL        reg8,   reg8
    procedure Instruction_D1_3E; virtual; // SHL        reg16,  reg8
    procedure Instruction_D1_3F; virtual; // SHL        mem8,   reg8
    procedure Instruction_D1_40; virtual; // SHL        mem16,  reg8
    procedure Instruction_D1_41; virtual; // SAL        reg8
    procedure Instruction_D1_42; virtual; // SAL        reg16
    procedure Instruction_D1_43; virtual; // SAL        mem8
    procedure Instruction_D1_44; virtual; // SAL        mem16
    procedure Instruction_D1_45; virtual; // SAL        reg8,   imm8
    procedure Instruction_D1_46; virtual; // SAL        reg16,  imm8
    procedure Instruction_D1_47; virtual; // SAL        mem8,   imm8
    procedure Instruction_D1_48; virtual; // SAL        mem16,  imm8
    procedure Instruction_D1_49; virtual; // SAL        reg8,   reg8
    procedure Instruction_D1_4A; virtual; // SAL        reg16,  reg8
    procedure Instruction_D1_4B; virtual; // SAL        mem8,   reg8
    procedure Instruction_D1_4C; virtual; // SAL        mem16,  reg8
    procedure Instruction_D1_4D; virtual; // ROR        reg8
    procedure Instruction_D1_4E; virtual; // ROR        reg16
    procedure Instruction_D1_4F; virtual; // ROR        mem8
    procedure Instruction_D1_50; virtual; // ROR        mem16
    procedure Instruction_D1_51; virtual; // ROR        reg8,   imm8
    procedure Instruction_D1_52; virtual; // ROR        reg16,  imm8
    procedure Instruction_D1_53; virtual; // ROR        mem8,   imm8
    procedure Instruction_D1_54; virtual; // ROR        mem16,  imm8
    procedure Instruction_D1_55; virtual; // ROR        reg8,   reg8
    procedure Instruction_D1_56; virtual; // ROR        reg16,  reg8
    procedure Instruction_D1_57; virtual; // ROR        mem8,   reg8
    procedure Instruction_D1_58; virtual; // ROR        mem16,  reg8
    procedure Instruction_D1_59; virtual; // ROL        reg8
    procedure Instruction_D1_5A; virtual; // ROL        reg16
    procedure Instruction_D1_5B; virtual; // ROL        mem8
    procedure Instruction_D1_5C; virtual; // ROL        mem16
    procedure Instruction_D1_5D; virtual; // ROL        reg8,   imm8
    procedure Instruction_D1_5E; virtual; // ROL        reg16,  imm8
    procedure Instruction_D1_5F; virtual; // ROL        mem8,   imm8
    procedure Instruction_D1_60; virtual; // ROL        mem16,  imm8
    procedure Instruction_D1_61; virtual; // ROL        reg8,   reg8
    procedure Instruction_D1_62; virtual; // ROL        reg16,  reg8
    procedure Instruction_D1_63; virtual; // ROL        mem8,   reg8
    procedure Instruction_D1_64; virtual; // ROL        mem16,  reg8
    procedure Instruction_D1_65; virtual; // RCR        reg8
    procedure Instruction_D1_66; virtual; // RCR        reg16
    procedure Instruction_D1_67; virtual; // RCR        mem8
    procedure Instruction_D1_68; virtual; // RCR        mem16
    procedure Instruction_D1_69; virtual; // RCR        reg8,   imm8
    procedure Instruction_D1_6A; virtual; // RCR        reg16,  imm8
    procedure Instruction_D1_6B; virtual; // RCR        mem8,   imm8
    procedure Instruction_D1_6C; virtual; // RCR        mem16,  imm8
    procedure Instruction_D1_6D; virtual; // RCR        reg8,   reg8
    procedure Instruction_D1_6E; virtual; // RCR        reg16,  reg8
    procedure Instruction_D1_6F; virtual; // RCR        mem8,   reg8
    procedure Instruction_D1_70; virtual; // RCR        mem16,  reg8  
    procedure Instruction_D1_71; virtual; // RCL        reg8
    procedure Instruction_D1_72; virtual; // RCL        reg16
    procedure Instruction_D1_73; virtual; // RCL        mem8
    procedure Instruction_D1_74; virtual; // RCL        mem16
    procedure Instruction_D1_75; virtual; // RCL        reg8,   imm8
    procedure Instruction_D1_76; virtual; // RCL        reg16,  imm8
    procedure Instruction_D1_77; virtual; // RCL        mem8,   imm8
    procedure Instruction_D1_78; virtual; // RCL        mem16,  imm8
    procedure Instruction_D1_79; virtual; // RCL        reg8,   reg8
    procedure Instruction_D1_7A; virtual; // RCL        reg16,  reg8
    procedure Instruction_D1_7B; virtual; // RCL        mem8,   reg8
    procedure Instruction_D1_7C; virtual; // RCL        mem16,  reg8
    procedure Instruction_D1_7D; virtual; // BT         reg8,   imm8
    procedure Instruction_D1_7E; virtual; // BT         reg16,  imm16
    procedure Instruction_D1_7F; virtual; // BT         reg8,   reg8
    procedure Instruction_D1_80; virtual; // BT         reg16,  reg16
    procedure Instruction_D1_81; virtual; // BT         mem8,   reg8
    procedure Instruction_D1_82; virtual; // BT         mem16,  reg16
    procedure Instruction_D1_83; virtual; // BT         mem8,   imm8
    procedure Instruction_D1_84; virtual; // BT         mem16,  imm16
    procedure Instruction_D1_85; virtual; // BTS        reg8,   imm8
    procedure Instruction_D1_86; virtual; // BTS        reg16,  imm16
    procedure Instruction_D1_87; virtual; // BTS        reg8,   reg8
    procedure Instruction_D1_88; virtual; // BTS        reg16,  reg16
    procedure Instruction_D1_89; virtual; // BTS        mem8,   reg8
    procedure Instruction_D1_8A; virtual; // BTS        mem16,  reg16
    procedure Instruction_D1_8B; virtual; // BTS        mem8,   imm8
    procedure Instruction_D1_8C; virtual; // BTS        mem16,  imm16
    procedure Instruction_D1_8D; virtual; // BTR        reg8,   imm8
    procedure Instruction_D1_8E; virtual; // BTR        reg16,  imm16
    procedure Instruction_D1_8F; virtual; // BTR        reg8,   reg8
    procedure Instruction_D1_90; virtual; // BTR        reg16,  reg16
    procedure Instruction_D1_91; virtual; // BTR        mem8,   reg8
    procedure Instruction_D1_92; virtual; // BTR        mem16,  reg16
    procedure Instruction_D1_93; virtual; // BTR        mem8,   imm8
    procedure Instruction_D1_94; virtual; // BTR        mem16,  imm16
    procedure Instruction_D1_95; virtual; // BTC        reg8,   imm8
    procedure Instruction_D1_96; virtual; // BTC        reg16,  imm16
    procedure Instruction_D1_97; virtual; // BTC        reg8,   reg8
    procedure Instruction_D1_98; virtual; // BTC        reg16,  reg16
    procedure Instruction_D1_99; virtual; // BTC        mem8,   reg8
    procedure Instruction_D1_9A; virtual; // BTC        mem16,  reg16
    procedure Instruction_D1_9B; virtual; // BTC        mem8,   imm8
    procedure Instruction_D1_9C; virtual; // BTC        mem16,  imm16
    procedure Instruction_D1_9D; virtual; // BSF        reg8,   reg8
    procedure Instruction_D1_9E; virtual; // BSF        reg16,  reg16
    procedure Instruction_D1_9F; virtual; // BSF        reg8,   mem8
    procedure Instruction_D1_A0; virtual; // BSF        reg16,  mem16
    procedure Instruction_D1_A1; virtual; // BSR        reg8,   reg8
    procedure Instruction_D1_A2; virtual; // BSR        reg16,  reg16
    procedure Instruction_D1_A3; virtual; // BSR        reg8,   mem8
    procedure Instruction_D1_A4; virtual; // BSR        reg16,  mem16
    procedure Instruction_D1_A5; virtual; // SRRD       reg16,  reg16,  imm8
    procedure Instruction_D1_A6; virtual; // SHRD       mem16,  reg16,  imm8
    procedure Instruction_D1_A7; virtual; // SHRD       reg16,  mem16,  imm8
    procedure Instruction_D1_A8; virtual; // SHRD       reg16,  reg16,  reg8
    procedure Instruction_D1_A9; virtual; // SHRD       mem16,  reg16,  reg8
    procedure Instruction_D1_AA; virtual; // SHRD       reg16,  mem16,  reg8
    procedure Instruction_D1_AB; virtual; // SHLD       reg16,  reg16,  imm8
    procedure Instruction_D1_AC; virtual; // SHLD       mem16,  reg16,  imm8
    procedure Instruction_D1_AD; virtual; // SHLD       reg16,  mem16,  imm8
    procedure Instruction_D1_AE; virtual; // SHLD       reg16,  reg16,  reg8
    procedure Instruction_D1_AF; virtual; // SHLD       mem16,  reg16,  reg8
    procedure Instruction_D1_B0; virtual; // SHLD       reg16,  mem16,  reg8
    // string manipulation instructions
    procedure Instruction_D2_01; virtual; // LODSB      reg8,   reg16
    procedure Instruction_D2_02; virtual; // LODSW      reg16,  reg16
    procedure Instruction_D2_03; virtual; // STOSB      reg16,  reg8
    procedure Instruction_D2_04; virtual; // STOSW      reg16,  reg16
    procedure Instruction_D2_05; virtual; // MOVSB      reg16,  reg16
    procedure Instruction_D2_06; virtual; // MOVSW      reg16,  reg16
    procedure Instruction_D2_07; virtual; // LOADSB     reg16,  reg16
    procedure Instruction_D2_08; virtual; // LOADSW     reg16,  reg16
    procedure Instruction_D2_09; virtual; // STORESB    reg16,  reg16
    procedure Instruction_D2_0A; virtual; // STORESW    reg16,  reg16
    procedure Instruction_D2_0B; virtual; // CMPSB      reg16,  reg16
    procedure Instruction_D2_0C; virtual; // CMPSW      reg16,  reg16
    procedure Instruction_D2_0D; virtual; // SCASB      reg8,   reg16
    procedure Instruction_D2_0E; virtual; // SCASW      reg16,  reg16
    procedure Instruction_D2_0F; virtual; // INSB       reg16,  imm8
    procedure Instruction_D2_10; virtual; // INSW       reg16,  imm8
    procedure Instruction_D2_11; virtual; // INSB       reg16,  reg8
    procedure Instruction_D2_12; virtual; // INSW       reg16,  reg8
    procedure Instruction_D2_13; virtual; // OUTSB      imm8,   reg16
    procedure Instruction_D2_14; virtual; // OUTSW      imm8,   reg16
    procedure Instruction_D2_15; virtual; // OUTSB      reg8,   reg16
    procedure Instruction_D2_16; virtual; // OUTSW      reg8,   reg16
  end;

implementation

uses
  AuxTypes, BitOps,
  SiViC_Registers,
  SiViC_Interrupts,
  SiViC_IO;

Function TSVCProcessor_0000.GetInfoPage(Page: TSVCProcessorInfoPage; Param: TSVCProcessorInfoData): TSVCProcessorInfoData;
begin
case Page of
  // CPU info
  SVC_PCS_INFOPAGE_CPU_REVISION:  Result := TSVCProcessorInfoData($0000);
else
  Result := inherited GetInfoPage(Page,Param);
end;
end;

//==============================================================================

procedure TSVCProcessor_0000.PrefixSelect(Prefix: TSVCInstructionPrefix);
begin
with fCurrentInstruction do
  case Prefix of
    $E1:  begin                                         // REP
            Include(Prefixes,ipfxREP);
            Prefixes := Prefixes - [ipfxREPZ,ipfxREPNZ];
          end;
    $E2:  begin                                         // REP(Z/E)
            Include(Prefixes,ipfxREPZ);
            Prefixes := Prefixes - [ipfxREP,ipfxREPNZ];
          end;
    $E3:  begin                                         // REP(NZ/NE)
            Include(Prefixes,ipfxREPNZ);
            Prefixes := Prefixes - [ipfxREP,ipfxREPZ];
          end;
  else
    inherited PrefixSelect(Prefix);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.InstructionSelect_L1(InstructionByte: TSVCByte);
begin
case InstructionByte of
  $50:  fCurrentInstruction.InstructionHandler := Instruction_50;   // LEA        reg16,  mem
  $51:  fCurrentInstruction.InstructionHandler := Instruction_51;   // LEA        reg16,  rel8
  $52:  fCurrentInstruction.InstructionHandler := Instruction_52;   // LEA        reg16,  rel16
  $53:  fCurrentInstruction.InstructionHandler := Instruction_53;   // CMP        reg8,   imm8
  $54:  fCurrentInstruction.InstructionHandler := Instruction_54;   // CMP        reg16,  imm16
  $55:  fCurrentInstruction.InstructionHandler := Instruction_55;   // CMP        reg8,   reg8
  $56:  fCurrentInstruction.InstructionHandler := Instruction_56;   // CMP        reg16,  reg16
  $57:  fCurrentInstruction.InstructionHandler := Instruction_57;   // CMP        reg8,   mem8
  $58:  fCurrentInstruction.InstructionHandler := Instruction_58;   // CMP        reg16,  mem16
  $59:  fCurrentInstruction.InstructionHandler := Instruction_59;   // CMP        mem8,   reg8
  $5A:  fCurrentInstruction.InstructionHandler := Instruction_5A;   // CMP        mem16,  reg16
  $5B:  fCurrentInstruction.InstructionHandler := Instruction_5B;   // TEST       reg8,   imm8
  $5C:  fCurrentInstruction.InstructionHandler := Instruction_5C;   // TEST       reg16,  imm16
  $5D:  fCurrentInstruction.InstructionHandler := Instruction_5D;   // TEST       reg8,   reg8
  $5E:  fCurrentInstruction.InstructionHandler := Instruction_5E;   // TEST       reg16,  reg16
  $5F:  fCurrentInstruction.InstructionHandler := Instruction_5F;   // TEST       reg8,   mem8
  $60:  fCurrentInstruction.InstructionHandler := Instruction_60;   // TEST       reg16,  mem16
  $61:  fCurrentInstruction.InstructionHandler := Instruction_61;   // TEST       mem8,   reg8
  $62:  fCurrentInstruction.InstructionHandler := Instruction_62;   // TEST       mem16,  reg16
  $63:  fCurrentInstruction.InstructionHandler := Instruction_63;   // JMP        rel8
  $64:  fCurrentInstruction.InstructionHandler := Instruction_64;   // JMP        rel16
  $65:  fCurrentInstruction.InstructionHandler := Instruction_65;   // JMP        reg16
  $66:  fCurrentInstruction.InstructionHandler := Instruction_66;   // JMP        mem16
  $67:  fCurrentInstruction.InstructionHandler := Instruction_67;   // Jcc        rel8
  $68:  fCurrentInstruction.InstructionHandler := Instruction_68;   // Jcc        rel16
  $69:  fCurrentInstruction.InstructionHandler := Instruction_69;   // Jcc        reg16
  $6A:  fCurrentInstruction.InstructionHandler := Instruction_6A;   // Jcc        mem16
  $6B:  fCurrentInstruction.InstructionHandler := Instruction_6B;   // SETcc      reg8
  $6C:  fCurrentInstruction.InstructionHandler := Instruction_6C;   // SETcc      reg16
  $6D:  fCurrentInstruction.InstructionHandler := Instruction_6D;   // SETcc      mem8
  $6E:  fCurrentInstruction.InstructionHandler := Instruction_6E;   // SETcc      mem16
  $6F:  fCurrentInstruction.InstructionHandler := Instruction_6F;   // CMOVcc     reg8,   imm8
  $70:  fCurrentInstruction.InstructionHandler := Instruction_70;   // CMOVcc     reg16,  imm16
  $71:  fCurrentInstruction.InstructionHandler := Instruction_71;   // CMOVcc     reg8,   reg8
  $72:  fCurrentInstruction.InstructionHandler := Instruction_72;   // CMOVcc     reg16,  reg16
  $73:  fCurrentInstruction.InstructionHandler := Instruction_73;   // CMOVcc     reg8,   mem8
  $74:  fCurrentInstruction.InstructionHandler := Instruction_74;   // CMOVcc     reg16,  mem16
  $75:  fCurrentInstruction.InstructionHandler := Instruction_75;   // CMOVcc     mem8,   reg8
  $76:  fCurrentInstruction.InstructionHandler := Instruction_76;   // CMOVcc     mem16,  reg16
  $77:  fCurrentInstruction.InstructionHandler := Instruction_77;   // LOOP       rel8
  $78:  fCurrentInstruction.InstructionHandler := Instruction_78;   // LOOP       rel16
  $79:  fCurrentInstruction.InstructionHandler := Instruction_79;   // LOOPcc     rel8
  $7A:  fCurrentInstruction.InstructionHandler := Instruction_7A;   // LOOPcc     rel16
  $7B:  fCurrentInstruction.InstructionHandler := Instruction_7B;   // MOV        reg8,   imm8
  $7C:  fCurrentInstruction.InstructionHandler := Instruction_7C;   // MOV        reg16,  imm16
  $7D:  fCurrentInstruction.InstructionHandler := Instruction_7D;   // MOV        reg8,   reg8
  $7E:  fCurrentInstruction.InstructionHandler := Instruction_7E;   // MOV        reg16,  reg16
  $7F:  fCurrentInstruction.InstructionHandler := Instruction_7F;   // MOV        reg8,   mem8
  $80:  fCurrentInstruction.InstructionHandler := Instruction_80;   // MOV        reg16,  mem16
  $81:  fCurrentInstruction.InstructionHandler := Instruction_81;   // MOV        mem8,   reg8
  $82:  fCurrentInstruction.InstructionHandler := Instruction_82;   // MOV        mem16,  reg16
  $83:  fCurrentInstruction.InstructionHandler := Instruction_83;   // MOVZX      reg16,  reg8
  $84:  fCurrentInstruction.InstructionHandler := Instruction_84;   // MOVZX      reg16,  mem8
  $85:  fCurrentInstruction.InstructionHandler := Instruction_85;   // MOVSX      reg16,  reg8
  $86:  fCurrentInstruction.InstructionHandler := Instruction_86;   // MOVSX      reg16,  mem8
  $87:  fCurrentInstruction.InstructionHandler := Instruction_87;   // XCHG       reg8,   reg8
  $88:  fCurrentInstruction.InstructionHandler := Instruction_88;   // XCHG       reg16,  reg16
  $89:  fCurrentInstruction.InstructionHandler := Instruction_89;   // XCHG       reg8,   mem8
  $8A:  fCurrentInstruction.InstructionHandler := Instruction_8A;   // XCHG       reg16,  mem16
  $8B:  fCurrentInstruction.InstructionHandler := Instruction_8B;   // XCHG       mem8,   reg8
  $8C:  fCurrentInstruction.InstructionHandler := Instruction_8C;   // XCHG       mem16,  reg16
  $8D:  fCurrentInstruction.InstructionHandler := Instruction_8D;   // CVTSX      reg16,  reg8
  $8E:  fCurrentInstruction.InstructionHandler := Instruction_8E;   // CVTSX      reg16,  mem8
  $8F:  fCurrentInstruction.InstructionHandler := Instruction_8F;   // CVTSX      mem16,  reg8
  {
    B0..CF reserved for special use
  }
  // continuous instructions
  $D0:  InstructionDecode(InstructionSelect_L2_D0,2);
  $D1:  InstructionDecode(InstructionSelect_L2_D1,2);
  $D2:  InstructionDecode(InstructionSelect_L2_D2,2);
else
  inherited InstructionSelect_L1(InstructionByte);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.InstructionSelect_L2_D0(InstructionByte: TSVCByte);
begin
case InstructionByte of
  $00:  fCurrentInstruction.InstructionHandler := Instruction_00;     // HALT
  $01:  fCurrentInstruction.InstructionHandler := Instruction_D0_01;  // INC        reg8
  $02:  fCurrentInstruction.InstructionHandler := Instruction_D0_02;  // INC        reg16
  $03:  fCurrentInstruction.InstructionHandler := Instruction_D0_03;  // INC        mem8
  $04:  fCurrentInstruction.InstructionHandler := Instruction_D0_04;  // INC        mem16
  $05:  fCurrentInstruction.InstructionHandler := Instruction_D0_05;  // DEC        reg8
  $06:  fCurrentInstruction.InstructionHandler := Instruction_D0_06;  // DEC        reg16
  $07:  fCurrentInstruction.InstructionHandler := Instruction_D0_07;  // DEC        mem8
  $08:  fCurrentInstruction.InstructionHandler := Instruction_D0_08;  // DEC        mem16
  $09:  fCurrentInstruction.InstructionHandler := Instruction_D0_09;  // NEG        reg8
  $0A:  fCurrentInstruction.InstructionHandler := Instruction_D0_0A;  // NEG        reg16
  $0B:  fCurrentInstruction.InstructionHandler := Instruction_D0_0B;  // NEG        mem8
  $0C:  fCurrentInstruction.InstructionHandler := Instruction_D0_0C;  // NEG        mem16
  $0D:  fCurrentInstruction.InstructionHandler := Instruction_D0_0D;  // ADD        reg8,   imm8
  $0E:  fCurrentInstruction.InstructionHandler := Instruction_D0_0E;  // ADD        reg16,  imm16
  $0F:  fCurrentInstruction.InstructionHandler := Instruction_D0_0F;  // ADD        reg8,   reg8
  $10:  fCurrentInstruction.InstructionHandler := Instruction_D0_10;  // ADD        reg16,  reg16
  $11:  fCurrentInstruction.InstructionHandler := Instruction_D0_11;  // ADD        reg8,   mem8
  $12:  fCurrentInstruction.InstructionHandler := Instruction_D0_12;  // ADD        reg16,  mem16
  $13:  fCurrentInstruction.InstructionHandler := Instruction_D0_13;  // ADD        mem8,   reg8
  $14:  fCurrentInstruction.InstructionHandler := Instruction_D0_14;  // ADD        mem16,  reg16
  $15:  fCurrentInstruction.InstructionHandler := Instruction_D0_15;  // SUB        reg8,   imm8
  $16:  fCurrentInstruction.InstructionHandler := Instruction_D0_16;  // SUB        reg16,  imm16
  $17:  fCurrentInstruction.InstructionHandler := Instruction_D0_17;  // SUB        reg8,   reg8
  $18:  fCurrentInstruction.InstructionHandler := Instruction_D0_18;  // SUB        reg16,  reg16
  $19:  fCurrentInstruction.InstructionHandler := Instruction_D0_19;  // SUB        reg8,   mem8
  $1A:  fCurrentInstruction.InstructionHandler := Instruction_D0_1A;  // SUB        reg16,  mem16
  $1B:  fCurrentInstruction.InstructionHandler := Instruction_D0_1B;  // SUB        mem8,   reg8
  $1C:  fCurrentInstruction.InstructionHandler := Instruction_D0_1C;  // SUB        mem16,  reg16
  $1D:  fCurrentInstruction.InstructionHandler := Instruction_D0_1D;  // ADC        reg8,   imm8
  $1E:  fCurrentInstruction.InstructionHandler := Instruction_D0_1E;  // ADC        reg16,  imm16
  $1F:  fCurrentInstruction.InstructionHandler := Instruction_D0_1F;  // ADC        reg8,   reg8
  $20:  fCurrentInstruction.InstructionHandler := Instruction_D0_20;  // ADC        reg16,  reg16
  $21:  fCurrentInstruction.InstructionHandler := Instruction_D0_21;  // ADC        reg8,   mem8
  $22:  fCurrentInstruction.InstructionHandler := Instruction_D0_22;  // ADC        reg16,  mem16
  $23:  fCurrentInstruction.InstructionHandler := Instruction_D0_23;  // ADC        mem8,   reg8
  $24:  fCurrentInstruction.InstructionHandler := Instruction_D0_24;  // ADC        mem16,  reg16
  $25:  fCurrentInstruction.InstructionHandler := Instruction_D0_25;  // SBB        reg8,   imm8
  $26:  fCurrentInstruction.InstructionHandler := Instruction_D0_26;  // SBB        reg16,  imm16
  $27:  fCurrentInstruction.InstructionHandler := Instruction_D0_27;  // SBB        reg8,   reg8
  $28:  fCurrentInstruction.InstructionHandler := Instruction_D0_28;  // SBB        reg16,  reg16
  $29:  fCurrentInstruction.InstructionHandler := Instruction_D0_29;  // SBB        reg8,   mem8
  $2A:  fCurrentInstruction.InstructionHandler := Instruction_D0_2A;  // SBB        reg16,  mem16
  $2B:  fCurrentInstruction.InstructionHandler := Instruction_D0_2B;  // SBB        mem8,   reg8
  $2C:  fCurrentInstruction.InstructionHandler := Instruction_D0_2C;  // SBB        mem16,  reg16
  $2D:  fCurrentInstruction.InstructionHandler := Instruction_D0_2D;  // MUL        reg8,   imm8
  $2E:  fCurrentInstruction.InstructionHandler := Instruction_D0_2E;  // MUL        reg16,  imm16
  $2F:  fCurrentInstruction.InstructionHandler := Instruction_D0_2F;  // MUL        reg8,   reg8
  $30:  fCurrentInstruction.InstructionHandler := Instruction_D0_30;  // MUL        reg16,  reg16
  $31:  fCurrentInstruction.InstructionHandler := Instruction_D0_31;  // MUL        reg8,   mem8
  $32:  fCurrentInstruction.InstructionHandler := Instruction_D0_32;  // MUL        reg16,  mem16
  $33:  fCurrentInstruction.InstructionHandler := Instruction_D0_33;  // MUL        mem8,   reg8
  $34:  fCurrentInstruction.InstructionHandler := Instruction_D0_34;  // MUL        mem16,  reg16
  $35:  fCurrentInstruction.InstructionHandler := Instruction_D0_35;  // MUL        reg8,   reg8,   imm8
  $36:  fCurrentInstruction.InstructionHandler := Instruction_D0_36;  // MUL        reg16,  reg16,  imm16
  $37:  fCurrentInstruction.InstructionHandler := Instruction_D0_37;  // MUL        mem8,   reg8,   imm8
  $38:  fCurrentInstruction.InstructionHandler := Instruction_D0_38;  // MUL        mem16,  reg16,  imm16
  $39:  fCurrentInstruction.InstructionHandler := Instruction_D0_39;  // MUL        reg8,   mem8,   imm8
  $3A:  fCurrentInstruction.InstructionHandler := Instruction_D0_3A;  // MUL        reg16,  mem16,  imm16
  $3B:  fCurrentInstruction.InstructionHandler := Instruction_D0_3B;  // MUL        reg8,   reg8,   reg8
  $3C:  fCurrentInstruction.InstructionHandler := Instruction_D0_3C;  // MUL        reg16,  reg16,  reg16
  $3D:  fCurrentInstruction.InstructionHandler := Instruction_D0_3D;  // MUL        reg8,   reg8,   mem8
  $3E:  fCurrentInstruction.InstructionHandler := Instruction_D0_3E;  // MUL        reg16,  reg16,  mem16
  $3F:  fCurrentInstruction.InstructionHandler := Instruction_D0_3F;  // MUL        reg8,   mem8,   reg8
  $40:  fCurrentInstruction.InstructionHandler := Instruction_D0_40;  // MUL        reg16,  mem16,  reg16
  $41:  fCurrentInstruction.InstructionHandler := Instruction_D0_41;  // MUL        mem8,   reg8,   reg8
  $42:  fCurrentInstruction.InstructionHandler := Instruction_D0_42;  // MUL        mem16,  reg16,  reg16
  $43:  fCurrentInstruction.InstructionHandler := Instruction_D0_43;  // IMUL       reg8,   imm8
  $44:  fCurrentInstruction.InstructionHandler := Instruction_D0_44;  // IMUL       reg16,  imm16
  $45:  fCurrentInstruction.InstructionHandler := Instruction_D0_45;  // IMUL       reg8,   reg8
  $46:  fCurrentInstruction.InstructionHandler := Instruction_D0_46;  // IMUL       reg16,  reg16
  $47:  fCurrentInstruction.InstructionHandler := Instruction_D0_47;  // IMUL       reg8,   mem8
  $48:  fCurrentInstruction.InstructionHandler := Instruction_D0_48;  // IMUL       reg16,  mem16
  $49:  fCurrentInstruction.InstructionHandler := Instruction_D0_49;  // IMUL       mem8,   reg8
  $4A:  fCurrentInstruction.InstructionHandler := Instruction_D0_4A;  // IMUL       mem16,  reg16
  $4B:  fCurrentInstruction.InstructionHandler := Instruction_D0_4B;  // IMUL       reg8,   reg8,   imm8
  $4C:  fCurrentInstruction.InstructionHandler := Instruction_D0_4C;  // IMUL       reg16,  reg16,  imm16
  $4D:  fCurrentInstruction.InstructionHandler := Instruction_D0_4D;  // IMUL       mem8,   reg8,   imm8
  $4E:  fCurrentInstruction.InstructionHandler := Instruction_D0_4E;  // IMUL       mem16,  reg16,  imm16
  $4F:  fCurrentInstruction.InstructionHandler := Instruction_D0_4F;  // IMUL       reg8,   mem8,   imm8
  $50:  fCurrentInstruction.InstructionHandler := Instruction_D0_50;  // IMUL       reg16,  mem16,  imm16
  $51:  fCurrentInstruction.InstructionHandler := Instruction_D0_51;  // IMUL       reg8,   reg8,   reg8
  $52:  fCurrentInstruction.InstructionHandler := Instruction_D0_52;  // IMUL       reg16,  reg16,  reg16
  $53:  fCurrentInstruction.InstructionHandler := Instruction_D0_53;  // IMUL       reg8,   reg8,   mem8
  $54:  fCurrentInstruction.InstructionHandler := Instruction_D0_54;  // IMUL       reg16,  reg16,  mem16
  $55:  fCurrentInstruction.InstructionHandler := Instruction_D0_55;  // IMUL       reg8,   mem8,   reg8
  $56:  fCurrentInstruction.InstructionHandler := Instruction_D0_56;  // IMUL       reg16,  mem16,  reg16
  $57:  fCurrentInstruction.InstructionHandler := Instruction_D0_57;  // IMUL       mem8,   reg8,   reg8
  $58:  fCurrentInstruction.InstructionHandler := Instruction_D0_58;  // IMUL       mem16,  reg16,  reg16
  $59:  fCurrentInstruction.InstructionHandler := Instruction_D1_59;  // DIV        reg8,   imm8
  $5A:  fCurrentInstruction.InstructionHandler := Instruction_D1_5A;  // DIV        reg16,  imm16
  $5B:  fCurrentInstruction.InstructionHandler := Instruction_D1_5B;  // DIV        reg8,   reg8
  $5C:  fCurrentInstruction.InstructionHandler := Instruction_D1_5C;  // DIV        reg16,  reg16
  $5D:  fCurrentInstruction.InstructionHandler := Instruction_D1_5D;  // DIV        reg8,   mem8
  $5E:  fCurrentInstruction.InstructionHandler := Instruction_D1_5E;  // DIV        reg16,  mem16
  $5F:  fCurrentInstruction.InstructionHandler := Instruction_D1_5F;  // DIV        mem8,   reg8
  $60:  fCurrentInstruction.InstructionHandler := Instruction_D1_60;  // DIV        mem16,  reg16
  $61:  fCurrentInstruction.InstructionHandler := Instruction_D0_61;  // DIV        reg8,   reg8,   imm8
  $62:  fCurrentInstruction.InstructionHandler := Instruction_D0_62;  // DIV        reg16,  reg16,  imm16
  $63:  fCurrentInstruction.InstructionHandler := Instruction_D0_63;  // DIV        mem8,   reg8,   imm8
  $64:  fCurrentInstruction.InstructionHandler := Instruction_D0_64;  // DIV        mem16,  reg16,  imm16
  $65:  fCurrentInstruction.InstructionHandler := Instruction_D0_65;  // DIV        reg8,   mem8,   imm8
  $66:  fCurrentInstruction.InstructionHandler := Instruction_D0_66;  // DIV        reg16,  mem16,  imm16
  $67:  fCurrentInstruction.InstructionHandler := Instruction_D0_67;  // DIV        reg8,   reg8,   reg8
  $68:  fCurrentInstruction.InstructionHandler := Instruction_D0_68;  // DIV        reg16,  reg16,  reg16
  $69:  fCurrentInstruction.InstructionHandler := Instruction_D0_69;  // DIV        reg8,   reg8,   mem8
  $6A:  fCurrentInstruction.InstructionHandler := Instruction_D0_6A;  // DIV        reg16,  reg16,  mem16
  $6B:  fCurrentInstruction.InstructionHandler := Instruction_D0_6B;  // DIV        reg8,   mem8,   reg8
  $6C:  fCurrentInstruction.InstructionHandler := Instruction_D0_6C;  // DIV        reg16,  mem16,  reg16
  $6D:  fCurrentInstruction.InstructionHandler := Instruction_D0_6D;  // DIV        mem8,   reg8,   reg8
  $6E:  fCurrentInstruction.InstructionHandler := Instruction_D0_6E;  // DIV        mem16,  reg16,  reg16
  $6F:  fCurrentInstruction.InstructionHandler := Instruction_D1_6F;  // IDIV       reg8,   imm8
  $70:  fCurrentInstruction.InstructionHandler := Instruction_D1_70;  // IDIV       reg16,  imm16
  $71:  fCurrentInstruction.InstructionHandler := Instruction_D1_71;  // IDIV       reg8,   reg8
  $72:  fCurrentInstruction.InstructionHandler := Instruction_D1_72;  // IDIV       reg16,  reg16
  $73:  fCurrentInstruction.InstructionHandler := Instruction_D1_73;  // IDIV       reg8,   mem8
  $74:  fCurrentInstruction.InstructionHandler := Instruction_D1_74;  // IDIV       reg16,  mem16
  $75:  fCurrentInstruction.InstructionHandler := Instruction_D1_75;  // IDIV       mem8,   reg8
  $76:  fCurrentInstruction.InstructionHandler := Instruction_D1_76;  // IDIV       mem16,  reg16
  $77:  fCurrentInstruction.InstructionHandler := Instruction_D0_77;  // IDIV       reg8,   reg8,   imm8
  $78:  fCurrentInstruction.InstructionHandler := Instruction_D0_78;  // IDIV       reg16,  reg16,  imm16
  $79:  fCurrentInstruction.InstructionHandler := Instruction_D0_79;  // IDIV       mem8,   reg8,   imm8
  $7A:  fCurrentInstruction.InstructionHandler := Instruction_D0_7A;  // IDIV       mem16,  reg16,  imm16
  $7B:  fCurrentInstruction.InstructionHandler := Instruction_D0_7B;  // IDIV       reg8,   mem8,   imm8
  $7C:  fCurrentInstruction.InstructionHandler := Instruction_D0_7C;  // IDIV       reg16,  mem16,  imm16
  $7D:  fCurrentInstruction.InstructionHandler := Instruction_D0_7D;  // IDIV       reg8,   reg8,   reg8
  $7E:  fCurrentInstruction.InstructionHandler := Instruction_D0_7E;  // IDIV       reg16,  reg16,  reg16
  $7F:  fCurrentInstruction.InstructionHandler := Instruction_D0_7F;  // IDIV       reg8,   reg8,   mem8
  $80:  fCurrentInstruction.InstructionHandler := Instruction_D0_80;  // IDIV       reg16,  reg16,  mem16
  $81:  fCurrentInstruction.InstructionHandler := Instruction_D0_81;  // IDIV       reg8,   mem8,   reg8
  $82:  fCurrentInstruction.InstructionHandler := Instruction_D0_82;  // IDIV       reg16,  mem16,  reg16
  $83:  fCurrentInstruction.InstructionHandler := Instruction_D0_83;  // IDIV       mem8,   reg8,   reg8
  $84:  fCurrentInstruction.InstructionHandler := Instruction_D0_84;  // IDIV       mem16,  reg16,  reg16
  $85:  fCurrentInstruction.InstructionHandler := Instruction_D0_85;  // MOD        reg8,   imm8
  $86:  fCurrentInstruction.InstructionHandler := Instruction_D0_86;  // MOD        reg16,  imm16
  $87:  fCurrentInstruction.InstructionHandler := Instruction_D0_87;  // MOD        reg8,   reg8
  $88:  fCurrentInstruction.InstructionHandler := Instruction_D0_88;  // MOD        reg16,  reg16
  $89:  fCurrentInstruction.InstructionHandler := Instruction_D0_89;  // MOD        reg8,   mem8
  $8A:  fCurrentInstruction.InstructionHandler := Instruction_D0_8A;  // MOD        reg16,  mem16
  $8B:  fCurrentInstruction.InstructionHandler := Instruction_D0_8B;  // MOD        mem8,   reg8
  $8C:  fCurrentInstruction.InstructionHandler := Instruction_D0_8C;  // MOD        mem16,  reg16
  $8D:  fCurrentInstruction.InstructionHandler := Instruction_D0_8D;  // MOD        reg8,   reg8,   imm8
  $8E:  fCurrentInstruction.InstructionHandler := Instruction_D0_8E;  // MOD        reg16,  reg16,  imm16
  $8F:  fCurrentInstruction.InstructionHandler := Instruction_D0_8F;  // MOD        mem8,   reg8,   imm8
  $90:  fCurrentInstruction.InstructionHandler := Instruction_D0_90;  // MOD        mem16,  reg16,  imm16
  $91:  fCurrentInstruction.InstructionHandler := Instruction_D0_91;  // MOD        reg8,   mem8,   imm8
  $92:  fCurrentInstruction.InstructionHandler := Instruction_D0_92;  // MOD        reg16,  mem16,  imm16
  $93:  fCurrentInstruction.InstructionHandler := Instruction_D0_93;  // MOD        reg8,   reg8,   reg8
  $94:  fCurrentInstruction.InstructionHandler := Instruction_D0_94;  // MOD        reg16,  reg16,  reg16
  $95:  fCurrentInstruction.InstructionHandler := Instruction_D0_95;  // MOD        reg8,   reg8,   mem8
  $96:  fCurrentInstruction.InstructionHandler := Instruction_D0_96;  // MOD        reg16,  reg16,  mem16
  $97:  fCurrentInstruction.InstructionHandler := Instruction_D0_97;  // MOD        reg8,   mem8,   reg8
  $98:  fCurrentInstruction.InstructionHandler := Instruction_D0_98;  // MOD        reg16,  mem16,  reg16
  $99:  fCurrentInstruction.InstructionHandler := Instruction_D0_99;  // MOD        mem8,   reg8,   reg8
  $9A:  fCurrentInstruction.InstructionHandler := Instruction_D0_9A;  // MOD        mem16,  reg16,  reg16
  $9B:  fCurrentInstruction.InstructionHandler := Instruction_D0_9B;  // IMOD       reg8,   imm8
  $9C:  fCurrentInstruction.InstructionHandler := Instruction_D0_9C;  // IMOD       reg16,  imm16
  $9D:  fCurrentInstruction.InstructionHandler := Instruction_D0_9D;  // IMOD       reg8,   reg8
  $9E:  fCurrentInstruction.InstructionHandler := Instruction_D0_9E;  // IMOD       reg16,  reg16
  $9F:  fCurrentInstruction.InstructionHandler := Instruction_D0_9F;  // IMOD       reg8,   mem8
  $A0:  fCurrentInstruction.InstructionHandler := Instruction_D0_A0;  // IMOD       reg16,  mem16
  $A1:  fCurrentInstruction.InstructionHandler := Instruction_D0_A1;  // IMOD       mem8,   reg8
  $A2:  fCurrentInstruction.InstructionHandler := Instruction_D0_A2;  // IMOD       mem16,  reg16
  $A3:  fCurrentInstruction.InstructionHandler := Instruction_D0_A3;  // IMOD       reg8,   reg8,   imm8
  $A4:  fCurrentInstruction.InstructionHandler := Instruction_D0_A4;  // IMOD       reg16,  reg16,  imm16
  $A5:  fCurrentInstruction.InstructionHandler := Instruction_D0_A5;  // IMOD       mem8,   reg8,   imm8
  $A6:  fCurrentInstruction.InstructionHandler := Instruction_D0_A6;  // IMOD       mem16,  reg16,  imm16
  $A7:  fCurrentInstruction.InstructionHandler := Instruction_D0_A7;  // IMOD       reg8,   mem8,   imm8
  $A8:  fCurrentInstruction.InstructionHandler := Instruction_D0_A8;  // IMOD       reg16,  mem16,  imm16
  $A9:  fCurrentInstruction.InstructionHandler := Instruction_D0_A9;  // IMOD       reg8,   reg8,   reg8
  $AA:  fCurrentInstruction.InstructionHandler := Instruction_D0_AA;  // IMOD       reg16,  reg16,  reg16
  $AB:  fCurrentInstruction.InstructionHandler := Instruction_D0_AB;  // IMOD       reg8,   reg8,   mem8
  $AC:  fCurrentInstruction.InstructionHandler := Instruction_D0_AC;  // IMOD       reg16,  reg16,  mem16
  $AD:  fCurrentInstruction.InstructionHandler := Instruction_D0_AD;  // IMOD       reg8,   mem8,   reg8
  $AE:  fCurrentInstruction.InstructionHandler := Instruction_D0_AE;  // IMOD       reg16,  mem16,  reg16
  $AF:  fCurrentInstruction.InstructionHandler := Instruction_D0_AF;  // IMOD       mem8,   reg8,   reg8
  $B0:  fCurrentInstruction.InstructionHandler := Instruction_D0_B0;  // IMOD       mem16,  reg16,  reg16
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.InstructionSelect_L2_D1(InstructionByte: TSVCByte);
begin
case InstructionByte of
  $00:  fCurrentInstruction.InstructionHandler := Instruction_00;     // HALT
  $01:  fCurrentInstruction.InstructionHandler := Instruction_D1_01;  // NOT        reg8
  $02:  fCurrentInstruction.InstructionHandler := Instruction_D1_02;  // NOT        reg16
  $03:  fCurrentInstruction.InstructionHandler := Instruction_D1_03;  // NOT        mem8
  $04:  fCurrentInstruction.InstructionHandler := Instruction_D1_04;  // NOT        mem16
  $05:  fCurrentInstruction.InstructionHandler := Instruction_D1_05;  // AND        reg8,   imm8
  $06:  fCurrentInstruction.InstructionHandler := Instruction_D1_06;  // AND        reg16,  imm16
  $07:  fCurrentInstruction.InstructionHandler := Instruction_D1_07;  // AND        reg8,   reg8
  $08:  fCurrentInstruction.InstructionHandler := Instruction_D1_08;  // AND        reg16,  reg16
  $09:  fCurrentInstruction.InstructionHandler := Instruction_D1_09;  // AND        reg8,   mem8
  $0A:  fCurrentInstruction.InstructionHandler := Instruction_D1_0A;  // AND        reg16,  mem16
  $0B:  fCurrentInstruction.InstructionHandler := Instruction_D1_0B;  // AND        mem8,   reg8
  $0C:  fCurrentInstruction.InstructionHandler := Instruction_D1_0C;  // AND        mem16,  reg16
  $0D:  fCurrentInstruction.InstructionHandler := Instruction_D1_0D;  // OR         reg8,   imm8
  $0E:  fCurrentInstruction.InstructionHandler := Instruction_D1_0E;  // OR         reg16,  imm16
  $0F:  fCurrentInstruction.InstructionHandler := Instruction_D1_0F;  // OR         reg8,   reg8
  $10:  fCurrentInstruction.InstructionHandler := Instruction_D1_10;  // OR         reg16,  reg16
  $11:  fCurrentInstruction.InstructionHandler := Instruction_D1_11;  // OR         reg8,   mem8
  $12:  fCurrentInstruction.InstructionHandler := Instruction_D1_12;  // OR         reg16,  mem16
  $13:  fCurrentInstruction.InstructionHandler := Instruction_D1_13;  // OR         mem8,   reg8
  $14:  fCurrentInstruction.InstructionHandler := Instruction_D1_14;  // OR         mem16,  reg16
  $15:  fCurrentInstruction.InstructionHandler := Instruction_D1_15;  // XOR        reg8,   imm8
  $16:  fCurrentInstruction.InstructionHandler := Instruction_D1_16;  // XOR        reg16,  imm16
  $17:  fCurrentInstruction.InstructionHandler := Instruction_D1_17;  // XOR        reg8,   reg8
  $18:  fCurrentInstruction.InstructionHandler := Instruction_D1_18;  // XOR        reg16,  reg16
  $19:  fCurrentInstruction.InstructionHandler := Instruction_D1_19;  // XOR        reg8,   mem8
  $1A:  fCurrentInstruction.InstructionHandler := Instruction_D1_1A;  // XOR        reg16,  mem16
  $1B:  fCurrentInstruction.InstructionHandler := Instruction_D1_1B;  // XOR        mem8,   reg8
  $1C:  fCurrentInstruction.InstructionHandler := Instruction_D1_1C;  // XOR        mem16,  reg16
  $1D:  fCurrentInstruction.InstructionHandler := Instruction_D1_1D;  // SHR        reg8
  $1E:  fCurrentInstruction.InstructionHandler := Instruction_D1_1E;  // SHR        reg16
  $1F:  fCurrentInstruction.InstructionHandler := Instruction_D1_1F;  // SHR        mem8
  $20:  fCurrentInstruction.InstructionHandler := Instruction_D1_20;  // SHR        mem16
  $21:  fCurrentInstruction.InstructionHandler := Instruction_D1_21;  // SHR        reg8,   imm8
  $22:  fCurrentInstruction.InstructionHandler := Instruction_D1_22;  // SHR        reg16,  imm8
  $23:  fCurrentInstruction.InstructionHandler := Instruction_D1_23;  // SHR        mem8,   imm8
  $24:  fCurrentInstruction.InstructionHandler := Instruction_D1_24;  // SHR        mem16,  imm8
  $25:  fCurrentInstruction.InstructionHandler := Instruction_D1_25;  // SHR        reg8,   reg8
  $26:  fCurrentInstruction.InstructionHandler := Instruction_D1_26;  // SHR        reg16,  reg8
  $27:  fCurrentInstruction.InstructionHandler := Instruction_D1_27;  // SHR        mem8,   reg8
  $28:  fCurrentInstruction.InstructionHandler := Instruction_D1_28;  // SHR        mem16,  reg8
  $29:  fCurrentInstruction.InstructionHandler := Instruction_D1_29;  // SAR        reg8
  $2A:  fCurrentInstruction.InstructionHandler := Instruction_D1_2A;  // SAR        reg16
  $2B:  fCurrentInstruction.InstructionHandler := Instruction_D1_2B;  // SAR        mem8
  $2C:  fCurrentInstruction.InstructionHandler := Instruction_D1_2C;  // SAR        mem16
  $2D:  fCurrentInstruction.InstructionHandler := Instruction_D1_2D;  // SAR        reg8,   imm8
  $2E:  fCurrentInstruction.InstructionHandler := Instruction_D1_2E;  // SAR        reg16,  imm8
  $2F:  fCurrentInstruction.InstructionHandler := Instruction_D1_2F;  // SAR        mem8,   imm8
  $30:  fCurrentInstruction.InstructionHandler := Instruction_D1_30;  // SAR        mem16,  imm8
  $31:  fCurrentInstruction.InstructionHandler := Instruction_D1_31;  // SAR        reg8,   reg8
  $32:  fCurrentInstruction.InstructionHandler := Instruction_D1_32;  // SAR        reg16,  reg8
  $33:  fCurrentInstruction.InstructionHandler := Instruction_D1_33;  // SAR        mem8,   reg8
  $34:  fCurrentInstruction.InstructionHandler := Instruction_D1_34;  // SAR        mem16,  reg8
  $35:  fCurrentInstruction.InstructionHandler := Instruction_D1_35;  // SHL        reg8
  $36:  fCurrentInstruction.InstructionHandler := Instruction_D1_36;  // SHL        reg16
  $37:  fCurrentInstruction.InstructionHandler := Instruction_D1_37;  // SHL        mem8
  $38:  fCurrentInstruction.InstructionHandler := Instruction_D1_38;  // SHL        mem16
  $39:  fCurrentInstruction.InstructionHandler := Instruction_D1_39;  // SHL        reg8,   imm8
  $3A:  fCurrentInstruction.InstructionHandler := Instruction_D1_3A;  // SHL        reg16,  imm8
  $3B:  fCurrentInstruction.InstructionHandler := Instruction_D1_3B;  // SHL        mem8,   imm8
  $3C:  fCurrentInstruction.InstructionHandler := Instruction_D1_3C;  // SHL        mem16,  imm8
  $3D:  fCurrentInstruction.InstructionHandler := Instruction_D1_3D;  // SHL        reg8,   reg8
  $3E:  fCurrentInstruction.InstructionHandler := Instruction_D1_3E;  // SHL        reg16,  reg8
  $3F:  fCurrentInstruction.InstructionHandler := Instruction_D1_3F;  // SHL        mem8,   reg8
  $40:  fCurrentInstruction.InstructionHandler := Instruction_D1_40;  // SHL        mem16,  reg8
  $41:  fCurrentInstruction.InstructionHandler := Instruction_D1_41;  // SAL        reg8
  $42:  fCurrentInstruction.InstructionHandler := Instruction_D1_42;  // SAL        reg16
  $43:  fCurrentInstruction.InstructionHandler := Instruction_D1_43;  // SAL        mem8
  $44:  fCurrentInstruction.InstructionHandler := Instruction_D1_44;  // SAL        mem16
  $45:  fCurrentInstruction.InstructionHandler := Instruction_D1_45;  // SAL        reg8,   imm8
  $46:  fCurrentInstruction.InstructionHandler := Instruction_D1_46;  // SAL        reg16,  imm8
  $47:  fCurrentInstruction.InstructionHandler := Instruction_D1_47;  // SAL        mem8,   imm8
  $48:  fCurrentInstruction.InstructionHandler := Instruction_D1_48;  // SAL        mem16,  imm8
  $49:  fCurrentInstruction.InstructionHandler := Instruction_D1_49;  // SAL        reg8,   reg8
  $4A:  fCurrentInstruction.InstructionHandler := Instruction_D1_4A;  // SAL        reg16,  reg8
  $4B:  fCurrentInstruction.InstructionHandler := Instruction_D1_4B;  // SAL        mem8,   reg8
  $4C:  fCurrentInstruction.InstructionHandler := Instruction_D1_4C;  // SAL        mem16,  reg8
  $4D:  fCurrentInstruction.InstructionHandler := Instruction_D1_4D;  // ROR        reg8
  $4E:  fCurrentInstruction.InstructionHandler := Instruction_D1_4E;  // ROR        reg16
  $4F:  fCurrentInstruction.InstructionHandler := Instruction_D1_4F;  // ROR        mem8
  $50:  fCurrentInstruction.InstructionHandler := Instruction_D1_50;  // ROR        mem16
  $51:  fCurrentInstruction.InstructionHandler := Instruction_D1_51;  // ROR        reg8,   imm8
  $52:  fCurrentInstruction.InstructionHandler := Instruction_D1_52;  // ROR        reg16,  imm8
  $53:  fCurrentInstruction.InstructionHandler := Instruction_D1_53;  // ROR        mem8,   imm8
  $54:  fCurrentInstruction.InstructionHandler := Instruction_D1_54;  // ROR        mem16,  imm8
  $55:  fCurrentInstruction.InstructionHandler := Instruction_D1_55;  // ROR        reg8,   reg8
  $56:  fCurrentInstruction.InstructionHandler := Instruction_D1_56;  // ROR        reg16,  reg8
  $57:  fCurrentInstruction.InstructionHandler := Instruction_D1_57;  // ROR        mem8,   reg8
  $58:  fCurrentInstruction.InstructionHandler := Instruction_D1_58;  // ROR        mem16,  reg8
  $59:  fCurrentInstruction.InstructionHandler := Instruction_D1_59;  // ROL        reg8
  $5A:  fCurrentInstruction.InstructionHandler := Instruction_D1_5A;  // ROL        reg16
  $5B:  fCurrentInstruction.InstructionHandler := Instruction_D1_5B;  // ROL        mem8
  $5C:  fCurrentInstruction.InstructionHandler := Instruction_D1_5C;  // ROL        mem16
  $5D:  fCurrentInstruction.InstructionHandler := Instruction_D1_5D;  // ROL        reg8,   imm8
  $5E:  fCurrentInstruction.InstructionHandler := Instruction_D1_5E;  // ROL        reg16,  imm8
  $5F:  fCurrentInstruction.InstructionHandler := Instruction_D1_5F;  // ROL        mem8,   imm8
  $60:  fCurrentInstruction.InstructionHandler := Instruction_D1_60;  // ROL        mem16,  imm8
  $61:  fCurrentInstruction.InstructionHandler := Instruction_D1_61;  // ROL        reg8,   reg8
  $62:  fCurrentInstruction.InstructionHandler := Instruction_D1_62;  // ROL        reg16,  reg8
  $63:  fCurrentInstruction.InstructionHandler := Instruction_D1_63;  // ROL        mem8,   reg8
  $64:  fCurrentInstruction.InstructionHandler := Instruction_D1_64;  // ROL        mem16,  reg8
  $65:  fCurrentInstruction.InstructionHandler := Instruction_D1_65;  // RCR        reg8
  $66:  fCurrentInstruction.InstructionHandler := Instruction_D1_66;  // RCR        reg16
  $67:  fCurrentInstruction.InstructionHandler := Instruction_D1_67;  // RCR        mem8
  $68:  fCurrentInstruction.InstructionHandler := Instruction_D1_68;  // RCR        mem16
  $69:  fCurrentInstruction.InstructionHandler := Instruction_D1_69;  // RCR        reg8,   imm8
  $6A:  fCurrentInstruction.InstructionHandler := Instruction_D1_6A;  // RCR        reg16,  imm8
  $6B:  fCurrentInstruction.InstructionHandler := Instruction_D1_6B;  // RCR        mem8,   imm8
  $6C:  fCurrentInstruction.InstructionHandler := Instruction_D1_6C;  // RCR        mem16,  imm8
  $6D:  fCurrentInstruction.InstructionHandler := Instruction_D1_6D;  // RCR        reg8,   reg8
  $6E:  fCurrentInstruction.InstructionHandler := Instruction_D1_6E;  // RCR        reg16,  reg8
  $6F:  fCurrentInstruction.InstructionHandler := Instruction_D1_6F;  // RCR        mem8,   reg8
  $70:  fCurrentInstruction.InstructionHandler := Instruction_D1_70;  // RCR        mem16,  reg8
  $71:  fCurrentInstruction.InstructionHandler := Instruction_D1_71;  // RCL        reg8
  $72:  fCurrentInstruction.InstructionHandler := Instruction_D1_72;  // RCL        reg16
  $73:  fCurrentInstruction.InstructionHandler := Instruction_D1_73;  // RCL        mem8
  $74:  fCurrentInstruction.InstructionHandler := Instruction_D1_74;  // RCL        mem16
  $75:  fCurrentInstruction.InstructionHandler := Instruction_D1_75;  // RCL        reg8,   imm8
  $76:  fCurrentInstruction.InstructionHandler := Instruction_D1_76;  // RCL        reg16,  imm8
  $77:  fCurrentInstruction.InstructionHandler := Instruction_D1_77;  // RCL        mem8,   imm8
  $78:  fCurrentInstruction.InstructionHandler := Instruction_D1_78;  // RCL        mem16,  imm8
  $79:  fCurrentInstruction.InstructionHandler := Instruction_D1_79;  // RCL        reg8,   reg8
  $7A:  fCurrentInstruction.InstructionHandler := Instruction_D1_7A;  // RCL        reg16,  reg8
  $7B:  fCurrentInstruction.InstructionHandler := Instruction_D1_7B;  // RCL        mem8,   reg8
  $7C:  fCurrentInstruction.InstructionHandler := Instruction_D1_7C;  // RCL        mem16,  reg8
  $7D:  fCurrentInstruction.InstructionHandler := Instruction_D1_7D;  // BT         reg8,   imm8
  $7E:  fCurrentInstruction.InstructionHandler := Instruction_D1_7E;  // BT         reg16,  imm16
  $7F:  fCurrentInstruction.InstructionHandler := Instruction_D1_7F;  // BT         reg8,   reg8
  $80:  fCurrentInstruction.InstructionHandler := Instruction_D1_80;  // BT         reg16,  reg16
  $81:  fCurrentInstruction.InstructionHandler := Instruction_D1_81;  // BT         mem8,   reg8
  $82:  fCurrentInstruction.InstructionHandler := Instruction_D1_82;  // BT         mem16,  reg16
  $83:  fCurrentInstruction.InstructionHandler := Instruction_D1_83;  // BT         mem8,   imm8
  $84:  fCurrentInstruction.InstructionHandler := Instruction_D1_84;  // BT         mem16,  imm16
  $85:  fCurrentInstruction.InstructionHandler := Instruction_D1_85;  // BTS        reg8,   imm8
  $86:  fCurrentInstruction.InstructionHandler := Instruction_D1_86;  // BTS        reg16,  imm16
  $87:  fCurrentInstruction.InstructionHandler := Instruction_D1_87;  // BTS        reg8,   reg8
  $88:  fCurrentInstruction.InstructionHandler := Instruction_D1_88;  // BTS        reg16,  reg16
  $89:  fCurrentInstruction.InstructionHandler := Instruction_D1_89;  // BTS        mem8,   reg8
  $8A:  fCurrentInstruction.InstructionHandler := Instruction_D1_8A;  // BTS        mem16,  reg16
  $8B:  fCurrentInstruction.InstructionHandler := Instruction_D1_8B;  // BTS        mem8,   imm8
  $8C:  fCurrentInstruction.InstructionHandler := Instruction_D1_8C;  // BTS        mem16,  imm16
  $8D:  fCurrentInstruction.InstructionHandler := Instruction_D1_8D;  // BTR        reg8,   imm8
  $8E:  fCurrentInstruction.InstructionHandler := Instruction_D1_8E;  // BTR        reg16,  imm16
  $8F:  fCurrentInstruction.InstructionHandler := Instruction_D1_8F;  // BTR        reg8,   reg8
  $90:  fCurrentInstruction.InstructionHandler := Instruction_D1_90;  // BTR        reg16,  reg16
  $91:  fCurrentInstruction.InstructionHandler := Instruction_D1_91;  // BTR        mem8,   reg8
  $92:  fCurrentInstruction.InstructionHandler := Instruction_D1_92;  // BTR        mem16,  reg16
  $93:  fCurrentInstruction.InstructionHandler := Instruction_D1_93;  // BTR        mem8,   imm8
  $94:  fCurrentInstruction.InstructionHandler := Instruction_D1_94;  // BTR        mem16,  imm16
  $95:  fCurrentInstruction.InstructionHandler := Instruction_D1_95;  // BTC        reg8,   imm8
  $96:  fCurrentInstruction.InstructionHandler := Instruction_D1_96;  // BTC        reg16,  imm16
  $97:  fCurrentInstruction.InstructionHandler := Instruction_D1_97;  // BTC        reg8,   reg8
  $98:  fCurrentInstruction.InstructionHandler := Instruction_D1_98;  // BTC        reg16,  reg16
  $99:  fCurrentInstruction.InstructionHandler := Instruction_D1_99;  // BTC        mem8,   reg8
  $9A:  fCurrentInstruction.InstructionHandler := Instruction_D1_9A;  // BTC        mem16,  reg16
  $9B:  fCurrentInstruction.InstructionHandler := Instruction_D1_9B;  // BTC        mem8,   imm8
  $9C:  fCurrentInstruction.InstructionHandler := Instruction_D1_9C;  // BTC        mem16,  imm16
  $9D:  fCurrentInstruction.InstructionHandler := Instruction_D1_9D;  // BSF        reg8,   reg8
  $9E:  fCurrentInstruction.InstructionHandler := Instruction_D1_9E;  // BSF        reg16,  reg16
  $9F:  fCurrentInstruction.InstructionHandler := Instruction_D1_9F;  // BSF        reg8,   mem8
  $A0:  fCurrentInstruction.InstructionHandler := Instruction_D1_A0;  // BSF        reg16,  mem16
  $A1:  fCurrentInstruction.InstructionHandler := Instruction_D1_A1;  // BSR        reg8,   reg8
  $A2:  fCurrentInstruction.InstructionHandler := Instruction_D1_A2;  // BSR        reg16,  reg16
  $A3:  fCurrentInstruction.InstructionHandler := Instruction_D1_A3;  // BSR        reg8,   mem8
  $A4:  fCurrentInstruction.InstructionHandler := Instruction_D1_A4;  // BSR        reg16,  mem16
  $A5:  fCurrentInstruction.InstructionHandler := Instruction_D1_A5;  // SHRD       reg16,  reg16,  imm8
  $A6:  fCurrentInstruction.InstructionHandler := Instruction_D1_A6;  // SHRD       mem16,  reg16,  imm8
  $A7:  fCurrentInstruction.InstructionHandler := Instruction_D1_A7;  // SHRD       reg16,  mem16,  imm8
  $A8:  fCurrentInstruction.InstructionHandler := Instruction_D1_A8;  // SHRD       reg16,  reg16,  reg8
  $A9:  fCurrentInstruction.InstructionHandler := Instruction_D1_A9;  // SHRD       mem16,  reg16,  reg8
  $AA:  fCurrentInstruction.InstructionHandler := Instruction_D1_AA;  // SHRD       reg16,  mem16,  reg8
  $AB:  fCurrentInstruction.InstructionHandler := Instruction_D1_AB;  // SHLD       reg16,  reg16,  imm8
  $AC:  fCurrentInstruction.InstructionHandler := Instruction_D1_AC;  // SHLD       mem16,  reg16,  imm8
  $AD:  fCurrentInstruction.InstructionHandler := Instruction_D1_AD;  // SHLD       reg16,  mem16,  imm8
  $AE:  fCurrentInstruction.InstructionHandler := Instruction_D1_AE;  // SHLD       reg16,  reg16,  reg8
  $AF:  fCurrentInstruction.InstructionHandler := Instruction_D1_AF;  // SHLD       mem16,  reg16,  reg8
  $B0:  fCurrentInstruction.InstructionHandler := Instruction_D1_B0;  // SHLD       reg16,  mem16,  reg8
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.InstructionSelect_L2_D2(InstructionByte: TSVCByte);
begin
case InstructionByte of
  $00:  fCurrentInstruction.InstructionHandler := Instruction_00;     // HALT
  $01:  fCurrentInstruction.InstructionHandler := Instruction_D2_01;  // LODSB      reg8,   reg16
  $02:  fCurrentInstruction.InstructionHandler := Instruction_D2_02;  // LODSW      reg16,  reg16
  $03:  fCurrentInstruction.InstructionHandler := Instruction_D2_03;  // STOSB      reg16,  reg8
  $04:  fCurrentInstruction.InstructionHandler := Instruction_D2_04;  // STOSW      reg16,  reg16
  $05:  fCurrentInstruction.InstructionHandler := Instruction_D2_05;  // MOVSB      reg16,  reg16
  $06:  fCurrentInstruction.InstructionHandler := Instruction_D2_06;  // MOVSW      reg16,  reg16
  $07:  fCurrentInstruction.InstructionHandler := Instruction_D2_07;  // LOADSB     reg16,  reg16
  $08:  fCurrentInstruction.InstructionHandler := Instruction_D2_08;  // LOADSW     reg16,  reg16
  $09:  fCurrentInstruction.InstructionHandler := Instruction_D2_09;  // STORESB    reg16,  reg16
  $0A:  fCurrentInstruction.InstructionHandler := Instruction_D2_0A;  // STORESW    reg16,  reg16
  $0B:  fCurrentInstruction.InstructionHandler := Instruction_D2_0B;  // CMPSB      reg16,  reg16
  $0C:  fCurrentInstruction.InstructionHandler := Instruction_D2_0C;  // CMPSW      reg16,  reg16
  $0D:  fCurrentInstruction.InstructionHandler := Instruction_D2_0D;  // SCASB      reg8,   reg16
  $0E:  fCurrentInstruction.InstructionHandler := Instruction_D2_0E;  // SCASW      reg16,  reg16
  $0F:  fCurrentInstruction.InstructionHandler := Instruction_D2_0F;  // INSB       reg16,  imm8
  $10:  fCurrentInstruction.InstructionHandler := Instruction_D2_10;  // INSW       reg16,  imm8
  $11:  fCurrentInstruction.InstructionHandler := Instruction_D2_11;  // INSB       reg16,  reg8
  $12:  fCurrentInstruction.InstructionHandler := Instruction_D2_12;  // INSW       reg16,  reg8
  $13:  fCurrentInstruction.InstructionHandler := Instruction_D2_13;  // OUTSB      imm8,   reg16
  $14:  fCurrentInstruction.InstructionHandler := Instruction_D2_14;  // OUTSW      imm8,   reg16
  $15:  fCurrentInstruction.InstructionHandler := Instruction_D2_15;  // OUTSB      reg8,   reg16
  $16:  fCurrentInstruction.InstructionHandler := Instruction_D2_16;  // OUTSW      reg8,   reg16
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;
end;

//==============================================================================

Function TSVCProcessor_0000.RepeatPrefixActive: Boolean;
begin
Result := (ipfxREP   in fCurrentInstruction.Prefixes) or
          (ipfxREPZ  in fCurrentInstruction.Prefixes) or
          (ipfxREPNZ in fCurrentInstruction.Prefixes);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.RepeatNextCycle: Boolean;
begin
fRegisters.CNTR := TSVCNative(TSVCComp(fRegisters.CNTR) - 1);
If ipfxREPZ in fCurrentInstruction.Prefixes then
  Result := not GetFlag(SVC_REG_FLAGS_ZERO)
else If ipfxREPNZ in fCurrentInstruction.Prefixes then
  Result := GetFlag(SVC_REG_FLAGS_ZERO)
else
  Result := True;
end;

//==============================================================================

Function TSVCProcessor_0000.FlaggedADD_B(A,B: TSVCByte): TSVCByte;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $80) <> 0; S2 := (B and $80) <> 0;
Result := TSVCByte(TSVCComp(A) + TSVCComp(B));
SR := (Result and $80) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,Result < A);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,not(S1 xor S2) and (S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedADD_W(A,B: TSVCWord): TSVCWord;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $8000) <> 0; S2 := (B and $8000) <> 0;
Result := TSVCWord(TSVCComp(A) + TSVCComp(B));
SR := (Result and $8000) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,Result < A);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,not(S1 xor S2) and (S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSUB_B(A,B: TSVCByte): TSVCByte;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $80) <> 0; S2 := (B and $80) <> 0;
Result := TSVCByte(TSVCComp(A) - TSVCComp(B));
SR := (Result and $80) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,A < B);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,(S1 xor S2) and not(S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSUB_W(A,B: TSVCWord): TSVCWord;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $8000) <> 0; S2 := (B and $8000) <> 0;
Result := TSVCWord(TSVCComp(A) - TSVCComp(B));
SR := (Result and $8000) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,A < B);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,(S1 xor S2) and not(S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedADC_B(A,B: TSVCByte): TSVCByte;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $80) <> 0; S2 := (B and $80) <> 0;
Result := TSVCByte(TSVCComp(A) + TSVCComp(B) + TSVCComp(BoolToByte(GetFlag(SVC_REG_FLAGS_CARRY))));
SR := (Result and $80) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,Result < A);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,not(S1 xor S2) and (S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedADC_W(A,B: TSVCWord): TSVCWord;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $8000) <> 0; S2 := (B and $8000) <> 0;
Result := TSVCWord(TSVCComp(A) + TSVCComp(B) + TSVCComp(BoolToByte(GetFlag(SVC_REG_FLAGS_CARRY))));
SR := (Result and $8000) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,Result < A);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,not(S1 xor S2) and (S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSBB_B(A,B: TSVCByte): TSVCByte;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $80) <> 0; S2 := (B and $80) <> 0;
Result := TSVCByte(TSVCComp(A) - (TSVCComp(B) + TSVCComp(BoolToByte(GetFlag(SVC_REG_FLAGS_CARRY)))));
SR := (Result and $80) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,A < B);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,(S1 xor S2) and not(S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSBB_W(A,B: TSVCWord): TSVCWord;
var
  S1,S2,SR: Boolean;
begin
S1 := (A and $8000) <> 0; S2 := (B and $8000) <> 0;
Result := TSVCWord(TSVCComp(A) - (TSVCComp(B) + TSVCComp(BoolToByte(GetFlag(SVC_REG_FLAGS_CARRY)))));
SR := (Result and $8000) <> 0;
SetFlagValue(SVC_REG_FLAGS_CARRY,A < B);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,SR);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,(S1 xor S2) and not(S2 xor SR));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedMUL_B(A,B: TSVCByte; out High: TSVCByte): TSVCByte;
var
  FullResult: TSVCWord;
begin
FullResult := TSVCWord(A) * TSVCWord(B);
Result := TSVCByte(FullResult);
High := TSVCByte(FullResult shr 8);
SetFlagValue(SVC_REG_FLAGS_CARRY,High <> 0);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,High <> 0);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedMUL_W(A,B: TSVCWord; out High: TSVCWord): TSVCWord;
var
  FullResult: TSVCLong;
begin
FullResult := TSVCLong(A) * TSVCLong(B);
Result := TSVCWord(FullResult);
High := TSVCWord(FullResult shr 16);
SetFlagValue(SVC_REG_FLAGS_CARRY,High <> 0);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,High <> 0);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedIMUL_B(A,B: TSVCSByte; out High: TSVCSByte): TSVCSByte;
var
  FullResult: TSVCSWord;
begin
FullResult := TSVCSWord(A) * TSVCSWord(B);
Result := TSVCSByte(FullResult);
High := TSVCSByte(FullResult shr 8);
SetFlagValue(SVC_REG_FLAGS_CARRY,FullResult <> TSVCSWord(Result));
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(TSVCByte(Result)));
SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
SetFlagValue(SVC_REG_FLAGS_SIGN,(TSVCWord(FullResult) and TSVCWord($8000)) <> 0);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,FullResult <> TSVCSWord(Result));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedIMUL_W(A,B: TSVCSWord; out High: TSVCSWord): TSVCSWord;
var
  FullResult: TSVCSLong;
begin
FullResult := TSVCSLong(A) * TSVCSLong(B);
Result := TSVCSWord(FullResult);
High := TSVCSWord(FullResult shr 16);
SetFlagValue(SVC_REG_FLAGS_CARRY,FullResult <> TSVCSLong(Result));
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(TSVCWord(Result)));
SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
SetFlagValue(SVC_REG_FLAGS_SIGN,(TSVCLong(FullResult) and TSVCLong($80000000)) <> 0);
SetFlagValue(SVC_REG_FLAGS_OVERFLOW,FullResult <> TSVCSLong(Result));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedDIV_B(AL,AH,B: TSVCByte; out High: TSVCByte): TSVCByte;
var
  FullResult: TSVCWord;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCWord(AH) shl 8) or TSVCWord(AL)) div TSVCWord(B);
    Result := TSVCByte(FullResult);
    High := TSVCByte(FullResult shr 8);
    SetFlagValue(SVC_REG_FLAGS_CARRY,High <> 0);
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
    SetFlagValue(SVC_REG_FLAGS_OVERFLOW,High <> 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedDIV_W(AL,AH,B: TSVCWord; out High: TSVCWord): TSVCWord;
var
  FullResult: TSVCLong;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCLong(AH) shl 16) or TSVCLong(AL)) div TSVCLong(B);
    Result := TSVCWord(FullResult);
    High := TSVCWord(FullResult shr 16);
    SetFlagValue(SVC_REG_FLAGS_CARRY,High <> 0);
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
    SetFlagValue(SVC_REG_FLAGS_OVERFLOW,High <> 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedIDIV_B(AL,AH,B: TSVCSByte; out High: TSVCSByte): TSVCSByte;
var
  FullResult: TSVCSWord;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCSWord(AH) shl 8) or TSVCSWord(AL)) div TSVCSWord(B);
    Result := TSVCSByte(FullResult);
    High := TSVCSByte(FullResult shr 8);
    SetFlagValue(SVC_REG_FLAGS_CARRY,High <> 0);
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(TSVCByte(Result)));
    SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
    SetFlagValue(SVC_REG_FLAGS_OVERFLOW,High <> 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedIDIV_W(AL,AH,B: TSVCSWord; out High: TSVCSWord): TSVCSWord;
var
  FullResult: TSVCSLong;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCSLong(AH) shl 16) or TSVCSLong(AL)) div TSVCSLong(B);
    Result := TSVCSWord(FullResult);
    High := TSVCSWord(FullResult shr 16);
    SetFlagValue(SVC_REG_FLAGS_CARRY,High <> 0);
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(TSVCWord(Result)));
    SetFlagValue(SVC_REG_FLAGS_ZERO,(Result = 0) and (High = 0));
    SetFlagValue(SVC_REG_FLAGS_OVERFLOW,High <> 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedMOD_B(AL,AH,B: TSVCByte): TSVCByte;
var
  FullResult: TSVCWord;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCWord(AH) shl 8) or TSVCWord(AL)) mod TSVCWord(B);
    Result := TSVCByte(FullResult);
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedMOD_W(AL,AH,B: TSVCWord): TSVCWord;
var
  FullResult: TSVCLong;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCLong(AH) shl 8) or TSVCLong(AL)) mod TSVCLong(B);
    Result := TSVCWord(FullResult);
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedIMOD_B(AL,AH,B: TSVCSByte): TSVCSByte;
var
  FullResult: TSVCSWord;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCSWord(AH) shl 8) or TSVCSWord(AL)) mod TSVCSWord(B);
    Result := TSVCSByte(FullResult);
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(TSVCByte(Result)));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedIMOD_W(AL,AH,B: TSVCSWord): TSVCSWord;
var
  FullResult: TSVCSLong;
begin
If B <> 0 then
  begin
    FullResult := ((TSVCSLong(AH) shl 8) or TSVCSLong(AL)) mod TSVCSLong(B);
    Result := TSVCSWord(FullResult);
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(TSVCWord(Result)));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_DIVISIONBYZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedAND_B(A,B: TSVCByte): TSVCByte;
begin
Result := A and B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedAND_W(A,B: TSVCWord): TSVCWord;
begin
Result := A and B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedOR_B(A,B: TSVCByte): TSVCByte;
begin
Result := A or B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedOR_W(A,B: TSVCWord): TSVCWord;
begin
Result := A or B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedXOR_B(A,B: TSVCByte): TSVCByte;
begin
Result := A xor B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedXOR_W(A,B: TSVCWord): TSVCWord;
begin
Result := A xor B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSHR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := TSVCByte(A shr (Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $7))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSHR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := TSVCWord(A shr (Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $F))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSAR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := SAR(A,UInt8(Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $7))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSAR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := SAR(A,UInt8(Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $F))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSHL_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := TSVCByte(A shl (Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(8 - (Count and $7))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSHL_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := TSVCWord(A shl (Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(16 - (Count and $F))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedROR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := ROR(A,UInt8(Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $7))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedROR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := ROR(A,UInt8(Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $F))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedROL_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := ROL(A,UInt8(Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(8 - (Count and $7))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedROL_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := ROL(A,UInt8(Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(16 - (Count and $F))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedRCR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
var
  Carry:  ByteBool;
begin
If (Count and $7) <> 0 then
  begin
    Carry := GetFlag(SVC_REG_FLAGS_CARRY);
    Result := RCRCarry(A,UInt8(Count and $7),Carry);
    SetFlagValue(SVC_REG_FLAGS_CARRY,Carry);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedRCR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
var
  Carry:  ByteBool;
begin
If (Count and $F) <> 0 then
  begin
    Carry := GetFlag(SVC_REG_FLAGS_CARRY);
    Result := RCRCarry(A,UInt8(Count and $F),Carry);
    SetFlagValue(SVC_REG_FLAGS_CARRY,Carry);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedRCL_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
var
  Carry:  ByteBool;
begin
If (Count and $7) <> 0 then
  begin
    Carry := GetFlag(SVC_REG_FLAGS_CARRY);
    Result := RCLCarry(A,UInt8(Count and $7),Carry);
    SetFlagValue(SVC_REG_FLAGS_CARRY,Carry);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedRCL_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
var
  Carry:  ByteBool;
begin
If (Count and $F) <> 0 then
  begin
    Carry := GetFlag(SVC_REG_FLAGS_CARRY);
    Result := RCLCarry(A,UInt8(Count and $F),Carry);
    SetFlagValue(SVC_REG_FLAGS_CARRY,Carry);
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSHRD_W(AL,AH: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := TSVCWord(TSVCLong((TSVCLong(AH) shl 16) or AL) shr (Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(AL,UInt8(Pred(Count and $F))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
  end
else Result := AL;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000.FlaggedSHLD_W(AL,AH: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := TSVCWord(TSVCLong((TSVCLong(AH) shl 16) or AL) shr (16 - (Count and $F)));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(AH,UInt8(16 - (Count and $F))));
    SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
    SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
    SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
  end
else Result := AL;
end;

//==============================================================================

procedure TSVCProcessor_0000.ImplementationXCHG_B;
var
  Temp: TSVCByte;
begin
Temp := TSVCByte(GetArgVal(0));
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
TSVCByte(GetArgPtr(1)^) := Temp;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.ImplementationXCHG_W;
var
  Temp: TSVCWord;
begin
Temp := TSVCWord(GetArgVal(0));
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
TSVCWord(GetArgPtr(1)^) := Temp;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.ImplementationINC_B;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.ImplementationINC_W;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.ImplementationDEC_B;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.ImplementationDEC_W;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//==============================================================================

procedure TSVCProcessor_0000.Instruction_50;   // LEA        reg16,  mem
begin
ArgumentsDecode(True,[iatREG16,iatMEM]);
TSVCNative(GetArgPtr(0)^) := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_51;   // LEA        reg16,  rel8
begin
ArgumentsDecode(False,[iatREG16,iatREL8]);
TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(fRegisters.IP) + TSVCComp(TSVCSNative(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_52;   // LEA        reg16,  rel16
begin
ArgumentsDecode(False,[iatREG16,iatREL16]);
TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(fRegisters.IP) + TSVCComp(TSVCSNative(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_53;   // CMP        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_54;   // CMP        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_55;   // CMP        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_56;   // CMP        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_57;   // CMP        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_58;   // CMP        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_59;   // CMP        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_5A;   // CMP        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_5B;   // TEST       reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_5C;   // TEST       reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_5D;   // TEST       reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_5E;   // TEST       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_5F;   // TEST       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_60;   // TEST       reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_61;   // TEST       mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_62;   // TEST       mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_63;   // JMP        rel8
begin
ArgumentsDecode(False,[iatREL8]);
AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_64;   // JMP        rel16
begin
ArgumentsDecode(False,[iatREL16]);
AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_65;   // JMP        reg16
begin
ArgumentsDecode(False,[iatREG16]);
fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_66;   // JMP        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_67;   // Jcc        rel8
begin
ArgumentsDecode(True,[iatREL8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_68;   // Jcc        rel16
begin
ArgumentsDecode(True,[iatREL16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_69;   // Jcc        reg16
begin
ArgumentsDecode(True,[iatREG16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_6A;   // Jcc        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_6B;   // SETcc      reg8
begin
ArgumentsDecode(True,[iatREG8]);
TSVCByte(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_6C;   // SETcc      reg16
begin
ArgumentsDecode(True,[iatREG16]);
TSVCWord(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_6D;   // SETcc      mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_6E;   // SETcc      mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_6F;   // CMOVcc     reg8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatIMM8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_70;   // CMOVcc     reg16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatIMM16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_71;   // CMOVcc     reg8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatREG8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_72;   // CMOVcc     reg16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatREG16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_73;   // CMOVcc     reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_74;   // CMOVcc     reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_75;   // CMOVcc     mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_76;   // CMOVcc     mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_77;   // LOOP       rel8
begin
ArgumentsDecode(False,[iatREL8]);
If fRegisters.CNTR > 0 then
  begin
    AdvanceIP(GetArgVal(0));
    Dec(fRegisters.CNTR);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_78;   // LOOP       rel16
begin
ArgumentsDecode(False,[iatREL16]);
If fRegisters.CNTR > 0 then
  begin
    AdvanceIP(GetArgVal(0));
    Dec(fRegisters.CNTR);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_79;   // LOOPcc     rel8
begin
ArgumentsDecode(True,[iatREL8]);
If (fRegisters.CNTR > 0) and EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    AdvanceIP(GetArgVal(0));
    Dec(fRegisters.CNTR);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_7A;   // LOOPcc     rel16
begin
ArgumentsDecode(True,[iatREL16]);
If (fRegisters.CNTR > 0) and EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    AdvanceIP(GetArgVal(0));
    Dec(fRegisters.CNTR);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_7B;   // MOV        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_7C;   // MOV        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_7D;   // MOV        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_7E;   // MOV        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_7F;   // MOV        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_80;   // MOV        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_81;   // MOV        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_82;   // MOV        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_83;   // MOVZX      reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_84;   // MOVZX      reg16,  mem8
begin
ArgumentsDecode(True,[iatREG16,iatMEM8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_85;   // MOVSX      reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCSWord(TSVCSByte(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_86;   // MOVSX      reg16,  mem8
begin
ArgumentsDecode(True,[iatREG16,iatMEM8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCSWord(TSVCSByte(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_87;   // XCHG       reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
ImplementationXCHG_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_88;   // XCHG       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
ImplementationXCHG_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_89;   // XCHG       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
ImplementationXCHG_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_8A;   // XCHG       reg16,  mem16
begin
ArgumentsDecode(False,[iatREG16,iatMEM16]);
ImplementationXCHG_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_8B;   // XCHG       mem8,   reg8
begin
ArgumentsDecode(False,[iatMEM8,iatREG8]);
ImplementationXCHG_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_8C;   // XCHG       mem16,  reg16
begin
ArgumentsDecode(False,[iatMEM16,iatREG16]);
ImplementationXCHG_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_8D;   // CVTSX      reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCSWord(GetArgPtr(0)^) := TSVCSWord(TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_8E;   // CVTSX      reg16,  mem8
begin
ArgumentsDecode(False,[iatREG16,iatMEM8]);
TSVCSWord(GetArgPtr(0)^) := TSVCSWord(TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_8F;   // CVTSX      mem16,  reg8
begin
ArgumentsDecode(False,[iatMEM16,iatREG8]);
TSVCSWord(GetArgPtr(0)^) := TSVCSWord(TSVCSByte(GetArgVal(1)));
end;

//==============================================================================

procedure TSVCProcessor_0000.Instruction_D0_01;   // INC        reg8
begin
ArgumentsDecode(False,[iatREG8]);
ImplementationINC_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_02;   // INC        reg16
begin
ArgumentsDecode(False,[iatREG16]);
ImplementationINC_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_03;   // INC        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
ImplementationINC_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_04;   // INC        mem16
begin
ArgumentsDecode(False,[iatMEM16]);
ImplementationINC_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_05;   // DEC        reg8
begin
ArgumentsDecode(False,[iatREG8]);
ImplementationDEC_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_06;   // DEC        reg16
begin
ArgumentsDecode(False,[iatREG16]);
ImplementationDEC_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_07;   // DEC        mem8
begin
ArgumentsDecode(False,[iatMEM8]);
ImplementationDEC_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_08;   // DEC        mem16
begin
ArgumentsDecode(False,[iatMEM16]);
ImplementationDEC_W;
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_09;   // NEG        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := -TSVCSByte(GetArgVal(0));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_0A;   // NEG        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCSWord(GetArgPtr(0)^) := -TSVCSWord(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_0B;   // NEG        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := -TSVCSByte(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_0C;   // NEG        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := -TSVCSWord(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_0D;   // ADD        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_0E;   // ADD        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_0F;   // ADD        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_10;   // ADD        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_11;   // ADD        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_12;   // ADD        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_13;   // ADD        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_14;   // ADD        mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_15;   // SUB        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_16;   // SUB        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_17;   // SUB        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_18;   // SUB        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_19;   // SUB        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_1A;   // SUB        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_1B;   // SUB        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_1C;   // SUB        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_1D;   // ADC        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_1E;   // ADC        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_1F;   // ADC        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_20;   // ADC        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_21;   // ADC        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_22;   // ADC        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_23;   // ADC        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_24;   // ADC        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_25;   // SBB        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_26;   // SBB        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_27;   // SBB        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_28;   // SBB        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_29;   // SBB        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_2A;   // SBB        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_2B;   // SBB        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_2C;   // SBB        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_2D;   // MUL        reg8,   imm8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_2E;   // MUL        reg16,  imm16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_2F;   // MUL        reg8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_30;   // MUL        reg16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_31;   // MUL        reg8,   mem8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_32;   // MUL        reg16,  mem16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_33;   // MUL        mem8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_34;   // MUL        mem16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_35;   // MUL        reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_36;   // MUL        reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_37;   // MUL        mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_38;   // MUL        mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_39;   // MUL        reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_3A;   // MUL        reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_3B;   // MUL        reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_3C;   // MUL        reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_3D;   // MUL        reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_3E;   // MUL        reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_3F;   // MUL        reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_40;   // MUL        reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_41;   // MUL        mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_42;   // MUL        mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_43;   // IMUL       reg8,   imm8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_44;   // IMUL       reg16,  imm16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_45;   // IMUL       reg8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_46;   // IMUL       reg16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_47;   // IMUL       reg8,   mem8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_48;   // IMUL       reg16,  mem16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_49;   // IMUL       mem8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_4A;   // IMUL       mem16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_4B;   // IMUL       reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_4C;   // IMUL       reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_4D;   // IMUL       mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_4E;   // IMUL       mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_4F;   // IMUL       reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_50;   // IMUL       reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_51;   // IMUL       reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_52;   // IMUL       reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_53;   // IMUL       reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_54;   // IMUL       reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_55;   // IMUL       reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_56;   // IMUL       reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_57;   // IMUL       mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_58;   // IMUL       mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_59;   // DIV        reg8,   imm8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_5A;   // DIV        reg16,  imm16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_5B;   // DIV        reg8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_5C;   // DIV        reg16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_5D;   // DIV        reg8,   mem8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_5E;   // DIV        reg16,  mem16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_5F;   // DIV        mem8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_60;   // DIV        mem16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_61;   // DIV        reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_62;   // DIV        reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;  

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_63;   // DIV        mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_64;   // DIV        mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_65;   // DIV        reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_66;   // DIV        reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_67;   // DIV        reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_68;   // DIV        reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_69;   // DIV        reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_6A;   // DIV        reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_6B;   // DIV        reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_6C;   // DIV        reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_6D;   // DIV        mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_6E;   // DIV        mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_6F;   // IDIV       reg8,   imm8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_70;   // IDIV       reg16,  imm16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_71;   // IDIV       reg8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_72;   // IDIV       reg16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_73;   // IDIV       reg8,   mem8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_74;   // IDIV       reg16,  mem16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_75;   // IDIV       mem8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_76;   // IDIV       mem16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_77;   // IDIV       reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_78;   // IDIV       reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_79;   // IDIV       mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_7A;   // IDIV       mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_7B;   // IDIV       reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_7C;   // IDIV       reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_7D;   // IDIV       reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_7E;   // IDIV       reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_7F;   // IDIV       reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_80;   // IDIV       reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_81;   // IDIV       reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_82;   // IDIV       reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_83;   // IDIV       mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_84;   // IDIV       mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_85;   // MOD        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_86;   // MOD        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_87;   // MOD        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_88;   // MOD        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_89;   // MOD        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_8A;   // MOD        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_8B;   // MOD        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_8C;   // MOD        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_8D;   // MOD        reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_8E;   // MOD        reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_8F;   // MOD        mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_90;   // MOD        mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_91;   // MOD        reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_92;   // MOD        reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_93;   // MOD        reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_94;   // MOD        reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_95;   // MOD        reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_96;   // MOD        reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_97;   // MOD        reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_98;   // MOD        reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_99;   // MOD        mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_9A;   // MOD        mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_9B;   // IMOD       reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_9C;   // IMOD       reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_9D;   // IMOD       reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_9E;   // IMOD       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_9F;   // IMOD       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A0;   // IMOD       reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A1;   // IMOD       mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A2;   // IMOD       mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A3;   // IMOD       reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A4;   // IMOD       reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A5;   // IMOD       mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A6;   // IMOD       mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A7;   // IMOD       reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A8;   // IMOD       reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_A9;   // IMOD       reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_AA;   // IMOD       reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_AB;   // IMOD       reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_AC;   // IMOD       reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_AD;   // IMOD       reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_AE;   // IMOD       reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_AF;   // IMOD       mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D0_B0;   // IMOD       mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//==============================================================================

procedure TSVCProcessor_0000.Instruction_D1_01;   // NOT        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := not TSVCByte(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_02;   // NOT        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := not TSVCWord(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_03;   // NOT        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := not TSVCByte(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_04;   // NOT        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := not TSVCWord(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_05;   // AND        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_06;   // AND        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_07;   // AND        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_08;   // AND        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_09;   // AND        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_0A;   // AND        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_0B;   // AND        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_0C;   // AND        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_0D;   // OR         reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_0E;   // OR         reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_0F;   // OR         reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_10;   // OR         reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_11;   // OR         reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_12;   // OR         reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_13;   // OR         mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_14;   // OR         mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_15;   // XOR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_16;   // XOR        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_17;   // XOR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_18;   // XOR        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_19;   // XOR        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_1A;   // XOR        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_1B;   // XOR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_1C;   // XOR        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//==============================================================================

procedure TSVCProcessor_0000.Instruction_D1_1D;   // SHR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_1E;   // SHR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_1F;   // SHR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_20;   // SHR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_21;   // SHR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_22;   // SHR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_23;   // SHR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_24;   // SHR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_25;   // SHR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_26;   // SHR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_27;   // SHR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_28;   // SHR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_29;   // SAR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),1);
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_2A;   // SAR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),1);
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_2B;   // SAR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),1);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_2C;   // SAR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),1);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_2D;   // SAR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_2E;   // SAR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
        
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_2F;   // SAR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_30;   // SAR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

procedure TSVCProcessor_0000.Instruction_D1_31;   // SAR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_32;   // SAR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_33;   // SAR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_34;   // SAR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_35;   // SHL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_36;   // SHL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_37;   // SHL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_38;   // SHL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_39;   // SHL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_3A;   // SHL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_3B;   // SHL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_3C;   // SHL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_3D;   // SHL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_3E;   // SHL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_3F;   // SHL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_40;   // SHL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_41;   // SAL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_42;   // SAL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_43;   // SAL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_44;   // SAL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_45;   // SAL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_46;   // SAL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_47;   // SAL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_48;   // SAL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_49;   // SAL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_4A;   // SAL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_4B;   // SAL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_4C;   // SAL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_4D;   // ROR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),1);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_4E;   // ROR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_4F;   // ROR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),1);
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_50;   // ROR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),1);
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_51;   // ROR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_52;   // ROR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_53;   // ROR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_54;   // ROR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_55;   // ROR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_56;   // ROR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_57;   // ROR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_58;   // ROR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_59;   // ROL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_5A;   // ROL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_5B;   // ROL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_5C;   // ROL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_5D;   // ROL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_5E;   // ROL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_5F;   // ROL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_60;   // ROL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_61;   // ROL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_62;   // ROL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_63;   // ROL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_64;   // ROL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_65;   // RCR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_66;   // RCR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_67;   // RCR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_68;   // RCR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_69;   // RCR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_6A;   // RCR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_6B;   // RCR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_6C;   // RCR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_6D;   // RCR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_6E;   // RCR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_6F;   // RCR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_70;   // RCR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_71;   // RCL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_72;   // RCL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_73;   // RCL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_74;   // RCL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_75;   // RCL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_76;   // RCL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_77;   // RCL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_78;   // RCL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_79;   // RCL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_7A;   // RCL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_7B;   // RCL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_7C;   // RCL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_7D;   // BT         reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(GetArgVal(0)),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_7E;   // BT         reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(GetArgVal(0)),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_7F;   // BT         reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(GetArgVal(0)),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_80;   // BT         reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(GetArgVal(0)),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_81;   // BT         mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_82;   // BT         mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_83;   // BT         mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_84;   // BT         mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_85;   // BTS        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_86;   // BTS        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_87;   // BTS        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_88;   // BTS        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_89;   // BTS        mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_8A;   // BTS        mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_8B;   // BTS        mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_8C;   // BTS        mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_8D;   // BTR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_8E;   // BTR        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_8F;   // BTR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_90;   // BTR        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_91;   // BTR        mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_92;   // BTR        mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_93;   // BTR        mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_94;   // BTR        mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_95;   // BTC        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_96;   // BTC        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_97;   // BTC        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_98;   // BTC        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_99;   // BTC        mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_9A;   // BTC        mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_9B;   // BTC        mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidAddr(Addr) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_9C;   // BTC        mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_9D;   // BSF        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSF(UInt8(TSVCByte(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_9E;   // BSF        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSF(UInt16(TSVCWord(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_9F;   // BSF        reg8,   mem8
begin
ArgumentsDecode(False,[iatREG8,iatMEM8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSF(UInt8(TSVCByte(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A0;   // BSF        reg16,  mem16
begin
ArgumentsDecode(False,[iatREG16,iatMEM16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSF(UInt16(TSVCWord(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A1;   // BSR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSR(UInt8(TSVCByte(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A2;   // BSR        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSR(UInt16(TSVCWord(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A3;   // BSR        reg8,   mem8
begin
ArgumentsDecode(False,[iatREG8,iatMEM8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSR(UInt8(TSVCByte(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A4;   // BSR        reg16,  mem16
begin
ArgumentsDecode(False,[iatREG16,iatMEM16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSR(UInt16(TSVCWord(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A5;   // SHRD       reg16,  reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A6;   // SHRD       mem16,  reg16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A7;   // SHRD       reg16,  mem16,  imm8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A8;   // SHRD       reg16,  reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_A9;   // SHRD       mem16,  reg16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_AA;   // SHRD       reg16,  mem16,  reg8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_AB;   // SHLD       reg16,  reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_AC;   // SHLD       mem16,  reg16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_AD;   // SHLD       reg16,  mem16,  imm8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_AE;   // SHLD       reg16,  reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_AF;   // SHLD       mem16,  reg16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D1_B0;   // SHLD       reg16,  mem16,  reg8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//==============================================================================

procedure TSVCProcessor_0000.Instruction_D2_01;   // LODSB      reg8,   reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        TSVCByte(GetArgPtr(0)^) := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_02;   // LODSW      reg16,  reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        TSVCWord(GetArgPtr(0)^) := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_03;   // STOSB      reg16,  reg8
var
  LowAddr:  TSVCComp;

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(GetArgVal(1));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          LowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE)
        else
          LowAddr := GetArgVal(0);
        If (LowAddr >= 0) and fMemory.IsValidArea(TSVCNative(LowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            FillChar(fMemory.AddrPtr(TSVCNative(LowAddr))^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE,TSVCByte(GetArgVal(1)));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr - SVC_SZ_BYTE)
            else
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(LowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_04;   // STOSW      reg16,  reg16
var
  LowAddr:  TSVCComp;

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(GetArgVal(1));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) and (TSVCByte(GetArgVal(1)) = TSVCByte(GetArgVal(1) shr 8)) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          LowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD)
        else
          LowAddr := GetArgVal(0);
        If (LowAddr >= 0) and fMemory.IsValidArea(TSVCNative(LowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            FillChar(fMemory.AddrPtr(TSVCNative(LowAddr))^,TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD,TSVCByte(GetArgVal(1)));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr - SVC_SZ_WORD)
            else
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(LowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_05;   // MOVSB      reg16,  reg16
var
  SrcLowAddr: TSVCComp;
  DstLowAddr: TSVCComp;

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
              begin
                Move(fMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_BYTE);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_BYTE);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_06;   // MOVSW      reg16,  reg16
var
  SrcLowAddr: TSVCComp;
  DstLowAddr: TSVCComp;

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
              begin
                Move(fMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_WORD);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_WORD);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_07;   // LOADSB     reg16,  reg16
var
  SrcLowAddr: TSVCComp; // vn-mem
  DstLowAddr: TSVCComp; // ram

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fNVMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fNVMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
              begin
                Move(fNVMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_BYTE);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_BYTE);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_08;   // LOADSW     reg16,  reg16
var
  SrcLowAddr: TSVCComp; // vn-mem
  DstLowAddr: TSVCComp; // ram

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fNVMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fNVMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
              begin
                Move(fNVMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_WORD);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_WORD);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_09;   // STORESB    reg16,  reg16
var
  SrcLowAddr: TSVCComp; // ram
  DstLowAddr: TSVCComp; // nv-mem

  procedure InstructionCycle;
  begin
    If fNVMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            TSVCByte(fNVMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            If (DstLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
              begin
                Move(fMemory.AddrPtr(SrcLowAddr)^,fNVMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_BYTE);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_BYTE);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(DstLowAddr));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_0A;   // STORESW    reg16,  reg16
var
  SrcLowAddr: TSVCComp; // ram
  DstLowAddr: TSVCComp; // nv-mem

  procedure InstructionCycle;
  begin
    If fNVMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            TSVCWord(fNVMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            If (DstLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
              begin
                Move(fMemory.AddrPtr(SrcLowAddr)^,fNVMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_WORD);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_WORD);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(DstLowAddr));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_0B;   // CMPSB      reg16,  reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            FlaggedSUB_B(TSVCByte(fMemory.AddrPtr(GetArgVal(0))^),TSVCByte(fMemory.AddrPtr(GetArgVal(1))^));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_0C;   // CMPSW      reg16,  reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            FlaggedSUB_W(TSVCWord(fMemory.AddrPtr(GetArgVal(0))^),TSVCWord(fMemory.AddrPtr(GetArgVal(1))^));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_0D;   // SCASB      reg8,   reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(fMemory.AddrPtr(GetArgVal(1))^));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_0E;   // SCASW      reg16,  reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(fMemory.AddrPtr(GetArgVal(1))^));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_0F;   // INSB       reg16,  imm8

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_10;   // INSW       reg16,  imm8

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_11;   // INSB       reg16,  reg8

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_12;   // INSW       reg16,  reg8

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_13;   // OUTSB      imm8,   reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatIMM8,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_14;   // OUTSW      imm8,   reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatIMM8,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_15;   // OUTSB      reg8,   reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000.Instruction_D2_16;   // OUTSW      reg8,   reg16

  procedure InstructionCycle;
  begin
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
end;

end.
