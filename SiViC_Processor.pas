unit SiViC_Processor;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SysUtils,
  AuxTypes,
  SiViC_Common,
  SiViC_Memory,
  SiViC_Registers,
  SiViC_Instructions,
  SiViC_Interrupts,
  SiViC_IO;

type
  TSVCProcessorState = (psUninitialized,psRunning,psHalted,psReleased,
                        psWaiting,psSynchronizing,psFailed);

  // processor (system) information
  TSVCProcessorInfoPage = TSVCWord;
  TSVCProcessorInfoData = TSVCWord;

  TSVCInstructionSelectMethod = procedure(InstructionByte: TSVCByte) of object;

type
  TSVCProcessor = class(TObject)
  private
    fExecutionCount:      UInt64;
    fFaultClass:          String;
    fFaultMessage:        String;
    fOnBeforeInstruction: TSVCInstructionEvent;
    fOnAfterInstruction:  TSVCInstructionEvent;
  protected
    // internal processor state
    fState:               TSVCProcessorState;
    fMemory:              TSVCMemory;
    fNVMemory:            TSVCMemory;
    fRegisters:           TSVCRegisters;
    fInterruptHandlers:   TSVCInterruptHandlers;
    fPorts:               TSVCPorts;
    // data of the currently processed instruction
    fCurrentInstruction:  TSVCInstructionData;
    // processor info engine
    Function GetInfoPage({%H-}Page: TSVCProcessorInfoPage; {%H-}Param: TSVCProcessorInfoData): TSVCProcessorInfoData; virtual;
    // memory access
    Function ResolveMemoryAddress(AddressingMode: TSVCInstructionAddressingMode; out Address: TSVCNative): Boolean; virtual;
    // stack access and manipulation
    Function IsValidStackPUSHArea(AreaSize: TSVCNative): TSVCStackError; virtual;
    Function IsValidStackPOPArea(AreaSize: TSVCNative): TSVCStackError; virtual;
    procedure StackPUSH_B(Value: TSVCByte); virtual;
    procedure StackPUSH_W(Value: TSVCWord); virtual;
    procedure StackPUSH(Value: TSVCNative); virtual;
    Function StackPOP_B: TSVCByte; virtual;
    Function StackPOP_W: TSVCWord; virtual;
    Function StackPOP: TSVCNative; virtual;
    procedure RaiseStackError(Error: TSVCStackError); virtual;
    // general purpose registers access
    Function IsValidGPRIdx(RegisterIndex: TSVCRegisterIndex): Boolean; virtual;
    Function IsValidGPR(RegisterID: TSVCRegisterID; ExpectedTypes: TSVCRegisterTypes): Boolean; virtual;
    Function GetGPRPtr(RegisterID: TSVCRegisterID): Pointer; virtual;
    Function GetGPRVal(RegisterID: TSVCRegisterID): TSVCNative; virtual;
    procedure SetGPRVal(RegisterID: TSVCRegisterID; NewValue: TSVCNative); virtual;
    // FLAGS register access, conditions
    Function GetFlag(FlagMask: TSVCNative): Boolean; virtual;
    procedure SetFlag(FlagMask: TSVCNative); virtual;
    procedure ClearFlag(FlagMask: TSVCNative); virtual;
    procedure ComplementFlag(FlagMask: TSVCNative); virtual;
    procedure SetFlagValue(FlagMask: TSVCNative; NewValue: Boolean); virtual;
    Function EvaluateCondition(ConditionCode: TSVCInstructionConditionCode): Boolean; virtual;
    // control registers access
    Function GetCRFlag(FlagMask: TSVCNative): Boolean; virtual;
    // registers advance macros
    procedure AdvanceIP(Step: TSVCNative); virtual;
    procedure AdvanceSP(Step: TSVCNative); virtual;
    // interrupt access and handling
    procedure HandleException(E: Exception); virtual;
    procedure DispatchInterrupt(InterruptIndex: TSVCInterruptIndex; Data: TSVCNative = 0); virtual;
    // IO, hardware
    procedure PortUpdated(PortIndex: TSVCPortIndex); virtual;
    procedure PortRequested(PortIndex: TSVCPortIndex); virtual;
    // instruction window access
    Function IsValidWndPos(Position: TSVCNumber): Boolean; virtual;
    Function IsValidWndOff(Offset: TSVCNumber): Boolean; virtual;
    Function IsValidCurrWndPos: Boolean; virtual;
    Function GetWndPtr(Position: TSVCNumber): Pointer; virtual;
    Function GetWndOffPtr(Offset: TSVCNumber = 0): Pointer; virtual;
    Function GetWndCurrByte: TSVCByte; virtual;
    // current instruction arguments access
    Function GetArgVal(ArgIdx: Integer): TSVCNative; virtual;
    Function GetArgPtr(ArgIdx: Integer): Pointer; virtual;
    Function GetArgAddr(ArgIdx: Integer): TSVCNative; virtual;
    // execution engine
    procedure InvalidateInstructionData; virtual;
    procedure ExecuteNextInstruction; virtual;
    procedure InstructionFetch; virtual;
    procedure InstructionIssue; virtual;
    procedure InstructionDecode; overload; virtual;
    procedure InstructionExecute; virtual;
    // instruction decoding
    procedure ArgumentsDecode(Suffix: Boolean; ArgumentList: array of TSVCInstructionArgumentType; AccessingNVMem: Boolean = False); virtual;
    procedure PrefixSelect({%H-}Prefix: TSVCInstructionPrefix); virtual;
    procedure InstructionDecode(SelectMethod: TSVCInstructionSelectMethod; InstructionLength: Integer); overload; virtual;
    procedure InstructionSelect_L1({%H-}InstructionByte: TSVCByte); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize(MemorySize, NVMemorySize: TMemSize); virtual;
    procedure Finalize; virtual;
    procedure Restart; virtual;
    procedure Reset; virtual;
    // LoadProgram, UnloadProgram, GetCompressedNVMemory, ...
    procedure ExecuteInstruction(InstructionWindow: TSVCInstructionWindow; AffectIP: Boolean = False); virtual;
    Function Run(InstructionCount: Integer = 1): Integer; virtual;
    procedure InterruptRequest(InterruptIndex: TSVCInterruptIndex; Data: TSVCNative = 0); virtual;
    procedure SetPortHandlers(PortIndex: TSVCPortIndex; InHandler,OutHandler: TSVCPortEvent); virtual;
    // for debugging purposes...
    property Memory: TSVCMemory read fMemory;
    property NVMemory: TSVCMemory read fNVMemory;
    property Registers: TSVCRegisters read fRegisters;
    property InterruptHandlers: TSVCInterruptHandlers read fInterruptHandlers;
    property Ports: TSVCPorts read fPorts;
  published
    property State: TSVCProcessorState read fState write fState;
    property ExecutionCount: UInt64 read fExecutionCount;
    property FaultClass: String read fFaultClass;
    property FaultMessage: String read fFaultMessage;
    property OnBeforeInstruction: TSVCInstructionEvent read fOnBeforeInstruction write fOnBeforeInstruction;
    property OnAfterInstruction: TSVCInstructionEvent read fOnAfterInstruction write fOnAfterInstruction;
  end;

