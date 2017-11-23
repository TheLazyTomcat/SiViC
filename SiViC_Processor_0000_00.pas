unit SiViC_Processor_0000_00;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Processor_Base;

type
  TSVCProcessor_0000_00 = class(TSVCProcessor_Base)
  protected
    // arithmetic and logical helpers
    Function FlaggedSUB_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedSUB_W(A,B: TSVCWord): TSVCWord; virtual;
    Function FlaggedAND_B(A,B: TSVCByte): TSVCByte; virtual;
    Function FlaggedAND_W(A,B: TSVCWord): TSVCWord; virtual;
    // instruction decoding
    procedure InstructionSelect_L1(InstructionByte: TSVCByte); override;
    // instructions implementation
    procedure ImplementationXCHG_B; virtual;
    procedure ImplementationXCHG_W; virtual;
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
  end;

implementation

uses
  SiViC_Registers,
  SiViC_Instructions;

procedure TSVCProcessor_0000_00.InstructionSelect_L1(InstructionByte: TSVCByte);
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
else
  inherited InstructionSelect_L1(InstructionByte);
end;
end;

//==============================================================================

Function TSVCProcessor_0000_00.FlaggedSUB_B(A,B: TSVCByte): TSVCByte;
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

Function TSVCProcessor_0000_00.FlaggedSUB_W(A,B: TSVCWord): TSVCWord;
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

Function TSVCProcessor_0000_00.FlaggedAND_B(A,B: TSVCByte): TSVCByte;
begin
Result := A and B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,ByteParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCByte($80)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_00.FlaggedAND_W(A,B: TSVCWord): TSVCWord;
begin
Result := A and B;
ClearFlag(SVC_REG_FLAGS_CARRY);
SetFlagValue(SVC_REG_FLAGS_PARITY,WordParity(Result));
SetFlagValue(SVC_REG_FLAGS_ZERO,Result = 0);
SetFlagValue(SVC_REG_FLAGS_SIGN,(Result and TSVCWord($8000)) <> 0);
ClearFlag(SVC_REG_FLAGS_OVERFLOW);
end;

//==============================================================================

procedure TSVCProcessor_0000_00.ImplementationXCHG_B;
var
  Temp: TSVCByte;
begin
Temp := TSVCByte(GetArgVal(0));
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
TSVCByte(GetArgPtr(1)^) := Temp;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.ImplementationXCHG_W;
var
  Temp: TSVCWord;
begin
Temp := TSVCWord(GetArgVal(0));
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
TSVCWord(GetArgPtr(1)^) := Temp;
end;

//==============================================================================

