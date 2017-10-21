unit SiViC_ASM_Unparser;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Instructions,
  SiViC_ASM_Lists;

type
  TSVCUnparserStage = (usInitial,usPrefix,usOpCode,usSuffix,usArgument,usFinal);

  TSVCUnparserData = record
    Window:   TSVCInstructionWindow;
    Line:     String;
    HexOnly:  Boolean;
    OpCode:   TSVCByteArray;
    InstrIdx: Integer;
    AddrMode: TSVCInstructionAddressingMode;
    ArgIdx:   Integer;
  end;

  TSVCUnparser = class(TObject)
  private
    fOwnsLists:     Boolean;
    fLists:         TSVCListManager;
    // unparsing variables
    fStage:         TSVCUnparserStage;
    fUnparserData:  TSVCUnparserData;
  protected
    procedure AppendToLine(const Str: String; DoSpace: Boolean = True); virtual;
    procedure Unparse_Stage_Initial; virtual;
    procedure Unparse_Stage_Prefix; virtual;
    procedure Unparse_Stage_OpCode; virtual;
    procedure Unparse_Stage_Suffix; virtual;
    procedure Unparse_Stage_Argument; virtual;
    procedure Unparse_Stage_Final; virtual;
  public
    constructor Create(Lists: TSVCListManager = nil);
    destructor Destroy; override;
    Function Unparse(InstructionWindow: TSVCInstructionWindow; HexOnly: Boolean = False): Integer; virtual;
  published
    property Line: String read fUnparserData.Line;
  end;

implementation

uses
  SysUtils,
  AuxTypes,
  SiViC_Registers,
  SiViC_ASM_Parser_Instr;

type
  ESVCUnparsingError = class(Exception);

//------------------------------------------------------------------------------

procedure TSVCUnparser.AppendToLine(const Str: String; DoSpace: Boolean = True);
begin
If not fUnparserData.HexOnly then
  begin
    If Length(fUnparserData.Line) > 0 then
      begin
        If DoSpace then fUnparserData.Line := fUnparserData.Line + ' ' + Str
          else fUnparserData.Line := fUnparserData.Line + Str;
      end
    else fUnparserData.Line := Str;
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_Initial;
begin
// usInitial -> usPrefix
fStage := usPrefix;
Dec(fUnparserData.Window.Position);
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_Prefix;
var
  Index:  Integer;
begin
// usPrefix -> usPrefix
// usPrefix -> usOpCode
// usPrefix -> usFinal
case fUnparserData.Window.Data[fUnparserData.Window.Position] of
  $00..
  $CF:  begin // instruction
          SetLength(fUnparserData.OpCode,Length(fUnparserData.OpCode) + 1);
          fUnparserData.OpCode[High(fUnparserData.OpCode)] :=
            fUnparserData.Window.Data[fUnparserData.Window.Position];
          fStage := usOpCode;
        end;
  $D0..
  $DF:  begin // continuous instruction
          SetLength(fUnparserData.OpCode,Length(fUnparserData.OpCode) + 1);
          fUnparserData.OpCode[High(fUnparserData.OpCode)] :=
            fUnparserData.Window.Data[fUnparserData.Window.Position];
          fStage := usPrefix;  
        end;
  $E0..
  $FF:  begin // prefix
          Index := fLists.IndexOfPrefix(TSVCInstructionPrefix(
            fUnparserData.Window.Data[fUnparserData.Window.Position]));
          If Index >= 0 then
            AppendToLine(fLists.Prefixes[Index].Mnemonic)
          else
            raise ESVCUnparsingError.Create('Unknown prefix');
          fStage := usPrefix;  
        end;
else
  raise ESVCUnparsingError.CreateFmt('Invalid code (0x.2x) at %d',
          [fUnparserData.Window.Data[fUnparserData.Window.Position],fUnparserData.Window.Position]);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_OpCode;
var
  CondCode: TSVCInstructionConditionCode;
  Index:    Integer;