implementation


Function TSVCProcessor.GetInfoPage(Page: TSVCProcessorInfoPage; Param: TSVCProcessorInfoData): TSVCProcessorInfoData;
begin
{for invalid and unimplemented pages}
Result := 0;
SetFlag(SVC_REG_FLAGS_ZERO);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.ResolveMemoryAddress(AddressingMode: TSVCInstructionAddressingMode; out Address: TSVCNative): Boolean;
begin
Address := 0;
Result := False;
case AddressingMode of
  // reg16                          (base)
  0:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) then
        begin
          Address := GetGPRVal(GetWndCurrByte);
          Result := True;
        end;
  // imm16                          (displacement)
  1:  begin
        Address := TSVCNative(GetWndOffPtr^);
        Result := True;
      end;
  // reg16 + imm16                  (base + displacement)
  2:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) then
        begin
          Address := TSVCNative(TSVCComp(GetGPRVal(GetWndCurrByte)) +
                                TSVCComp(TSVCWord(GetWndOffPtr(1)^)));
          Result := True;
        end;
  // reg16 * imm8                   (index * scale)
  3:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) then
        begin
          Address := TSVCNative(TSVCComp(GetGPRVal(GetWndCurrByte)) *
                                TSVCComp(TSVCByte(GetWndOffPtr(1)^)));
          Result := True;
        end;
  // reg16 * imm8 + imm16           (index * scale + displacement)
  4:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) then
        begin
          Address := TSVCNative(TSVCComp(GetGPRVal(GetWndCurrByte)) *
                                TSVCComp(TSVCByte(GetWndOffPtr(1)^)) +
                                TSVCComp(TSVCWord(GetWndOffPtr(2)^)));
          Result := True;
        end;
  // reg16 + reg16                  (base + index)
  5:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) and
         IsValidGPR(TSVCRegisterID(GetWndOffPtr(1)^),[rtWord,rtNative]) then
        begin
          Address := TSVCNative(TSVCComp(GetGPRVal(GetWndCurrByte)) +
                                TSVCComp(GetGPRVal(TSVCRegisterID(GetWndOffPtr(1)^))));
          Result := True;
        end;
  // reg16 + reg16 * imm8           (base + index * scale)
  6:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) and
         IsValidGPR(TSVCRegisterID(GetWndOffPtr(1)^),[rtWord,rtNative]) then
        begin
          Address := TSVCNative(TSVCComp(GetGPRVal(GetWndCurrByte)) +
                                TSVCComp(GetGPRVal(TSVCRegisterID(GetWndOffPtr(1)^))) *
                                TSVCComp(TSVCByte(GetWndOffPtr(2)^)));
          Result := True;
        end;
  // reg16 + reg16 * imm8 + imm16   (base + index * scale + displacement)
  7:  If IsValidGPR(TSVCRegisterID(GetWndCurrByte),[rtWord,rtNative]) and
         IsValidGPR(TSVCRegisterID(GetWndOffPtr(1)^),[rtWord,rtNative]) then
        begin
          Address := TSVCNative(TSVCComp(GetGPRVal(GetWndCurrByte)) +
                                TSVCComp(GetGPRVal(TSVCRegisterID(GetWndOffPtr(1)^))) *
                                TSVCComp(TSVCByte(GetWndOffPtr(2)^)) +
                                TSVCComp(TSVCWord(GetWndOffPtr(3)^)));
          Result := True;
        end;
