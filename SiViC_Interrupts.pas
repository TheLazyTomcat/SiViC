unit SiViC_Interrupts;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SysUtils,
  SiViC_Common;

const
  // interrupt indices
  SVC_INT_IDX_GENERALEXCEPTION            = 0;  // currently not used
  SVC_INT_IDX_INVALIDINSTRUCTIONEXCEPTION = 1;
  SVC_INT_IDX_DIVISIONBYZEROEXCEPTION     = 2;
  SVC_INT_IDX_ARITHMETICOVERFLOWEXCEPTION = 3;
  SVC_INT_IDX_MEMORYALIGNMENTEXCEPTION    = 4;  // currently not used
  SVC_INT_IDX_MEMORYACCESSEXCEPTION       = 5;
  SVC_INT_IDX_NVMEMORYACCESSEXCEPTION     = 6;
  SVC_INT_IDX_DEVICENOTAVAILABLEEXCEPTION = 7;  // currently not used
  SVC_INT_IDX_INVALIDREGISTEREXCEPTION    = 8;
  SVC_INT_IDX_INVALIDADDRMODEEXCEPTION    = 9;
  SVC_INT_IDX_INVALIDARGUMENTEXCEPTION    = 10;
  SVC_INT_IDX_STACKOVERFLOWEXCEPTION      = 11;
  SVC_INT_IDX_STACKUNDERFLOWEXCEPTION     = 12;
  SVC_INT_IDX_STACKREDZONEEXCEPTION       = 13;
  SVC_INT_IDX_DOUBLEFAULTEXCEPTION        = 31;

  SVC_EXCEPTION_GENERAL            = SVC_INT_IDX_GENERALEXCEPTION;
  SVC_EXCEPTION_INVALIDINSTRUCTION = SVC_INT_IDX_INVALIDINSTRUCTIONEXCEPTION;
  SVC_EXCEPTION_DIVISIONBYZERO     = SVC_INT_IDX_DIVISIONBYZEROEXCEPTION;
  SVC_EXCEPTION_ARITHMETICOVERFLOW = SVC_INT_IDX_ARITHMETICOVERFLOWEXCEPTION;
  SVC_EXCEPTION_MEMORYALIGNMENT    = SVC_INT_IDX_MEMORYALIGNMENTEXCEPTION;
  SVC_EXCEPTION_MEMORYACCESS       = SVC_INT_IDX_MEMORYACCESSEXCEPTION;
  SVC_EXCEPTION_NVMEMORYACCESS     = SVC_INT_IDX_NVMEMORYACCESSEXCEPTION;
  SVC_EXCEPTION_DEVICENOTAVAILABLE = SVC_INT_IDX_DEVICENOTAVAILABLEEXCEPTION;
  SVC_EXCEPTION_INVALIDREGISTER    = SVC_INT_IDX_INVALIDREGISTEREXCEPTION;
  SVC_EXCEPTION_INVALIDADDRMODE    = SVC_INT_IDX_INVALIDADDRMODEEXCEPTION;
  SVC_EXCEPTION_INVALIDARGUMENT    = SVC_INT_IDX_INVALIDARGUMENTEXCEPTION;
  SVC_EXCEPTION_STACKOVERFLOW      = SVC_INT_IDX_STACKOVERFLOWEXCEPTION;
  SVC_EXCEPTION_STACKUNDERFLOW     = SVC_INT_IDX_STACKUNDERFLOWEXCEPTION;
  SVC_EXCEPTION_STACKREDZONE       = SVC_INT_IDX_STACKREDZONEEXCEPTION;
  SVC_EXCEPTION_DOUBLEFAULT        = SVC_INT_IDX_DOUBLEFAULTEXCEPTION;

  SVC_INT_IDX_MAXEXC = 31;
  SVC_INT_IDX_MINIRQ = 32;
  SVC_INT_IDX_MAXIRQ = 95;
  SVC_INT_IDX_TRAP   = 255;

  // space (bytes) required on the stack for interrupt handler call
  SVC_INT_INTERRUPTSTACKSPACE = 4 * SVC_SZ_NATIVE;

type
  TSVCStackError = (seOK,seOverflow,seUnderflow,seRedZone);

  TSVCInterruptIndex = TSVCByte;

  // interrupt vector
  TSVCInterruptHandler = record
    HandlerAddr:  TSVCNative;
    Counter:      TSVCNumber;
  end;

  TSVCInterruptHandlers = array[TSVCInterruptIndex] of TSVCInterruptHandler;

  // internal exception classes
  ESVCFatalInternalException = class(Exception);

  ESVCQuietInternalException = class(Exception)
  public
    constructor Create;
  end;

  ESVCInterruptException = class(ESVCQuietInternalException)
  protected
    fInterruptIndex:  TSVCInterruptIndex;
    fInterruptData:   TSVCNative;
  public
    constructor Create(InterruptIndex: TSVCInterruptIndex; InterruptData: TSVCNative = 0);
  published
    property InterruptIndex: TSVCInterruptIndex read fInterruptIndex;
    property InterruptData: TSVCNative read fInterruptData;
  end;

// functions for interrupt management
Function IsIRQInterrupt(InterruptIndex: TSVCInterruptIndex): Boolean;{$IFDEF CanInline} inline;{$ENDIF}

implementation

constructor ESVCQuietInternalException.Create;
begin
inherited Create('SiViC quiet internal exception');
end;

//==============================================================================

constructor ESVCInterruptException.Create(InterruptIndex: TSVCInterruptIndex; InterruptData: TSVCNative = 0);
begin
inherited Create;
fInterruptIndex := InterruptIndex;
fInterruptData := InterruptData;
end;

//==============================================================================

Function IsIRQInterrupt(InterruptIndex: TSVCInterruptIndex): Boolean;
begin
Result := (InterruptIndex >= SVC_INT_IDX_MINIRQ) and (InterruptIndex <= SVC_INT_IDX_MAXIRQ);
end;

end.
