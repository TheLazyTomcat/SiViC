unit SiViC_ASM_Unparser;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Instructions,
  SiViC_ASM_Lists;

type
  TSVCUnparserStage = (usInitial,usPrefix,usOpCode,usSuffix,usArgument,usFinal);

  TSVCUnparserWindowMapItemType = (wmitNone = 0,wmitPrefix,wmitInstruction,wmitSuffix,wmitArgument);

  TSVCUnparserWindowMap = array[0..Pred(SVC_INS_WINDOWLENGTH)] of TSVCUnparserWindowMapItemType;

  TSVCUnparserLineInfo = (uliPrefix,uliMemory,uliCondition);
  TSVCUnparserLineInfos = set of TSVCUnparserLineInfo;

  TSVCUnparserData = record
    HexOnly:      Boolean;
    SplitHexLine: Boolean;
    Window:       TSVCInstructionWindow;
    WindowMap:    TSVCUnparserWindowMap;
    WindowMapPos: Integer;
    LineInfo:     TSVCUnparserLineInfos;
    Line:         String;
    HexLine:      String; 
    OpCode:       TSVCByteArray;
    InstrIdx:     Integer;
    AddrMode:     TSVCInstructionAddressingMode;
    ArgIdx:       Integer;
  end;

  TSVCUnparser = class(TObject)
  private
    fOwnsLists:     Boolean;
    fLists:         TSVCListManager;
    // unparsing variables
    fStage:         TSVCUnparserStage;
    fUnparserData:  TSVCUnparserData;
  protected
    procedure AppendToLine(const Str: String; AddSpace: Boolean = True); virtual;
    procedure AppendToHexLine(Byte: TSVCByte; WindowMapItemType: TSVCUnparserWindowMapItemType; AddSpace: Boolean = True); virtual;
    procedure Unparse_Stage_Initial; virtual;
    procedure Unparse_Stage_Prefix; virtual;
    procedure Unparse_Stage_OpCode; virtual;
    procedure Unparse_Stage_Suffix; virtual;
    procedure Unparse_Stage_Argument; virtual;
    procedure Unparse_Stage_Final; virtual;
  public
    constructor Create(Lists: TSVCListManager = nil);
    destructor Destroy; override;
    Function Unparse(InstructionWindow: TSVCInstructionWindow): Integer; overload; virtual;
    Function Unparse(InstructionData: array of TSVCByte): Integer; overload; virtual;
    property InstructionWindowMap: TSVCUnparserWindowMap read fUnparserData.WindowMap;
  published
    property HexOnly: Boolean read fUnparserData.HexOnly write fUnparserData.HexOnly;
    property SplitHexLine: Boolean read fUnparserData.SplitHexLine write fUnparserData.SplitHexLine;
    property Line: String read fUnparserData.Line;
    property HexLine: String read fUnparserData.HexLine;
    property LineInfo: TSVCUnparserLineInfos read fUnparserData.LineInfo;
  end;

implementation

uses
  SysUtils,
  AuxTypes,
  SiViC_Registers,
  SiViC_ASM_Parser_Instr;

{$IFDEF FPC_DisableWarns}
  {$WARN 5057 OFF} // Local variable "$1" does not seem to be initialized
{$ENDIF}

type
  ESVCUnparsingError = class(Exception);

//------------------------------------------------------------------------------

procedure TSVCUnparser.AppendToLine(const Str: String; AddSpace: Boolean = True);
begin
If Length(fUnparserData.Line) > 0 then
  begin
    If AddSpace then fUnparserData.Line := fUnparserData.Line + ' ' + Str
      else fUnparserData.Line := fUnparserData.Line + Str;
  end
else fUnparserData.Line := Str;
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.AppendToHexLine(Byte: TSVCByte; WindowMapItemType: TSVCUnparserWindowMapItemType; AddSpace: Boolean = True);
begin
If (fUnparserData.WindowMapPos >= Low(TSVCUnparserWindowMap)) and (fUnparserData.WindowMapPos <= High(TSVCUnparserWindowMap)) then
  begin
    fUnparserData.WindowMap[fUnparserData.WindowMapPos] := WindowMapItemType;
    Inc(fUnparserData.WindowMapPos);
  end
