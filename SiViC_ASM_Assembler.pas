unit SiViC_ASM_Assembler;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  SiViC_Common,
  SiViC_Instructions,
  SiViC_Program,
  SiViC_ASM_Lists,
  SiViC_ASM_Parser_Base,
  SiViC_ASM_Parser_Instr,
  SiViC_ASM_Parser;

const
  SVC_ASM_ASSEMBLER_LOWORD_SUFFIX = '_LO';
  SVC_ASM_ASSEMBLER_HIWORD_SUFFIX = '_HI';   

type
  TSVCAssemblerItem_Sys = record
    Identifier: String;
    Value:      TSVCComp;
    Counter:    Integer;
    SrcLineIdx: Integer;
  end;

  TSVCAssemblerList_Sys = record
    Arr:    array of TSVCAssemblerItem_Sys;
    Count:  Integer;
  end;

  TSVCAssemblerItem_Const = record
    Identifier: String;
    Value:      TSVCNative;
    Size:       TSVCValueSize;
    SrcLineIdx: Integer;
  end;

  TSVCAssemblerList_Const = record
    Arr:    array of TSVCAssemblerItem_Const;
    Count:  Integer;
  end;

  TSVCAssemblerItem_Var = record
    Identifier:             String;
    Size:                   TSVCNative;
    Data:                   TSVCByteArray;
    Referencing:            Boolean;
    ReferenceIdentifier:    String;
    ReferenceIdentifierPos: Integer;
    ReferenceOffset:        TSVCNative;
    Address:                TSVCNative;
    SrcLineIdx:             Integer;
  end;

  TSVCAssemblerList_Var = record
    Arr:    array of TSVCAssemblerItem_Var;
    Count:  Integer;
  end;

  TSVCAssemblerItem_Label = record
    Identifier: String;
    Address:    TSVCNative;
    SrcLineIdx: Integer;
  end;

  TSVCAssemblerList_Label = record
    Arr:    array of TSVCAssemblerItem_Label;
    Count:  Integer;
  end;

  TSVCAssemblerItem_Unresolved = record
    Identifier: String;
    Count:      Integer;
    SrcLineIdx: Integer;
    SrcLinePos: Integer;
  end;

  TSVCAssemblerList_Unresolved = record
    Arr:    array of TSVCAssemblerItem_Unresolved;
    Count:  Integer;
  end;

  TSVCAssemblerLineType = (altSys,altConst,altVar,altLabel,altData,altInstr,altOther);

  TSVCAssemblerInstruction = record
    Address:      TSVCNative;
    Data:         TSVCByteArray;
    Replacements: array of TSVCParserResult_Instr_Replacement;
  end;

  TSVCAssemblerLine = record
    Str:          String;
    SrcLineIdx:   Integer;
    LineType:     TSVCAssemblerLineType;
    Instruction:  TSVCAssemblerInstruction;
  end;

  TSVCAssemblerLines = record
    Arr:    array of TSVCAssemblerLine;
    Count:  Integer;
  end;

  TSVCAssemblerMessage = record
    MessageType:  TSVCParserMessageType;
    Text:         String;
    LineIdx:      Integer;
    Position:     Integer;
  end;

  TSVCAssemblerMessages = record
    Arr:      array of TSVCAssemblerMessage;
    Count:    Integer;
    Counters: array[TSVCParserMessageType] of Integer;
  end;

  TSVCAssembler = class(TObject)
  private
    fLists:             TSVCListManager;
    fParser:            TSVCParser;
    fSystemValues:      TSVCAssemblerList_Sys;
    fConstants:         TSVCAssemblerList_Const;
    fVariables:         TSVCAssemblerList_Var;
    fLabels:            TSVCAssemblerList_Label;
    fUnresolved:        TSVCAssemblerList_Unresolved;
    fAssemblerLines:    TSVCAssemblerLines;
    fAssemblerMessages: TSVCAssemblerMessages;
    // assembling variables
    fParsedLine:        String;
    fParsedLineIdx:     Integer;
    fParsedLinePos:     Integer;
    fCodeSize:          TMemSize;
    fMemTaken:          TMemSize;
    Function GetSys(Index: Integer): TSVCAssemblerItem_Sys;
    Function GetConst(Index: Integer): TSVCAssemblerItem_Const;
    Function GetVar(Index: Integer): TSVCAssemblerItem_Var;
    Function GetLabel(Index: Integer): TSVCAssemblerItem_Label;
    Function GetAssemblerLine(Index: Integer): TSVCAssemblerLine;
    Function GetAssemblerMessage(Index: Integer): TSVCAssemblerMessage;
    Function GetAssemblerMessageTypeCount(MessageType: TSVCParserMessageType): Integer;
  protected
    Function IndexOfSys(const Identifier: String): Integer; virtual;
    Function CheckedIndexOfSys(const Identifier: String): Integer; virtual;
    Function IndexOfConst(const Identifier: String): Integer; virtual;
    Function IndexOfVar(const Identifier: String): Integer; virtual;
    Function IndexOfLabel(const Identifier: String): Integer; virtual;
    Function IndexOfUnresolved(const Identifier: String): Integer; virtual;
    Function AddDefaultSys(const Identifier: String; Value: TSVCNative): Integer; virtual;
    Function AddSys(Item: TSVCAssemblerItem_Sys): Integer; virtual;
    Function AddConst(Item: TSVCAssemblerItem_Const): Integer; virtual;
    Function AddVar(Item: TSVCAssemblerItem_Var): Integer; virtual;
    Function AddLabel(Item: TSVCAssemblerItem_Label): Integer; virtual;
    Function AddUnresolved(const Identifier: String; SrcLineIdx, SrcLinePos: Integer): Integer; virtual;
    Function RemoveUnresolved(const Identifier: String): Integer; virtual;
    Function AddAssemblerLine(Item: TSVCAssemblerLine): Integer; virtual;
    procedure AssignSysToConst(const Identifier: String; Value: TSVCComp); virtual;
    class Function BuildAssemblerMessage(MessageType: TSVCParserMessageType; Text: String; LineIdx,Position: Integer): TSVCAssemblerMessage; virtual;
    Function AddAssemblerMessage(Item: TSVCAssemblerMessage): Integer; virtual;
    Function AddWarningMessage(const Text: String; Values: array of const): Integer; overload; virtual;
    Function AddWarningMessage(const Text: String): Integer; overload; virtual;
    procedure LoadDefaultSystemValues; virtual;
    procedure LoadPredefinedConstants; virtual;
    procedure SortMessages; virtual;
    procedure CountMessages; virtual;
    procedure FinalizeVariables; virtual;
    procedure FinalizeSystemValues; virtual;
    procedure FinalizeReplacements; virtual;
    procedure ParsingResultHandler(Sender: TObject; ResultType: TSVCParserResultType; Result: Pointer); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear(FreeMem: Boolean = False); virtual;    
    procedure AssembleInit; virtual;
    Function AssembleUpdate(const Line: String): Boolean; virtual;
    Function AssembleFinal: Boolean; virtual;
    Function Assemble(const SourceCode: TStrings; MaxErrorCount: Integer = -1): Boolean; virtual;
    Function BuildProgram: TSVCProgram; virtual;
    property SystemValues[Index: Integer]: TSVCAssemblerItem_Sys read GetSys;
    property Constants[Index: Integer]: TSVCAssemblerItem_Const read GetConst;
    property Variables[Index: Integer]: TSVCAssemblerItem_Var read GetVar;
    property Labels[Index: Integer]: TSVCAssemblerItem_Label read GetLabel;
    property AssemblerLines[Index: Integer]: TSVCAssemblerLine read GetAssemblerLine; default;
    property AssemblerMessages[Index: Integer]: TSVCAssemblerMessage read GetAssemblerMessage;
    property AssemblerMessageTypeCounts[MessageType: TSVCParserMessageType]: Integer read GetAssemblerMessageTypeCount;
  published
    property Lists: TSVCListManager read fLists;
    property SystemValueCount: Integer read fSystemValues.Count;
    property ConstantCount: Integer read fConstants.Count;
    property VariableCount: Integer read fVariables.Count;    
    property LabelCount: Integer read fLabels.Count;
    property AssemblerLineCount: Integer read fAssemblerLines.Count;
    property AssemblerMessageCount: Integer read fAssemblerMessages.Count;
    property CodeSize: TMemSize read fCodeSize;
    property MemoryTaken: TMemSize read fMemTaken;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Parser_Sys,
  SiViC_ASM_Parser_Const,
  SiViC_ASM_Parser_Var,
  SiViC_ASM_Parser_Data,
  SiViC_ASM_Parser_Label;