end;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidStackPUSHArea(AreaSize: TSVCNative): TSVCStackError;
var
  LowAddr:  TSVCComp;
begin
LowAddr := TSVCComp(fRegisters.GP[REG_SP].Native) - TSVCComp(AreaSize);
If LowAddr >= TSVCComp(fRegisters.GP[REG_SL].Native) then
  begin
    If LowAddr < (TSVCComp(fRegisters.GP[REG_SL].Native) + TSVCComp(SVC_INT_INTERRUPTSTACKSPACE)) then
      Result := seRedZone
    else
      Result := seOK;
  end
else Result := seOverflow;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidStackPOPArea(AreaSize: TSVCNative): TSVCStackError;
begin
If fMemory.IsValidArea(fRegisters.GP[REG_SP].Native,AreaSize) then
  Result := seOK
else
  Result := seUnderflow;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.StackPUSH_B(Value: TSVCByte);
begin
AdvanceSP(TSVCNative(-SVC_SZ_BYTE));
TSVCByte(fMemory.AddrPtr(fRegisters.GP[REG_SP].Native)^) := Value;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.StackPUSH_W(Value: TSVCWord);
begin
AdvanceSP(TSVCNative(-SVC_SZ_WORD));
TSVCWord(fMemory.AddrPtr(fRegisters.GP[REG_SP].Native)^) := Value;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.StackPUSH(Value: TSVCNative);
begin
AdvanceSP(TSVCNative(-SVC_SZ_NATIVE));
TSVCNative(fMemory.AddrPtr(fRegisters.GP[REG_SP].Native)^) := Value;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.StackPOP_B: TSVCByte;
begin
Result := TSVCByte(fMemory.AddrPtr(fRegisters.GP[REG_SP].Native)^);
AdvanceSP(SVC_SZ_BYTE);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.StackPOP_W: TSVCWord;
begin
Result := TSVCWord(fMemory.AddrPtr(fRegisters.GP[REG_SP].Native)^);
AdvanceSP(SVC_SZ_WORD);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.StackPOP: TSVCNative;
begin
Result := TSVCNative(fMemory.AddrPtr(fRegisters.GP[REG_SP].Native)^);
AdvanceSP(SVC_SZ_NATIVE);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.RaiseStackError(Error: TSVCStackError);
begin
case Error of
  seOverflow:   raise ESVCInterruptException.Create(SVC_EXCEPTION_STACKOVERFLOW);
  seUnderflow:  raise ESVCInterruptException.Create(SVC_EXCEPTION_STACKUNDERFLOW);
  seRedZone:    raise ESVCInterruptException.Create(SVC_EXCEPTION_STACKREDZONE);
else
 {seOK}
end;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidGPRIdx(RegisterIndex: TSVCRegisterIndex): Boolean;
begin
Result := RegisterIndex in [0..Pred(SVC_REG_GP_IMPLEMENTED),REG_SL,REG_SB,REG_SP];
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidGPR(RegisterID: TSVCRegisterID; ExpectedTypes: TSVCRegisterTypes): Boolean;
begin
Result := IsValidGPRIdx(ExtractRegisterIndex(RegisterID)) and (ExtractRegisterType(RegisterID) in ExpectedTypes);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetGPRPtr(RegisterID: TSVCRegisterID): Pointer;
begin
If IsValidGPR(RegisterID,[rtLoByte,rtHiByte,rtWord,rtNative]) then
  case ExtractRegisterType(RegisterID) of
    rtLoByte: Result := Addr(fRegisters.GP[ExtractRegisterIndex(RegisterID)].LoByte);
    rtHiByte: Result := Addr(fRegisters.GP[ExtractRegisterIndex(RegisterID)].HiByte);
    rtWord:   Result := Addr(fRegisters.GP[ExtractRegisterIndex(RegisterID)].Word);
    rtNative: Result := Addr(fRegisters.GP[ExtractRegisterIndex(RegisterID)].Native);
  else
    raise ESVCFatalInternalException.CreateFmt('TSVCProcessor.GetGPRPtr: Invalid register type (%d).',
                                               [Ord(ExtractRegisterType(RegisterID))]);
  end
