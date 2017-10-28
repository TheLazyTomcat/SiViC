unit SiViC_Processor_Base;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Instructions,
  SiViC_Processor;

const
  // common info
  SVC_PCS_INFOPAGE_INVALID          = 0;
  // CPU info
  SVC_PCS_INFOPAGE_CPU_ARCHITECTURE = $0001;
  SVC_PCS_INFOPAGE_CPU_REVISION     = $0002;
  // memory info
  SVC_PCS_INFOPAGE_MEM_SIZE_W1      = $1000;
  SVC_PCS_INFOPAGE_MEM_SIZE_W2      = $1001;
  SVC_PCS_INFOPAGE_MEM_SIZE_W3      = $1002;
  SVC_PCS_INFOPAGE_MEM_SIZE_W4      = $1003;
  SVC_PCS_INFOPAGE_MEM_BASE_W1      = $1004;
  SVC_PCS_INFOPAGE_MEM_BASE_W2      = $1005;
  SVC_PCS_INFOPAGE_MEM_BASE_W3      = $1006;
  SVC_PCS_INFOPAGE_MEM_BASE_W4      = $1007;
  // NV memory info
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W1    = $2000;
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W2    = $2001;
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W3    = $2002;
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W4    = $2003;
  SVC_PCS_INFOPAGE_MEM_NVBASE_W1    = $2004;
  SVC_PCS_INFOPAGE_MEM_NVBASE_W2    = $2005;
  SVC_PCS_INFOPAGE_MEM_NVBASE_W3    = $2006;
  SVC_PCS_INFOPAGE_MEM_NVBASE_W4    = $2007;
  // Counters, timers, clocks
  SVC_PCS_INFOPAGE_CNTR_EXEC_W1     = $3000;
  SVC_PCS_INFOPAGE_CNTR_EXEC_W2     = $3001;
  SVC_PCS_INFOPAGE_CNTR_EXEC_W3     = $3002;
  SVC_PCS_INFOPAGE_CNTR_EXEC_W4     = $3003;

type
  TSVCProcessor_Base = class(TSVCProcessor)
  protected
    // processor info engine
    Function GetInfoPage(Page: TSVCProcessorInfoPage; Param: TSVCProcessorInfoData): TSVCProcessorInfoData; override;
    // instruction decoding
    procedure PrefixSelect(Prefix: TSVCInstructionPrefix); override;
    procedure InstructionSelect_L1(InstructionByte: TSVCByte); override;
    // individual instructions
    procedure Instruction_00; virtual;    // HALT
    procedure Instruction_01; virtual;    // RELEASE
    procedure Instruction_02; virtual;    // WAIT
    procedure Instruction_03; virtual;    // SYNC
    procedure Instruction_04; virtual;    // NOP
    procedure Instruction_05; virtual;    // INVINS
    procedure Instruction_06; virtual;    // INTCALL    imm8
    procedure Instruction_07; virtual;    // INTRET
    procedure Instruction_08; virtual;    // INTCALLO
    procedure Instruction_09; virtual;    // INTCALLT
    procedure Instruction_0A; virtual;    // INTGET     reg16,  imm8
    procedure Instruction_0B; virtual;    // INTGET     reg16,  reg8
    procedure Instruction_0C; virtual;    // INTSET     imm8,   imm16
    procedure Instruction_0D; virtual;    // INTSET     imm8,   reg16
    procedure Instruction_0E; virtual;    // INTCLR     imm8
    procedure Instruction_0F; virtual;    // CALL       rel8
    procedure Instruction_10; virtual;    // CALL       rel16
    procedure Instruction_11; virtual;    // CALL       reg16
    procedure Instruction_12; virtual;    // CALL       mem16
    procedure Instruction_13; virtual;    // RET
    procedure Instruction_14; virtual;    // RET        imm16
    procedure Instruction_15; virtual;    // PUSH       imm8
    procedure Instruction_16; virtual;    // PUSH       imm16
    procedure Instruction_17; virtual;    // PUSH       reg8
    procedure Instruction_18; virtual;    // PUSH       reg16
    procedure Instruction_19; virtual;    // PUSH       mem8
    procedure Instruction_1A; virtual;    // PUSH       mem16
    procedure Instruction_1B; virtual;    // POP        reg8
    procedure Instruction_1C; virtual;    // POP        reg16
    procedure Instruction_1D; virtual;    // POP        mem8
    procedure Instruction_1E; virtual;    // POP        mem16
    procedure Instruction_1F; virtual;    // PUSHF
    procedure Instruction_20; virtual;    // POPF
    procedure Instruction_21; virtual;    // PUSHA
    procedure Instruction_22; virtual;    // POPA
    procedure Instruction_23; virtual;    // INFO       reg16,  imm16
    procedure Instruction_24; virtual;    // INFO       reg16,  reg16
    procedure Instruction_25; virtual;    // STcc
    procedure Instruction_26; virtual;    // CLcc
    procedure Instruction_27; virtual;    // CMcc
    procedure Instruction_28; virtual;    // MOV        reg16,  FLAGS
    procedure Instruction_29; virtual;    // MOV        FLAGS,  reg16
    procedure Instruction_2A; virtual;    // MOV        reg16,  CNTR
    procedure Instruction_2B; virtual;    // MOV        mem16,  CNTR
    procedure Instruction_2C; virtual;    // MOV        CNTR,   imm16
    procedure Instruction_2D; virtual;    // MOV        CNTR,   reg16
    procedure Instruction_2E; virtual;    // MOV        CNTR,   mem16
    procedure Instruction_2F; virtual;    // MOV        reg16,  CR
    procedure Instruction_30; virtual;    // MOV        CR,     reg16
    procedure Instruction_31; virtual;    // LOAD       reg8,   mem8
    procedure Instruction_32; virtual;    // LOAD       reg16,  mem16
    procedure Instruction_33; virtual;    // STORE      mem8,   reg8
    procedure Instruction_34; virtual;    // STORE      mem16,  reg16
    procedure Instruction_35; virtual;    // IN         reg8,   imm8
    procedure Instruction_36; virtual;    // IN         reg16,  imm8
    procedure Instruction_37; virtual;    // IN         reg8,   reg8
    procedure Instruction_38; virtual;    // IN         reg16,  reg8
    procedure Instruction_39; virtual;    // OUT        imm8,   reg8
    procedure Instruction_3A; virtual;    // OUT        imm8,   reg16
    procedure Instruction_3B; virtual;    // OUT        reg8,   reg8
    procedure Instruction_3C; virtual;    // OUT        reg8,   reg16
  end;

