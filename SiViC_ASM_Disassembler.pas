unit SiViC_ASM_Disassembler;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Processor,
  SiViC_Program,
  SiViC_ASM_Lists,
  SiViC_ASM_Unparser;

type
  TSVCDisassemblerDisassembledLine = record
    Address:      TSVCNative;
    Str:          String;
    HexStr:       String;
    InstrLength:  Integer;
    WindowMap:    TSVCUnparserWindowMap;
    LineInfo:     TSVCUnparserLineInfos;
    UserData:     TSVCNative;
  end;

  TSVCDisassemblerDisassembledLines = record
    Arr:    array of TSVCDisassemblerDisassembledLine;
    Count:  Integer;
  end;

  TSVCDisassembler = class(TObject)
  private
    fUnparser:          TSVCUnparser;
    fDisassembledLines: TSVCDisassemblerDisassembledLines;
    Function GetDisassembledLine(Index: Integer): TSVCDisassemblerDisassembledLine;
    Function GetUserData(Index: Integer): TSVCNative;
    procedure SetUserData(Index: Integer; Value: TSVCNative);
  protected
    Function IndexForAddition(Address: TSVCNative): Integer; virtual;
    procedure SequentialAdd(Address: TSVCNative; const Str, HexStr: String; InstrLength: Integer; WindowMap: TSVCUnparserWindowMap; LineInfo: TSVCUnparserLineInfos); virtual;
  public
    constructor Create(Lists: TSVCListManager = nil);
    destructor Destroy; override;
    Function IndexOfDisassembledLine(Address: TSVCNative): Integer; virtual;
    Function AddDisassembledLine(Address: TSVCNative; const Str, HexStr: String; InstrLength: Integer; WindowMap: TSVCUnparserWindowMap; LineInfo: TSVCUnparserLineInfos): Integer; virtual;
    Function RemoveDisassembledLine(Address: TSVCNative): Integer; virtual;
    procedure DeleteDisassembledLine(Index: Integer); virtual;
    procedure ClearDisassembledLines(FreeMemory: Boolean = False); virtual;
    Function Disassemble(ProgramObject: TSVCProgram): Boolean; overload; virtual;
  {$IFDEF SVC_Debug}
    Function Disassemble(ProcessorObject: TSVCProcessor; Limit: TSVCComp = High(TSVCComp)): Boolean; overload; virtual;
    Function DisassembleOneAtIP(ProcessorObject: TSVCProcessor): Integer; virtual;
  {$ENDIF SVC_Debug}
    property DisassembledLines[Index: Integer]: TSVCDisassemblerDisassembledLine read GetDisassembledLine; default;
    property UserData[Index: Integer]: TSVCNative read GetUserData write SetUserData;
  published
    property Unparser: TSVCUnparser read fUnparser;
    property DisassembledLineCount: Integer read fDisassembledLines.Count;
  end;

implementation

uses
  SysUtils,
  AuxTypes,
  SiViC_Instructions;

Function TSVCDisassembler.GetDisassembledLine(Index: Integer): TSVCDisassemblerDisassembledLine;
begin
If (Index >= Low(fDisassembledLines.Arr)) and (Index < fDisassembledLines.Count) then
  Result := fDisassembledLines.Arr[Index]
else
  raise Exception.CreateFmt('TSVCDisassembler.GetDisassembledLine: Index (%d) out of bounds.',[Index]);
end;
 
//------------------------------------------------------------------------------

Function TSVCDisassembler.GetUserData(Index: Integer): TSVCNative;
begin
If (Index >= Low(fDisassembledLines.Arr)) and (Index < fDisassembledLines.Count) then
  Result := fDisassembledLines.Arr[Index].UserData