procedure TSVCProcessor_0000_00.Instruction_50;   // LEA        reg16,  mem
begin
ArgumentsDecode(True,[iatREG16,iatMEM]);
TSVCNative(GetArgPtr(0)^) := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_51;   // LEA        reg16,  rel8
begin
ArgumentsDecode(False,[iatREG16,iatREL8]);
TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(fRegisters.IP) + TSVCComp(TSVCSNative(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_52;   // LEA        reg16,  rel16
begin
ArgumentsDecode(False,[iatREG16,iatREL16]);
TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(fRegisters.IP) + TSVCComp(TSVCSNative(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_53;   // CMP        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_54;   // CMP        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_55;   // CMP        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_56;   // CMP        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_57;   // CMP        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_58;   // CMP        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_59;   // CMP        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_5A;   // CMP        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_5B;   // TEST       reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_5C;   // TEST       reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_5D;   // TEST       reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_5E;   // TEST       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_5F;   // TEST       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_60;   // TEST       reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_61;   // TEST       mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
FlaggedAND_B(TSVCByte(GetArgVal(0)),TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_62;   // TEST       mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
FlaggedAND_W(TSVCWord(GetArgVal(0)),TSVCWord(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_63;   // JMP        rel8
begin
ArgumentsDecode(False,[iatREL8]);
AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_64;   // JMP        rel16
begin
ArgumentsDecode(False,[iatREL16]);
AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_65;   // JMP        reg16
begin
ArgumentsDecode(False,[iatREG16]);
fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_66;   // JMP        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
fRegisters.IP := GetArgVal(0);
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_67;   // Jcc        rel8
begin
ArgumentsDecode(True,[iatREL8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_68;   // Jcc        rel16
begin
ArgumentsDecode(True,[iatREL16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_69;   // Jcc        reg16
begin
ArgumentsDecode(True,[iatREG16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_6A;   // Jcc        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    fRegisters.IP := GetArgVal(0);
  {$IFDEF SVC_Debug}
    DoMemoryReadEvent(GetArgAddr(0));
  {$ENDIF SVC_Debug}
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_6B;   // SETcc      reg8
begin
ArgumentsDecode(True,[iatREG8]);
TSVCByte(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_6C;   // SETcc      reg16
begin
ArgumentsDecode(True,[iatREG16]);
TSVCWord(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_6D;   // SETcc      mem8
begin
ArgumentsDecode(True,[iatMEM8]);
TSVCByte(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_6E;   // SETcc      mem16
begin
ArgumentsDecode(True,[iatMEM16]);
TSVCWord(GetArgPtr(0)^) :=
  BoolToByte(EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_6F;   // CMOVcc     reg8,   imm8
begin
ArgumentsDecode(True,[iatREG8,iatIMM8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_70;   // CMOVcc     reg16,  imm16
begin
ArgumentsDecode(True,[iatREG16,iatIMM16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_71;   // CMOVcc     reg8,   reg8
begin
ArgumentsDecode(True,[iatREG8,iatREG8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_72;   // CMOVcc     reg16,  reg16
begin
ArgumentsDecode(True,[iatREG16,iatREG16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_73;   // CMOVcc     reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
  {$IFDEF SVC_Debug}
    DoMemoryReadEvent(GetArgAddr(1));
  {$ENDIF SVC_Debug}
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_74;   // CMOVcc     reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
  {$IFDEF SVC_Debug}
    DoMemoryReadEvent(GetArgAddr(1));
  {$ENDIF SVC_Debug}
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_75;   // CMOVcc     mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
  {$IFDEF SVC_Debug}
    DoMemoryWriteEvent(GetArgAddr(0));
  {$ENDIF SVC_Debug}
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_76;   // CMOVcc     mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
If EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  begin
    TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
  {$IFDEF SVC_Debug}
    DoMemoryWriteEvent(GetArgAddr(0));
  {$ENDIF SVC_Debug}
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_77;   // LOOP       rel8
begin
ArgumentsDecode(False,[iatREL8]);
Dec(fRegisters.CNTR);
If fRegisters.CNTR > 0 then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_78;   // LOOP       rel16
begin
ArgumentsDecode(False,[iatREL16]);
Dec(fRegisters.CNTR);
If fRegisters.CNTR > 0 then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_79;   // LOOPcc     rel8
begin
ArgumentsDecode(True,[iatREL8]);
Dec(fRegisters.CNTR);
If (fRegisters.CNTR > 0) and EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_7A;   // LOOPcc     rel16
begin
ArgumentsDecode(True,[iatREL16]);
Dec(fRegisters.CNTR);
If (fRegisters.CNTR > 0) and EvaluateCondition(ExtractConditionCode(fCurrentInstruction.Suffix)) then
  AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_7B;   // MOV        reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_7C;   // MOV        reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_7D;   // MOV        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_7E;   // MOV        reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_7F;   // MOV        reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_80;   // MOV        reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_81;   // MOV        mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8]);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_82;   // MOV        mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_83;   // MOVZX      reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_84;   // MOVZX      reg16,  mem8
begin
ArgumentsDecode(True,[iatREG16,iatMEM8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_85;   // MOVSX      reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCSWord(TSVCSByte(GetArgVal(1))));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_86;   // MOVSX      reg16,  mem8
begin
ArgumentsDecode(True,[iatREG16,iatMEM8]);
TSVCWord(GetArgPtr(0)^) := TSVCWord(TSVCSWord(TSVCSByte(GetArgVal(1))));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_87;   // XCHG       reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
ImplementationXCHG_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_88;   // XCHG       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
ImplementationXCHG_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_89;   // XCHG       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8]);
ImplementationXCHG_B;
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_8A;   // XCHG       reg16,  mem16
begin
ArgumentsDecode(False,[iatREG16,iatMEM16]);
ImplementationXCHG_W;
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_8B;   // XCHG       mem8,   reg8
begin
ArgumentsDecode(False,[iatMEM8,iatREG8]);
ImplementationXCHG_B;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_8C;   // XCHG       mem16,  reg16
begin
ArgumentsDecode(False,[iatMEM16,iatREG16]);
ImplementationXCHG_W;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_8D;   // CVTSX      reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCSWord(GetArgPtr(0)^) := TSVCSWord(TSVCSByte(GetArgVal(1)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_8E;   // CVTSX      reg16,  mem8
begin
ArgumentsDecode(True,[iatREG16,iatMEM8]);
TSVCSWord(GetArgPtr(0)^) := TSVCSWord(TSVCSByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_00.Instruction_8F;   // CVTSX      mem16,  reg8
begin
ArgumentsDecode(True,[iatMEM16,iatREG8]);
TSVCSWord(GetArgPtr(0)^) := TSVCSWord(TSVCSByte(GetArgVal(1)));
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

end.