else raise ESVCFatalInternalException.CreateFmt('TSVCProcessor.GetGPRPtr: Invalid register (0x%.2x).',[RegisterID]);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetGPRVal(RegisterID: TSVCRegisterID): TSVCNative;
begin
case ExtractRegisterType(RegisterID) of
  rtLoByte: Result := fRegisters.GP[ExtractRegisterIndex(RegisterID)].LoByte;
  rtHiByte: Result := fRegisters.GP[ExtractRegisterIndex(RegisterID)].HiByte;
  rtWord:   Result := fRegisters.GP[ExtractRegisterIndex(RegisterID)].Word;
  rtNative: Result := fRegisters.GP[ExtractRegisterIndex(RegisterID)].Native;
else
  raise ESVCFatalInternalException.CreateFmt('TSVCProcessor.GetGPRVal: Invalid register type (%d).',
                                              [Ord(ExtractRegisterType(RegisterID))]);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.SetGPRVal(RegisterID: TSVCRegisterID; NewValue: TSVCNative);
begin
case ExtractRegisterType(RegisterID) of
  rtLoByte: fRegisters.GP[ExtractRegisterIndex(RegisterID)].LoByte := TSVCByte(NewValue);
  rtHiByte: fRegisters.GP[ExtractRegisterIndex(RegisterID)].HiByte := TSVCByte(NewValue);
  rtWord:   fRegisters.GP[ExtractRegisterIndex(RegisterID)].Word   := TSVCWord(NewValue);
  rtNative: fRegisters.GP[ExtractRegisterIndex(RegisterID)].Native := NewValue;
else
  raise ESVCFatalInternalException.CreateFmt('TSVCProcessor.SetGPRVal: Invalid register type (%d).',
                                            [Ord(ExtractRegisterType(RegisterID))]);
end;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetFlag(FlagMask: TSVCNative): Boolean;
begin
Result := (fRegisters.FLAGS and FlagMask) = FlagMask;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.SetFlag(FlagMask: TSVCNative);
begin
fRegisters.FLAGS := fRegisters.FLAGS or FlagMask;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.ClearFlag(FlagMask: TSVCNative);
begin
fRegisters.FLAGS := fRegisters.FLAGS and not FlagMask;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.ComplementFlag(FlagMask: TSVCNative);
begin
fRegisters.FLAGS := fRegisters.FLAGS xor FlagMask;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.SetFlagValue(FlagMask: TSVCNative; NewValue: Boolean);
begin
If NewValue then SetFlag(FlagMask)
  else ClearFlag(FlagMask);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.EvaluateCondition(ConditionCode: TSVCInstructionConditionCode): Boolean;
begin
case ConditionCode of
   0: Result := GetFlag(SVC_REG_FLAGS_CARRY);
   1: Result := GetFlag(SVC_REG_FLAGS_PARITY);
   2: Result := GetFlag(SVC_REG_FLAGS_ZERO);
   3: Result := GetFlag(SVC_REG_FLAGS_SIGN);
   4: Result := GetFlag(SVC_REG_FLAGS_OVERFLOW);
   5: Result := GetFlag(SVC_REG_FLAGS_DIRECTION);
   6: Result := GetFlag(SVC_REG_FLAGS_INTERRUPTS);
   7: Result := not GetFlag(SVC_REG_FLAGS_CARRY);
   8: Result := not GetFlag(SVC_REG_FLAGS_PARITY);
   9: Result := not GetFlag(SVC_REG_FLAGS_ZERO);
  10: Result := not GetFlag(SVC_REG_FLAGS_SIGN);
  11: Result := not GetFlag(SVC_REG_FLAGS_OVERFLOW);
  12: Result := not GetFlag(SVC_REG_FLAGS_DIRECTION);
  13: Result := not GetFlag(SVC_REG_FLAGS_INTERRUPTS);
  14: Result := GetFlag(SVC_REG_FLAGS_CARRY) or GetFlag(SVC_REG_FLAGS_ZERO);
  15: Result := not(GetFlag(SVC_REG_FLAGS_CARRY) or GetFlag(SVC_REG_FLAGS_ZERO));
  16: Result := GetFlag(SVC_REG_FLAGS_SIGN) xor GetFlag(SVC_REG_FLAGS_OVERFLOW);
  17: Result := not(GetFlag(SVC_REG_FLAGS_SIGN) xor GetFlag(SVC_REG_FLAGS_OVERFLOW));
  18: Result := (GetFlag(SVC_REG_FLAGS_SIGN) xor GetFlag(SVC_REG_FLAGS_OVERFLOW)) or
                GetFlag(SVC_REG_FLAGS_ZERO);
  19: Result := not((GetFlag(SVC_REG_FLAGS_SIGN) xor GetFlag(SVC_REG_FLAGS_OVERFLOW)) or
                GetFlag(SVC_REG_FLAGS_ZERO));
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDARGUMENT,ConditionCode);
end;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetCRFlag(FlagMask: TSVCNative): Boolean;
begin
Result := (fRegisters.CR and FlagMask) = FlagMask;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.AdvanceIP(Step: TSVCNative);
begin
fRegisters.IP := TSVCNative(TSVCComp(fRegisters.IP) + TSVCComp(Step));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.AdvanceSP(Step: TSVCNative);
begin
fRegisters.GP[REG_SP].Native := TSVCNative(TSVCComp(fRegisters.GP[REG_SP].Native) + TSVCComp(Step));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.HandleException(E: Exception);
begin
If E is ESVCInterruptException then
  with ESVCInterruptException(E) do
    DispatchInterrupt(InterruptIndex,InterruptData)
