unit SiViC_Instructions;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common;

const
  // some basic constants, do not change (maybe except window length)
  SVC_INS_WINDOWLENGTH    = 16;
  SVC_INS_MAXOPCODELENGTH = 4;
  SVC_INS_MAXARGUMENTS    = 4;

  SVC_INS_IDTHRESHOLD_CONTINUOUS = $D0;
  SVC_INS_IDTHRESHOLD_PREFIX     = $E0;

type
  TSVCInstructionLength = TSVCByte;

  TSVCInstructionPrefix = TSVCByte;
  TSVCInstructionSuffix = TSVCByte;

  // types for info stored in suffix
  TSVCInstructionAddressingMode = TSVCByte;
  TSVCInstructionConditionCode  = TSVCByte;

  // instruction window structures
  TSVCInstructionWindowData = array[0..Pred(SVC_INS_WINDOWLENGTH)] of TSVCByte;

  TSVCInstructionWindow = record
    Data:     TSVCInstructionWindowData;
    Position: TSVCNumber;
  end;

  // implemented prefixes
  TSVCImplementedPrefix   = (ipfxPFXR,ipfxREP,ipfxREPZ,ipfxREPNZ);
  TSVCImplementedPrefixes = set of TSVCImplementedPrefix;

  // possible types of instruction arguments
  TSVCInstructionArgumentType  = (iatNone,iatIP,iatFLAGS,iatCNTR,iatCR,
                                  iatREL8,iatREL16,iatIMM8,iatIMM16,
                                  iatREG8,iatREG16,
                                  iatMEM8,iatMEM16,iatMEM);

  TSVCInstructionArgumentTypes = set of TSVCInstructionArgumentType;

const
  SVC_INS_ARGUMENTTYPES_STRINGS: array[TSVCInstructionArgumentType] of String =
    ('','IP','FLAGS','CNTR','CR','REL8','REL16','IMM8','IMM16','REG8','REG16','MEM8','MEM16','MEM');

type
  // instructions (event) handler prototypes
  TSVCInstructionHandler = procedure of object;
  TSVCInstructionEvent   = procedure(Sender: TObject; InstructionWindow: TSVCInstructionWindow) of object;

  // structures used in instruction execution
  TSVCInstructionArgumentData = record
    ArgumentType:   TSVCInstructionArgumentType;
    ArgumentAddr:   TSVCNative;
    ArgumentPtr:    Pointer;
    ArgumentValue:  TSVCNative;
  end;

  TSVCInstructionData = record
    PrevPrefixes:       TSVCImplementedPrefixes;
    StartAddress:       TSVCNative;
    InstructionHandler: TSVCInstructionHandler;
    Window:             TSVCInstructionWindow;
    Prefixes:           TSVCImplementedPrefixes;
    Instruction:        array[0..Pred(SVC_INS_MAXOPCODELENGTH)] of TSVCByte;
    InstructionLength:  TSVCInstructionLength;
    Suffix:             TSVCInstructionSuffix;
    Arguments:          array[0..Pred(SVC_INS_MAXARGUMENTS)] of TSVCInstructionArgumentData;
  end;

// some functions for instructions/arguments manipulation and eccess
Function ExtractAddressingMode(Suffix: TSVCInstructionSuffix): TSVCInstructionAddressingMode;{$IFDEF CanInline} inline;{$ENDIF}
Function ExtractConditionCode(Suffix: TSVCInstructionSuffix): TSVCInstructionConditionCode;{$IFDEF CanInline} inline;{$ENDIF}

Function BuildSuffix(AddrMode: TSVCInstructionAddressingMode; CondCode: TSVCInstructionConditionCode): TSVCInstructionSuffix;{$IFDEF CanInline} inline;{$ENDIF}

Function AddressingModeLength(AddrMode: TSVCInstructionAddressingMode): TSVCNumber;
Function AddressingModeLengthSuffix(Suffix: TSVCInstructionSuffix): TSVCNumber;{$IFDEF CanInline} inline;{$ENDIF}

implementation

Function ExtractAddressingMode(Suffix: TSVCInstructionSuffix): TSVCInstructionAddressingMode;
begin
Result := Suffix and $7;  // lower 3 bits of suffix
end;

//------------------------------------------------------------------------------

Function ExtractConditionCode(Suffix: TSVCInstructionSuffix): TSVCInstructionConditionCode;
begin
Result := (Suffix shr 3) and $1F;   // highest 5 bits of suffix
end;

//------------------------------------------------------------------------------

Function BuildSuffix(AddrMode: TSVCInstructionAddressingMode; CondCode: TSVCInstructionConditionCode): TSVCInstructionSuffix;
begin
Result := TSVCInstructionSuffix(CondCode shl 3) or TSVCInstructionSuffix(AddrMode and $7);
end;

//------------------------------------------------------------------------------

Function AddressingModeLength(AddrMode: TSVCInstructionAddressingMode): TSVCNumber;
begin
case AddrMode of
  0:  Result := 1;  // reg16
  1:  Result := 2;  // imm16
  2:  Result := 3;  // reg16 + imm16
  3:  Result := 2;  // reg16 * imm8
  4:  Result := 4;  // reg16 * imm8 + imm16
  5:  Result := 2;  // reg16 + reg16
  6:  Result := 3;  // reg16 + reg16 * imm8
  7:  Result := 5;  // reg16 + reg16 * imm8 + imm16
else
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

Function AddressingModeLengthSuffix(Suffix: TSVCInstructionSuffix): TSVCNumber;
begin
Result := AddressingModeLength(ExtractAddressingMode(Suffix));
end;

end.
