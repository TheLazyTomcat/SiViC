unit SiViC_Registers;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common;

const
  SVC_REG_GP_COUNT       = 64; // do not change
  SVC_REG_GP_IMPLEMENTED = 61;
  SVC_REG_GP_TOTALCOUNT  = SVC_REG_GP_IMPLEMENTED + 3{SL,SB,SP};

  // general purpose registers indices
  SVC_REG_GP_IDX_R0  = 0;       REG_R0  = SVC_REG_GP_IDX_R0;
  SVC_REG_GP_IDX_R1  = 1;       REG_R1  = SVC_REG_GP_IDX_R1;
  SVC_REG_GP_IDX_R2  = 2;       REG_R2  = SVC_REG_GP_IDX_R2;
  SVC_REG_GP_IDX_R3  = 3;       REG_R3  = SVC_REG_GP_IDX_R3;
  SVC_REG_GP_IDX_R4  = 4;       REG_R4  = SVC_REG_GP_IDX_R4;
  SVC_REG_GP_IDX_R5  = 5;       REG_R5  = SVC_REG_GP_IDX_R5;
  SVC_REG_GP_IDX_R6  = 6;       REG_R6  = SVC_REG_GP_IDX_R6;
  SVC_REG_GP_IDX_R7  = 7;       REG_R7  = SVC_REG_GP_IDX_R7;
  SVC_REG_GP_IDX_R8  = 8;       REG_R8  = SVC_REG_GP_IDX_R8;
  SVC_REG_GP_IDX_R9  = 9;       REG_R9  = SVC_REG_GP_IDX_R9;
  SVC_REG_GP_IDX_R10 = 10;      REG_R10 = SVC_REG_GP_IDX_R10;
  SVC_REG_GP_IDX_R11 = 11;      REG_R11 = SVC_REG_GP_IDX_R11;
  SVC_REG_GP_IDX_R12 = 12;      REG_R12 = SVC_REG_GP_IDX_R12;
  SVC_REG_GP_IDX_R13 = 13;      REG_R13 = SVC_REG_GP_IDX_R13;
  SVC_REG_GP_IDX_R14 = 14;      REG_R14 = SVC_REG_GP_IDX_R14;
  SVC_REG_GP_IDX_R15 = 15;      REG_R15 = SVC_REG_GP_IDX_R15;

  // indices of GPRs that have assigned meaning
  SVC_REG_GP_IDX_SL = SVC_REG_GP_COUNT - 3;
  SVC_REG_GP_IDX_SB = SVC_REG_GP_COUNT - 2;
  SVC_REG_GP_IDX_SP = SVC_REG_GP_COUNT - 1;

  REG_SL = SVC_REG_GP_IDX_SL;
  REG_SB = SVC_REG_GP_IDX_SB;
  REG_SP = SVC_REG_GP_IDX_SP;

  // indices of implicit (hidden) registers
  SVC_REG_IMPL_IDX_IP    = 255;
  SVC_REG_IMPL_IDX_FLAGS = 254;
  SVC_REG_IMPL_IDX_CNTR  = 253;
  SVC_REG_IMPL_IDX_CR    = 252;

  // implemented bits in FLAGS register
  SVC_REG_FLAGS_CARRY      = TSVCNative($1);    // bit 0
  SVC_REG_FLAGS_PARITY     = TSVCNative($2);    // bit 1
  SVC_REG_FLAGS_ZERO       = TSVCNative($4);    // bit 2
  SVC_REG_FLAGS_SIGN       = TSVCNative($8);    // bit 3
  SVC_REG_FLAGS_OVERFLOW   = TSVCNative($10);   // bit 4
  SVC_REG_FLAGS_DIRECTION  = TSVCNative($20);   // bit 5
  SVC_REG_FLAGS_INTERRUPTS = TSVCNative($40);   // bit 6

  // implemented bits in control register CR
  SVC_REG_CR_INCDECCARRY = $0001;  // INC and DEC are affecting carry flag
  SVC_REG_CR_FASTSTRING  = $0002;  // optimized string instructions (MOVS*, STOS*)
  SVC_REG_CR_UNHINTERROR = $0004;  // unhandled interupt causes an error
  SVC_REG_CR_PORTERRORS  = $0008;  // raise error on access to port without connected device 

  // initial values for special registers
  SVC_REG_INITVAL_IP    = $0000;
  SVC_REG_INITVAL_FLAGS = SVC_REG_FLAGS_INTERRUPTS;
  SVC_REG_INITVAL_CNTR  = $0000;
  SVC_REG_INITVAL_CR    = SVC_REG_CR_FASTSTRING;

