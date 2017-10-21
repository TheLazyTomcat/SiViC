unit SiViC_ASM_Lists;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  Classes,
  SiViC_Common,
  SiViC_Instructions,
  SiViC_Registers;

const
  SVC_ASM_LISTS_RESERVEDWORDS: array[0..2] of String = ('sys','const','var');

  SVC_ASM_LISTS_CHAR_COMMENT    = '#';
  SVC_ASM_LISTS_CHAR_BLOCKSTART = '<';
  SVC_ASM_LISTS_CHAR_BLOCKEND   = '>';
  SVC_ASM_LISTS_CHAR_REPLACE    = '%';

  SVC_ASM_LISTS_CHAR_CC_DELIMITER        = ',';
  SVC_ASM_LISTS_CHAR_CC_SUBSTR_DELIMITER = '/';

  SVC_ASM_LISTS_CHAR_PFX_DELIMITER      = '|';
  SVC_ASM_LISTS_CHAR_PFX_MNEM_DELIMITER = ',';

  SVC_ASM_LISTS_CHAR_REG_INDICES        = '*';
  SVC_ASM_LISTS_CHAR_REG_IDX_DELIMITER  = ',';
  SVC_ASM_LISTS_CHAR_REG_DELIMITER      = '|';  
  SVC_ASM_LISTS_CHAR_REG_MNEM_DELIMITER = ',';

  SVC_ASM_LISTS_CHAR_INS_DEFAULT          = '!';
  SVC_ASM_LISTS_CHAR_INS_DELIMITER        = '|';
  SVC_ASM_LISTS_CHAR_INS_MNEM_DELIMITER   = ',';
  SVC_ASM_LISTS_CHAR_INS_OPCODE_DELIMITER = '\';
  SVC_ASM_LISTS_CHAR_INS_SFX_DELIMITER    = ',';
  SVC_ASM_LISTS_CHAR_INS_ARG_DELIMITER    = ',';

  SVC_ASM_LISTS_DEFAULTRESOURCENAME = 'ListsData';

