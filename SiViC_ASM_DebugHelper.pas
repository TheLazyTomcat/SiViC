unit SiViC_ASM_DebugHelper;

{$INCLUDE '.\SiViC_defs.inc'}

interface

{$IFDEF SVC_Debug}

uses
  Classes,
  SiViC_Common,
  SiViC_Memory,
  SiViC_Registers,
  SiViC_Interrupts,
  SiViC_IO,
  SiViC_Processor;

type
  TSVCDebugHelperIndexEvent = procedure(Sender: TObject; Index: TSVCComp) of object;

  TSVCDebugHelper = class(TObject)
  private
    fProcessor:             TSVCProcessor;
    fAccessMask:            TSVCWord;
    fRegistersShadow:       TSVCRegisters;
    fInterruptsShadow:      TSVCInterruptHandlers;
    fPortsShadow:           TSVCPorts;
    fLastMemoryRead:        TSVCNative;
    fLastMemoryWrite:       TSVCNative;
    fLastNVMemoryRead:      TSVCNative;
    fLastNVMemoryWrite:     TSVCNative;
    fOnExecution:           TNotifyEvent;
    fOnGPRegisterChange:    TSVCDebugHelperIndexEvent;
    fOnSpecRegisterChange:  TSVCDebugHelperIndexEvent;
    fOnPortChange:          TSVCDebugHelperIndexEvent;
    fOnInterruptChange:     TSVCDebugHelperIndexEvent;
    fOnStackChange:         TSVCDebugHelperIndexEvent;
    fOnMemoryRead:          TSVCMemoryAccessEvent;
    fOnMemoryWrite:         TSVCMemoryAccessEvent;
    fOnNVMemoryRead:        TSVCMemoryAccessEvent;
    fOnNVMemoryWrite:       TSVCMemoryAccessEvent;
  protected
    procedure AfterInstructionHandler(Sender: TObject); virtual;
    procedure MemoryReadHandler(Sender: TObject; Address: TSVCNative); virtual;
    procedure MemoryWriteHandler(Sender: TObject; Address: TSVCNative); virtual;
    procedure NVMemoryReadHandler(Sender: TObject; Address: TSVCNative); virtual;
    procedure NVMemoryWriteHandler(Sender: TObject; Address: TSVCNative); virtual;
  public
    constructor Create(Processor: TSVCProcessor);
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure Update; virtual;
  published
    property OnExecution: TNotifyEvent read fOnExecution write fOnExecution;
    property OnGPRegisterChange: TSVCDebugHelperIndexEvent read fOnGPRegisterChange write fOnGPRegisterChange;
    property OnSpecialRegisterChange: TSVCDebugHelperIndexEvent read fOnSpecRegisterChange write fOnSpecRegisterChange;
    property OnPortChange: TSVCDebugHelperIndexEvent read fOnPortChange write fOnPortChange;
    property OnInterruptChange: TSVCDebugHelperIndexEvent read fOnInterruptChange write fOnInterruptChange;
    property OnStackChange: TSVCDebugHelperIndexEvent read fOnStackChange write fOnStackChange;
    property OnMemoryRead: TSVCMemoryAccessEvent read fOnMemoryRead write fOnMemoryRead;
    property OnMemoryWrite: TSVCMemoryAccessEvent read fOnMemoryWrite write fOnMemoryWrite;
    property OnNVMemoryRead: TSVCMemoryAccessEvent read fOnNVMemoryRead write fOnNVMemoryRead;
    property OnNVMemoryWrite: TSVCMemoryAccessEvent read fOnNVMemoryWrite write fOnNVMemoryWrite;
  end;

{$ENDIF SVC_Debug}

implementation

const
  SVC_ACCESSMASK_INSTRUCTION = $0001;
  SVC_ACCESSMASK_MEMREAD     = $0002;
  SVC_ACCESSMASK_MEMWRITE    = $0004;
  SVC_ACCESSMASK_NVMEMREAD   = $0008;
  SVC_ACCESSMASK_NVMEMWRITE  = $0010;

{$IFDEF SVC_Debug}

procedure TSVCDebugHelper.AfterInstructionHandler(Sender: TObject);
begin
fAccessMask := fAccessMask or SVC_ACCESSMASK_INSTRUCTION;
end;

//------------------------------------------------------------------------------

procedure TSVCDebugHelper.MemoryReadHandler(Sender: TObject; Address: TSVCNative);
begin
fLastMemoryRead := Address;
fAccessMask := fAccessMask or SVC_ACCESSMASK_MEMREAD;
end;

//------------------------------------------------------------------------------

procedure TSVCDebugHelper.MemoryWriteHandler(Sender: TObject; Address: TSVCNative);
begin
fLastMemoryWrite := Address;
fAccessMask := fAccessMask or SVC_ACCESSMASK_MEMWRITE;
end;

//------------------------------------------------------------------------------

procedure TSVCDebugHelper.NVMemoryReadHandler(Sender: TObject; Address: TSVCNative);
begin
fLastNVMemoryRead := Address;
fAccessMask := fAccessMask or SVC_ACCESSMASK_NVMEMREAD;
end;
  
//------------------------------------------------------------------------------

procedure TSVCDebugHelper.NVMemoryWriteHandler(Sender: TObject; Address: TSVCNative);
begin
fLastNVMemoryWrite := Address;
fAccessMask := fAccessMask or SVC_ACCESSMASK_NVMEMWRITE;
end;