else If E is ESVCFatalInternalException then
  begin
    fFaultClass := E.ClassName;
    fFaultMessage := ESVCFatalInternalException(E).Message;
    fState := psFailed;
  end
else If E is ESVCQuietInternalException then
  {nothing, continue}
else
  begin
    fState := psFailed;
    raise E;
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.DispatchInterrupt(InterruptIndex: TSVCInterruptIndex; Data: TSVCNative = 0);
begin
try
  If GetFlag(SVC_REG_FLAGS_INTERRUPTS) or (InterruptIndex <= SVC_INT_IDX_MAXEXC) then
    begin
      // interrupt enabled or exception
      If (fInterruptHandlers[InterruptIndex].HandlerAddr <> 0) then
        begin
          // interrupt handler assigned
          If fMemory.IsValidAddr(fInterruptHandlers[InterruptIndex].HandlerAddr) then
            begin
              // interrupt handler is at valid address
              If (fInterruptHandlers[InterruptIndex].Counter <= 0) or not IsIRQInterrupt(InterruptIndex) then
                begin
                  case IsValidStackPUSHArea(SVC_INT_INTERRUPTSTACKSPACE) of
                    seOverflow,
                    seUnderflow:  raise ESVCFatalInternalException.Create('TSVCProcessor.DispatchInterrupt: Triple fault (stack fault).');
                  else
                   {seOK,seRedZone}
                    Inc(fInterruptHandlers[InterruptIndex].Counter);
                    StackPUSH(fRegisters.FLAGS);
                    StackPUSH(InterruptIndex);
                    StackPUSH(Data);
                    If InterruptIndex <= SVC_INT_IDX_MAXEXC then
                      // exception, pust start of the instruction that caused it
                      StackPUSH(fCurrentInstruction.StartAddress)
                    else
                      // other insterrupts, push current instruction pointer
                      StackPUSH(fRegisters.IP);
                    fRegisters.IP := fInterruptHandlers[InterruptIndex].HandlerAddr;
                    ClearFlag(SVC_REG_FLAGS_INTERRUPTS);
                  end;
                end;
            end
          else
            begin
              // interrupt handler is at invalid address
              If InterruptIndex <> SVC_EXCEPTION_DOUBLEFAULT then
                DispatchInterrupt(SVC_EXCEPTION_DOUBLEFAULT)
              else
                raise ESVCFatalInternalException.Create('TSVCProcessor.DispatchInterrupt: Triple fault (invalid handler address).');
            end;
        end
      else
        begin
          // interrupt handler not assigned
          If GetCRFlag(SVC_REG_CR_UNHINTERROR) then
            begin
              // unhandled interrupt is an error
              If InterruptIndex <> SVC_EXCEPTION_DOUBLEFAULT then
                DispatchInterrupt(SVC_EXCEPTION_DOUBLEFAULT)
              else
                raise ESVCFatalInternalException.Create('TSVCProcessor.DispatchInterrupt: Triple fault (unassigned interrupt handler).');
            end;
        end;
    end;
except
  on E: Exception do
    begin
      fFaultClass := E.ClassName;
      fFaultMessage := E.Message;
      fState := psFailed;
    end;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.PortUpdated(PortIndex: TSVCPortIndex);
begin
If Assigned(fPorts[PortIndex].OutHandler) then
  fPorts[PortIndex].OutHandler(Self,PortIndex,fPorts[PortIndex].Data)
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_DEVICENOTAVAILABLE,TSVCNative(PortIndex));
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.PortRequested(PortIndex: TSVCPortIndex);
begin
If Assigned(fPorts[PortIndex].InHandler) then
  fPorts[PortIndex].InHandler(Self,PortIndex,fPorts[PortIndex].Data)