else
  raise Exception.CreateFmt('TSVCDisassembler.GetUserData: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TSVCDisassembler.SetUserData(Index: Integer; Value: TSVCNative);
begin
If (Index >= Low(fDisassembledLines.Arr)) and (Index < fDisassembledLines.Count) then
  fDisassembledLines.Arr[Index].UserData := Value
else
  raise Exception.CreateFmt('TSVCDisassembler.SetUserData: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

Function TSVCDisassembler.IndexForAddition(Address: TSVCNative): Integer;
var
  Left,Right: Integer;
  Pivot:      Integer;
begin
If fDisassembledLines.Count > 0 then
  begin
    Left := Low(fDisassembledLines.Arr);
    Right := Pred(fDisassembledLines.Count);
    Pivot := Left;
    while Left <= Right do
      begin
        Pivot := (Left + Right) shr 1;
        If fDisassembledLines.Arr[Pivot].Address > Address then
          begin
            Right := Pivot - 1;
            Dec(Pivot);
          end
        else If fDisassembledLines.Arr[Pivot].Address < Address then
          Left := Pivot + 1
        else
          Break{while Left <= Right ...};
      end;
    Result := Succ(Pivot);  
  end
else Result := 0;
end;

//------------------------------------------------------------------------------

procedure TSVCDisassembler.SequentialAdd(Address: TSVCNative; const Str, HexStr: String; InstrLength: Integer; WindowMap: TSVCUnparserWindowMap; LineInfo: TSVCUnparserLineInfos);
begin
If fDisassembledLines.Count >= Length(fDisassembledLines.Arr) then
  SetLength(fDisassembledLines.Arr,Length(fDisassembledLines.Arr) + 128);
fDisassembledLines.Arr[fDisassembledLines.Count].Address := Address;
fDisassembledLines.Arr[fDisassembledLines.Count].Str := Str;
fDisassembledLines.Arr[fDisassembledLines.Count].HexStr := HexStr;
fDisassembledLines.Arr[fDisassembledLines.Count].InstrLength := InstrLength;
fDisassembledLines.Arr[fDisassembledLines.Count].WindowMap := WindowMap;
fDisassembledLines.Arr[fDisassembledLines.Count].LineInfo := LineInfo;
fDisassembledLines.Arr[fDisassembledLines.Count].UserData := 0;
Inc(fDisassembledLines.Count);
end;

//==============================================================================

constructor TSVCDisassembler.Create(Lists: TSVCListManager = nil);
begin
inherited Create;
fUnparser := TSVCUnparser.Create(Lists);
SetLength(fDisassembledLines.Arr,0);
fDisassembledLines.Count := 0;
end;

//------------------------------------------------------------------------------

destructor TSVCDisassembler.Destroy;
begin
fUnparser.Free;
inherited;
end;

//------------------------------------------------------------------------------

Function TSVCDisassembler.IndexOfDisassembledLine(Address: TSVCNative): Integer;
var
  Left,Right: Integer;
  Pivot:      Integer;
begin
If fDisassembledLines.Count > 0 then
  begin
    Result := -1;
    Left := Low(fDisassembledLines.Arr);
    Right := Pred(fDisassembledLines.Count);
    while Left <= Right do
      begin
        Pivot := (Left + Right) shr 1;
        If fDisassembledLines.Arr[Pivot].Address > Address then
          Right := Pivot - 1
        else If fDisassembledLines.Arr[Pivot].Address < Address then
          Left := Pivot + 1
        else
          begin
            Result := Pivot;
            Break{while Left <= Right ...};
          end;
      end;
  end
else Result := -1;
end;

//------------------------------------------------------------------------------

Function TSVCDisassembler.AddDisassembledLine(Address: TSVCNative; const Str, HexStr: String; InstrLength: Integer; WindowMap: TSVCUnparserWindowMap; LineInfo: TSVCUnparserLineInfos): Integer;
var
  i:  Integer;
begin
Result := IndexForAddition(Address);
If fDisassembledLines.Count >= Length(fDisassembledLines.Arr) then
  SetLength(fDisassembledLines.Arr,Length(fDisassembledLines.Arr) + 128);
Inc(fDisassembledLines.Count);
For i := Pred(fDisassembledLines.Count) downto Succ(Result) do
  fDisassembledLines.Arr[i] := fDisassembledLines.Arr[i - 1];
fDisassembledLines.Arr[Result].Address := Address;
fDisassembledLines.Arr[Result].Str := Str;
fDisassembledLines.Arr[Result].HexStr := HexStr;
fDisassembledLines.Arr[Result].InstrLength := InstrLength;
fDisassembledLines.Arr[Result].WindowMap := WindowMap;
fDisassembledLines.Arr[Result].LineInfo := LineInfo;
fDisassembledLines.Arr[Result].UserData := 0;
end;

//------------------------------------------------------------------------------

Function TSVCDisassembler.RemoveDisassembledLine(Address: TSVCNative): Integer;
begin
Result := IndexOfDisassembledLine(Address);
If Result >= 0 then
  DeleteDisassembledLine(Result);
end;

//------------------------------------------------------------------------------

procedure TSVCDisassembler.DeleteDisassembledLine(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fDisassembledLines.Arr)) and (Index < fDisassembledLines.Count) then
  begin
    For i := Index to (fDisassembledLines.Count - 2) do
      fDisassembledLines.Arr[i] := fDisassembledLines.Arr[i + 1];
    Dec(fDisassembledLines.Count);   
  end
else raise Exception.CreateFmt('TSVCDisassembler.DeleteDisassembledLine: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TSVCDisassembler.ClearDisassembledLines(FreeMemory: Boolean = False);
begin
fDisassembledLines.Count := 0;
If FreeMemory then
  SetLength(fDisassembledLines.Arr,0);
end;

//------------------------------------------------------------------------------

Function TSVCDisassembler.Disassemble(ProgramObject: TSVCProgram): Boolean;
var
  Offset:   TSVCNative;
  InstrLen: Integer;
  Window:   TSVCInstructionWindow;

  procedure FetchWindow;
  begin
    If TMemSize(Offset + Length(Window.Data)) > ProgramObject.ProgramSize then
      begin
        FillChar(Window.Data,Length(Window.Data),0);
        Move({%H-}Pointer({%H-}PtrUInt(ProgramObject.ProgramData) + PtrUInt(Offset))^,Window.Data,ProgramObject.ProgramSize - Offset);
      end
    else Move({%H-}Pointer({%H-}PtrUInt(ProgramObject.ProgramData) + PtrUInt(Offset))^,Window.Data,Length(Window.Data));
  end;

begin
ClearDisassembledLines;
Offset := 0;
Result := True;
while TMemSize(Offset) < ProgramObject.ProgramSize do
  begin
    FetchWindow;
    InstrLen := TSVCNative(fUnparser.Unparse(Window));
    SequentialAdd(Offset,fUnparser.Line,fUnparser.HexLine,InstrLen,fUnparser.InstructionWindowMap,fUnparser.LineInfo);
    If InstrLen <= 0 then
      begin
        Result := False;
        Break{while...}
      end
    else Offset := Offset + TSVCNative(InstrLen);
  end;
end;

//------------------------------------------------------------------------------

{$IFDEF SVC_Debug}

Function TSVCDisassembler.Disassemble(ProcessorObject: TSVCProcessor; Limit: TSVCComp = High(TSVCComp)): Boolean;
var
  Offset:   TSVCNative;
  InstrLen: Integer;
  Window:   TSVCInstructionWindow;
begin
ClearDisassembledLines;
Offset := 0;
Result := True;
while (TMemSize(Offset) < ProcessorObject.Memory.Size) and (TSVCComp(Offset) < Limit) do
  begin
    ProcessorObject.Memory.FetchMemoryArea(Offset,Length(Window.Data),Window.Data);
    InstrLen := TSVCNative(fUnparser.Unparse(Window));
    SequentialAdd(Offset,fUnparser.Line,fUnparser.HexLine,InstrLen,fUnparser.InstructionWindowMap,fUnparser.LineInfo);
    If InstrLen <= 0 then
      begin
        Result := False;
        Break{while...}
      end
    else Offset := Offset + TSVCNative(InstrLen);
  end;
end;

//------------------------------------------------------------------------------

Function TSVCDisassembler.DisassembleOneAtIP(ProcessorObject: TSVCProcessor): Integer;
var
  InstrLen: Integer;
  Window:   TSVCInstructionWindow;
begin
If TMemSize(ProcessorObject.Registers.IP) < ProcessorObject.Memory.Size then
  begin
    ProcessorObject.Memory.FetchMemoryArea(ProcessorObject.Registers.IP,Length(Window.Data),Window.Data);
    InstrLen := TSVCNative(fUnparser.Unparse(Window));
    Result := AddDisassembledLine(ProcessorObject.Registers.IP,fUnparser.Line,fUnparser.HexLine,InstrLen,fUnparser.InstructionWindowMap,fUnparser.LineInfo);
  end
else Result := -1;
end;

{$ENDIF SVC_Debug}

end.