else raise Exception.CreateFmt('TSVCUnparser.AppendToHexLine: Window map position (%d) out of bounds.',[fUnparserData.WindowMapPos]);
If Length(fUnparserData.HexLine) > 0 then
  begin
    If AddSpace and fUnparserData.SplitHexLine then
      fUnparserData.HexLine := fUnparserData.HexLine + ' ' + Format('%.2x',[Byte])
    else
      fUnparserData.HexLine := fUnparserData.HexLine + Format('%.2x',[Byte]);
  end
else fUnparserData.HexLine := Format('%.2x',[Byte]);
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
          AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitPrefix,True);
          Include(fUnparserData.LineInfo,uliPrefix);
          If not fUnparserData.HexOnly then
            begin
              Index := fLists.IndexOfPrefix(TSVCInstructionPrefix(
                fUnparserData.Window.Data[fUnparserData.Window.Position]));
              If Index >= 0 then
                AppendToLine(fLists.Prefixes[Index].Mnemonic)
              else
                raise ESVCUnparsingError.Create('Unknown prefix');
            end;
          fStage := usPrefix;            
        end;
else
  // it should never get here
  raise ESVCUnparsingError.CreateFmt('Invalid code (0x.2x) at %d',
          [fUnparserData.Window.Data[fUnparserData.Window.Position],fUnparserData.Window.Position]);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_OpCode;
var
  i:        Integer;
  CondCode: TSVCInstructionConditionCode;
  Index:    Integer;
begin
// usOpCode -> usSuffix
// usOpCode -> usArgument
// usOpCode -> usFinal
fUnparserData.InstrIdx := fLists.IndexOfInstruction(fUnparserData.OpCode);
// add instruction to hex
For i := Low(fUnparserData.OpCode) to High(fUnparserData.OpCode) do
  AppendToHexLine(fUnparserData.OpCode[i],wmitInstruction,i = Low(fUnparserData.OpCode));
If fUnparserData.InstrIdx >= 0 then
  begin
    with fLists.Instructions[fUnparserData.InstrIdx] do
      begin
        If CCSuffix or MemSuffix then
          begin
            // add suffix to hex
            AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitSuffix,True);
            fUnparserData.AddrMode := ExtractAddressingMode(TSVCInstructionSuffix(
              fUnparserData.Window.Data[fUnparserData.Window.Position]));
            CondCode := ExtractconditionCode(TSVCInstructionSuffix(
              fUnparserData.Window.Data[fUnparserData.Window.Position]));
            If CCSuffix then
              Include(fUnparserData.LineInfo,uliCondition);
            If MemSuffix then
              Include(fUnparserData.LineInfo,uliMemory);              
            fStage := usSuffix;
          end
        else
          begin
            CondCode := 0;
            fStage := usArgument;
            Dec(fUnparserData.Window.Position);
          end;
        If not fUnparserData.HexOnly then
          begin
            If CCSuffix then
              begin
                Index := fUnparserData.InstrIdx;
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
          end;
        If Length(Arguments) <= 0 then
          fStage := usFinal;
      end;
  end
else raise ESVCUnparsingError.Create('Unknown instruction');
end;

//------------------------------------------------------------------------------