//==============================================================================

constructor TSVCDebugHelper.Create(Processor: TSVCProcessor);
begin
inherited Create;
fProcessor := Processor;
Initialize;
fProcessor.OnAfterInstruction := AfterInstructionHandler;
fProcessor.OnMemoryRead := MemoryReadHandler;
fProcessor.OnMemoryWrite := MemoryWriteHandler;
fProcessor.OnNVMemoryRead := NVMemoryReadHandler;
fProcessor.OnNVMemoryWrite := NVMemoryWriteHandler;
end;

//------------------------------------------------------------------------------

destructor TSVCDebugHelper.Destroy;
begin
fProcessor.OnAfterInstruction := nil;
fProcessor.OnMemoryRead := nil;
fProcessor.OnMemoryWrite := nil;
fProcessor.OnNVMemoryRead := nil;
fProcessor.OnNVMemoryWrite := nil;
inherited;
end;

//------------------------------------------------------------------------------

procedure TSVCDebugHelper.Initialize;
begin
fAccessMask := 0;
fRegistersShadow := fProcessor.Registers;
fInterruptsShadow := fProcessor.InterruptHandlers;
fPortsShadow := fProcessor.Ports;
fLastMemoryWrite := 0;
fLastMemoryRead := 0;
fLastNVMemoryWrite := 0;
fLastNVMemoryRead := 0;
end;

//------------------------------------------------------------------------------

procedure TSVCDebugHelper.Update;
var
  i:      Integer;
  GPRCh:  Boolean;
begin
// execution
If Assigned(fOnExecution) and ((fAccessMask and SVC_ACCESSMASK_INSTRUCTION) <> 0) then
  fOnExecution(Self);
// GPRs
GPRCh := False;
If Assigned(fOnGPRegisterChange) then
  For i := Low(fProcessor.Registers.GP) to High(fProcessor.Registers.GP) do
    If fProcessor.Registers.GP[i].Native <> fRegistersShadow.GP[i].Native then
      begin
        If i in [REG_SP,REG_SB,REG_SL] then
          begin
            If not GPRCh then
              fOnGPRegisterChange(Self,i);
          end
        else
          begin
            GPRCh := True;
            fOnGPRegisterChange(Self,i);
          end;
      end;
// special registers
If Assigned(fOnSpecRegisterChange) then
  begin
    If fProcessor.Registers.IP <> fRegistersShadow.IP then
      fOnSpecRegisterChange(Self,SVC_REG_IMPL_IDX_IP);
    If fProcessor.Registers.FLAGS <> fRegistersShadow.FLAGS then
      fOnSpecRegisterChange(Self,SVC_REG_IMPL_IDX_FLAGS);
    If fProcessor.Registers.CNTR <> fRegistersShadow.CNTR then
      fOnSpecRegisterChange(Self,SVC_REG_IMPL_IDX_CNTR);
    If fProcessor.Registers.CR <> fRegistersShadow.CR then
      fOnSpecRegisterChange(Self,SVC_REG_IMPL_IDX_CR);
  end;
// ports
If Assigned(fOnPortChange) then
  For i := Low(fProcessor.Ports) to High(fProcessor.Ports) do
    If (fProcessor.Ports[i].Data <> fPortsShadow[i].Data) then
      fOnPortChange(Self,i);
// interrupt handlers
If Assigned(fOnInterruptChange) then
  For i := Low(fProcessor.InterruptHandlers) to High(fProcessor.InterruptHandlers) do
    If (fProcessor.InterruptHandlers[i].HandlerAddr <> fInterruptsShadow[i].HandlerAddr) or
      (fProcessor.InterruptHandlers[i].Counter <> fInterruptsShadow[i].Counter) then
      fOnInterruptChange(Self,i);
// stack
If Assigned(fOnStackChange) then
  begin
    If fProcessor.Registers.GP[REG_SL].Native <> fRegistersShadow.GP[REG_SL].Native then
      fOnStackChange(Self,REG_SL);
    If fProcessor.Registers.GP[REG_SB].Native <> fRegistersShadow.GP[REG_SB].Native then
      fOnStackChange(Self,REG_SB);
    If fProcessor.Registers.GP[REG_SP].Native <> fRegistersShadow.GP[REG_SP].Native then
      fOnStackChange(Self,REG_SP);
  end;
// RAM
If Assigned(fOnMemoryRead) and ((fAccessMask and SVC_ACCESSMASK_MEMREAD) <> 0) then
  fOnMemoryRead(Self,fLastMemoryRead);
If Assigned(fOnMemoryWrite) and ((fAccessMask and SVC_ACCESSMASK_MEMWRITE) <> 0) then
  fOnMemoryWrite(Self,fLastMemoryWrite);
// NV-memory
If Assigned(fOnNVMemoryRead) and ((fAccessMask and SVC_ACCESSMASK_NVMEMREAD) <> 0) then
  fOnNVMemoryRead(Self,fLastNVMemoryRead);
If Assigned(fOnNVMemoryWrite) and ((fAccessMask and SVC_ACCESSMASK_NVMEMWRITE) <> 0) then
  fOnNVMemoryWrite(Self,fLastNVMemoryWrite);
Initialize;
end;

{$ENDIF SVC_Debug}

end.