type
  // types for GPR access
  TSVCRegisterType  = (rtLoByte,rtHiByte,rtWord,rtNative);
  TSVCRegisterTypes = set of TSVCRegisterType;

  TSVCRegisterIndex = TSVCByte;
  TSVCRegisterID    = TSVCByte;

  // simplified register (special registers)
  TSVCSimpleRegister = TSVCNative;  

  // structured register (general purpose registers)
  TSVCStructRegister = packed record
    case TSVCRegisterType of
      rtLoByte,
      rtHiByte: (LoByte,
                 HiByte:  TSVCByte);
      rtWord:   (Word:    TSVCWord);
      rtNative: (Native:  TSVCNative);
  end;

  // general purpose registers
  TSVCGPRegisters = array[0..Pred(SVC_REG_GP_COUNT)] of TSVCStructRegister;

  // structure of all registers on SiViC architecture
  TSVCRegisters = record
    GP:     TSVCGPRegisters;      // general purpose registers
    IP:     TSVCSimpleRegister;   // instruction pointer
    FLAGS:  TSVCSimpleRegister;   // flags register
    CNTR:   TSVCSimpleRegister;   // counter register
    CR:     TSVCSimpleRegister;   // control register
  end;

// funtions for register manipulation and access
Function RegisterTypeFromNumber(RegisterTypeNumber: TSVCNumber): TSVCRegisterType;

Function ExtractRegisterIndex(RegisterID: TSVCRegisterID): TSVCRegisterIndex;{$IFDEF CanInline} inline;{$ENDIF}
Function ExtractRegisterType(RegisterID: TSVCRegisterID): TSVCRegisterType;

Function BuildRegisterID(RegisterIndex: TSVCRegisterIndex; RegisterType: TSVCRegisterType): TSVCRegisterID; overload;
Function BuildRegisterID(RegisterIndex: TSVCRegisterIndex; RegisterTypeNum: TSVCNumber): TSVCRegisterID; overload;{$IFDEF CanInline} inline;{$ENDIF}

implementation

uses
  SysUtils;

Function RegisterTypeFromNumber(RegisterTypeNumber: TSVCNumber): TSVCRegisterType;
begin
case RegisterTypeNumber of
  0:  Result := rtLoByte;
  1:  Result := rtHiByte;
  2:  Result := rtWord;
  3:  Result := rtNative;
else
  raise Exception.CreateFmt('RegisterTypeFromNumber: Unknown register type (%d).',[RegisterTypeNumber]);
end;
end;

//------------------------------------------------------------------------------

Function ExtractRegisterIndex(RegisterID: TSVCRegisterID): TSVCRegisterIndex;
begin
Result := RegisterID and $3F; // lower 6 bits
end;

//------------------------------------------------------------------------------

Function ExtractRegisterType(RegisterID: TSVCRegisterID): TSVCRegisterType;
begin
case RegisterID shr 6 of    // highest 2 bits
  0:  Result := rtLoByte;
  1:  Result := rtHiByte;
  2:  Result := rtWord;
  3:  Result := rtNative;
else
  // it really should not get here, but better save than sorry
  raise Exception.CreateFmt('ExtractRegisterType: Unknown register type (%d).',[RegisterID]);
end;
end;

//------------------------------------------------------------------------------

Function BuildRegisterID(RegisterIndex: TSVCRegisterIndex; RegisterType: TSVCRegisterType): TSVCRegisterID;
var
  RegisterTypeNum:  TSVCNumber;
begin
case RegisterType of
  rtLoByte: RegisterTypeNum := 0;
  rtHiByte: RegisterTypeNum := 1;
  rtWord:   RegisterTypeNum := 2;
  rtNative: RegisterTypeNum := 3;
else
  raise Exception.CreateFmt('BuildRegisterID: Unknown register type (%d).',[Ord(RegisterType)]);
end;
Result := BuildRegisterID(RegisterIndex,RegisterTypeNum);
end;

//------------------------------------------------------------------------------

Function BuildRegisterID(RegisterIndex: TSVCRegisterIndex; RegisterTypeNum: TSVCNumber): TSVCRegisterID;
begin
Result := TSVCRegisterID((RegisterTypeNum shl 6) or (RegisterIndex and $3F));
end;

end.
