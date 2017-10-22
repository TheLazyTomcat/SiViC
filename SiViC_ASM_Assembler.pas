unit SiViC_ASM_Assembler;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  SiViC_Common,
  SiViC_Instructions,
  SiViC_ASM_Lists,
  SiViC_ASM_Parser_Base,
  SiViC_ASM_Parser_Instr,
  SiViC_ASM_Parser;

type
  TSVCAssemblerItem_Sys = record
    Identifier: String;
    Value:      TSVCNumber;
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
    Identifier: String;
    Size:       TSVCNative;
    Data:       TSVCByteArray;
    Address:    TSVCNative;
    SrcLineIdx: Integer;
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

  TSVCAssemblerItem_Unres = record
    Identifier: String;
    Count:      Integer;
    SrcLineIdx: Integer;    
  end;

  TSVCAssemblerList_Unres = record
    Arr:    array of TSVCAssemblerItem_Unres;
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
    Arr:    array of TSVCAssemblerMessage;
    Count:  Integer;
  end;

  TSVCAssembler = class(TObject)
  private
    fLists:             TSVCListManager;
    fParser:            TSVCParser;
    fSystemValues:      TSVCAssemblerList_Sys;
    fConstants:         TSVCAssemblerList_Const;
    fVariables:         TSVCAssemblerList_Var;
    fLabels:            TSVCAssemblerList_Label;
    fUnresolved:        TSVCAssemblerList_Unres;     
    fAssemblerLines:    TSVCAssemblerLines;
    fAssemblerMessages: TSVCAssemblerMessages;
    // assembling variables
    fParsedLine:        String;
    fParsedLineIdx:     Integer;
    fCodeSize:          TMemSize;
    fMemTaken:          TMemSize;
    Function GetSys(Index: Integer): TSVCAssemblerItem_Sys;
    Function GetConst(Index: Integer): TSVCAssemblerItem_Const;
    Function GetVar(Index: Integer): TSVCAssemblerItem_Var;
    Function GetLabel(Index: Integer): TSVCAssemblerItem_Label;
    Function GetAssemblerLine(Index: Integer): TSVCAssemblerLine;
    Function GetAssemblerMessage(Index: Integer): TSVCAssemblerMessage;
  protected
    Function IndexOfSys(const Identifier: String): Integer; virtual;
    Function IndexOfConst(const Identifier: String): Integer; virtual;
    Function IndexOfVar(const Identifier: String): Integer; virtual;
    Function IndexOfLabel(const Identifier: String): Integer; virtual;
    Function IndexOfUnres(const Identifier: String): Integer; virtual;
    Function AddSys(Item: TSVCAssemblerItem_Sys): Integer; virtual;
    Function AddConst(Item: TSVCAssemblerItem_Const): Integer; virtual;
    Function AddVar(Item: TSVCAssemblerItem_Var): Integer; virtual;
    Function AddLabel(Item: TSVCAssemblerItem_Label): Integer; virtual;
    Function AddUnres(const Identifier: String; SrcLineIdx: Integer): Integer; virtual;
    Function RemoveUnres(const Identifier: String): Integer; virtual;
    Function AddAssemblerLine(Item: TSVCAssemblerLine): Integer; virtual;
    class Function BuildAssemblerMessage(MessageType: TSVCParserMessageType; Text: String; LineIdx,Position: Integer): TSVCAssemblerMessage; virtual;
    Function AddAssemblerMessage(Item: TSVCAssemblerMessage): Integer; virtual;
    Function AddWarningMessage(const Text: String; Values: array of const): Integer; overload; virtual;
    Function AddWarningMessage(const Text: String): Integer; overload; virtual;
    procedure FinalizeVariables; virtual;
    procedure FinalizeReplacements; virtual;
    procedure ParsingResultHandler(Sender: TObject; ResultType: TSVCParserResultType; Result: Pointer); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear(FreeMem: Boolean = False); virtual;    
    procedure Assemble_Init; virtual;
    Function Assemble_Update(const Line: String): Boolean; virtual;
    Function Assemble_Final: Boolean; virtual;
    Function Assemble(const SourceCode: TStrings; MaxErrorCount: Integer = -1): Boolean; virtual;
    property SystemValues[Index: Integer]: TSVCAssemblerItem_Sys read GetSys;
    property Constants[Index: Integer]: TSVCAssemblerItem_Const read GetConst;
    property Variables[Index: Integer]: TSVCAssemblerItem_Var read GetVar;
    property Labels[Index: Integer]: TSVCAssemblerItem_Label read GetLabel;
    property AssemblerLines[Index: Integer]: TSVCAssemblerLine read GetAssemblerLine; default;
    property AssemblerMessages[Index: Integer]: TSVCAssemblerMessage read GetAssemblerMessage;
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

