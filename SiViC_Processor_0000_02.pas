unit SiViC_Processor_0000_02;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Processor_0000_01;

type
  TSVCProcessor_0000_02 = class(TSVCProcessor_0000_01)
  protected
    // instruction decoding
    procedure InstructionSelect_L1(InstructionByte: TSVCByte); override;
    procedure InstructionSelect_L2_D1(InstructionByte: TSVCByte); virtual;
    // arithmetic and logical helpers
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
  end;

implementation

uses
  AuxTypes, BitOps,
  SiViC_Registers,
  SiViC_Instructions,
  SiViC_Interrupts;

procedure TSVCProcessor_0000_02.InstructionSelect_L1(InstructionByte: TSVCByte);
begin
case InstructionByte of
  // continuous instructions
  $D1:  InstructionDecode(InstructionSelect_L2_D1,2);
else
  inherited InstructionSelect_L1(InstructionByte);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.InstructionSelect_L2_D1(InstructionByte: TSVCByte);
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

//==============================================================================

Function TSVCProcessor_0000_02.FlaggedOR_B(A,B: TSVCByte): TSVCByte;
begin
Result := A or B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedOR_W(A,B: TSVCWord): TSVCWord;
begin
Result := A or B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedXOR_B(A,B: TSVCByte): TSVCByte;
begin
Result := A xor B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedXOR_W(A,B: TSVCWord): TSVCWord;
begin
Result := A xor B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedSHR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_02.FlaggedSHR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
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

Function TSVCProcessor_0000_02.FlaggedSAR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_02.FlaggedSAR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
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

Function TSVCProcessor_0000_02.FlaggedSHL_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_02.FlaggedSHL_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
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