implementation

uses
  AuxTypes,
  SiViC_Registers,
  SiViC_Interrupts,
  SiViC_IO;

Function TSVCProcessor_Base.GetInfoPage(Page: TSVCProcessorInfoPage; Param: TSVCProcessorInfoData): TSVCProcessorInfoData;
begin
case Page of
  // CPU info
  SVC_PCS_INFOPAGE_CPU_ARCHITECTURE:  Result := TSVCProcessorInfoData($57C0);
  // memory info
  SVC_PCS_INFOPAGE_MEM_SIZE_W1:       Result := TSVCProcessorInfoData(fMemory.Size);
  SVC_PCS_INFOPAGE_MEM_SIZE_W2:       Result := TSVCProcessorInfoData(fMemory.Size shr 16);
  SVC_PCS_INFOPAGE_MEM_BASE_W1:       Result := TSVCProcessorInfoData({%H-}PtrUInt(fMemory.Memory));
  SVC_PCS_INFOPAGE_MEM_BASE_W2:       Result := TSVCProcessorInfoData({%H-}PtrUInt(fMemory.Memory) shr 16);
{$IFDEF 64bit}
  SVC_PCS_INFOPAGE_MEM_SIZE_W3:       Result := TSVCProcessorInfoData(fMemory.Size shr 32);
  SVC_PCS_INFOPAGE_MEM_SIZE_W4:       Result := TSVCProcessorInfoData(fMemory.Size shr 48);
  SVC_PCS_INFOPAGE_MEM_BASE_W3:       Result := TSVCProcessorInfoData({%H-}PtrUInt(fMemory.Memory) shr 32);
  SVC_PCS_INFOPAGE_MEM_BASE_W4:       Result := TSVCProcessorInfoData({%H-}PtrUInt(fMemory.Memory) shr 48);
{$ELSE}
  SVC_PCS_INFOPAGE_MEM_SIZE_W3:       Result := 0;
  SVC_PCS_INFOPAGE_MEM_SIZE_W4:       Result := 0;
  SVC_PCS_INFOPAGE_MEM_BASE_W3:       Result := 0;
  SVC_PCS_INFOPAGE_MEM_BASE_W4:       Result := 0;
{$ENDIF}
  // non-volatile memory info
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W1:     Result := TSVCProcessorInfoData(fNVMemory.Size);
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W2:     Result := TSVCProcessorInfoData(fNVMemory.Size shr 16);
  SVC_PCS_INFOPAGE_MEM_NVBASE_W1:     Result := TSVCProcessorInfoData({%H-}PtrUInt(fNVMemory.Memory));
  SVC_PCS_INFOPAGE_MEM_NVBASE_W2:     Result := TSVCProcessorInfoData({%H-}PtrUInt(fNVMemory.Memory) shr 16);
{$IFDEF 64bit}
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W3:     Result := TSVCProcessorInfoData(fNVMemory.Size shr 32);
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W4:     Result := TSVCProcessorInfoData(fNVMemory.Size shr 48);
  SVC_PCS_INFOPAGE_MEM_NVBASE_W3:     Result := TSVCProcessorInfoData({%H-}PtrUInt(fNVMemory.Memory) shr 32);
  SVC_PCS_INFOPAGE_MEM_NVBASE_W4:     Result := TSVCProcessorInfoData({%H-}PtrUInt(fNVMemory.Memory) shr 48);
{$ELSE}
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W3:     Result := 0;
  SVC_PCS_INFOPAGE_MEM_NVSIZE_W4:     Result := 0;
  SVC_PCS_INFOPAGE_MEM_NVBASE_W3:     Result := 0;
  SVC_PCS_INFOPAGE_MEM_NVBASE_W4:     Result := 0;
{$ENDIF}
  // Counters, timers, clocks
  SVC_PCS_INFOPAGE_CNTR_EXEC_W1:      Result := TSVCProcessorInfoData(fExecutionCount);
  SVC_PCS_INFOPAGE_CNTR_EXEC_W2:      Result := TSVCProcessorInfoData(fExecutionCount shr 16);
  SVC_PCS_INFOPAGE_CNTR_EXEC_W3:      Result := TSVCProcessorInfoData(fExecutionCount shr 32);
  SVC_PCS_INFOPAGE_CNTR_EXEC_W4:      Result := TSVCProcessorInfoData(fExecutionCount shr 48);