type
  ESVCAssemblerError = class(Exception);

//------------------------------------------------------------------------------

Function TSVCAssembler.GetSys(Index: Integer): TSVCAssemblerItem_Sys;
begin
If (Index >= Low(fSystemValues.Arr)) and (Index < fSystemValues.Count) then
  Result := fSystemValues.Arr[Index]
else
  raise Exception.CreateFmt('TSVCAssembler.GetSys: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.GetConst(Index: Integer): TSVCAssemblerItem_Const;
begin
If (Index >= Low(fConstants.Arr)) and (Index < fConstants.Count) then
  Result := fConstants.Arr[Index]
else
  raise Exception.CreateFmt('TSVCAssembler.GetConst: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.GetVar(Index: Integer): TSVCAssemblerItem_Var;
begin
If (Index >= Low(fVariables.Arr)) and (Index < fVariables.Count) then
  Result := fVariables.Arr[Index]
else
  raise Exception.CreateFmt('TSVCAssembler.GetVar: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.GetLabel(Index: Integer): TSVCAssemblerItem_Label;
begin
If (Index >= Low(fLabels.Arr)) and (Index < fLabels.Count) then
  Result := fLabels.Arr[Index]
else
  raise Exception.CreateFmt('TSVCAssembler.GetLabel: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.GetAssemblerLine(Index: Integer): TSVCAssemblerLine;
begin
If (Index >= Low(fAssemblerLines.Arr)) and (Index < fAssemblerLines.Count) then
  Result := fAssemblerLines.Arr[Index]
else
  raise Exception.CreateFmt('TSVCAssembler.GetAssemblerLine: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.GetAssemblerMessage(Index: Integer): TSVCAssemblerMessage;
begin
If (Index >= Low(fAssemblerMessages.Arr)) and (Index < fAssemblerMessages.Count) then
  Result := fAssemblerMessages.Arr[Index]
else
  raise Exception.CreateFmt('TSVCAssembler.GetAssemblerMessage: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.GetAssemblerMessageTypeCount(MessageType: TSVCParserMessageType): Integer;
begin
If (MessageType >= Low(TSVCParserMessageType)) and (MessageType <= High(TSVCParserMessageType)) then
  Result := fAssemblerMessages.Counters[MessageType]
else
  raise Exception.CreateFmt('TSVCAssembler.GetAssemblerMessageTypeCount: Unknown message type (%d).',[Ord(MessageType)]);
end;

//==============================================================================

Function TSVCAssembler.IndexOfSys(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fSystemValues.Arr) to Pred(fSystemValues.Count) do
  If AnsiSameText(fSystemValues.Arr[i].Identifier,Identifier) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.CheckedIndexOfSys(const Identifier: String): Integer;
begin
Result := IndexOfSys(Identifier);
If Result < 0 then
  raise Exception.CreateFmt('TSVCAssembler.FinalizeSystemValues: %s value not found.',[Identifier]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.IndexOfConst(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fConstants.Arr) to Pred(fConstants.Count) do
  If AnsiSameText(fConstants.Arr[i].Identifier,Identifier) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.IndexOfVar(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fVariables.Arr) to Pred(fVariables.Count) do
  If AnsiSameText(fVariables.Arr[i].Identifier,Identifier) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.IndexOfLabel(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fLabels.Arr) to Pred(fLabels.Count) do
  If AnsiSameText(fLabels.Arr[i].Identifier,Identifier) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.IndexOfUnresolved(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fUnresolved.Arr) to Pred(fUnresolved.Count) do
  If AnsiSameText(fUnresolved.Arr[i].Identifier,Identifier) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddDefaultSys(const Identifier: String; Value: TSVCNative): Integer;
var
  SysTemp:    TSVCAssemblerItem_Sys;
  ConstTemp:  TSVCAssemblerItem_Const;
begin
If IndexOfSys(Identifier) < 0 then
  begin 
    SysTemp.Identifier := Identifier;
    SysTemp.Value := Value;
    SysTemp.Counter := 0;
    SysTemp.SrcLineIdx := -1;
    Result := AddSys(SysTemp);
    // add low word as constant
    ConstTemp.Identifier := Identifier + SVC_ASM_ASSEMBLER_LOWORD_SUFFIX;
    ConstTemp.Value := TSVCNative(Value);
    ConstTemp.Size := vsNative;
    ConstTemp.SrcLineIdx := -1;
    AddConst(ConstTemp);
    // add high word as constant
    ConstTemp.Identifier := Identifier + SVC_ASM_ASSEMBLER_HIWORD_SUFFIX;
    ConstTemp.Value := TSVCNative(Value shr 16);
    ConstTemp.Size := vsNative;
    ConstTemp.SrcLineIdx := -1;
    AddConst(ConstTemp);
  end
else raise Exception.Create('TSVCAssembler.AddDefaultSys: Default system value already defined');
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddSys(Item: TSVCAssemblerItem_Sys): Integer;
begin
Result := IndexOfSys(Item.Identifier);
If Result < 0 then
  begin
    If fSystemValues.Count >= Length(fSystemValues.Arr) then
      SetLength(fSystemValues.Arr,Length(fSystemValues.Arr) + 8);
    Item.Counter := 0;
    fSystemValues.Arr[fSystemValues.Count] := Item;
    Result := fSystemValues.Count;
    Inc(fSystemValues.Count);
  end
else
  begin
    Inc(fSystemValues.Arr[Result].Counter);
    fSystemValues.Arr[Result].Value := Item.Value;
    fSystemValues.Arr[Result].SrcLineIdx := Item.SrcLineIdx;
  end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddConst(Item: TSVCAssemblerItem_Const): Integer;
begin
If fConstants.Count >= Length(fConstants.Arr) then
  SetLength(fConstants.Arr,Length(fConstants.Arr) + 8);
fConstants.Arr[fConstants.Count] := Item;
Result := fConstants.Count;
Inc(fConstants.Count);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddVar(Item: TSVCAssemblerItem_Var): Integer;
begin
If fVariables.Count >= Length(fVariables.Arr) then
  SetLength(fVariables.Arr,Length(fVariables.Arr) + 8);
fVariables.Arr[fVariables.Count] := Item;
Result := fVariables.Count;
Inc(fVariables.Count);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddLabel(Item: TSVCAssemblerItem_Label): Integer;
begin
If fLabels.Count >= Length(fLabels.Arr) then
  SetLength(fLabels.Arr,Length(fLabels.Arr) + 8);
fLabels.Arr[fLabels.Count] := Item;
Result := fLabels.Count;
Inc(fLabels.Count);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddUnresolved(const Identifier: String; SrcLineIdx, SrcLinePos: Integer): Integer;
begin
Result := IndexOfUnresolved(Identifier);
If Result < 0 then
  begin
    If fUnresolved.Count >= Length(fUnresolved.Arr) then
      SetLength(fUnresolved.Arr,Length(fUnresolved.Arr) + 8);
    fUnresolved.Arr[fUnresolved.Count].Identifier := Identifier;
    fUnresolved.Arr[fUnresolved.Count].Count := 1;
    fUnresolved.Arr[fUnresolved.Count].SrcLineIdx := SrcLineIdx;
    fUnresolved.Arr[fUnresolved.Count].SrcLinePos := SrcLinePos;
    Result := fUnresolved.Count;
    Inc(fUnresolved.Count);
  end
else Inc(fUnresolved.Arr[Result].Count);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.RemoveUnresolved(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := IndexOfUnresolved(Identifier);
If Result >= 0 then
  begin
    Dec(fUnresolved.Arr[Result].Count);
    If fUnresolved.Arr[Result].Count <= 0 then
      begin
        For i := Succ(Result) to Pred(fUnresolved.Count) do
          fUnresolved.Arr[i - 1] := fUnresolved.Arr[i];
        Dec(fUnresolved.Count);
      end;
  end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddAssemblerLine(Item: TSVCAssemblerLine): Integer;
begin
If Length(fAssemblerLines.Arr) <= 0 then
  SetLength(fAssemblerLines.Arr,256);
If fAssemblerLines.Count >= Length(fAssemblerLines.Arr) then
  SetLength(fAssemblerLines.Arr,Length(fAssemblerLines.Arr) * 2);
fAssemblerLines.Arr[fAssemblerLines.Count] := Item;
Result := fAssemblerLines.Count;
Inc(fAssemblerLines.Count);
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.AssignSysToConst(const Identifier: String; Value: TSVCComp);
var
  Index:  Integer;
begin
// low word
Index := IndexOfConst(Identifier + SVC_ASM_ASSEMBLER_LOWORD_SUFFIX);
If Index >= 0 then
  begin
    fConstants.Arr[Index].Value := TSVCNative(Value);
    fConstants.Arr[Index].Size := vsNative;
    fConstants.Arr[Index].SrcLineIdx := fParsedLineIdx;
  end
else raise ESVCAssemblerError.CreateFmt('System value %s does not have matching lo-word constant',[AnsiUpperCase(Identifier)]);
// high word
Index := IndexOfConst(Identifier + SVC_ASM_ASSEMBLER_HIWORD_SUFFIX);
If Index >= 0 then
  begin
    fConstants.Arr[Index].Value := TSVCNative(Value shr 16);
    fConstants.Arr[Index].Size := vsNative;
    fConstants.Arr[Index].SrcLineIdx := fParsedLineIdx;
  end
else raise ESVCAssemblerError.CreateFmt('System value %s does not have matching hi-word constant',[AnsiUpperCase(Identifier)]);
end;

//------------------------------------------------------------------------------

class Function TSVCAssembler.BuildAssemblerMessage(MessageType: TSVCParserMessageType; Text: String; LineIdx,Position: Integer): TSVCAssemblerMessage;
begin
Result.MessageType := MessageType;
Result.Text := Text;
Result.LineIdx := LineIdx;
Result.Position := Position;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddAssemblerMessage(Item: TSVCAssemblerMessage): Integer;
begin
If Length(fAssemblerMessages.Arr) <= 0 then
  SetLength(fAssemblerMessages.Arr,128);
If fAssemblerMessages.Count >= Length(fAssemblerMessages.Arr) then
  SetLength(fAssemblerMessages.Arr,Length(fAssemblerMessages.Arr) * 2);
fAssemblerMessages.Arr[fAssemblerMessages.Count] := Item;
Result := fAssemblerMessages.Count;
Inc(fAssemblerMessages.Count);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddWarningMessage(const Text: String; Values: array of const): Integer;
var
  TempMsg:  TSVCAssemblerMessage;
begin
TempMsg.MessageType := pmtWarning;
TempMsg.Text := Format(Text,Values);
TempMsg.LineIdx := fParsedLineIdx;
TempMsg.Position := fParsedLinePos;
Result := AddAssemblerMessage(TempMsg);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddWarningMessage(const Text: String): Integer;
begin
Result := AddWarningMessage(Text,[]);
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.LoadDefaultSystemValues;
var
  i:  Integer;
begin
For i := Low(SVC_PROGRAM_DEFAULTSYSVALS) to High(SVC_PROGRAM_DEFAULTSYSVALS) do
  AddDefaultSys(SVC_PROGRAM_DEFAULTSYSVALS[i].Identifier,SVC_PROGRAM_DEFAULTSYSVALS[i].Value);
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.LoadPredefinedConstants;
var
  i:    Integer;
  Temp: TSVCAssemblerItem_Const;
begin
Temp.Size := vsNative;
Temp.SrcLineIdx := -1;
For i := 0 to Pred(fLists.PredefinedConstantCount) do
  begin
    Temp.Identifier := fLists.PredefinedConstants[i].Identifier;
    Temp.Value := fLists.PredefinedConstants[i].Value;
    AddConst(Temp);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.SortMessages;

  procedure Exchange(Idx1,Idx2: Integer);
  var
    Temp: TSVCAssemblerMessage;
  begin
    If Idx1 <> Idx2 then
      begin
        Temp := fAssemblerMessages.Arr[Idx1];
        fAssemblerMessages.Arr[Idx1] := fAssemblerMessages.Arr[Idx2];
        fAssemblerMessages.Arr[Idx2] := Temp;
      end;
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Function CompareItems(Idx1,Idx2: Integer): Integer;
  begin
    Result := (fAssemblerMessages.Arr[Idx1].LineIdx - fAssemblerMessages.Arr[Idx2].LineIdx) * 10;
    If fAssemblerMessages.Arr[Idx1].Position > fAssemblerMessages.Arr[Idx2].Position then
      Dec(Result)
    else
      Inc(Result);
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  procedure QuickSort(LeftIdx,RightIdx: Integer);
  var
    Idx,i:  Integer;
  begin
    If LeftIdx < RightIdx then
      begin
        Exchange((LeftIdx + RightIdx) shr 1,RightIdx);
        Idx := LeftIdx;
        For i := LeftIdx to Pred(RightIdx) do
          If CompareItems(RightIdx,i) > 0 then
            begin
              Exchange(i,idx);
              Inc(Idx);
            end;
        Exchange(Idx,RightIdx);
        QuickSort(LeftIdx,Idx - 1);
        QuickSort(Idx + 1,RightIdx);
      end;
  end;

begin
If fAssemblerMessages.Count > 1 then
  QuickSort(0,Pred(fAssemblerMessages.Count))
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.CountMessages;
var
  i:  Integer;
begin
For i := Ord(Low(fAssemblerMessages.Counters)) to Ord(High(fAssemblerMessages.Counters)) do
  fAssemblerMessages.Counters[TSVCParserMessageType(i)] := 0;
For i := Low(fAssemblerMessages.Arr) to Pred(fAssemblerMessages.Count) do
  Inc(fAssemblerMessages.Counters[fAssemblerMessages.Arr[i].MessageType]);
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.FinalizeVariables;
var
  CurrAddr: TSVCComp;
  i:        Integer;
  Index:    Integer;
  Temp:     TSVCAssemblerItem_Const;
begin
If fVariables.Count > 0 then
  begin
    fParsedLineIdx := -1;
    fParsedLinePos := 0;
    If fMemTaken <= TMemSize(High(TSVCNative) + 1) then
      begin
        // get address of first variable (lowest address)
        CurrAddr := TSVCComp(fMemTaken);
        try
          // resolve addresses...
          For i := Low(fVariables.Arr) to Pred(fVariables.Count) do
            begin
              fParsedLineIdx := fVariables.Arr[i].SrcLineIdx; // for possible exception
              If fVariables.Arr[i].Referencing then
                begin
                  // variable overlap another one
                  Index := IndexOfVar(fVariables.Arr[i].ReferenceIdentifier);
                  fParsedLinePos := fVariables.Arr[i].ReferenceIdentifierPos;
                  If (Index >= 0) and (Index < i) then
                    begin
                      fParsedLinePos := 0;
                      If TSVCComp(fVariables.Arr[Index].Address) + TSVCComp(fVariables.Arr[i].ReferenceOffset) <= TSVCComp(High(TSVCNative)) then
                        begin
                          fVariables.Arr[i].Address := TSVCNative(TSVCComp(fVariables.Arr[Index].Address) + TSVCComp(fVariables.Arr[i].ReferenceOffset));
                          If (TSVCComp(fVariables.Arr[i].Address) + TSVCComp(fVariables.Arr[i].Size)) <= (TSVCComp(High(TSVCNative)) + 1) then
                            begin
                              If (TSVCComp(fVariables.Arr[i].Address) + TSVCComp(fVariables.Arr[i].Size)) > CurrAddr then
                                CurrAddr := TSVCComp(fVariables.Arr[i].Address) + TSVCComp(fVariables.Arr[i].Size);
                            end
                          else raise ESVCAssemblerError.CreateFmt('Variable "%s" cannot fit into memory',[fVariables.Arr[i].Identifier]);
                        end
                      else raise ESVCAssemblerError.Create('Reference address outside of a valid memory space');
                    end
                  else raise ESVCAssemblerError.CreateFmt('Undeclared identifier "%s"',[fVariables.Arr[i].ReferenceIdentifier]);
                end
              else
                begin
                  // variable do NOT overlap another one
                  If (CurrAddr + TSVCComp(fVariables.Arr[i].Size)) <= (TSVCComp(High(TSVCNative)) + 1) then
                    begin
                      fVariables.Arr[i].Address := TSVCNative(CurrAddr);
                      CurrAddr := CurrAddr + TSVCComp(fVariables.Arr[i].Size);
                    end
                  else raise ESVCAssemblerError.CreateFmt('Variable "%s" cannot fit into memory',[fVariables.Arr[i].Identifier]);
                end;
              Temp.Identifier := fVariables.Arr[i].Identifier;
              Temp.Value := fVariables.Arr[i].Address;
              Temp.Size := vsNative;
              Temp.SrcLineIdx := fVariables.Arr[i].SrcLineIdx;
              AddConst(Temp);
            end;
        finally
          fMemTaken := CurrAddr;
        end;
      end
    // line index should be at the end by this point
    else raise ESVCAssemblerError.Create('No memory available for variables');
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.FinalizeSystemValues;
var
  Index:      Integer;
  StackSize:  TSVCComp;
  MemSize:    TSVCComp;

begin
fParsedLinePos := 0;
// check stack size
Index := CheckedIndexOfSys(SVC_PROGRAM_SYSVALNAME_STACKSIZE);
fParsedLineIdx := fSystemValues.Arr[Index].SrcLineIdx;
If fSystemValues.Arr[Index].Value >= TSVCComp(High(TSVCNative) + 1) then
  raise ESVCAssemblerError.Create('Stack cannot fit into available memory')
else
  StackSize := fSystemValues.Arr[Index].Value;
// check and rectify NVmem size
Index := CheckedIndexOfSys(SVC_PROGRAM_SYSVALNAME_NVMEMSIZE);
fParsedLineIdx := fSystemValues.Arr[Index].SrcLineIdx;
If fSystemValues.Arr[Index].Value <= TSVCComp(High(TSVCNative) + 1) then
  fSystemValues.Arr[Index].Value := (fSystemValues.Arr[Index].Value + 255) and not TSVCComp($FF)
else
  raise ESVCAssemblerError.Create('Size of non-volatile memory is out of allowed range');
// check mem size
Index := CheckedIndexOfSys(SVC_PROGRAM_SYSVALNAME_MEMSIZE);
fParsedLineIdx := fSystemValues.Arr[Index].SrcLineIdx;
If fSystemValues.Arr[Index].Value <= TSVCComp(High(TSVCNative) + 1) then
  begin
    If fSystemValues.Arr[Index].Value <= 0 then
      fSystemValues.Arr[Index].Value := 256
    else
      fSystemValues.Arr[Index].Value := (fSystemValues.Arr[Index].Value + $FF) and not TSVCComp($FF);
  end
else raise ESVCAssemblerError.Create('Size of allocated memory is out of allowed range');
MemSize := fSystemValues.Arr[Index].Value;
// rectify memory size
fParsedLineIdx := -1;
If (TSVCComp(fMemTaken) + StackSize) > MemSize then
  MemSize := (TSVCComp(fMemTaken) + StackSize + $FF) and not TSVCComp($FF);
If MemSize > TSVCComp(High(TSVCNative) + 1) then
  raise ESVCAssemblerError.Create('Program cannot fit into available memory');
fSystemValues.Arr[Index].Value := MemSize;
AssignSysToConst(SVC_PROGRAM_SYSVALNAME_MEMSIZE,MemSize);
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.FinalizeReplacements;
var
  i,j:    Integer;
  Index:  Integer;
  Value:  TSVCComp;
begin
For i := Low(fAssemblerLines.Arr) to Pred(fAssemblerLines.Count) do
  If fAssemblerLines.Arr[i].LineType in [altInstr,altData] then
    For j := Low(fAssemblerLines.Arr[i].Instruction.Replacements) to
             High(fAssemblerLines.Arr[i].Instruction.Replacements) do
      with fAssemblerLines.Arr[i].Instruction.Replacements[j] do
        begin
          // prepare for possible exception
          fParsedLine := fAssemblerLines.Arr[i].Str;
          fParsedLineIdx := fAssemblerLines.Arr[i].SrcLineIdx;
          fParsedLinePos := LinePos;
          If IsLabel then
            begin
              // replacement is a label, true value needs to be calculated
              Index := IndexOfLabel(Identifier);
              If Index >= 0 then
                begin
                  Value := TSVCComp(fLabels.Arr[Index].Address) -
                          (TSVCComp(fAssemblerLines.Arr[i].Instruction.Address) +
                           Length(fAssemblerLines.Arr[i].Instruction.Data));
                  case ValType of
                    iatREL8:  If not fParser.CheckRange(Value,vsByte) then
                                AddWarningMessage('Memory offset out of allowed range for label "%s"',[Identifier]);
                    iatREL16: If not fParser.CheckRange(Value,vsWord) then
                                AddWarningMessage('Memory offset out of allowed range for label "%s"',[Identifier]);
                  else
                    raise ESVCAssemblerError.CreateFmt('Invalid value type for label "%s"',[Identifier]);
                  end;
                end
              else raise ESVCAssemblerError.CreateFmt('Undeclared label "%s"',[Identifier]);
            end
          else
            begin
              // replacement is a constant or address of variable
              Index := IndexOfConst(Identifier);
              If Index >= 0 then
                begin
                  If IndexOfVar(Identifier) >= 0 then
                    begin
                      // replacement is an address of variable (value is taken from constant of the same name)
                      Value := TSVCComp(TSVCSNative(fConstants.Arr[Index].Value));
                      case ValType of
                        iatREL8:  begin
                                    AddAssemblerMessage(BuildAssemblerMessage(pmtHint,
                                      'Assigning address of a variable into relative offset',fParsedLineIdx,fParsedLinePos));
                                    If not fParser.CheckRange(Value,vsByte) then
                                      AddWarningMessage('Address of variable "%s" out of alloved range for this argument',[Identifier]);
                                  end;
                        iatIMM8:  If not fParser.CheckRange(Value,vsByte) then
                                    AddWarningMessage('Address of variable "%s" out of alloved range for this argument',[Identifier]);
                        iatREL16: begin
                                    AddAssemblerMessage(BuildAssemblerMessage(pmtHint,
                                      'Assigning address of a variable into relative offset',fParsedLineIdx,fParsedLinePos));
                                    If not fParser.CheckRange(Value,vsWord) then
                                      AddWarningMessage('Address of variable "%s" out of alloved range for this argument',[Identifier]);
                                  end;
                        iatIMM16: If not fParser.CheckRange(Value,vsWord) then
                                    AddWarningMessage('Address of variable "%s" out of alloved range for this argument',[Identifier]);
                      else
                        raise ESVCAssemblerError.CreateFmt('Invalid value type for replacement "%s"',[Identifier]);
                      end;
                    end
                  else
                    begin
                      // replacement is a constant
                      Value := TSVCComp(TSVCSNative(fConstants.Arr[Index].Value));
                      case ValType of
                        iatREL8,
                        iatIMM8:  If not fParser.CheckRange(Value,vsByte) then
                                    AddWarningMessage('Value of constant "%s" out of alloved range for this argument',[Identifier]);
                        iatREL16,
                        iatIMM16: If not fParser.CheckRange(Value,vsWord) then
                                    AddWarningMessage('Value of constant "%s" out of alloved range for this argument',[Identifier]);
                      else
                        raise ESVCAssemblerError.CreateFmt('Invalid value type for replacement "%s"',[Identifier]);
                      end;
                    end;
                end
              else raise ESVCAssemblerError.CreateFmt('Undeclared identifier "%s"',[Identifier]);
            end; {If IsLabel then - else - end}
          // store value of replacement into the code
          If ValType in [iatREL8,iatIMM8] then
            begin
              If Position <= High(fAssemblerLines.Arr[i].Instruction.Data) then
                fAssemblerLines.Arr[i].Instruction.Data[Position] := TSVCByte(Value)
              else
                raise ESVCAssemblerError.CreateFmt('Replacement for identifier "%s" cannot fit into code stream',[Identifier]);
            end
          else If ValType in [iatREL16,iatIMM16] then
            begin
              If Position < High(fAssemblerLines.Arr[i].Instruction.Data) then
                begin
                  fAssemblerLines.Arr[i].Instruction.Data[Position] := TSVCBYte(Value);
                  fAssemblerLines.Arr[i].Instruction.Data[Position + 1] := TSVCBYte(Value shr 8);
                end
              else raise ESVCAssemblerError.CreateFmt('Replacement for identifier "%s" cannot fit into code stream',[Identifier]);
            end
          else raise ESVCAssemblerError.CreateFmt('Invalid argument type for replacement "%s"',[Identifier]);
          // remove replacement from unresolved
          RemoveUnresolved(Identifier);
        end;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.ParsingResultHandler(Sender: TObject; ResultType: TSVCParserResultType; Result: Pointer);
var
  i:          Integer;
  TempConst:  TSVCAssemblerItem_Const;
  TempVar:    TSVCAssemblerItem_Var;
  TempLabel:  TSVCAssemblerItem_Label;
  TempLine:   TSVCAssemblerLine;
begin
fParsedLinePos := 0;
// initialize temporary storage for assembler line
TempLine.Str := fParsedLine;
TempLine.SrcLineIdx := fParsedLineIdx;
TempLine.LineType := altOther;
TempLine.Instruction.Address := 0;
SetLength(TempLine.Instruction.Data,0);
SetLength(TempLine.Instruction.Replacements,0);
case ResultType of
  prtNone:;       // no valid result, do nothing
  prtSys:   begin // system value
              i := IndexOfSys(PSVCParserResult_Sys(Result)^.Identifier);
              fParsedLinePos := PSVCParserResult_Sys(Result)^.IdentifierPos;
              If i >= 0 then
                begin
                  If fSystemValues.Arr[i].Counter > 0 then
                    AddWarningMessage('System value %s already assigned',[AnsiUpperCase(fSystemValues.Arr[i].Identifier)]);
                  fSystemValues.Arr[i].Value := PSVCParserResult_Sys(Result)^.Value;
                  Inc(fSystemValues.Arr[i].Counter);
                  fSystemValues.Arr[i].SrcLineIdx := fParsedLineIdx;
                  // assign value to appropriate constant
                  AssignSysToConst(fSystemValues.Arr[i].Identifier,fSystemValues.Arr[i].Value);
                end
              else raise ESVCAssemblerError.CreateFmt('Unknown system value %s',[AnsiUpperCase(PSVCParserResult_Sys(Result)^.Identifier)]);
              TempLine.LineType := altSys;
              AddAssemblerLine(TempLine);
            end;
  prtConst: begin // constant
              fParsedLinePos := PSVCParserResult_Const(Result)^.IdentifierPos;
              If (IndexOfConst(PSVCParserResult_Const(Result)^.Identifier) < 0) and (IndexOfVar(PSVCParserResult_Const(Result)^.Identifier) < 0) then
                begin
                  TempConst.Identifier := PSVCParserResult_Const(Result)^.Identifier;
                  TempConst.Value := PSVCParserResult_Const(Result)^.Value;
                  TempConst.Size := PSVCParserResult_Const(Result)^.Size;
                  TempConst.SrcLineIdx := fParsedLineIdx;
                  AddConst(TempConst);
                  TempLine.LineType := altConst;
                  AddAssemblerLine(TempLine);
                end
              else raise ESVCAssemblerError.CreateFmt('Identifier "%s" redeclared',[PSVCParserResult_Const(Result)^.Identifier]);
            end;
  prtVar:   begin // variable
              fParsedLinePos := PSVCParserResult_Var(Result)^.IdentifierPos;
              If (IndexOfConst(PSVCParserResult_Var(Result)^.Identifier) < 0) and (IndexOfVar(PSVCParserResult_Var(Result)^.Identifier) < 0) then
                begin
                  TempVar.Identifier := PSVCParserResult_Var(Result)^.Identifier;
                  TempVar.Size := PSVCParserResult_Var(Result)^.Size;
                  TempVar.Data := PSVCParserResult_Var(Result)^.Data;
                  TempVar.Referencing := PSVCParserResult_Var(Result)^.Referencing;
                  TempVar.ReferenceIdentifier := PSVCParserResult_Var(Result)^.ReferenceIdentifier;
                  TempVar.ReferenceIdentifierPos := PSVCParserResult_Var(Result)^.ReferenceIdentifierPos;
                  TempVar.ReferenceOffset := PSVCParserResult_Var(Result)^.ReferenceOffset;
                  TempVar.Address := 0;
                  TempVar.SrcLineIdx := fParsedLineIdx;
                  AddVar(TempVar);
                  TempLine.LineType := altVar;
                  AddAssemblerLine(TempLine);
                end
              else raise ESVCAssemblerError.CreateFmt('Identifier "%s" redeclared',[PSVCParserResult_Var(Result)^.Identifier]);
            end;
  prtLabel: begin // label
              fParsedLinePos := PSVCParserResult_Label(Result)^.IdentifierPos;
              If IndexOfLabel(PSVCParserResult_Label(Result)^.Identifier) < 0 then
                begin
                  TempLabel.Identifier := PSVCParserResult_Label(Result)^.Identifier;
                  TempLabel.Address := TSVCNative(fCodeSize);
                  AddLabel(TempLabel);
                  TempLine.LineType := altLabel;
                  AddAssemblerLine(TempLine);
                end
              else raise ESVCAssemblerError.CreateFmt('Label "%s" already declared elsewhere',[PSVCParserResult_Label(Result)^.Identifier]);
            end;
  prtData:  begin // data
              TempLine.LineType := altData;
              TempLine.SrcLineIdx := fParsedLineIdx;
              TempLine.Instruction.Address := TSVCNative(fCodeSize);
              TempLine.Instruction.Data := PSVCParserResult_Data(Result)^.Data;
              If (fCodeSize + TMemSize(Length(TempLine.Instruction.Data))) <= (TMemSize(High(TSVCNative)) + 1) then
                begin
                  AddAssemblerLine(TempLine);
                  fCodeSize := fCodeSize + TMemSize(Length(TempLine.Instruction.Data));
                end
              else raise ESVCAssemblerError.Create('Program cannot fit into available memory');
            end;
  prtInstr: begin // instruction
              TempLine.LineType := altInstr;
              TempLine.Instruction.Address := TSVCNative(fCodeSize);
              fParsedLinePos := PSVCParserResult_Instr(Result)^.InstructionPos;
              If (PSVCParserResult_Instr(Result)^.Window.Position > Length(PSVCParserResult_Instr(Result)^.Window.Data)) or
                 (PSVCParserResult_Instr(Result)^.Window.Position < 0) then
                raise ESVCAssemblerError.CreateFmt('Invalid instruction window size (%d)',[PSVCParserResult_Instr(Result)^.Window.Position]);
              SetLength(TempLine.Instruction.Data,PSVCParserResult_Instr(Result)^.Window.Position);
              fParsedLinePos := 0;
              If (fCodeSize + TMemSize(Length(TempLine.Instruction.Data))) <= (TMemSize(High(TSVCNative)) + 1) then
                begin
                  // copy instruction data
                  For i := Low(TempLine.Instruction.Data) to High(TempLine.Instruction.Data) do
                    TempLine.Instruction.Data[i] := PSVCParserResult_Instr(Result)^.Window.Data[i];
                  // copy replacements and add to unresolved replacements
                  SetLength(TempLine.Instruction.Replacements,Length(PSVCParserResult_Instr(Result)^.Replacements));
                  For i := Low(TempLine.Instruction.Replacements) to High(TempLine.Instruction.Replacements) do
                    begin
                      TempLine.Instruction.Replacements[i] := PSVCParserResult_Instr(Result)^.Replacements[i];
                      AddUnresolved(PSVCParserResult_Instr(Result)^.Replacements[i].Identifier,fParsedLineIdx,
                                    PSVCParserResult_Instr(Result)^.Replacements[i].LinePos);
                    end;
                  AddAssemblerLine(TempLine);
                  fCodeSize := fCodeSize + TMemSize(Length(TempLine.Instruction.Data));
                end
              else raise ESVCAssemblerError.Create('Program cannot fit into available memory');
            end;
else
  raise Exception.CreateFmt('TSVCAssembler.ParsingResultHandler: Unknown result type (%d).',[Ord(ResultType)]);
end;
end;

//==============================================================================

constructor TSVCAssembler.Create;
begin
inherited Create;
fLists := TSVCListManager.Create;
fLists.LoadFromResource(SVC_ASM_LISTS_DEFAULTRESOURCENAME);
fParser := TSVCParser.Create(fLists);
fParser.OnResult := ParsingResultHandler;
end;

//------------------------------------------------------------------------------

destructor TSVCAssembler.Destroy;
begin
Clear(True);
fParser.Free;
fLists.Free;
inherited;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.Clear(FreeMem: Boolean = False);
begin
fSystemValues.Count := 0;
fConstants.Count := 0;
fVariables.Count := 0;
fLabels.Count := 0;
fUnresolved.Count := 0;
fAssemblerLines.Count := 0;
fAssemblerMessages.Count := 0;
If FreeMem then
  begin
    SetLength(fSystemValues.Arr,0);
    SetLength(fConstants.Arr,0);
    SetLength(fVariables.Arr,0);
    SetLength(fLabels.Arr,0);
    SetLength(fUnresolved.Arr,0);
    SetLength(fAssemblerLines.Arr,0);
    SetLength(fAssemblerMessages.Arr,0);
  end;
CountMessages;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.AssembleInit;
begin
Clear;
fParser.Initialize;
fParsedLine := '';
fParsedLineIdx := -1;
fCodeSize := 0;
fMemTaken := 0;
LoadDefaultSystemValues;
LoadPredefinedConstants;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AssembleUpdate(const Line: String): Boolean;
var
  i:  Integer;
begin
fParsedLine := Line;
Inc(fParsedLineIdx);
try
  Result := fParser.Parse(fParsedLine);
  For i := 0 to Pred(fParser.Count) do
    with fParser.Messages[i] do
      AddAssemblerMessage(BuildAssemblerMessage(MessageType,Text,fParsedLineIdx,Position));
except
  on E: ESVCAssemblerError do
    begin
      AddAssemblerMessage(BuildAssemblerMessage(pmtError,E.Message,fParsedLineIdx,fParsedLinePos));
      Result := False;
    end
  else raise;
end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AssembleFinal: Boolean;
var
  i:  Integer;
begin
try
  fMemTaken := fCodeSize;
  FinalizeVariables;
  FinalizeSystemValues;
  FinalizeReplacements;
  // check if all replacements has been resolved
  If fUnresolved.Count > 0 then
    begin
      For i := Low(fUnresolved.Arr) to Pred(fUnresolved.Count) do
        AddAssemblerMessage(BuildAssemblerMessage(pmtError,
          Format('Unresolved identifier "%s"',[fUnresolved.Arr[i].Identifier]),
          fUnresolved.Arr[i].SrcLineIdx,fUnresolved.Arr[i].SrcLinePos));
    end;
  CountMessages;
  Result := AssemblerMessageTypeCounts[pmtError] <= 0;  
except
  on E: ESVCAssemblerError do
    begin
      AddAssemblerMessage(BuildAssemblerMessage(pmtError,E.Message,fParsedLineIdx,fParsedLinePos));
      CountMessages;
      Result := False;
    end
  else raise;
end;
SortMessages;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.Assemble(const SourceCode: TStrings; MaxErrorCount: Integer = -1): Boolean;
var
  i:        Integer;
  ErrCount: Integer;
begin
ErrCount := 0;
Result := True;
AssembleInit;
For i := 0 to Pred(SourceCode.Count) do
  begin
    If not AssembleUpdate(SourceCode[i]) then
      Inc(ErrCount);
    If ErrCount > 0 then
      If (MaxErrorCount >= 0) and (ErrCount >= MaxErrorCount) then
        begin
          Result := False;
          Break{For i};
        end;
  end;
If not Result then
  begin
    CountMessages;
    SortMessages;
  end
else Result := AssembleFinal;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.BuildProgram: TSVCProgram;
var
  Index,i:  Integer;
  TempPtr:  PBYte;
begin
Result := TSVCProgram.Create;
try
  // store program code
  Result.ProgramSize := fCodeSize;                    // this will also allocate memory
  FillChar(Result.ProgramData^,Result.ProgramSize,0); // make sure the memory is empty
  TempPtr := PBYte(Result.ProgramData);
  For Index := Low(fAssemblerLines.Arr) to Pred(fAssemblerLines.Count) do
    with fAssemblerLines.Arr[Index] do
      If (LineType in [altData,altInstr]) and (Length(Instruction.Data) > 0) then
        For i := Low(Instruction.Data) to High(Instruction.Data) do
          If {%H-}PtrUInt(TempPtr) < {%H-}PtrUInt(Result.ProgramData) + PtrUInt(Result.ProgramSize) then
            begin
              TempPtr^ := Instruction.Data[i];
              Inc(TempPtr);
            end
          else raise Exception.Create('Program cannot fit into allocated memory');
  // store variable inits
  For Index := Low(fVariables.Arr) to Pred(fVariables.Count) do
    Result.AddVariableInit(fVariables.Arr[Index].Address,fVariables.Arr[Index].Data);
  // set system values
  Index := CheckedIndexOfSys(SVC_PROGRAM_SYSVALNAME_STACKSIZE);
  Result.StackSize := TMemSize(fSystemValues.Arr[Index].Value);
  Index := CheckedIndexOfSys(SVC_PROGRAM_SYSVALNAME_MEMSIZE);
  Result.MemorySize := TMemSize(fSystemValues.Arr[Index].Value);
  Index := CheckedIndexOfSys(SVC_PROGRAM_SYSVALNAME_NVMEMSIZE);
  Result.NVMemorySize := TMemSize(fSystemValues.Arr[Index].Value);
except
  FreeAndNil(Result);
  raise;
end;
end;

end.