procedure TSVCUnparser.Unparse_Stage_Suffix;
var
  i:  Integer;

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
                AppendToLine('+ 0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1]) or
                               UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 2] shl 8),4) +
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
                  If not fUnparserData.HexOnly then
                    AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_IP));
                  Dec(fUnparserData.Window.Position);
                end;
      iatFLAGS: begin
                  If not fUnparserData.HexOnly then
                    AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_FLAGS));
                  Dec(fUnparserData.Window.Position);
                end;
      iatCNTR:  begin
                  If not fUnparserData.HexOnly then
                    AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_CNTR));
                  Dec(fUnparserData.Window.Position);
                end;
      iatCR:    begin
                  If not fUnparserData.HexOnly then
                    AppendToLine(GetImplicitRegisterStr(SVC_REG_IMPL_IDX_CR));
                  Dec(fUnparserData.Window.Position);
                end;                  
      iatREL8:  begin
                  AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitArgument,True);
                  If not fUnparserData.HexOnly then
                    AppendToLine('byte ' + IntToStr(Int8(fUnparserData.Window.Data[fUnparserData.Window.Position])));
                end;
      iatREL16: If (fUnparserData.Window.Position + 1) < Length(fUnparserData.Window.Data) then
                  begin
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitArgument,True);
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position + 1],wmitArgument,False);
                    If not fUnparserData.HexOnly then
                      AppendToLine('word ' + IntToStr(Int16(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position]) or
                        UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1] shl 8))));
                    Inc(fUnparserData.Window.Position);
                  end
                else raise ESVCUnparsingError.Create('Out of instruction window');
      iatIMM8:  begin
                  AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitArgument,True);
                  If not fUnparserData.HexOnly then
                    AppendToLine('0x' + IntToHex(UInt8(fUnparserData.Window.Data[fUnparserData.Window.Position]),2));
                end;
      iatIMM16: If (fUnparserData.Window.Position + 1) < Length(fUnparserData.Window.Data) then
                  begin
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitArgument,True);
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position + 1],wmitArgument,False);
                    If not fUnparserData.HexOnly then
                      AppendToLine('0x' + IntToHex(UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position]) or
                        UInt16(fUnparserData.Window.Data[fUnparserData.Window.Position + 1] shl 8),4));
                    Inc(fUnparserData.Window.Position);
                  end
                else raise ESVCUnparsingError.Create('Out of instruction window');
      iatREG8,
      iatREG16: begin
                  AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position],wmitArgument,True);
                  If not fUnparserData.HexOnly then
                    AppendToLine(GetRegisterStr(fUnparserData.Window.Data[fUnparserData.Window.Position]));
                end;
      iatMEM8:  begin
                  For i := 0 to Pred(AddressingModeLength(fUnparserData.AddrMode)) do
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position + i],wmitArgument,i = 0);
                  If not fUnparserData.HexOnly then
                    begin
                      AppendToLine('byte ptr');
                      AppendAddressing;
                    end;
                end;
      iatMEM16: begin
                  For i := 0 to Pred(AddressingModeLength(fUnparserData.AddrMode)) do
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position + i],wmitArgument,i = 0);
                  If not fUnparserData.HexOnly then
                    begin
                      AppendToLine('word ptr');
                      AppendAddressing;
                    end;
                end;
      iatMEM:   begin
                  For i := 0 to Pred(AddressingModeLength(fUnparserData.AddrMode)) do
                    AppendToHexLine(fUnparserData.Window.Data[fUnparserData.Window.Position + i],wmitArgument,i = 0);      
                  If not fUnparserData.HexOnly then
                    AppendAddressing;
                end;    
    else
      raise ESVCUnparsingError.Create('Invalid argument type');
    end;
    Inc(fUnparserData.ArgIdx);
    If fUnparserData.ArgIdx < Length(fLists.Instructions[fUnparserData.InstrIdx].Arguments) then
      begin
        fStage := usArgument;
        If not fUnparserData.HexOnly then
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
begin
If fStage = usFinal then
  begin
    If fUnparserData.HexOnly then
      fUnparserData.Line := fUnparserData.HexLine;
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
// initialize data
fUnparserData.HexOnly := False;
fUnparserData.SplitHexLine := False;
fUnparserData.Line := '';
fUnparserData.HexLine := '';
end;

//------------------------------------------------------------------------------

destructor TSVCUnparser.Destroy;
begin
If fOwnsLists then
  fLists.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TSVCUnparser.Unparse(InstructionWindow: TSVCInstructionWindow): Integer;
var
  i:  Integer;
begin
fStage := usInitial;
// init unparsing data
fUnparserData.Window := InstructionWindow;
fUnparserData.Window.Position := Low(fUnparserData.Window.Data);
For i := Low(TSVCUnparserWindowMap) to High(TSVCUnparserWindowMap) do
  fUnparserData.WindowMap[i] := wmitNone;
fUnparserData.WindowMapPos := 0;
fUnparserData.LineInfo := [];
fUnparserData.Line := '';
fUnparserData.HexLine := '';
SetLength(fUnparserData.OpCode,0);
fUnparserData.InstrIdx := -1;
fUnparserData.AddrMode := 255;  // invalid addressing mode
fUnparserData.ArgIdx := 0;
try
  // processing cycle
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

//------------------------------------------------------------------------------

Function TSVCUnparser.Unparse(InstructionData: array of TSVCByte): Integer;
var
  Temp: TSVCInstructionWindow;
  i:    Integer;
begin
If Length(InstructionData) <= Length(Temp.Data) then
  begin
    FillChar(Temp.Data,Length(Temp.Data),0);
    Temp.Position := Low(Temp.Data);
    For i := Low(InstructionData) to High(InstructionData) do
      Temp.Data[i] := InstructionData[i];
    Result := Unparse(Temp);
  end
else raise Exception.CreateFmt('TSVCUnparser.Unparse: Instruction array too long (%d).',[Length(InstructionData)]);
end;

end.