type
  // condition code list
  TSVCListsConditionCodeListItem = record
    Str:  String;
    Code: TSVCInstructionConditionCode;
  end;

  TSVCListsConditionCodeList = record
    List:   array of TSVCListsConditionCodeListItem;
    Count:  Integer;
  end;

  // condition codes group list
  TSVCListsCondCodeGroupListItem = array of Integer;

  TSVCListsCondCodeGroupList = record
    List:   array of TSVCListsCondCodeGroupListItem;
    Count:  Integer;
  end;

  // prefix list
  TSVCListsPrefixListItem = record
    Mnemonic: String;
    Name:     String;
    Code:     TSVCInstructionPrefix;
  end;

  TSVCListsPrefixList = record
    List:   array of TSVCListsPrefixListItem;
    Count:  Integer;
  end;

  // register list
  TSVCListsRegisterListItem = record
    Name:     String;
    Index:    TSVCRegisterIndex;
    TypeNum:  TSVCNumber;
    RegType:  TSVCRegisterType;
    ID:       TSVCRegisterID;
    Implicit: Boolean;
  end;

  TSVCListsRegisterList = record
    List:   array of TSVCListsRegisterListItem;
    Count:  Integer;
  end;

  // instruction list
  TSVCListsInstructionListItem = record
    Mnemonic:   String;
    Name:       String;
    OpCode:     array of Byte;
    MemSuffix:  Boolean;
    CCSuffix:   Boolean;
    CCCode:     TSVCInstructionConditionCode;
    Arguments:  array of TSVCInstructionArgumentType;
    Default:    Boolean;
  end;

  TSVCListsInstructionList = record
    List:   array of TSVCListsInstructionListItem;
    Count:  Integer;
  end;

  TSVCListManager = class(TObject)
  private
    fConditionCodeList: TSVCListsConditionCodeList;
    fCondCodeGroupList: TSVCListsCondCodeGroupList;
    fPrefixList:        TSVCListsPrefixList;
    fRegisterList:      TSVCListsRegisterList;
    fInstructionList:   TSVCListsInstructionList;
    // variables for instruction line parsing
    fILP_Line:          TStringList;
    fILP_Mnem:          TStringList;
    fILP_Other:         TStringList;
    Function GetConditionCode(Index: Integer): TSVCListsConditionCodeListItem;
    Function GetCondCodeGroup(Index: Integer): TSVCListsCondCodeGroupListItem;
    Function GetPrefix(Index: Integer): TSVCListsPrefixListItem;
    Function GetRegister(Index: Integer): TSVCListsRegisterListItem;
    Function GetInstruction(Index: Integer): TSVCListsInstructionListItem;
  protected
    class procedure SeparateItems(const List: String; Items: TStrings; Separator: Char); virtual;
    Function AddConditionCode(const Str: String; Code: TSVCInstructionConditionCode): Integer; virtual;
    Function AddConditionCodeGroup(Group: TSVCListsCondCodeGroupListItem): Integer; virtual;
    Function AddPrefix(Item: TSVCListsPrefixListItem): Integer; virtual;
    Function AddRegister(Item: TSVCListsRegisterListItem): Integer; virtual;
    Function AddInstruction(Item: TSVCListsInstructionListItem): Integer; virtual;
    // block parsing
    Function ParseBlock_0(Strings: TStrings; FromIndex: Integer): Integer; virtual; // condition code groups
    Function ParseBlock_1(Strings: TStrings; FromIndex: Integer): Integer; virtual; // prefixes
    Function ParseBlock_2(Strings: TStrings; FromIndex: Integer): Integer; virtual; // registers
    Function ParseBlock_3(Strings: TStrings; FromIndex: Integer): Integer; virtual; // instructions
    procedure ParseBlock_3_Line(const LineStr: String); virtual;
  public
    class Function IsReservedWord(const Str: String): Boolean; virtual;
    Function IndexOfConditionCode(const Str: String): Integer; overload; virtual;
    Function IndexOfConditionCode(Code: TSVCInstructionConditionCode): Integer; overload; virtual;
    Function IndexOfPrefix(const Mnemonic: String): Integer; overload; virtual;
    Function IndexOfPrefix(Code: TSVCInstructionPrefix): Integer; overload; virtual;
    Function IndexOfRegister(const Name: String): Integer; overload; virtual;
    Function IndexOfRegister(ID: TSVCRegisterID): Integer; overload; virtual;
    Function IndexOfImplicitRegister(RegIdx: TSVCRegisterIndex): Integer; virtual;
    Function IndexOfInstruction(const Mnemonic: String; StartFrom: Integer = 0): Integer; overload; virtual;
    Function IndexOfInstruction(OpCode: array of TSVCByte; StartFrom: Integer = 0): Integer; overload; virtual;
    procedure LoadFromStrings(Strings: TStrings); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
    procedure LoadFromResource(const ResName: String); virtual;
    procedure ClearConditionCodes; virtual;
    procedure ClearConditionCodeGroups; virtual;
    procedure ClearPrefixes; virtual;
    procedure ClearRegisters; virtual;
    procedure ClearInstructions; virtual;
    procedure Clear; virtual;
    property ConditionCodes[Index: Integer]: TSVCListsConditionCodeListItem read GetConditionCode;
    property ConditionCodeGroups[Index: Integer]: TSVCListsCondCodeGroupListItem read GetCondCodeGroup;
    property Prefixes[Index: Integer]: TSVCListsPrefixListItem read GetPrefix;
    property Registers[Index: Integer]: TSVCListsRegisterListItem read GetRegister;
    property Instructions[Index: Integer]: TSVCListsInstructionListItem read GetInstruction;
  published
    property ConditionCodeCount: Integer read fConditionCodeList.Count;
    property ConditionCodeGroupCount: Integer read fCondCodeGroupList.Count;
    property PrefixCount: Integer read fPrefixList.Count;
    property RegisterCount: Integer read fRegisterList.Count;
    property InstructionCount: Integer read fInstructionList.Count;
  end;