else
   raise ESVCInterruptException.Create(SVC_EXCEPTION_DEVICENOTAVAILABLE,TSVCNative(PortIndex));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidWndPos(Position: TSVCNumber): Boolean;
begin
Result := (Position >= Low(fCurrentInstruction.Window.Data)) and
          (Position <= High(fCurrentInstruction.Window.Data));
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidWndOff(Offset: TSVCNumber): Boolean;
begin
Result := IsValidWndPos(fCurrentInstruction.Window.Position + Offset);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.IsValidCurrWndPos: Boolean;
begin
Result := IsValidWndPos(fCurrentInstruction.Window.Position);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetWndPtr(Position: TSVCNumber): Pointer;
begin
Result := Addr(fCurrentInstruction.Window.Data[Position]);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetWndOffPtr(Offset: TSVCNumber = 0): Pointer;
begin
Result := GetWndPtr(fCurrentInstruction.Window.Position + Offset);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetWndCurrByte: TSVCByte;
begin
Result := fCurrentInstruction.Window.Data[fCurrentInstruction.Window.Position];
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetArgVal(ArgIdx: Integer): TSVCNative;
begin
Result := fCurrentInstruction.Arguments[ArgIdx].ArgumentValue;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetArgPtr(ArgIdx: Integer): Pointer;
begin
Result := fCurrentInstruction.Arguments[ArgIdx].ArgumentPtr;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.GetArgAddr(ArgIdx: Integer): TSVCNative;
begin
Result := fCurrentInstruction.Arguments[ArgIdx].ArgumentAddr;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InvalidateInstructionData;
var
  i:  Integer;
begin
with fCurrentInstruction do
  begin
    StartAddress := 0;
    InstructionHandler := nil;
    FillChar(Window.Data,SizeOf(TSVCInstructionWindowData),0);
    Window.Position := 0;
    Prefixes := [];
    FillChar(Instruction,SVC_INS_MAXOPCODELENGTH,0);
    InstructionLength := 0;
    Suffix := 0;
    For i := Low(Arguments) to High(Arguments) do
      begin
        Arguments[i].ArgumentType := iatNone;
        Arguments[i].ArgumentAddr := 0;
        Arguments[i].ArgumentPtr := nil;
        Arguments[i].ArgumentValue := 0;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.ExecuteNextInstruction;
begin
try
  InstructionFetch;
  InstructionIssue;
except
  on E: Exception do HandleException(E);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InstructionFetch;
begin
fCurrentInstruction.StartAddress := fRegisters.IP;
If fMemory.IsValidAddr(fRegisters.IP) then
  fMemory.FetchMemoryArea(fRegisters.IP,SizeOf(TSVCInstructionWindowData),fCurrentInstruction.Window.Data)
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InstructionIssue;
begin
If Assigned(fOnBeforeInstruction) then
  fOnBeforeInstruction(Self,fCurrentInstruction.Window);
InstructionDecode;
InstructionExecute;
Inc(fExecutionCount);
If Assigned(fOnAfterInstruction) then
  fOnAfterInstruction(Self,fCurrentInstruction.Window);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InstructionDecode;
begin
fCurrentInstruction.Window.Position := Pred(Low(fCurrentInstruction.Window.Data));
InstructionDecode(InstructionSelect_L1,1);
Inc(fCurrentInstruction.Window.Position);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InstructionExecute;
begin
If Assigned(fCurrentInstruction.InstructionHandler) then
  try
    fCurrentInstruction.InstructionHandler;
    fCurrentInstruction.PrevPrefixes := fCurrentInstruction.Prefixes;
  finally
    InvalidateInstructionData;
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.ArgumentsDecode(Suffix: Boolean; ArgumentList: array of TSVCInstructionArgumentType; AccessingNVMem: Boolean = False);
var
  i:          Integer;
  ArgsLength: TSVCNumber;

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

  Function CheckMemArea(Address,Size: TSVCNative): Boolean;
  begin
    If AccessingNVMem then Result := fNVMemory.IsValidArea(Address,Size)
      else Result := fMemory.IsValidArea(Address,Size);
  end;

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

  procedure ResolveMemoryLocation(var ArgumentData: TSVCInstructionArgumentData; LocationSize: TSVCNative);
  begin
    If ResolveMemoryAddress(ExtractAddressingMode(fCurrentInstruction.Suffix),ArgumentData.ArgumentAddr) then
      begin
        If CheckMemArea(ArgumentData.ArgumentAddr,LocationSize) then
          begin
            If AccessingNVMem then
              ArgumentData.ArgumentPtr := fNVMemory.AddrPtr(ArgumentData.ArgumentAddr)
            else
              ArgumentData.ArgumentPtr := fMemory.AddrPtr(ArgumentData.ArgumentAddr);
            Inc(fCurrentInstruction.Window.Position,
                AddressingModeLengthSuffix(fCurrentInstruction.Suffix));
          end
        else
          begin
            If AccessingNVMem then
              raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,ArgumentData.ArgumentAddr)
            else
              raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,ArgumentData.ArgumentAddr);
          end;
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDADDRMODE);
  end;