begin
// usOpCode -> usSuffix
// usOpCode -> usArgument
// usOpCode -> usFinal
fUnparserData.InstrIdx := fLists.IndexOfInstruction(fUnparserData.OpCode);
If fUnparserData.InstrIdx >= 0 then
  begin
    with fLists.Instructions[fUnparserData.InstrIdx] do
      begin
        If CCSuffix or MemSuffix then
          begin
            fUnparserData.AddrMode := ExtractAddressingMode(TSVCInstructionSuffix(
              fUnparserData.Window.Data[fUnparserData.Window.Position]));
            CondCode := ExtractconditionCode(TSVCInstructionSuffix(
              fUnparserData.Window.Data[fUnparserData.Window.Position]));
            fStage := usSuffix;
          end
        else
          begin
            CondCode := 0;
            fStage := usArgument;
            Dec(fUnparserData.Window.Position);
          end;
        If CCSuffix then
          begin
            Index := fLists.IndexOfInstruction(fUnparserData.OpCode);
            while Index >= 0 do
              begin
                If fLists.Instructions[Index].CCCode = CondCode then
                  Break{while Index...};
                Index := fLists.IndexOfInstruction(fUnparserData.OpCode,Succ(Index));
              end;
            If Index >= 0 then
              begin
                AppendToLine(fLists.Instructions[Index].Mnemonic);
                fUnparserData.InstrIdx := Index;
              end
            else raise ESVCUnparsingError.Create('Unknown instruction');
          end
        else AppendToLine(Mnemonic);
        If Length(Arguments) <= 0 then
          fStage := usFinal;
      end;
  end
else raise ESVCUnparsingError.Create('Unknown instruction');
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_Suffix;

  Function GetImplicitRegisterStr(RegIdx: TSVCRegisterIndex): String;
  var
    Index:  Integer;
  begin
    Index := fLists.IndexOfImplicitRegister(RegIdx);
    If Index >= 0 then
      Result := fLists.Registers[Index].Name
    else
      raise ESVCUnparsingError.Create('Unknown implicit register');
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Function GetRegisterStr(RegID: TSVCRegisterID): String;
  var
    Index:  Integer;
  begin
    Index := fLists.IndexOfRegister(RegID);
    If Index >= 0 then
      Result := fLists.Registers[Index].Name
    else
      raise ESVCUnparsingError.Create('Unknown register');
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  procedure AppendAddressing;
  begin
    If (fUnparserData.Window.Position + AddressingModeLength(fUnparserData.AddrMode)) < Length(fUnparserData.Window.Data) then
      begin
        case fUnparserData.AddrMode of
          0:  AppendToLine(Format('%s%s%s',[SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART,
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]),
                             SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND]));
          1:  AppendToLine(Format('%s%s%s',[SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART,
                             '0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position]) or
                             UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1] shl 8),4),
                             SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND]));
          2:  begin
                AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART +
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                AppendToLine('+ 0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position]) or
                               UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1] shl 8),4) +
                               SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND);
              end;
          3:  begin
                AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART +
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                AppendToLine('* ' + IntToStr(UInt8(fUnparserData.Window.Data[fUnparserData.Window.Position + 1])) +
                                    SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND);
              end;
          4:  begin
                AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART +
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                AppendToLine('* ' + IntToStr(UInt8(fUnparserData.Window.Data[fUnparserData.Window.Position + 1])));
                AppendToLine('+ 0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 2]) or
                               UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 3] shl 8),4) +
                               SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND);
              end;
          5:  begin
                AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART +
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                AppendToLine('+ ' + GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position + 1]) +
                                    SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND);
              end;
          6:  begin
                AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART +
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                AppendToLine('+ ' + GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position + 1]));
                AppendToLine('* ' + IntToStr(UInt8(fUnparserData.Window.Data[fUnparserData.Window.Position + 2])) +
                                    SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND);
              end;
          7:  begin
                AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART +
                             GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                AppendToLine('+ ' + GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position + 1]));
                AppendToLine('* ' + IntToStr(UInt8(fUnparserData.Window.Data[fUnparserData.Window.Position + 2])));
                AppendToLine('+ 0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 3]) or
                               UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 4] shl 8),4) +
                               SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND);
              end;
        else
          raise ESVCUnparsingError.Create('Unknown addressing mode');
        end;
        Inc(fUnparserData.Window.Position,AddressingModeLength(fUnparserData.AddrMode) - 1);
      end
    else raise ESVCUnparsingError.Create('Memory addressing too long');
  end;

