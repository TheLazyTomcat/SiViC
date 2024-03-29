unit SiViC_Processor_Base;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  AuxTypes,
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
  SVC_PCS_INFOPAGE_MEM_SIZE         = $1000;
  SVC_PCS_INFOPAGE_MEM_BASE         = $1001;
  // NV memory info
  SVC_PCS_INFOPAGE_MEM_NVSIZE       = $2000;
  SVC_PCS_INFOPAGE_MEM_NVBASE       = $2001;
  // Counters, timers, clocks
  SVC_PCS_INFOPAGE_CNTR_EXEC        = $3000;


type
  TSVCProcessor_Base = class(TSVCProcessor)
  protected
    // processor info engine
    Function PutIntoMemory(Address: TSVCNative; Value: UInt64): TSVCProcessorInfoData; virtual;
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
    procedure Instruction_3D; virtual;    // INTSET     reg8,   imm16
    procedure Instruction_3E; virtual;    // INTSET     reg8,   reg16
    procedure Instruction_3F; virtual;    // INTDEF     imm16
    procedure Instruction_40; virtual;    // INTDEF     reg16
  end;

implementation

uses
  SiViC_Registers,
  SiViC_Interrupts,
  SiViC_IO;

{$IFDEF FPC_DisableWarns}
  {$WARN 4055 OFF} // Conversion between ordinals and pointers is not portable
{$ENDIF}

Function TSVCProcessor_Base.PutIntoMemory(Address: TSVCNative; Value: UInt64): TSVCProcessorInfoData;
begin
If Address <> 0 then
  begin
    If fMemory.IsValidArea(Address,SizeOf(UInt64)) then
      begin
        UInt64(fMemory.AddrPtr(Address)^) := UInt64(Value);
      {$IFDEF SVC_Debug}
        DoMemoryWriteEvent(Address);
      {$ENDIF SVC_Debug}
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,Address);
  end;
Result := SizeOf(UInt64);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_Base.GetInfoPage(Page: TSVCProcessorInfoPage; Param: TSVCProcessorInfoData): TSVCProcessorInfoData;
begin
case Page of
  // CPU info
  SVC_PCS_INFOPAGE_CPU_ARCHITECTURE:  Result := GetArchitecture;
  SVC_PCS_INFOPAGE_CPU_REVISION:      Result := GetRevision;
  // memory info
  SVC_PCS_INFOPAGE_MEM_SIZE:          Result := PutIntoMemory(TSVCNative(Param),UInt64(fMemory.Size));
  SVC_PCS_INFOPAGE_MEM_BASE:          Result := PutIntoMemory(TSVCNative(Param),UInt64(PtrUInt(fMemory.Memory)));
  // non-volatile memory info
  SVC_PCS_INFOPAGE_MEM_NVSIZE:        Result := PutIntoMemory(TSVCNative(Param),UInt64(fNVMemory.Size));
  SVC_PCS_INFOPAGE_MEM_NVBASE:        Result := PutIntoMemory(TSVCNative(Param),UInt64(PtrUInt(fNVMemory.Memory)));
  // Counters, timers, clocks
  SVC_PCS_INFOPAGE_CNTR_EXEC:         Result := PutIntoMemory(TSVCNative(Param),UInt64(fExecutionCount));
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
  inherited PrefixSelect(Prefix);
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
  $3D:  fCurrentInstruction.InstructionHandler := Instruction_3D;   // INTSET     reg8,   imm16
  $3E:  fCurrentInstruction.InstructionHandler := Instruction_3E;   // INTSET     reg8,   reg16
  $3F:  fCurrentInstruction.InstructionHandler := Instruction_3F;   // INTDEF     imm16
  $40:  fCurrentInstruction.InstructionHandler := Instruction_40;   // INTDEF     reg16
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
If Assigned(fOnSynchronization) then
  fOnSynchronization(Self);
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
raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION,
        TSVCNative(-FCurrentInstruction.Window.Position));
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
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
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
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1A;   // PUSH       mem16
begin
ArgumentsDecode(True,[iatMEM16]);
RaiseStackError(IsValidStackPUSHArea(SVC_SZ_WORD));
StackPUSH_W(TSVCWord(GetArgVal(0)));
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
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
ArgumentsDecode(False,[iatREG16]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_WORD));
TSVCWord(GetArgPtr(0)^) := StackPOP_W;
end;
 
