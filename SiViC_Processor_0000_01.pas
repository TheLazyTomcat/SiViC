unit SiViC_Processor_0000_01;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Processor_0000_00;

type
  TSVCProcessor_0000_01 = class(TSVCProcessor_0000_00)
  protected
    // instruction decoding
    procedure InstructionSelect_L1(InstructionByte: TSVCByte); override;
    procedure InstructionSelect_L2_D0(InstructionByte: TSVCByte); virtual;
    // arithmetic and logical helpers
    Function FlaggedADD_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedADD_W(A,B: TSVCWord): TSVCWord; virtual;
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
    // instructions implementation
    procedure ImplementationINC_B; virtual;
    procedure ImplementationINC_W; virtual;
    procedure ImplementationDEC_B; virtual;
    procedure ImplementationDEC_W; virtual;
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
  end;

implementation

uses
  SiViC_Registers,
  SiViC_Instructions,
  SiViC_Interrupts;

procedure TSVCProcessor_0000_01.InstructionSelect_L1(InstructionByte: TSVCByte);
begin
case InstructionByte of
  // continuous instructions
  $D0:  InstructionDecode(InstructionSelect_L2_D0,2);
else
  inherited InstructionSelect_L1(InstructionByte);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.InstructionSelect_L2_D0(InstructionByte: TSVCByte);
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
  $59:  fCurrentInstruction.InstructionHandler := Instruction_D0_59;  // DIV        reg8,   imm8
  $5A:  fCurrentInstruction.InstructionHandler := Instruction_D0_5A;  // DIV        reg16,  imm16
  $5B:  fCurrentInstruction.InstructionHandler := Instruction_D0_5B;  // DIV        reg8,   reg8
  $5C:  fCurrentInstruction.InstructionHandler := Instruction_D0_5C;  // DIV        reg16,  reg16
  $5D:  fCurrentInstruction.InstructionHandler := Instruction_D0_5D;  // DIV        reg8,   mem8
  $5E:  fCurrentInstruction.InstructionHandler := Instruction_D0_5E;  // DIV        reg16,  mem16
  $5F:  fCurrentInstruction.InstructionHandler := Instruction_D0_5F;  // DIV        mem8,   reg8
  $60:  fCurrentInstruction.InstructionHandler := Instruction_D0_60;  // DIV        mem16,  reg16
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
  $6F:  fCurrentInstruction.InstructionHandler := Instruction_D0_6F;  // IDIV       reg8,   imm8
  $70:  fCurrentInstruction.InstructionHandler := Instruction_D0_70;  // IDIV       reg16,  imm16
  $71:  fCurrentInstruction.InstructionHandler := Instruction_D0_71;  // IDIV       reg8,   reg8
  $72:  fCurrentInstruction.InstructionHandler := Instruction_D0_72;  // IDIV       reg16,  reg16
  $73:  fCurrentInstruction.InstructionHandler := Instruction_D0_73;  // IDIV       reg8,   mem8
  $74:  fCurrentInstruction.InstructionHandler := Instruction_D0_74;  // IDIV       reg16,  mem16
  $75:  fCurrentInstruction.InstructionHandler := Instruction_D0_75;  // IDIV       mem8,   reg8
  $76:  fCurrentInstruction.InstructionHandler := Instruction_D0_76;  // IDIV       mem16,  reg16
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
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION,1);
end;
end;

//==============================================================================