//  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --

begin
{
  position in instruction window is assumed to be pointing to a byte just
  after the last instruction byte
}
// extract suffix if included
If Suffix then
  begin
    If IsValidCurrWndPos then
      begin
        fCurrentInstruction.Suffix := GetWndCurrByte;
        Inc(fCurrentInstruction.Window.Position);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
  end;
// count length of all arguments
ArgsLength := 0;
For i := Low(ArgumentList) to High(ArgumentList) do
  case ArgumentList[i] of
    iatNone,iatFLAGS,iatCNTR,iatCR:;
      // do nothing
    iatREL8,iatIMM8,iatREG8,iatREG16:
      Inc(ArgsLength);
    iatREL16,iatIMM16:
      Inc(ArgsLength,2);
    iatMEM,iatMEM8,iatMEM16:
      If Suffix then
        Inc(ArgsLength,AddressingModeLengthSuffix(fCurrentInstruction.Suffix))
      else
        raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
  else
    raise ESVCFatalInternalException.CreateFmt('TSVCProcessor.ArgumentsDecode: Unknonw argument type (%d).',[Ord(ArgumentList[i])]);
  end;
// resolve the arguments
If IsValidWndOff(ArgsLength) then
  begin
    AdvanceIP(TSVCNative(fCurrentInstruction.Window.Position + ArgsLength));  
    For i := Low(ArgumentList) to IntMin(High(ArgumentList),High(fCurrentInstruction.Arguments)) do
      with fCurrentInstruction.Arguments[i] do
        begin
          ArgumentType := ArgumentList[i];
          case ArgumentType of
            iatNone,
            iatFLAGS,
            iatCNTR,
            iatCR:;   // ignore
            iatREL8:  begin
                        ArgumentPtr := GetWndOffPtr;
                        ArgumentValue := TSVCNative(TSVCSNative(TSVCRel8(ArgumentPtr^)));
                        Inc(fCurrentInstruction.Window.Position);
                      end;
            iatREL16: begin
                        ArgumentPtr := GetWndOffPtr;
                        ArgumentValue := TSVCNative(TSVCRel16(ArgumentPtr^));
                        Inc(fCurrentInstruction.Window.Position,2);
                      end;
            iatIMM8:  begin
                        ArgumentPtr := GetWndOffPtr;
                        ArgumentValue := TSVCNative(TSVCByte(ArgumentPtr^));
                        Inc(fCurrentInstruction.Window.Position);
                      end;
            iatIMM16: begin
                        ArgumentPtr := GetWndOffPtr;
                        ArgumentValue := TSVCNative(TSVCWord(ArgumentPtr^));
                        Inc(fCurrentInstruction.Window.Position,2);
                      end;
            iatREG8:  If IsValidGPR(GetWndCurrByte,[rtLoByte,rtHiByte]) then
                        begin
                          ArgumentPtr := GetGPRPtr(GetWndCurrByte);
                          ArgumentValue := TSVCNative(TSVCByte(ArgumentPtr^));
                          Inc(fCurrentInstruction.Window.Position);
                        end
                      else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDREGISTER,GetWndCurrByte);
            iatREG16: If IsValidGPR(GetWndCurrByte,[rtWord,rtNative]) then
                        begin
                          ArgumentPtr := GetGPRPtr(GetWndCurrByte);
                          ArgumentValue := TSVCNative(TSVCWord(ArgumentPtr^));
                          Inc(fCurrentInstruction.Window.Position);
                        end
                      else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDREGISTER,GetWndCurrByte);
            iatMEM:   If ResolveMemoryAddress(ExtractAddressingMode(fCurrentInstruction.Suffix),ArgumentAddr) then
                        begin
                          ArgumentPtr := Addr(ArgumentValue);
                          ArgumentValue := ArgumentAddr;
                          Inc(fCurrentInstruction.Window.Position,
                              AddressingModeLengthSuffix(fCurrentInstruction.Suffix));
                        end
                      else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDADDRMODE);
            iatMEM8:  begin
                        ResolveMemoryLocation(fCurrentInstruction.Arguments[i],SVC_SZ_BYTE);
                        ArgumentValue := TSVCNative(TSVCByte(ArgumentPtr^));
                      end;
            iatMEM16: begin
                        ResolveMemoryLocation(fCurrentInstruction.Arguments[i],SVC_SZ_WORD);
                        ArgumentValue := TSVCNative(TSVCWord(ArgumentPtr^));
                      end;
          else
            raise ESVCFatalInternalException.CreateFmt('TSVCProcessor.ArgumentsDecode: Invalid argument type (%d).',[Ord(ArgumentType)]);
          end;
        end;
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.PrefixSelect(Prefix: TSVCInstructionPrefix);
begin
raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InstructionSelect_L1(InstructionByte: TSVCByte);
begin
raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InstructionDecode(SelectMethod: TSVCInstructionSelectMethod; InstructionLength: Integer);
begin
Inc(fCurrentInstruction.Window.Position);
If IsValidCurrWndPos then
  begin
    fCurrentInstruction.Instruction[Pred(InstructionLength)] := GetWndCurrByte;
    fCurrentInstruction.InstructionLength := InstructionLength;
    case fCurrentInstruction.Instruction[Pred(InstructionLength)] of
      $00.. // instructions
      $DF:  SelectMethod(fCurrentInstruction.Instruction[Pred(InstructionLength)]);
    //--------------------------------------------------------------------------
      $E0.. // prefixes
      $FF:  begin
              PrefixSelect(fCurrentInstruction.Instruction[Pred(InstructionLength)]);
              Inc(fCurrentInstruction.Window.Position);
              InstructionDecode(SelectMethod,InstructionLength);
            end
    else
      raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
    end;
  end
else raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;

//==============================================================================

constructor TSVCProcessor.Create;
begin
inherited Create;
fState := psUninitialized;
fMemory := nil;
fNVMemory := nil;
end;

//------------------------------------------------------------------------------

destructor TSVCProcessor.Destroy;
begin
Finalize;
inherited;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.Initialize(MemorySize, NVMemorySize: TMemSize);
begin
fMemory := TSVCMemory.Create(MemorySize);
fNVMemory := TSVCMemory.Create(NVMemorySize);
// initialize state
Restart;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.Finalize;
begin
If Assigned(fMemory) then
  FreeAndNil(fMemory);
If Assigned(fNVMemory) then
  FreeAndNil(fNVMemory);
fState := psUninitialized;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.Restart;
var
  i:  Integer;
begin
fExecutionCount := 0;
fFaultClass := '';
fFaultMessage := '';
// initialize state
FillChar(fRegisters,SizeOf(fRegisters),0);
For i := Low(fPorts) to High(fPorts) do
  fPorts[i].Data := 0;
InvalidateInstructionData;
fCurrentInstruction.PrevPrefixes := [];
// init stack
fRegisters.GP[REG_SL].Native := 0;
If fMemory.Size > TMemSize(High(TSVCNative)) then
  fRegisters.GP[REG_SB].Native := High(TSVCNative)
else
  fRegisters.GP[REG_SB].Native := TSVCNative(fMemory.Size);
fRegisters.GP[REG_SP].Native := fRegisters.GP[REG_SB].Native;
// init special registers
fRegisters.IP    := SVC_REG_INITVAL_IP;
fRegisters.FLAGS := SVC_REG_INITVAL_FLAGS;
fRegisters.CNTR  := SVC_REG_INITVAL_CNTR;
fRegisters.CR    := SVC_REG_INITVAL_CR;
// init state
fState := psRunning;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.Reset;
begin
Restart;
// clear ports events
FillChar(fPorts,SizeOf(fPorts),0);
// clear memory (don't touch NVmem)
FillChar(fMemory.Memory^,fMemory.Size,0);
// init interrupt handlers
FillChar(fInterruptHandlers,SizeOf(fInterruptHandlers),0);
// init state
fState := psRunning;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.ExecuteInstruction(InstructionWindow: TSVCInstructionWindow; AffectIP: Boolean = False);
var
  InstrPtr: TSVCNative;
begin
try
  InstrPtr := fRegisters.IP;
  try
    fCurrentInstruction.StartAddress := fRegisters.IP;
    fCurrentInstruction.Window := InstructionWindow;  // fetch
    InstructionIssue;
  finally
    If not AffectIP then
      fRegisters.IP := InstrPtr;
  end;
except
  on E: Exception do HandleException(E);
end;
end;

//------------------------------------------------------------------------------

Function TSVCProcessor.Run(InstructionCount: Integer = 1): Integer;
begin
Result := 0;
If InstructionCount > 0 then
  while (InstructionCount > 0) and (fState = psRunning) do
    begin
      ExecuteNextInstruction;
      Dec(InstructionCount);
      Inc(Result);
    end
else
  while fState = psRunning do
    begin
      ExecuteNextInstruction;
      Inc(Result);
    end;
If fState = psReleased then
  fState := psRunning;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.InterruptRequest(InterruptIndex: TSVCInterruptIndex; Data: TSVCNative = 0);
begin
If IsIRQInterrupt(InterruptIndex) then
  DispatchInterrupt(InterruptIndex,Data);
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor.SetPortHandlers(PortIndex: TSVCPortIndex; InHandler,OutHandler: TSVCPortEvent);
begin
fPorts[PortIndex].InHandler := InHandler;
fPorts[PortIndex].OutHandler := OutHandler;
end;

end.