begin
// usSuffix -> usArgument
// usSuffix -> usFinal
If fUnparserData.ArgIdx < Length(fLists.Instructions[fUnparserData.InstrIdx].Arguments) then
  begin
    case fLists.Instructions[fUnparserData.InstrIdx].Arguments[fUnparserData.ArgIdx] of
      iatIP:    begin
                  AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_IP));
                  Dec(fUnparserData.Window.Position);
                end;
      iatFLAGS: begin
                  AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_FLAGS));
                  Dec(fUnparserData.Window.Position);
                end;
      iatCNTR:  begin
                  AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_CNTR));
                  Dec(fUnparserData.Window.Position);
                end;
      iatCR:    begin
                  AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_CR));
                  Dec(fUnparserData.Window.Position);
                end;                  
      iatREL8:  AppendToLine('byte ' + IntToStr(Int8(fUnparserData.Window.Data[fUnparserData.Window.Position])));
      iatREL16: If (fUnparserData.Window.Position + 1) < Length(fUnparserData.Window.Data) then
                  begin
                    AppendToLine('word ' + IntToStr(Int16(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position]) or
                      UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1] shl 8))));
                    Inc(fUnparserData.Window.Position);
                  end
                else raise ESVCUnparsingError.Create('Out of instruction window');
      iatIMM8:  AppendToLine('0x' + IntToHex(UInt8(fUnparserData.Window.Data[fUnparserData.Window.Position]),2));
      iatIMM16: If (fUnparserData.Window.Position + 1) < Length(fUnparserData.Window.Data) then
                  begin
                    AppendToLine('0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position]) or
                      UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1] shl 8),4));
                    Inc(fUnparserData.Window.Position);
                  end
                else raise ESVCUnparsingError.Create('Out of instruction window');
      iatREG8,
      iatREG16: AppendToLine(GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
      iatMEM8:  begin
                  AppendToLine('byte ptr');
                  AppendAddressing;
                end;
      iatMEM16: begin
                  AppendToLine('word ptr');
                  AppendAddressing;
                end;
      iatMEM:   AppendAddressing;
    else
      raise ESVCUnparsingError.Create('Invalid argument type');
    end;
    Inc(fUnparserData.ArgIdx);
    If fUnparserData.ArgIdx < Length(fLists.Instructions[fUnparserData.InstrIdx].Arguments) then
      begin
        fStage := usArgument;
        AppendToLine(SVC_ASM_PARSER_CHAR_INSTR_ARGS_DELIMITER,False);
      end
    else fStage := usFinal;
  end
else raise ESVCUnparsingError.Create('Invalid argument index');
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_Argument;
begin
// usArgument -> usArgument
Unparse_Stage_Suffix;
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_Final;
var
  i:  Integer;
begin
If fStage = usFinal then
  begin
    If fUnparserData.HexOnly then
      begin
        fUnparserData.Line := '';
        For i := Low(fUnparserData.Window.Data) to Pred(fUnparserData.Window.Position) do
          fUnparserData.Line := fUnparserData.Line + IntToHex(fUnparserData.Window.Data[i],2);
      end;
  end
else raise ESVCUnparsingError.Create('Unterminated instruction');
end;

//==============================================================================

constructor TSVCUnparser.Create(Lists: TSVCListManager = nil);
begin
inherited Create;
fOwnsLists := not Assigned(Lists);
If not Assigned(Lists) then
  begin
    fLists := TSVCListManager.Create;
    fLists.LoadFromResource(SVC_ASM_LISTS_DEFAULTRESOURCENAME);
  end
else fLists := Lists;
end;

//------------------------------------------------------------------------------

destructor TSVCUnparser.Destroy;
begin
If fOwnsLists then
  fLists.Free;
inherited;
end;

//------------------------------------------------------------------------------

// limit to length of passed data
Function TSVCUnparser.Unparse(InstructionWindow: TSVCInstructionWindow; HexOnly: Boolean = False): Integer;
begin
fStage := usInitial;
// init unparsing data
fUnparserData.Window := InstructionWindow;
fUnparserData.Line := '';
fUnparserData.Window.Position := Low(fUnparserData.Window.Data);
fUnparserData.HexOnly := HexOnly;
SetLength(fUnparserData.OpCode,0);
fUnparserData.InstrIdx := -1;
fUnparserData.AddrMode := 255;  // invalid addressing mode
fUnparserData.ArgIdx := 0;
// processing cycle
try
  while fUnparserData.Window.Position <= High(fUnparserData.Window.Data) do
    begin
      case fStage of
        usInitial:  Unparse_Stage_Initial;
        usPrefix:   Unparse_Stage_Prefix;
        usOpCode:   Unparse_Stage_OpCode;
        usSuffix:   Unparse_Stage_Suffix;
        usArgument: Unparse_Stage_Argument;
        usFinal:    Break{while...};
      end;
      Inc(fUnparserData.Window.Position);
    end;
  Unparse_Stage_Final;
  Result := fUnparserData.Window.Position;
except
  on E: ESVCUnparsingError do
    begin
      fUnparserData.Line := Format('ERROR(%s)',[E.Message]);
      Result := 0;
    end
  else raise;
end;
end;

end.