Function TSVCProcessor_0000_01.FlaggedADD_B(A,B: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_01.FlaggedADD_W(A,B: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_01.FlaggedADC_B(A,B: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_01.FlaggedADC_W(A,B: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_01.FlaggedSBB_B(A,B: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_01.FlaggedSBB_W(A,B: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_01.FlaggedMUL_B(A,B: TSVCByte; out High: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_01.FlaggedMUL_W(A,B: TSVCWord; out High: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_01.FlaggedIMUL_B(A,B: TSVCSByte; out High: TSVCSByte): TSVCSByte;
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

Function TSVCProcessor_0000_01.FlaggedIMUL_W(A,B: TSVCSWord; out High: TSVCSWord): TSVCSWord;
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

Function TSVCProcessor_0000_01.FlaggedDIV_B(AL,AH,B: TSVCByte; out High: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_01.FlaggedDIV_W(AL,AH,B: TSVCWord; out High: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_01.FlaggedIDIV_B(AL,AH,B: TSVCSByte; out High: TSVCSByte): TSVCSByte;
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

Function TSVCProcessor_0000_01.FlaggedIDIV_W(AL,AH,B: TSVCSWord; out High: TSVCSWord): TSVCSWord;
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

Function TSVCProcessor_0000_01.FlaggedMOD_B(AL,AH,B: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_01.FlaggedMOD_W(AL,AH,B: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_01.FlaggedIMOD_B(AL,AH,B: TSVCSByte): TSVCSByte;
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

Function TSVCProcessor_0000_01.FlaggedIMOD_W(AL,AH,B: TSVCSWord): TSVCSWord;
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

//==============================================================================

procedure TSVCProcessor_0000_01.ImplementationINC_B;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.ImplementationINC_W;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.ImplementationDEC_B;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.ImplementationDEC_W;
var
  CarryVal: Boolean;
begin
CarryVal := GetFlag(SVC_REG_FLAGS_CARRY);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),1);
If not GetCRFlag(SVC_REG_CR_INCDECCARRY) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,CarryVal);
end;

//==============================================================================

procedure TSVCProcessor_0000_01.Instruction_D0_01;   // INC        reg8
begin
ArgumentsDecode(False,[iatREG8]);
ImplementationINC_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_02;   // INC        reg16
begin
ArgumentsDecode(False,[iatREG16]);
ImplementationINC_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_03;   // INC        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
ImplementationINC_B;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_04;   // INC        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
ImplementationINC_W;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_05;   // DEC        reg8
begin
ArgumentsDecode(False,[iatREG8]);
ImplementationDEC_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_06;   // DEC        reg16
begin
ArgumentsDecode(False,[iatREG16]);
ImplementationDEC_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_07;   // DEC        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
ImplementationDEC_B;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_08;   // DEC        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
ImplementationDEC_W;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_09;   // NEG        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := -TSVCSByte(GetArgVal(0));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_0A;   // NEG        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCSWord(GetArgPtr(0)^) := -TSVCSWord(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_0B;   // NEG        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := -TSVCSByte(GetArgVal(0));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_0C;   // NEG        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := -TSVCSWord(GetArgVal(0));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_0D;   // ADD        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_0E;   // ADD        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_0F;   // ADD        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_10;   // ADD        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_11;   // ADD        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_12;   // ADD        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_13;   // ADD        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADD_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_14;   // ADD        mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_15;   // SUB        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_16;   // SUB        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_17;   // SUB        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_18;   // SUB        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_19;   // SUB        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_1A;   // SUB        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_1B;   // SUB        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_1C;   // SUB        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_1D;   // ADC        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_1E;   // ADC        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_1F;   // ADC        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_20;   // ADC        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_21;   // ADC        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_22;   // ADC        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_23;   // ADC        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedADC_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_24;   // ADC        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedADC_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_25;   // SBB        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_26;   // SBB        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_27;   // SBB        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_28;   // SBB        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_29;   // SBB        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_2A;   // SBB        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_2B;   // SBB        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSBB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_2C;   // SBB        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSBB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_2D;   // MUL        reg8,   imm8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_2E;   // MUL        reg16,  imm16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_2F;   // MUL        reg8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_30;   // MUL        reg16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_31;   // MUL        reg8,   mem8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_32;   // MUL        reg16,  mem16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_33;   // MUL        mem8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMUL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_34;   // MUL        mem16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMUL_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_35;   // MUL        reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_36;   // MUL        reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_37;   // MUL        mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_38;   // MUL        mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_39;   // MUL        reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_3A;   // MUL        reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_3B;   // MUL        reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_3C;   // MUL        reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_3D;   // MUL        reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_3E;   // MUL        reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_3F;   // MUL        reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_40;   // MUL        reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_41;   // MUL        mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMUL_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_42;   // MUL        mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMUL_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_43;   // IMUL       reg8,   imm8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_44;   // IMUL       reg16,  imm16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_45;   // IMUL       reg8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_46;   // IMUL       reg16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_47;   // IMUL       reg8,   mem8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_48;   // IMUL       reg16,  mem16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_49;   // IMUL       mem8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_4A;   // IMUL       mem16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_4B;   // IMUL       reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_4C;   // IMUL       reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_4D;   // IMUL       mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_4E;   // IMUL       mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_4F;   // IMUL       reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_50;   // IMUL       reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_51;   // IMUL       reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_52;   // IMUL       reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_53;   // IMUL       reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_54;   // IMUL       reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_55;   // IMUL       reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_56;   // IMUL       reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_57;   // IMUL       mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMUL_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_58;   // IMUL       mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMUL_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_59;   // DIV        reg8,   imm8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_5A;   // DIV        reg16,  imm16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_5B;   // DIV        reg8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_5C;   // DIV        reg16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_5D;   // DIV        reg8,   mem8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_5E;   // DIV        reg16,  mem16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_5F;   // DIV        mem8,   reg8
var
  Temp: TSVCByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedDIV_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_60;   // DIV        mem16,  reg16
var
  Temp: TSVCWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedDIV_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_61;   // DIV        reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_62;   // DIV        reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end;  

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_63;   // DIV        mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_64;   // DIV        mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_65;   // DIV        reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_66;   // DIV        reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_67;   // DIV        reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_68;   // DIV        reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_69;   // DIV        reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end; 

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_6A;   // DIV        reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_6B;   // DIV        reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_6C;   // DIV        reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_6D;   // DIV        mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedDIV_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)),TSVCByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_6E;   // DIV        mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedDIV_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)),TSVCWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_6F;   // IDIV       reg8,   imm8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_70;   // IDIV       reg16,  imm16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_71;   // IDIV       reg8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_72;   // IDIV       reg16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_73;   // IDIV       reg8,   mem8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_74;   // IDIV       reg16,  mem16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_75;   // IDIV       mem8,   reg8
var
  Temp: TSVCSByte;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_76;   // IDIV       mem16,  reg16
var
  Temp: TSVCSWord;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)),Temp);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_77;   // IDIV       reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_78;   // IDIV       reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_79;   // IDIV       mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_7A;   // IDIV       mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_7B;   // IDIV       reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_7C;   // IDIV       reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_7D;   // IDIV       reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_7E;   // IDIV       reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_7F;   // IDIV       reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_80;   // IDIV       reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_81;   // IDIV       reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_82;   // IDIV       reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_83;   // IDIV       mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIDIV_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)),TSVCSByte(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_84;   // IDIV       mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIDIV_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)),TSVCSWord(GetArgPtr(0)^));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_85;   // MOD        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_86;   // MOD        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_87;   // MOD        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_88;   // MOD        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_89;   // MOD        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_8A;   // MOD        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_8B;   // MOD        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedMOD_B(TSVCByte(GetArgVal(0)),0,TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_8C;   // MOD        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedMOD_W(TSVCWord(GetArgVal(0)),0,TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_8D;   // MOD        reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_8E;   // MOD        reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_8F;   // MOD        mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_90;   // MOD        mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_91;   // MOD        reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_92;   // MOD        reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_93;   // MOD        reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_94;   // MOD        reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_95;   // MOD        reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_96;   // MOD        reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_97;   // MOD        reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_98;   // MOD        reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_99;   // MOD        mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCByte(GetArgPtr(1)^) := FlaggedMOD_B(TSVCByte(GetArgVal(1)),TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_9A;   // MOD        mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCWord(GetArgPtr(1)^) := FlaggedMOD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_9B;   // IMOD       reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_9C;   // IMOD       reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_9D;   // IMOD       reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_9E;   // IMOD       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_9F;   // IMOD       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A0;   // IMOD       reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A1;   // IMOD       mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(0)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(0)),0,TSVCSByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A2;   // IMOD       mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(0)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(0)),0,TSVCSWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A3;   // IMOD       reg8,   reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A4;   // IMOD       reg16,  reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A5;   // IMOD       mem8,   reg8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A6;   // IMOD       mem16,  reg16,  imm16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A7;   // IMOD       reg8,   mem8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatIMM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A8;   // IMOD       reg16,  mem16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_A9;   // IMOD       reg8,   reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_AA;   // IMOD       reg16,  reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_AB;   // IMOD       reg8,   reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatREG8,iatMEM8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_AC;   // IMOD       reg16,  reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatREG16,iatMEM16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(2));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_AD;   // IMOD       reg8,   mem8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_AE;   // IMOD       reg16,  mem16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_AF;   // IMOD       mem8,   reg8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8,iatREG8]);
TSVCSByte(GetArgPtr(1)^) := FlaggedIMOD_B(TSVCSByte(GetArgVal(1)),TSVCSByte(GetArgVal(0)),TSVCSByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_01.Instruction_D0_B0;   // IMOD       mem16,  reg16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG16]);
TSVCSWord(GetArgPtr(1)^) := FlaggedIMOD_W(TSVCSWord(GetArgVal(1)),TSVCSWord(GetArgVal(0)),TSVCSWord(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

end.