Function TSVCAssembler.IndexOfUnres(const Identifier: String): Integer;
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

Function TSVCAssembler.AddSys(Item: TSVCAssemblerItem_Sys): Integer;
begin
Result := IndexOfSys(Item.Identifier);
If Result < 0 then
  begin
    If fSystemValues.Count >= Length(fSystemValues.Arr) then
      SetLength(fSystemValues.Arr,Length(fSystemValues.Arr) + 8);
    fSystemValues.Arr[fSystemValues.Count] := Item;
    Result := fSystemValues.Count;
    Inc(fSystemValues.Count);
  end
else fSystemValues.Arr[Result].Value := Item.Value;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddConst(Item: TSVCAssemblerItem_Const): Integer;
begin
If IndexOfVar(Item.Identifier) < 0 then
  begin
    If IndexOfConst(Item.Identifier) < 0 then
      begin
        If fConstants.Count >= Length(fConstants.Arr) then
          SetLength(fConstants.Arr,Length(fConstants.Arr) + 8);
        fConstants.Arr[fConstants.Count] := Item;
        Result := fConstants.Count;
        Inc(fConstants.Count);
      end
    else raise ESVCAssemblerError.CreateFmt('Constant "%s" already declared',[Item.Identifier]);
  end
else raise ESVCAssemblerError.CreateFmt('Redeclared identifier "%s"',[Item.Identifier]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddVar(Item: TSVCAssemblerItem_Var): Integer;
begin
If IndexOfConst(Item.Identifier) < 0 then
  begin
    If IndexOfVar(Item.Identifier) < 0 then
      begin
        If fVariables.Count >= Length(fVariables.Arr) then
          SetLength(fVariables.Arr,Length(fVariables.Arr) + 8);
        fVariables.Arr[fVariables.Count] := Item;
        Result := fVariables.Count;
        Inc(fVariables.Count);
      end
    else raise ESVCAssemblerError.CreateFmt('Variable "%s" already declared',[Item.Identifier]);
  end
else raise ESVCAssemblerError.CreateFmt('Redeclared identifier "%s"',[Item.Identifier]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddLabel(Item: TSVCAssemblerItem_Label): Integer;
begin
If IndexOfLabel(Item.Identifier) < 0 then
  begin
    If fLabels.Count >= Length(fLabels.Arr) then
      SetLength(fLabels.Arr,Length(fLabels.Arr) + 8);
    fLabels.Arr[fLabels.Count] := Item;
    Result := fLabels.Count;
    Inc(fLabels.Count);
  end
else raise ESVCAssemblerError.CreateFmt('Label "%s" already declared',[Item.Identifier]);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddUnres(const Identifier: String; SrcLineIdx: Integer): Integer;
begin
Result := IndexOfUnres(Identifier);
If Result < 0 then
  begin
    If fUnresolved.Count >= Length(fUnresolved.Arr) then
      SetLength(fUnresolved.Arr,Length(fUnresolved.Arr) + 8);
    fUnresolved.Arr[fUnresolved.Count].Identifier := Identifier;
    fUnresolved.Arr[fUnresolved.Count].Count := 1;
    fUnresolved.Arr[fUnresolved.Count].SrcLineIdx := SrcLineIdx;
    Result := fUnresolved.Count;
    Inc(fUnresolved.Count);
  end
else Inc(fUnresolved.Arr[Result].Count);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.RemoveUnres(const Identifier: String): Integer;
var
  i:  Integer;
begin
Result := IndexOfUnres(Identifier);
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
If fAssemblerLines.Count >= Length(fAssemblerLines.Arr) then
  SetLength(fAssemblerLines.Arr,Length(fAssemblerLines.Arr) + 32);
fAssemblerLines.Arr[fAssemblerLines.Count] := Item;
Result := fAssemblerLines.Count;
Inc(fAssemblerLines.Count);
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
If fAssemblerMessages.Count >= Length(fAssemblerMessages.Arr) then
  SetLength(fAssemblerMessages.Arr,Length(fAssemblerMessages.Arr) + 8);
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
TempMsg.Position := 0;
Result := AddAssemblerMessage(TempMsg);
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.AddWarningMessage(const Text: String): Integer;
begin
Result := AddWarningMessage(Text,[]);
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.FinalizeVariables;
var
  Addr: TSVCComp;
  i:    Integer;
begin
If fMemTaken <= TMemSize(High(TSVCNative)) then
  begin
    // get address of first variable (lowest address)
    Addr := TSVCComp(fMemTaken);
    try
      // resolve addresses, variables do not overlap
      For i := Low(fVariables.Arr) to Pred(fVariables.Count) do
        begin
          fParsedLineIdx := fVariables.Arr[i].SrcLineIdx; // for possible exception
          If (Addr + TSVCComp(fVariables.Arr[i].Size)) <= (TSVCComp(High(TSVCNative)) + 1) then
            begin
              fVariables.Arr[i].Address := TSVCNative(Addr);
              Addr := Addr + TSVCComp(fVariables.Arr[i].Size);
            end
          else raise ESVCAssemblerError.CreateFmt('Variable "%s" cannot fit into memory',[fVariables.Arr[i].Identifier]);
        end;
    finally
      fMemTaken := Addr;
    end;
  end
// line index should be at the end by this point  
else raise ESVCAssemblerError.Create('No memory available for variables');
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.FinalizeReplacements;
var
  i,j:    Integer;
  Index:  Integer;
  Temp:   TSVCComp;
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
          If IsLabel then
            begin
              // replacement is a label, true value needs to be calculated
              Index := IndexOfLabel(Identifier);
              If Index >= 0 then
                begin
                  Temp := TSVCComp(fLabels.Arr[Index].Address) -
                          (TSVCComp(fAssemblerLines.Arr[i].Instruction.Address) +
                           Length(fAssemblerLines.Arr[i].Instruction.Data));
                  If (((Temp > 255) or (Temp < -128)) and (ValType = iatREL8)) or
                     (((Temp > 65535) or (Temp < -32768)) and (ValType = iatREL16)) then
                    AddWarningMessage('Size mismatch for label "%s"',[Identifier]);
                end
              else raise ESVCAssemblerError.CreateFmt('Undeclared label "%s"',[Identifier]);
            end
          else
            begin
              // replacement is a constant or address of variable
              Index := IndexOfConst(Identifier);
              If Index >= 0 then
                begin
                  // replacement is a constant
                  Temp := TSVCComp(TSVCSNative(fConstants.Arr[Index].Value));
                  If ((fConstants.Arr[Index].Size = vsByte) and (ValType in [iatREL16,iatIMM16])) or
                     ((fConstants.Arr[Index].Size = vsWord) and ((ValType in [iatREL8,iatIMM8]) and
                      ((Temp > 255) or (Temp < -128)))) then
                    AddWarningMessage('Size mismatch for constant "%s"',[Identifier]);
                end
              else
                begin
                  Index := IndexOfVar(Identifier);
                  If Index >= 0 then
                    begin
                      // replacement is an address of variable
                      Temp := TSVCComp(fVariables.Arr[Index].Address);
                      If ValType <> iatIMM16 then
                        AddWarningMessage('Type mismatch for identifier "%s", expected 16bit immediate',[Identifier]);
                    end
                  else raise ESVCAssemblerError.CreateFmt('Undeclared identifier "%s"',[Identifier]);
                end;
            end; {If IsLabel then - else - end}
          // store value of replacement into code
          If ValType in [iatREL8,iatIMM8] then
            begin
              If Position <= High(fAssemblerLines.Arr[i].Instruction.Data) then
                fAssemblerLines.Arr[i].Instruction.Data[Position] := TSVCByte(Temp)
              else
                raise ESVCAssemblerError.CreateFmt('Replacement "%s" cannot fit into code stream',[Identifier]);
            end
          else If ValType in [iatREL16,iatIMM16] then
            begin
              If Position < High(fAssemblerLines.Arr[i].Instruction.Data) then
                begin
                  fAssemblerLines.Arr[i].Instruction.Data[Position] := TSVCBYte(Temp);
                  fAssemblerLines.Arr[i].Instruction.Data[Position + 1] := TSVCBYte(Temp shr 8);
                end
              else raise ESVCAssemblerError.CreateFmt('Replacement "%s" cannot fit into code stream',[Identifier]);
            end
          else raise ESVCAssemblerError.CreateFmt('Invalid argument type for replacement "%s"',[Identifier]);
          // remove replacement from unresolved
          RemoveUnres(Identifier);
        end;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.ParsingResultHandler(Sender: TObject; ResultType: TSVCParserResultType; Result: Pointer);
var
  i:          Integer;
  TempSys:    TSVCAssemblerItem_Sys;
  TempConst:  TSVCAssemblerItem_Const;
  TempVar:    TSVCAssemblerItem_Var;
  TempLabel:  TSVCAssemblerItem_Label;
  TempLine:   TSVCAssemblerLine;
begin
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
              If IndexOfSys(PSVCParserResult_Sys(Result)^.Identifier) >= 0 then
                AddWarningMessage('System value %s already assigned',[AnsiUpperCase(PSVCParserResult_Sys(Result)^.Identifier)]);
              TempSys.Identifier := PSVCParserResult_Sys(Result)^.Identifier;
              TempSys.Value := PSVCParserResult_Sys(Result)^.Value;
              TempSys.SrcLineIdx := fParsedLineIdx;
              AddSys(TempSys);
              TempLine.LineType := altSys;
              AddAssemblerLine(TempLine);
            end;
  prtConst: begin // constant
              TempConst.Identifier := PSVCParserResult_Const(Result)^.Identifier;
              TempConst.Value := PSVCParserResult_Const(Result)^.Value;
              TempConst.Size := PSVCParserResult_Const(Result)^.Size;
              TempConst.SrcLineIdx := fParsedLineIdx;
              AddConst(TempConst);
              TempLine.LineType := altConst;
              AddAssemblerLine(TempLine);
            end;
  prtVar:   begin // variable
              TempVar.Identifier := PSVCParserResult_Var(Result)^.Identifier;
              TempVar.Size := PSVCParserResult_Var(Result)^.Size;
              TempVar.Data := PSVCParserResult_Var(Result)^.Data;
              TempVar.Address := 0;
              TempVar.SrcLineIdx := fParsedLineIdx;
              AddVar(TempVar);
              TempLine.LineType := altVar;
              AddAssemblerLine(TempLine);
            end;
  prtLabel: begin // label
              TempLabel.Identifier := PSVCParserResult_Label(Result)^.Identifier;
              TempLabel.Address := TSVCNative(fCodeSize);
              TempLabel.SrcLineIdx := fParsedLineIdx;
              AddLabel(TempLabel);
              TempLine.LineType := altLabel;
              AddAssemblerLine(TempLine);
            end;
  prtData:  begin // data
              TempLine.LineType := altData;
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
              If (PSVCParserResult_Instr(Result)^.Window.Position > Length(PSVCParserResult_Instr(Result)^.Window.Data)) or
                 (PSVCParserResult_Instr(Result)^.Window.Position < 0) then
                raise ESVCAssemblerError.Create('Invalid instruction window size');
              SetLength(TempLine.Instruction.Data,PSVCParserResult_Instr(Result)^.Window.Position);
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
                      AddUnres(PSVCParserResult_Instr(Result)^.Replacements[i].Identifier,fParsedLineIdx);
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
fAssemblerLines.Count := 0;
fAssemblerMessages.Count := 0;
If FreeMem then
  begin
    SetLength(fSystemValues.Arr,0);
    SetLength(fConstants.Arr,0);
    SetLength(fVariables.Arr,0);
    SetLength(fLabels.Arr,0);
    SetLength(fAssemblerLines.Arr,0);
    SetLength(fAssemblerMessages.Arr,0);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCAssembler.Assemble_Init;
begin
Clear;
fParser.Initialize;
fParsedLine := '';
fParsedLineIdx := -1;
fCodeSize := 0;
fMemTaken := 0;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.Assemble_Update(const Line: String): Boolean;
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
      AddAssemblerMessage(BuildAssemblerMessage(pmtError,E.Message,fParsedLineIdx,0));
      Result := False;
    end
  else raise;
end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.Assemble_Final: Boolean;
var
  i:  Integer;
begin
try
  fMemTaken := fCodeSize;
  FinalizeVariables;
  FinalizeReplacements;
  // check if all replacements has been resolved
  If fUnresolved.Count > 0 then
    begin
      For i := Low(fUnresolved.Arr) to Pred(fUnresolved.Count) do
        AddAssemblerMessage(BuildAssemblerMessage(pmtError,
          Format('Unresolved identifier "%s"',[fUnresolved.Arr[i].Identifier]),
          fUnresolved.Arr[i].SrcLineIdx,0));
      Result := False;
    end
  else Result := True;
except
  on E: ESVCAssemblerError do
    begin
      AddAssemblerMessage(BuildAssemblerMessage(pmtError,E.Message,fParsedLineIdx,0));
      Result := False;
    end
  else raise;
end;
end;

//------------------------------------------------------------------------------

Function TSVCAssembler.Assemble(const SourceCode: TStrings; MaxErrorCount: Integer = -1): Boolean;
var
  i:        Integer;
  ErrCount: Integer;
begin
ErrCount := 0;
Result := True;
Assemble_Init;
For i := 0 to Pred(SourceCode.Count) do
  begin
    If not Assemble_Update(SourceCode[i]) then
      Inc(ErrCount);
    If ErrCount > 0 then
      If (MaxErrorCount >= 0) and (ErrCount >= MaxErrorCount) then
        begin
          Result := False;
          Break{For i};
        end;
  end;
If Result then
  Result := Assemble_Final;
end;


end.