//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1D;   // POP        mem8
begin
ArgumentsDecode(True,[iatMEM8]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_BYTE));
TSVCByte(GetArgPtr(0)^) := StackPOP_B;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_1E;   // POP        mem16
begin
ArgumentsDecode(True,[iatMEM16]);
RaiseStackError(IsValidStackPOPArea(SVC_SZ_WORD));
TSVCWord(GetArgPtr(0)^) := StackPOP_W;
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
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
  SP: TSVCNative;
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPUSHArea(SVC_REG_GP_TOTALCOUNT * SVC_SZ_NATIVE));
SP := fRegisters.GP[REG_SP].Native;
For i := 0 to Pred(SVC_REG_GP_IMPLEMENTED) do
  StackPUSH(fRegisters.GP[i].Native);
StackPUSH(fRegisters.GP[REG_SL].Native);
StackPUSH(fRegisters.GP[REG_SB].Native);
StackPUSH(SP);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_22;   // POPA
var
  i:  Integer;
  SP: TSVCNative;
begin
ArgumentsDecode(False,[]);
RaiseStackError(IsValidStackPOPArea(SVC_REG_GP_TOTALCOUNT * SVC_SZ_NATIVE));
SP := StackPOP;
fRegisters.GP[REG_SB].Native := StackPOP;
fRegisters.GP[REG_SL].Native := StackPOP;
For i := Pred(SVC_REG_GP_IMPLEMENTED) downto 0 do
  fRegisters.GP[i].Native := StackPOP;
fRegisters.GP[REG_SP].Native := SP;  
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
{$IFDEF SVC_Debug}
DoMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
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
{$IFDEF SVC_Debug}
DoMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
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
{$IFDEF SVC_Debug}
DoNVMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_32;   // LOAD       reg16,  mem16
begin
ArgumentsDecode(True,[iatREG16,iatMEM16],True);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
{$IFDEF SVC_Debug}
DoNVMemoryReadEvent(GetArgAddr(1));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_33;   // STORE      mem8,   reg8
begin
ArgumentsDecode(True,[iatMEM8,iatREG8],True);
TSVCByte(GetArgPtr(0)^) := TSVCByte(GetArgVal(1));
{$IFDEF SVC_Debug}
DoNVMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_34;   // STORE      mem16,  reg16
begin
ArgumentsDecode(True,[iatMEM16,iatREG16],True);
TSVCWord(GetArgPtr(0)^) := TSVCWord(GetArgVal(1));
{$IFDEF SVC_Debug}
DoNVMemoryWriteEvent(GetArgAddr(0));
{$ENDIF SVC_Debug}
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

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_3D;   // INTSET     reg8,   imm16
begin
ArgumentsDecode(False,[iatREG8,iatIMM16]);
fInterruptHandlers[TSVCInterruptIndex(GetArgVal(0))].HandlerAddr := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_3E;   // INTSET     reg8,   reg16
begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
fInterruptHandlers[TSVCInterruptIndex(GetArgVal(0))].HandlerAddr := GetArgVal(1);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_3F;   // INTDEF     imm16
var
  i:  TSVCInterruptIndex;
begin
ArgumentsDecode(False,[iatIMM16]);
For i := Low(fInterruptHandlers) to High(fInterruptHandlers) do
  fInterruptHandlers[i].HandlerAddr := GetArgVal(0);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_Base.Instruction_40;   // INTDEF     reg16
var
  i:  TSVCInterruptIndex;
begin
ArgumentsDecode(False,[iatREG16]);
For i := Low(fInterruptHandlers) to High(fInterruptHandlers) do
  fInterruptHandlers[i].HandlerAddr := GetArgVal(0);
end;

end.