else
  Result := inherited GetInfoPage(Page,Param);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.PrefixSelect(Prefix: TSVCInstructionPrefix);
begin
case Prefix of
  $E0:  with fCurrentInstruction do Prefixes := Prefixes + PrevPrefixes;  // PFXR
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.InstructionSelect_L1(InstructionByte: TSVCByte);
begin
case InstructionByte of
  $00:  fCurrentInstruction.InstructionHandler := Instruction_00;   // HALT
  $01:  fCurrentInstruction.InstructionHandler := Instruction_01;   // RELEASE
  $02:  fCurrentInstruction.InstructionHandler := Instruction_02;   // WAIT
  $03:  fCurrentInstruction.InstructionHandler := Instruction_03;   // SYNC
  $04:  fCurrentInstruction.InstructionHandler := Instruction_04;   // NOP
  $05:  fCurrentInstruction.InstructionHandler := Instruction_05;   // INVINS
  $06:  fCurrentInstruction.InstructionHandler := Instruction_06;   // INTCALL    imm8
  $07:  fCurrentInstruction.InstructionHandler := Instruction_07;   // INTRET
  $08:  fCurrentInstruction.InstructionHandler := Instruction_08;   // INTCALLO
  $09:  fCurrentInstruction.InstructionHandler := Instruction_09;   // INTCALLT
  $0A:  fCurrentInstruction.InstructionHandler := Instruction_0A;   // INTGET     reg16,  imm8
  $0B:  fCurrentInstruction.InstructionHandler := Instruction_0B;   // INTGET     reg16,  reg8
  $0C:  fCurrentInstruction.InstructionHandler := Instruction_0C;   // INTSET     imm8,   imm16
  $0D:  fCurrentInstruction.InstructionHandler := Instruction_0D;   // INTSET     imm8,   reg16
  $0E:  fCurrentInstruction.InstructionHandler := Instruction_0E;   // INTCLR     imm8
  $0F:  fCurrentInstruction.InstructionHandler := Instruction_0F;   // CALL       rel8
  $10:  fCurrentInstruction.InstructionHandler := Instruction_10;   // CALL       rel16
  $11:  fCurrentInstruction.InstructionHandler := Instruction_11;   // CALL       reg16
  $12:  fCurrentInstruction.InstructionHandler := Instruction_12;   // CALL       mem16
  $13:  fCurrentInstruction.InstructionHandler := Instruction_13;   // RET
  $14:  fCurrentInstruction.InstructionHandler := Instruction_14;   // RET        imm16
  $15:  fCurrentInstruction.InstructionHandler := Instruction_15;   // PUSH       imm8
  $16:  fCurrentInstruction.InstructionHandler := Instruction_16;   // PUSH       imm16
  $17:  fCurrentInstruction.InstructionHandler := Instruction_17;   // PUSH       reg8
  $18:  fCurrentInstruction.InstructionHandler := Instruction_18;   // PUSH       reg16
  $19:  fCurrentInstruction.InstructionHandler := Instruction_19;   // PUSH       mem8
  $1A:  fCurrentInstruction.InstructionHandler := Instruction_1A;   // PUSH       mem16
  $1B:  fCurrentInstruction.InstructionHandler := Instruction_1B;   // POP        reg8
  $1C:  fCurrentInstruction.InstructionHandler := Instruction_1C;   // POP        reg16
  $1D:  fCurrentInstruction.InstructionHandler := Instruction_1D;   // POP        mem8
  $1E:  fCurrentInstruction.InstructionHandler := Instruction_1E;   // POP        mem16
  $1F:  fCurrentInstruction.InstructionHandler := Instruction_1F;   // PUSHF
  $20:  fCurrentInstruction.InstructionHandler := Instruction_20;   // POPF
  $21:  fCurrentInstruction.InstructionHandler := Instruction_21;   // PUSHA
  $22:  fCurrentInstruction.InstructionHandler := Instruction_22;   // POPA
  $23:  fCurrentInstruction.InstructionHandler := Instruction_23;   // INFO       reg16,  imm16
  $24:  fCurrentInstruction.InstructionHandler := Instruction_24;   // INFO       reg16,  reg16
  $25:  fCurrentInstruction.InstructionHandler := Instruction_25;   // STcc
  $26:  fCurrentInstruction.InstructionHandler := Instruction_26;   // CLcc
  $27:  fCurrentInstruction.InstructionHandler := Instruction_27;   // CMcc
  $28:  fCurrentInstruction.InstructionHandler := Instruction_28;   // MOV        reg16,  FLAGS
  $29:  fCurrentInstruction.InstructionHandler := Instruction_29;   // MOV        FLAGS,  reg16
  $2A:  fCurrentInstruction.InstructionHandler := Instruction_2A;   // MOV        reg16,  CNTR
  $2B:  fCurrentInstruction.InstructionHandler := Instruction_2B;   // MOV        mem16,  CNTR
  $2C:  fCurrentInstruction.InstructionHandler := Instruction_2C;   // MOV        CNTR,   imm16
  $2D:  fCurrentInstruction.InstructionHandler := Instruction_2D;   // MOV        CNTR,   reg16
  $2E:  fCurrentInstruction.InstructionHandler := Instruction_2E;   // MOV        CNTR,   mem16
  $2F:  fCurrentInstruction.InstructionHandler := Instruction_2F;   // MOV        reg16,  CR
  $30:  fCurrentInstruction.InstructionHandler := Instruction_30;   // MOV        CR,     reg16  
  $31:  fCurrentInstruction.InstructionHandler := Instruction_31;   // LOAD       reg8,   mem8
  $32:  fCurrentInstruction.InstructionHandler := Instruction_32;   // LOAD       reg16,  mem16
  $33:  fCurrentInstruction.InstructionHandler := Instruction_33;   // STORE      mem8,   reg8
  $34:  fCurrentInstruction.InstructionHandler := Instruction_34;   // STORE      mem16,  reg16
  $35:  fCurrentInstruction.InstructionHandler := Instruction_35;   // IN         reg8,   imm8
  $36:  fCurrentInstruction.InstructionHandler := Instruction_36;   // IN         reg16,  imm8
  $37:  fCurrentInstruction.InstructionHandler := Instruction_37;   // IN         reg8,   reg8
  $38:  fCurrentInstruction.InstructionHandler := Instruction_38;   // IN         reg16,  reg8
  $39:  fCurrentInstruction.InstructionHandler := Instruction_39;   // OUT        imm8,   reg8
  $3A:  fCurrentInstruction.InstructionHandler := Instruction_3A;   // OUT        imm8,   reg16
  $3B:  fCurrentInstruction.InstructionHandler := Instruction_3B;   // OUT        reg8,   reg8
  $3C:  fCurrentInstruction.InstructionHandler := Instruction_3C;   // OUT        reg8,   reg16