Function TSVCProcessor_0000_02.FlaggedROR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := ROR(A,UInt8(Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $7))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedROR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := ROR(A,UInt8(Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(Pred(Count and $F))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedROL_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
begin
If (Count and $7) <> 0 then
  begin
    Result := ROL(A,UInt8(Count and $7));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(8 - (Count and $7))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedROL_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
begin
If (Count and $F) <> 0 then
  begin
    Result := ROL(A,UInt8(Count and $F));
    SetFlagValue(SVC_REG_FLAGS_CARRY,BT(A,UInt8(16 - (Count and $F))));
  end
else Result := A;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_02.FlaggedRCR_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_02.FlaggedRCR_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
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

Function TSVCProcessor_0000_02.FlaggedRCL_B(A: TSVCByte; Count: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_02.FlaggedRCL_W(A: TSVCWord; Count: TSVCByte): TSVCWord;
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

Function TSVCProcessor_0000_02.FlaggedSHRD_W(AL,AH: TSVCWord; Count: TSVCByte): TSVCWord;
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

Function TSVCProcessor_0000_02.FlaggedSHLD_W(AL,AH: TSVCWord; Count: TSVCByte): TSVCWord;
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

procedure TSVCProcessor_0000_02.Instruction_D1_01;   // NOT        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := not TSVCByte(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_02;   // NOT        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := not TSVCWord(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_03;   // NOT        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := not TSVCByte(GetArgVal(0));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_04;   // NOT        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := not TSVCWord(GetArgVal(0));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_05;   // AND        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_06;   // AND        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_07;   // AND        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_08;   // AND        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_09;   // AND        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_0A;   // AND        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_0B;   // AND        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_0C;   // AND        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_0D;   // OR         reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_0E;   // OR         reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_0F;   // OR         reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_10;   // OR         reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_11;   // OR         reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_12;   // OR         reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_13;   // OR         mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_14;   // OR         mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_15;   // XOR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_16;   // XOR        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_17;   // XOR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_18;   // XOR        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_19;   // XOR        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_1A;   // XOR        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_1B;   // XOR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedXOR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_1C;   // XOR        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedXOR_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//==============================================================================

procedure TSVCProcessor_0000_02.Instruction_D1_1D;   // SHR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_1E;   // SHR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_1F;   // SHR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));   
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_20;   // SHR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_21;   // SHR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_22;   // SHR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_23;   // SHR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_24;   // SHR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_25;   // SHR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_26;   // SHR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_27;   // SHR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));   
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_28;   // SHR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_29;   // SAR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),1);
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_2A;   // SAR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),1);
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_2B;   // SAR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_2C;   // SAR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_2D;   // SAR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_2E;   // SAR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
        
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_2F;   // SAR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));   
{$ENDIF SVC_Debug}
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_30;   // SAR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_31;   // SAR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_32;   // SAR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_33;   // SAR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSAR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_34;   // SAR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSAR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_35;   // SHL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_36;   // SHL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_37;   // SHL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_38;   // SHL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;                               

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_39;   // SHL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_3A;   // SHL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_3B;   // SHL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_3C;   // SHL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_3D;   // SHL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_3E;   // SHL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_3F;   // SHL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_40;   // SHL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_41;   // SAL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_42;   // SAL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_43;   // SAL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_44;   // SAL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_45;   // SAL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_46;   // SAL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_47;   // SAL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_48;   // SAL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_49;   // SAL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_4A;   // SAL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_4B;   // SAL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedSHL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_4C;   // SAL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_4D;   // ROR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),1);
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_4E;   // ROR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_4F;   // ROR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));    
{$ENDIF SVC_Debug}
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_50;   // ROR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
     
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_51;   // ROR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_52;   // ROR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
      
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_53;   // ROR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_54;   // ROR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_55;   // ROR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
    
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_56;   // ROR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_57;   // ROR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_58;   // ROR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_59;   // ROL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_5A;   // ROL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_5B;   // ROL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_5C;   // ROL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_5D;   // ROL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_5E;   // ROL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_5F;   // ROL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_60;   // ROL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_61;   // ROL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_62;   // ROL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_63;   // ROL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedROL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));   
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_64;   // ROL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedROL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_65;   // RCR        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_66;   // RCR        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_67;   // RCR        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_68;   // RCR        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_69;   // RCR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_6A;   // RCR        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_6B;   // RCR        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_6C;   // RCR        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_6D;   // RCR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_6E;   // RCR        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_6F;   // RCR        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCR_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_70;   // RCR        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCR_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_71;   // RCL        reg8
begin
ArgumentsDecode(False,[iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_72;   // RCL        reg16
begin
ArgumentsDecode(False,[iatREG16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_73;   // RCL        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_74;   // RCL        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),1);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_75;   // RCL        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_76;   // RCL        reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_77;   // RCL        mem8,   imm8
begin
ArgumentsDecode(True,[iatMEM8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_78;   // RCL        mem16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_79;   // RCL        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_7A;   // RCL        reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_7B;   // RCL        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := FlaggedRCL_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_7C;   // RCL        mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedRCL_W(TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_7D;   // BT         reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(GetArgVal(0)),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_7E;   // BT         reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(GetArgVal(0)),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_7F;   // BT         reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(GetArgVal(0)),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_80;   // BT         reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(GetArgVal(0)),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_81;   // BT         mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(Addr);    
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_82;   // BT         mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(Addr);   
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_83;   // BT         mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(Addr);
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_84;   // BT         mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BT(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(Addr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_85;   // BTS        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_86;   // BTS        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_87;   // BTS        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
   
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_88;   // BTS        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_89;   // BTS        mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);  
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_8A;   // BTS        mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr); 
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_8B;   // BTS        mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_8C;   // BTS        mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTS(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_8D;   // BTR        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_8E;   // BTR        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_8F;   // BTR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_90;   // BTR        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_91;   // BTR        mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_92;   // BTR        mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_93;   // BTR        mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);  
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_94;   // BTR        mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTR(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_95;   // BTC        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_96;   // BTC        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_97;   // BTC        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(GetArgPtr(0)^),UInt8(TSVCByte(GetArgVal(1)) and $7)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_98;   // BTC        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(GetArgPtr(0)^),UInt8(TSVCWord(GetArgVal(1)) and $F)));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_99;   // BTC        mem8,   reg8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);
{$ENDIF SVC_Debug}
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_9A;   // BTC        mem16,  reg16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_9B;   // BTC        mem8,   imm8
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCByte(GetArgVal(1)) shr 3));
If fMemory.IsValidArea(Addr,SVC_SZ_BYTE) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCByte(fMemory.AddrPtr(Addr)^),UInt8(TSVCByte(GetArgVal(1)) and $7)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_9C;   // BTC        mem16,  imm16
var
  Addr: TSVCNative;
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
Addr := TSVCNative(TSVCComp(GetArgAddr(0)) + TSVCComp(TSVCWord(GetArgVal(1)) shr 4));
If fMemory.IsValidArea(Addr,SVC_SZ_WORD) then
  SetFlagValue(SVC_REG_FLAGS_CARRY,BTC(TSVCWord(fMemory.AddrPtr(Addr)^),UInt8(TSVCWord(GetArgVal(1)) and $F)))
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Addr);
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(Addr); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_9D;   // BSF        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSF(UInt8(TSVCByte(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_9E;   // BSF        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSF(UInt16(TSVCWord(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_9F;   // BSF        reg8,   mem8
begin
ArgumentsDecode(False,[iatREG8,iatMEM8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSF(UInt8(TSVCByte(GetArgVal(1)))));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A0;   // BSF        reg16,  mem16
begin
ArgumentsDecode(False,[iatREG16,iatMEM16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSF(UInt16(TSVCWord(GetArgVal(1)))));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A1;   // BSR        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSR(UInt8(TSVCByte(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A2;   // BSR        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSR(UInt16(TSVCWord(GetArgVal(1)))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A3;   // BSR        reg8,   mem8
begin
ArgumentsDecode(False,[iatREG8,iatMEM8]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCByte(GetArgVal(1)) = 0);
TSVCByte(GetArgPtr(0)^) := TSVCByte(BSR(UInt8(TSVCByte(GetArgVal(1)))));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A4;   // BSR        reg16,  mem16
begin
ArgumentsDecode(False,[iatREG16,iatMEM16]);
SetFlagValue(SVC_REG_FLAGS_ZERO,TSVCWord(GetArgVal(1)) = 0);
TSVCWord(GetArgPtr(0)^) := TSVCWord(BSR(UInt16(TSVCWord(GetArgVal(1)))));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A5;   // SHRD       reg16,  reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A6;   // SHRD       mem16,  reg16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A7;   // SHRD       reg16,  mem16,  imm8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A8;   // SHRD       reg16,  reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_A9;   // SHRD       mem16,  reg16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_AA;   // SHRD       reg16,  mem16,  reg8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHRD_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_AB;   // SHLD       reg16,  reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_AC;   // SHLD       mem16,  reg16,  imm8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_AD;   // SHLD       reg16,  mem16,  imm8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatIMM8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1)); 
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_AE;   // SHLD       reg16,  reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_AF;   // SHLD       mem16,  reg16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;
  
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_02.Instruction_D1_B0;   // SHLD       reg16,  mem16,  reg8
begin
ArgumentsDecode(True,[iatREG16,iatMEM16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := FlaggedSHLD_W(TSVCWord(GetArgVal(1)),TSVCWord(GetArgVal(0)),TSVCByte(GetArgVal(2)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

end.