implementation

uses
  SysUtils, StrUtils,
  StrRect, ExplicitStringLists;

{$RESOURCE '.\SiViC_ASM_Lists.res'}

Function TSVCListManager.GetConditionCode(Index: Integer): TSVCListsConditionCodeListItem;
begin
If (Index >= Low(fConditionCodeList.List)) and (Index < fConditionCodeList.Count) then
  Result := fConditionCodeList.List[Index]
else
  raise Exception.CreateFmt('TSVCListManager.GetConditionCode: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.GetCondCodeGroup(Index: Integer): TSVCListsCondCodeGroupListItem;
begin
If (Index >= Low(fCondCodeGroupList.List)) and (Index < fCondCodeGroupList.Count) then
  Result := fCondCodeGroupList.List[Index]
else
  raise Exception.CreateFmt('TSVCListManager.GetCondCodeGroup: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.GetPrefix(Index: Integer): TSVCListsPrefixListItem;
begin
If (Index >= Low(fPrefixList.List)) and (Index < fPrefixList.Count) then
  Result := fPrefixList.List[Index]
else
  raise Exception.CreateFmt('TSVCListManager.GetPrefix: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.GetRegister(Index: Integer): TSVCListsRegisterListItem;
begin
If (Index >= Low(fRegisterList.List)) and (Index < fRegisterList.Count) then
  Result := fRegisterList.List[Index]
else
  raise Exception.CreateFmt('TSVCListManager.GetRegister: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.GetInstruction(Index: Integer): TSVCListsInstructionListItem;
begin
If (Index >= Low(fInstructionList.List)) and (Index < fInstructionList.Count) then
  Result := fInstructionList.List[Index]
else
  raise Exception.CreateFmt('TSVCListManager.GetInstruction: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

class procedure TSVCListManager.SeparateItems(const List: String; Items: TStrings; Separator: Char);
var
  i,Start:  Integer;
begin
Items.Clear;
If Length(List) > 0 then
  begin
    i := 1; Start := 1;
    while i <= Length(List) do
      begin
        If List[i] = Separator then
          begin
            Items.Add(Trim(Copy(List,Start,i - Start)));
            Start := Succ(i);
          end;
        Inc(i);
      end;
    Items.Add(Trim(Copy(List,Start,Length(List) - Start + 1)));
  end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.AddConditionCode(const Str: String; Code: TSVCInstructionConditionCode): Integer;
begin
Result := IndexOfConditionCode(Str);
If Result >= 0 then
  begin
    If fConditionCodeList.List[Result].Code <> Code then
      raise Exception.CreateFmt('TSVCListManager.AddConditionCode: ' +
              'Condition mnemonic (%s) already listed with different code (%d,%d).',
              [Str,fConditionCodeList.List[Result].Code,Code]);
  end
else
  begin
    If fConditionCodeList.Count >= Length(fConditionCodeList.List) then
      SetLength(fConditionCodeList.List,Length(fConditionCodeList.List) + 8);
    fConditionCodeList.List[fConditionCodeList.Count].Str := Str;
    fConditionCodeList.List[fConditionCodeList.Count].Code := Code;
    Result := fConditionCodeList.Count;
    Inc(fConditionCodeList.Count);
  end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.AddConditionCodeGroup(Group: TSVCListsCondCodeGroupListItem): Integer;
begin
If Length(Group) > 0 then
  begin
    SetLength(fCondCodeGroupList.List,Length(fCondCodeGroupList.List) + 1);
    fCondCodeGroupList.List[fCondCodeGroupList.Count] := Group;
    Result := fCondCodeGroupList.Count;
    Inc(fCondCodeGroupList.Count);
  end
else Result := -1;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.AddPrefix(Item: TSVCListsPrefixListItem): Integer;
begin
If fPrefixList.Count >= Length(fPrefixList.List) then
  SetLength(fPrefixList.List,Length(fPrefixList.List) + 8);
fPrefixList.List[fPrefixList.Count] := Item;
Result := fPrefixList.Count;
Inc(fPrefixList.Count);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.AddRegister(Item: TSVCListsRegisterListItem): Integer;
begin
If fRegisterList.Count >= Length(fRegisterList.List) then
  SetLength(fRegisterList.List,Length(fRegisterList.List) + 16);
fRegisterList.List[fRegisterList.Count] := Item;
Result := fRegisterList.Count;
Inc(fRegisterList.Count);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.AddInstruction(Item: TSVCListsInstructionListItem): Integer;
begin
If fInstructionList.Count >= Length(fInstructionList.List) then
  SetLength(fInstructionList.List,Length(fInstructionList.List) + 128);
Item.Default := False;
If Length(Item.Mnemonic) > 1 then
  If Item.Mnemonic[1] = SVC_ASM_LISTS_CHAR_INS_DEFAULT then
    begin
      Item.Default := True;
      Item.Mnemonic := Copy(Item.Mnemonic,2,Length(Item.Mnemonic));
    end;
fInstructionList.List[fInstructionList.Count] := Item;
Result := fInstructionList.Count;
Inc(fInstructionList.Count);
end;

//------------------------------------------------------------------------------

Function TSVCListManager.ParseBlock_0(Strings: TStrings; FromIndex: Integer): Integer;
var
  i,j:          Integer;
  Codes:        TStringList;
  Strs:         TStringList;
  SubStrs:      TStringList;
  CodesLoaded:  Boolean;
  Code:         Integer;
  CCGroup:      TSVCListsCondCodeGroupListItem;
begin
Codes := TStringList.Create;
Strs := TStringList.Create;
SubStrs := TStringList.Create;
try
  Result := FromIndex;
  CodesLoaded := False;
  while Result <= Strings.Count do
    begin
      If Length(Strings[Result]) > 0 then
        case Strings[Result][1] of
          SVC_ASM_LISTS_CHAR_COMMENT:;
            // do nothing, ignore the line
          SVC_ASM_LISTS_CHAR_BLOCKSTART:
            raise Exception.CreateFmt('TSVCListManager.ParseBlock_0: ' +
                    'Nested blocks not allowed (line %d).',[Result]);
          SVC_ASM_LISTS_CHAR_BLOCKEND:
            begin
              Result := Succ(Result);
              Break{while...};
            end;
        else {case-else}
          If CodesLoaded then
            begin
              SeparateItems(Strings[Result],Strs,SVC_ASM_LISTS_CHAR_CC_DELIMITER);
              SetLength(CCGroup,0);
              If Codes.Count = Strs.Count then
                begin
                  For i := 0 to Pred(Codes.Count) do
                    If TryStrToInt(Codes[i],Code) then
                      begin
                        SeparateItems(Strs[i],SubStrs,SVC_ASM_LISTS_CHAR_CC_SUBSTR_DELIMITER);
                        For j := 0 to Pred(SubStrs.Count) do
                          begin
                            SetLength(CCGroup,Length(CCGroup) + 1);
                            CCGroup[High(CCGroup)] := AddConditionCode(SubStrs[j],TSVCInstructionConditionCode(Code));
                          end;
                      end;
                end
              else raise Exception.CreateFmt('TSVCListManager.ParseBlock_0: Counts (%d,%d) do not match.',
                                             [Codes.Count,Strs.Count]);
              AddConditionCodeGroup(CCGroup);                               
            end
          else SeparateItems(Strings[Result],Codes,SVC_ASM_LISTS_CHAR_CC_DELIMITER);
          CodesLoaded := not CodesLoaded;
        end;
      Inc(Result);
    end;
finally
  SubStrs.Free;
  Strs.Free;
  Codes.Free;
end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.ParseBlock_1(Strings: TStrings; FromIndex: Integer): Integer;
var
  i:    Integer;
  Line: TStringList;
  Mnem: TStringList;
  Temp: TSVCListsPrefixListItem;
begin
Line := TStringList.Create;
Mnem := TStringList.Create;
try
  Result := FromIndex;
  while Result <= Strings.Count do
    begin
      If Length(Strings[Result]) > 0 then
        case Strings[Result][1] of
          SVC_ASM_LISTS_CHAR_COMMENT:;
            // do nothing, ignore the line
          SVC_ASM_LISTS_CHAR_BLOCKSTART:
            raise Exception.CreateFmt('TSVCListManager.ParseBlock_1: ' +
                  'Nested blocks not allowed (line %d).',[Result]);
          SVC_ASM_LISTS_CHAR_BLOCKEND:
            begin
              Result := Succ(Result);
              Break{while...};
            end;
        else {case-else}
          SeparateItems(Strings[Result],Line,SVC_ASM_LISTS_CHAR_PFX_DELIMITER);
          If Line.Count >= 3 then
            begin
              Temp.Name := Line[0];
              Temp.Code := TSVCInstructionPrefix(StrToIntDef(Line[2],0));
              If Temp.Code >= SVC_INS_IDTHRESHOLD_PREFIX then
                begin
                  SeparateItems(Line[1],Mnem,SVC_ASM_LISTS_CHAR_PFX_MNEM_DELIMITER);
                  For i := 0 to Pred(Mnem.Count) do
                    begin
                      Temp.Mnemonic := Mnem[i];
                      AddPrefix(Temp);
                    end;
                end;
            end;
        end;
      Inc(Result);
    end;
finally
  Mnem.Free;
  Line.Free;
end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.ParseBlock_2(Strings: TStrings; FromIndex: Integer): Integer;
var
  i,j:            Integer;
  Line:           TStringList;
  Names:          TStringList;
  Idx:            Integer;
  Indices:        array of TSVCRegisterIndex;
  Temp:           TSVCListsRegisterListItem;
begin
Line := TStringList.Create;
Names := TStringList.Create;
try
  Result := FromIndex;
  SetLength(Indices,0);
  while Result <= Strings.Count do
    begin
      If Length(Strings[Result]) > 0 then
        case Strings[Result][1] of
          SVC_ASM_LISTS_CHAR_COMMENT:;
            // do nothing, ignore the line
          SVC_ASM_LISTS_CHAR_BLOCKSTART:
            raise Exception.CreateFmt('TSVCListManager.ParseBlock_2: ' +
                  'Nested blocks not allowed (line %d).',[Result]);
          SVC_ASM_LISTS_CHAR_BLOCKEND:
            begin
              Result := Succ(Result);
              Break{while...};
            end;
          SVC_ASM_LISTS_CHAR_REG_INDICES:
            begin
              // load indices of implemented GPRs
              SeparateItems(Copy(Strings[Result],2,Length(Strings[Result])),Line,SVC_ASM_LISTS_CHAR_REG_IDX_DELIMITER);
              For i := 0 to Pred(Line.Count) do
                begin
                  Idx := StrToIntDef(Line[i],-1);
                  If (Idx >= 0) and (Idx < SVC_REG_GP_COUNT) then
                    begin
                      SetLength(Indices,Length(Indices) + 1);
                      Indices[High(Indices)] := TSVCRegisterIndex(Idx);
                    end;
                end;
            end;
        else {case-else}
          // load normal line
          SeparateItems(Strings[Result],Line,SVC_ASM_LISTS_CHAR_REG_DELIMITER);
          If Line.Count >= 3 then
            begin
              SeparateItems(Line[0],Names,SVC_ASM_LISTS_CHAR_REG_MNEM_DELIMITER);
              Temp.TypeNum := StrToIntDef(Line[2],-1);
              If (Temp.TypeNum >= 0) and (Temp.TypeNum <= 3) then
                begin
                  Temp.RegType := RegisterTypeFromNumber(Temp.TypeNum);
                  If AnsiSameText(Line[1],'%') then
                    begin
                      // indexed register, make names with all of the implemented indices
                      For i := 0 to Pred(Names.Count) do
                        For j := Low(Indices) to High(Indices) do
                          begin
                            Temp.Name := AnsiReplaceText(Names[i],SVC_ASM_LISTS_CHAR_REPLACE,IntToStr(Indices[j]));
                            Temp.Index := Indices[j];
                            Temp.ID := BuildRegisterID(Temp.Index,Temp.TypeNum);
                            Temp.Implicit := False;
                            AddRegister(Temp);
                          end;
                    end
                 else
                    begin
                      // named register
                      Temp.Index := TSVCRegisterIndex(StrToIntDef(Line[1],255));
                      For i := 0 to Pred(Names.Count) do
                        begin
                          Temp.Name := Names[i];
                          Temp.ID := BuildRegisterID(Temp.Index,Temp.TypeNum);
                          Temp.Implicit := Temp.Index >= SVC_REG_GP_COUNT;
                          AddRegister(Temp);
                        end;
                    end;
                end;
            end;
        end; {case-else-end} 
      Inc(Result);
    end;
finally
  Names.Free;
  Line.Free;
end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.ParseBlock_3(Strings: TStrings; FromIndex: Integer): Integer;
begin
fILP_Line := TStringList.Create;
fILP_Mnem := TStringList.Create;
fILP_Other := TStringList.Create;
try
  Result := FromIndex;
  while Result <= Strings.Count do
    begin
      If Length(Strings[Result]) > 0 then
        case Strings[Result][1] of
          SVC_ASM_LISTS_CHAR_COMMENT:;
            // do nothing, ignore the line
          SVC_ASM_LISTS_CHAR_BLOCKSTART:
            raise Exception.CreateFmt('TSVCListManager.ParseBlock_2: ' +
                  'Nested blocks not allowed (line %d).',[Result]);
          SVC_ASM_LISTS_CHAR_BLOCKEND:
            begin
              Result := Succ(Result);
              Break{while...};
            end;
        else
          ParseBlock_3_Line(Strings[Result]);
        end;
      Inc(Result);
    end;
finally
  fILP_Other.Free;
  fILP_Mnem.Free;
  fILP_Line.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.ParseBlock_3_Line(const LineStr: String);
var
  i,j:    Integer;
  Temp:   TSVCListsInstructionListItem;
  CCGIdx: Integer;

  Function DecodeArgumentType(const Str: String): TSVCInstructionArgumentType;
  var
    ArgType:  TSVCInstructionArgumentType;
  begin
    Result := iatNone;
    For ArgType := Low(TSVCInstructionArgumentType) to High(TSVCInstructionArgumentType) do
      If AnsiSameText(SVC_INS_ARGUMENTTYPES_STRINGS[ArgType],Str) then
        begin
          Result := ArgType;
          Break{For ArgType};
        end;
  end;

begin
CCGIdx := -1;
SeparateItems(LineStr,fILP_Line,SVC_ASM_LISTS_CHAR_INS_DELIMITER);
If fILP_Line.Count >= 5 then
  begin
    Temp.Name := fILP_Line[0];
    // opcode
    SeparateItems(fILP_Line[2],fILP_Other,SVC_ASM_LISTS_CHAR_INS_OPCODE_DELIMITER);
    SetLength(Temp.OpCode,fILP_Other.Count);
    For i := 0 to Pred(fILP_Other.Count) do
      Temp.OpCode[i] := StrToIntDef(fILP_Other[i],0);
    // suffix
    SeparateItems(fILP_Line[3],fILP_Other,SVC_ASM_LISTS_CHAR_INS_SFX_DELIMITER);
    Temp.MemSuffix := fILP_Other.IndexOf('MEM') >= 0;
    Temp.CCSuffix := False;
    For i := 0 to Pred(fILP_Other.Count) do
      If AnsiStartsText('CC',fILP_Other[i]) then
        begin
          Temp.CCSuffix := True;
          CCGIdx := StrToIntDef(Copy(fILP_Other[i],3,Length(fILP_Other[i])),0);
          Break{For i};
        end;
    // arguments
    If Length(fILP_Line[4]) > 1 then
      begin
        SeparateItems(fILP_Line[4],fILP_Other,SVC_ASM_LISTS_CHAR_INS_ARG_DELIMITER);
        SetLength(Temp.Arguments,fILP_Other.Count);
        For i := 0 to Pred(fILP_Other.Count) do
          Temp.Arguments[i] := DecodeArgumentType(fILP_Other[i]);
      end
    else SetLength(Temp.Arguments,0);
    // mmemonics
    SeparateItems(fILP_Line[1],fILP_Mnem,SVC_ASM_LISTS_CHAR_INS_MNEM_DELIMITER);
    If Temp.CCSuffix and (CCGIdx >= Low(fCondCodeGroupList.List)) and (CCGIdx < fCondCodeGroupList.Count) then
      begin
        // expand mnemonics with CC group
        For i := 0 to Pred(fILP_Mnem.Count) do
          For j := Low(fCondCodeGroupList.List[CCGIdx]) to High(fCondCodeGroupList.List[CCGIdx]) do
            begin
              Temp.Mnemonic := AnsiReplaceStr(fILP_Mnem[i],SVC_ASM_LISTS_CHAR_REPLACE,
                fConditionCodeList.List[fCondCodeGroupList.List[CCGIdx][j]].Str);
              Temp.CCCode := fConditionCodeList.List[fCondCodeGroupList.List[CCGIdx][j]].Code;
              If (Length(Temp.OpCode) > 0) and (Length(Temp.OpCode) <= SVC_INS_MAXOPCODELENGTH) and
                (Length(Temp.Arguments) <= SVC_INS_MAXARGUMENTS) then
                AddInstruction(Temp);
            end;
      end
    else
      begin
        // normal instruction without CC
        For i := 0 to Pred(fILP_Mnem.Count) do
          begin
            Temp.Mnemonic := fILP_Mnem[i];
            Temp.CCCode := 0;
            If (Length(Temp.OpCode) > 0) and (Length(Temp.OpCode) <= SVC_INS_MAXOPCODELENGTH) and
              (Length(Temp.Arguments) <= SVC_INS_MAXARGUMENTS) then
              AddInstruction(Temp);
          end;
      end;
  end;
end;

//==============================================================================

class Function TSVCListManager.IsReservedWord(const Str: String): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(SVC_ASM_LISTS_RESERVEDWORDS) to High(SVC_ASM_LISTS_RESERVEDWORDS) do
  If AnsiSameText(Str,SVC_ASM_LISTS_RESERVEDWORDS[i]) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfConditionCode(const Str: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fConditionCodeList.List) to Pred(fConditionCodeList.Count) do
  If AnsiSameText(fConditionCodeList.List[i].Str,Str) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfConditionCode(Code: TSVCInstructionConditionCode): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fConditionCodeList.List) to Pred(fConditionCodeList.Count) do
  If fConditionCodeList.List[i].Code = Code then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfPrefix(const Mnemonic: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fPrefixList.List) to Pred(fPrefixList.Count) do
  If AnsiSameText(fPrefixList.List[i].Mnemonic,Mnemonic) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfPrefix(Code: TSVCInstructionPrefix): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fPrefixList.List) to Pred(fPrefixList.Count) do
  If fPrefixList.List[i].Code = Code then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfRegister(const Name: String): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fRegisterList.List) to Pred(fRegisterList.Count) do
  If AnsiSameText(fRegisterList.List[i].Name,Name) then
    begin
      Result := i;
      Break{For i};
    end;
end;
//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfRegister(ID: TSVCRegisterID): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fRegisterList.List) to Pred(fRegisterList.Count) do
  If not(fRegisterList.List[i].Implicit) and (fRegisterList.List[i].ID = ID) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfImplicitRegister(RegIdx: TSVCRegisterIndex): Integer;
var
  i:  Integer;
begin
Result := -1;
For i := Low(fRegisterList.List) to Pred(fRegisterList.Count) do
  If fRegisterList.List[i].Implicit and (fRegisterList.List[i].Index = RegIdx) then
    begin
      Result := i;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfInstruction(const Mnemonic: String; StartFrom: Integer = 0): Integer;
var
  i:  Integer;
begin
Result := -1;
If (StartFrom >= Low(fInstructionList.List)) and (StartFrom < fInstructionList.Count) then
  For i := StartFrom to Pred(fInstructionList.Count) do
    If AnsiSameText(fInstructionList.List[i].Mnemonic,Mnemonic) then
      begin
        Result := i;
        Break{For i};
      end;
end;

//------------------------------------------------------------------------------

Function TSVCListManager.IndexOfInstruction(OpCode: array of TSVCByte; StartFrom: Integer = 0): Integer;
var
  i,j:    Integer;
  Match:  Boolean;
begin
Result := -1;
If (StartFrom >= Low(fInstructionList.List)) and (StartFrom < fInstructionList.Count) then
  For i := StartFrom to Pred(fInstructionList.Count) do
    If Length(OpCode) = Length(fInstructionList.List[i].OpCode) then
      begin
        Match := True;
        For j := Low(OpCode) to High(OpCode) do
          If OpCode[j] <> fInstructionList.List[i].OpCode[j] then
            Match := False;
        If Match then
          begin
            Result := i;
            Break{For i};
          end;
      end;
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.LoadFromStrings(Strings: TStrings);
var
  i:          Integer;
  BlockType:  Integer;
begin
i := 0;
while i < Strings.Count do
  begin
    If Length(Strings[i]) > 0 then
      If Strings[i][1] = SVC_ASM_LISTS_CHAR_BLOCKSTART then
        begin
          BlockType := StrToIntDef(Trim(Copy(Strings[i],2,Length(Strings[i]))),-1);
          case BlockType of
            0:  i := ParseBlock_0(Strings,Succ(i));
            1:  i := ParseBlock_1(Strings,Succ(i));
            2:  i := ParseBlock_2(Strings,Succ(i));
            3:  i := ParseBlock_3(Strings,Succ(i));
          else
            raise Exception.CreateFmt('TSVCListManager.LoadFromStrings: Unknown block type (%d).',[BlockType]);
          end;
        end;
    Inc(i);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.LoadFromStream(Stream: TStream);
var
  AnsiStrings:  TAnsiStringList;
  Strings:      TStringList;
begin
AnsiStrings := TAnsiStringList.Create;
try
  AnsiStrings.LoadFromStream(Stream);
  Strings := TStringList.Create;
  try
    Strings.Assign(AnsiStrings);
    LoadFromStrings(Strings);
  finally
    Strings.Free;
  end;
finally
  AnsiStrings.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.LoadFromFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(StrToRTL(FileName),fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.LoadFromResource(const ResName: String);
var
  ResStream:  TResourceStream;
begin
ResStream := TResourceStream.Create(hInstance,StrToRTL(ResName),PChar(10){RT_RCDATA});
try
  LoadFromStream(ResStream);
finally
  ResStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.ClearConditionCodes;
begin
fConditionCodeList.Count := 0;
SetLength(fConditionCodeList.List,0);
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.ClearConditionCodeGroups;
begin
fCondCodeGroupList.Count := 0;
SetLength(fCondCodeGroupList.List,0);
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.ClearPrefixes;
begin
fPrefixList.Count := 0;
SetLength(fPrefixList.List,0);
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.ClearRegisters;
begin
fRegisterList.Count := 0;
SetLength(fRegisterList.List,0);
end;
 
//------------------------------------------------------------------------------

procedure TSVCListManager.ClearInstructions;
begin
fInstructionList.Count := 0;
SetLength(fInstructionList.List,0);
end;

//------------------------------------------------------------------------------

procedure TSVCListManager.Clear;
begin
ClearConditionCodeGroups;
ClearConditionCodes;
ClearPrefixes;
ClearRegisters;
ClearInstructions;
end;

end.