else
  inherited InstructionSelect_L1(InstructionByte);
end;
end;

//==============================================================================

procedure TSVCProcessor_Base.Instruction_00;   // HALT
begin
ArgumentsDecode(False,[]);
fState := psHalted;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_01;   // RELEASE
begin
ArgumentsDecode(False,[]);
fState := psReleased;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_02;   // WAIT
begin
ArgumentsDecode(False,[]);
fState := psWaiting;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_03;   // SYNC
begin
ArgumentsDecode(False,[]);
fState := psSynchronizing;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_04;   // NOP
begin
ArgumentsDecode(False,[]);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_05;   // INVINS
begin
ArgumentsDecode(False,[]);
raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_06;   // INTCALL  imm8
begin
ArgumentsDecode(False,[iatIMM8]);
DispatchInterrupt(TSVCInterruptIndex(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_07;   // INTRET
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPOPArea(SVC_INT_INTERRUPTSTACKSPACE));
fRegisters.IP := StackPOP;
StackPOP; // discard data
Dec(fInterruptHandlers[TSVCInterruptIndex(StackPOP)].Counter);
fRegisters.FLAGS := StackPOP;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_08;   // INTCALLO
begin
ArgumentsDecode(False,[]);
If GetFlag(SVC_REG_FLAGS_OVERFLOW) then
  DispatchInterrupt(SVC_EXCEPTION_ARITHMETICOVERFLOW);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_09;   // INTCALLT
begin
ArgumentsDecode(False,[]);
DispatchInterrupt(SVC_INT_IDX_TRAP);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_0A;   // INTGET     reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
TSVCNative(GetArgPtr(0)^) := fInterruptHandlers[TSVCInterruptIndex(GetArgVal(1))].HandlerAddr;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_0B;   // INTGET     reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
TSVCNative(GetArgPtr(0)^) := fInterruptHandlers[TSVCInterruptIndex(GetArgVal(1))].HandlerAddr;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_0C;   // INTSET     imm8,   imm16
begin
ArgumentsDecode(False,[iatIMM8,iatIMM16]);
fInterruptHandlers[TSVCInterruptIndex(GetArgVal(0))].HandlerAddr := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_0D;   // INTSET     imm8,   reg16
begin
ArgumentsDecode(False,[iatIMM8,iatREG16]);
fInterruptHandlers[TSVCInterruptIndex(GetArgVal(0))].HandlerAddr := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_0E;   // INTCLR     imm8
begin
ArgumentsDecode(False,[iatIMM8]);
fInterruptHandlers[TSVCInterruptIndex(GetArgVal(0))].HandlerAddr := 0;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_0F;   // CALL       rel8
begin
ArgumentsDecode(False,[iatREL8]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_NATIVE));
StackPUSH(fRegisters.IP);
AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_10;   // CALL       rel16
begin
ArgumentsDecode(False,[iatREL16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_NATIVE));
StackPUSH(fRegisters.IP);
AdvanceIP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_11;   // CALL       reg16
begin
ArgumentsDecode(False,[iatREG16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_NATIVE));
StackPUSH(fRegisters.IP);
fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_12;   // CALL       mem16
begin
ArgumentsDecode(True,[iatMEM16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_NATIVE));
StackPUSH(fRegisters.IP);
fRegisters.IP := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_13;   // RET
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_NATIVE));
fRegisters.IP := StackPOP;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_14;   // RET        imm16
begin
ArgumentsDecode(False,[iatIMM16]);
RaiseStackError(IsValidStackPOPArea(TSVCNative(TSVCComp(SVC_SZ_NATIVE) + TSVCComp(GetArgVal(0)))));
fRegisters.IP := StackPOP;
AdvanceSP(GetArgVal(0));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_15;   // PUSH       imm8
begin
ArgumentsDecode(False,[iatIMM8]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_BYTE));
StackPUSH_B(TSVCByte(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_16;   // PUSH       imm16
begin
ArgumentsDecode(False,[iatIMM16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_WORD));
StackPUSH_W(TSVCWord(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_17;   // PUSH       reg8
begin
ArgumentsDecode(False,[iatREG8]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_BYTE));
StackPUSH_B(TSVCByte(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_18;   // PUSH       reg16
begin
ArgumentsDecode(False,[iatREG16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_WORD));
StackPUSH_W(TSVCWord(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_19;   // PUSH       mem8
begin
ArgumentsDecode(True,[iatMEM8]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_BYTE));
StackPUSH_B(TSVCByte(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1A;   // PUSH       mem16
begin
ArgumentsDecode(True,[iatMEM16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_WORD));
StackPUSH_W(TSVCWord(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1B;   // POP        reg8
begin
ArgumentsDecode(False,[iatREG8]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_BYTE));
TSVCByte(GetArgPtr(0)^) := StackPOP_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1C;   // POP        reg16
begin
ArgumentsDecode(False,[iatREG8]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_WORD));
TSVCWord(GetArgPtr(0)^) := StackPOP_W;
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1D;   // POP        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_BYTE));
TSVCByte(GetArgPtr(0)^) := StackPOP_B;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1E;   // POP        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_WORD));
TSVCWord(GetArgPtr(0)^) := StackPOP_W;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1F;   // PUSHF
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_NATIVE));
StackPUSH(fRegisters.FLAGS);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_20;   // POPF
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_NATIVE));
fRegisters.FLAGS := StackPOP;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_21;   // PUSHA
var
  i:  Integer;
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPUSHArea(SVC_REG_GP_TOTALCOUNT * SVC_SZ_NATIVE));
For i := 0 to Pred(SVC_REG_GP_IMPLEMENTED) do
  StackPUSH(GetGPRVal(i));
StackPUSH(GetGPRVal(REG_SL));
StackPUSH(GetGPRVal(REG_SB));
StackPUSH(GetGPRVal(REG_SP));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_22;   // POPA
var
  i:  Integer;
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPOPArea(SVC_REG_GP_TOTALCOUNT * SVC_SZ_NATIVE));
SetGPRVal(REG_SP,StackPOP);
SetGPRVal(REG_SB,StackPOP);
SetGPRVal(REG_SL,StackPOP);
For i := Pred(SVC_REG_GP_IMPLEMENTED) downto 0 do
  SetGPRVal(i,StackPOP);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_23;   // INFO       reg16,  imm16
begin
ArgumentsDecode(False,[iatREG16,iatIMM16]);
ClearFlag(SVC_REG_FLAGS_ZERO);
TSVCProcessorInfoData(GetArgPtr(0)^) :=
  GetInfoPage(TSVCProcessorInfoPage(GetArgVal(1)),TSVCProcessorInfoData(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_24;   // INFO       reg16,  reg16
begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
ClearFlag(SVC_REG_FLAGS_ZERO);
TSVCProcessorInfoData(GetArgPtr(0)^) :=
  GetInfoPage(TSVCProcessorInfoPage(GetArgVal(1)),TSVCProcessorInfoData(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_25;   // STcc
begin
ArgumentsDecode(True,[]);
case ExtractConditionCode(fCurrentInstruction.Suffix) of
  0:  SetFlag(SVC_REG_FLAGS_CARRY);
  1:  SetFlag(SVC_REG_FLAGS_PARITY);
  2:  SetFlag(SVC_REG_FLAGS_ZERO);
  3:  SetFlag(SVC_REG_FLAGS_SIGN);
  4:  SetFlag(SVC_REG_FLAGS_OVERFLOW);
  5:  SetFlag(SVC_REG_FLAGS_DIRECTION);
  6:  SetFlag(SVC_REG_FLAGS_INTERRUPTS);
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDARGUMENT,
          ExtractConditionCode(fCurrentInstruction.Suffix));
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_26;   // CLcc
begin
ArgumentsDecode(True,[]);
case ExtractConditionCode(fCurrentInstruction.Suffix) of
  0:  ClearFlag(SVC_REG_FLAGS_CARRY);
  1:  ClearFlag(SVC_REG_FLAGS_PARITY);
  2:  ClearFlag(SVC_REG_FLAGS_ZERO);
  3:  ClearFlag(SVC_REG_FLAGS_SIGN);
  4:  ClearFlag(SVC_REG_FLAGS_OVERFLOW);
  5:  ClearFlag(SVC_REG_FLAGS_DIRECTION);
  6:  ClearFlag(SVC_REG_FLAGS_INTERRUPTS);
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDARGUMENT,
          ExtractConditionCode(fCurrentInstruction.Suffix));
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_27;   // CMcc
begin
ArgumentsDecode(True,[]);
case ExtractConditionCode(fCurrentInstruction.Suffix) of
  0:  ComplementFlag(SVC_REG_FLAGS_CARRY);
  1:  ComplementFlag(SVC_REG_FLAGS_PARITY);
  2:  ComplementFlag(SVC_REG_FLAGS_ZERO);
  3:  ComplementFlag(SVC_REG_FLAGS_SIGN);
  4:  ComplementFlag(SVC_REG_FLAGS_OVERFLOW);
  5:  ComplementFlag(SVC_REG_FLAGS_DIRECTION);
  6:  ComplementFlag(SVC_REG_FLAGS_INTERRUPTS);
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDARGUMENT,
          ExtractConditionCode(fCurrentInstruction.Suffix));
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_28;   // MOV        reg16,  FLAGS
begin
ArgumentsDecode(False,[iatREG16,iatFLAGS]);
TSVCNative(GetArgPtr(0)^) := fRegisters.FLAGS;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_29;   // MOV        FLAGS,  reg16
begin
ArgumentsDecode(False,[iatFLAGS,iatREG16]);
fRegisters.FLAGS := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_2A;   // MOV        reg16,  CNTR
begin
ArgumentsDecode(False,[iatREG16,iatCNTR]);
TSVCNative(GetArgPtr(0)^) := fRegisters.CNTR;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_2B;   // MOV        mem16,  CNTR
begin
ArgumentsDecode(True,[iatMEM16,iatCNTR]);
TSVCNative(GetArgPtr(0)^) := fRegisters.CNTR;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_2C;   // MOV        CNTR,   imm16
begin
ArgumentsDecode(False,[iatCNTR,iatIMM16]);
fRegisters.CNTR := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_2D;   // MOV        CNTR,   reg16
begin
ArgumentsDecode(False,[iatCNTR,iatREG16]);
fRegisters.CNTR := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_2E;   // MOV        CNTR,   mem16
begin
ArgumentsDecode(True,[iatCNTR,iatMEM16]);
fRegisters.CNTR := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_2F;   // MOV        reg16,  CR
begin
ArgumentsDecode(False,[iatREG16,iatCR]);
TSVCNative(GetArgPtr(0)^) := fRegisters.CR;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_30;   // MOV        CR,     reg16
begin
ArgumentsDecode(False,[iatCR,iatREG16]);
fRegisters.CR := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_31;   // LOAD       reg8,   mem8
begin
ArgumentsDecode(True,[iatREG8,iatMEM8],True);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_32;   // LOAD       reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16],True);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_33;   // STORE      mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8],True);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_34;   // STORE      mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16],True);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_35;   // IN         reg8,   imm8
begin
ArgumentsDecode(False,[iatREG8,iatIMM8]);
PortRequested(TSVCPortIndex(GetArgVal(1)));
TSVCByte(GetArgPtr(0)^) := TSVCByte(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_36;   // IN         reg16,  imm8
begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
PortRequested(TSVCPortIndex(GetArgVal(1)));
TSVCWord(GetArgPtr(0)^) := TSVCWord(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_37;   // IN         reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
PortRequested(TSVCPortIndex(GetArgVal(1)));
TSVCByte(GetArgPtr(0)^) := TSVCByte(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_38;   // IN         reg16,  reg8
begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
PortRequested(TSVCPortIndex(GetArgVal(1)));
TSVCWord(GetArgPtr(0)^) := TSVCWord(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_39;   // OUT        imm8,   reg8
begin
ArgumentsDecode(False,[iatIMM8,iatREG8]);
fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCByte(GetArgVal(1));
PortUpdated(TSVCPortIndex(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_3A;   // OUT        imm8,   reg16
begin
ArgumentsDecode(False,[iatIMM8,iatREG16]);
fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCWord(GetArgVal(1));
PortUpdated(TSVCPortIndex(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_3B;   // OUT        reg8,   reg8
begin
ArgumentsDecode(False,[iatREG8,iatREG8]);
fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCByte(GetArgVal(1));
PortUpdated(TSVCPortIndex(GetArgVal(0)));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_3C;   // OUT        reg8,   reg16
begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCWord(GetArgVal(1));
PortUpdated(TSVCPortIndex(GetArgVal(0)));
end;

end.
