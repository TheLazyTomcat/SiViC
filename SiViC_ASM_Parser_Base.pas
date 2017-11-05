unit SiViC_ASM_Parser_Base;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SysUtils,
  SiViC_Common,
  SiViC_ASM_Lists,
  SiViC_ASM_Lexer;

const
  SVC_ASM_PARSER_CHARS_IDENTIFIERSTART = ['a'..'z','A'..'Z','_','@'];

  SVC_ASM_PARSER_CHAR_EQUALS     = '=';
  SVC_ASM_PARSER_CHAR_LBRACKET   = '(';
  SVC_ASM_PARSER_CHAR_RBRACKET   = ')';
  SVC_ASM_PARSER_CHAR_LABELSTART = '@';

type
  TSVCParserMessageType = (pmtComment,pmtHint,pmtWarning,pmtError,pmtOther);

  TSVCParserMessage = record
    MessageType:  TSVCParserMessageType;
    Text:         String;
    Position:     Integer;
  end;

  TSVCParserMessages = record
    Arr:    array of TSVCParserMessage;
    Count:  Integer;
  end;

  TSVCParserModifier  = (pmodNone,pmodByte,pmodWord,pmodLong,pmodQuad,pmodPtr);
  TSVCParserModifiers = set of TSVCParserModifier;

type
  TSVCParserModifiersItem = record
    Str:      String;
    Modifier: TSVCParserModifier;
  end;

const
  SVC_ASM_PARSER_MODIFIERS: array[0..16] of TSVCParserModifiersItem = (
    (Str: 'byte';   Modifier: pmodByte),(Str: 'short';  Modifier: pmodByte),
    (Str: 'uint8';  Modifier: pmodByte),(Str: 'int8';   Modifier: pmodByte),
    (Str: 'word';   Modifier: pmodWord),(Str: 'small';  Modifier: pmodWord),
    (Str: 'uint16'; Modifier: pmodWord),(Str: 'int16';  Modifier: pmodWord),
    (Str: 'dword';  Modifier: pmodLong),(Str: 'long';   Modifier: pmodLong),
    (Str: 'uint32'; Modifier: pmodLong),(Str: 'int32';  Modifier: pmodLong),
    (Str: 'qword';  Modifier: pmodQuad),(Str: 'quad';   Modifier: pmodQuad),
    (Str: 'uint64'; Modifier: pmodQuad),(Str: 'int64';  Modifier: pmodQuad),
    (Str: 'ptr';    Modifier: pmodPtr));

type  
  ESVCParserParsingError = class(Exception);

  TSVCParser_Base = class(TObject)
  private
    fOwnsLists:   Boolean;
    fMessages:    TSVCParserMessages;
    Function GetMessage(Index: Integer): TSVCParserMessage;
  protected
    fLists:       TSVCListManager;
    fLexer:       TSVCLexer;
    // parsing engine variables
    fTokenIndex:  Integer;
    Function AddParsingMessage(MessageType: TSVCParserMessageType; const Text: String; Values: array of const; Position: Integer = -1): Integer; overload; virtual;
    Function AddParsingMessage(MessageType: TSVCParserMessageType; const Text: String; Position: Integer = -1): Integer; overload; virtual;
    Function AddErrorMessage(const Text: String; Values: array of const; Position: Integer = -1): Integer; overload; virtual;
    Function AddErrorMessage(const Text: String; Position: Integer = -1): Integer; overload; virtual;
    Function AddWarningMessage(const Text: String; Values: array of const; Position: Integer = -1): Integer; overload; virtual;
    Function AddWarningMessage(const Text: String; Position: Integer = -1): Integer; overload; virtual;
    procedure CheckConstRangeAndIssueWarning(Value: TSVCSQuad; ValueSize: TSVCValueSize); virtual;
    procedure ParsingChangeRequest(RequestID: Integer); virtual; abstract;
    procedure InitializeParsing; virtual;
    procedure PassResult; virtual; abstract;
  public
    class Function ResolveModifier(const Str: String): TSVCParserModifier; virtual;
    class Function IsValidIdentifier(const Identifier: String): Boolean; virtual;
    class Function IsValidLabel(const Identifier: String): Boolean; virtual;
    class Function CheckRange(Value: TSVCSQuad; ValueSize: TSVCValueSize): Boolean; virtual;
    constructor Create(Lists: TSVCListManager = nil);
    destructor Destroy; override;
    procedure Initialize; virtual;
    Function Parse(const Line: String): Boolean; virtual;
    procedure Clear; virtual;
    property Messages[Index: Integer]: TSVCParserMessage read GetMessage; default;
  published
    property Count: Integer read fMessages.Count;
  end;

implementation

Function TSVCParser_Base.GetMessage(Index: Integer): TSVCParserMessage;
begin
If (Index >= Low(fMessages.Arr)) and (Index < fMessages.Count) then
  Result := fMessages.Arr[Index]
else
  raise Exception.CreateFmt('TSVCParser.GetMessage: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

Function TSVCParser_Base.AddParsingMessage(MessageType: TSVCParserMessageType; const Text: String; Values: array of const; Position: Integer = -1): Integer;
begin
If fMessages.Count >= Length(fMessages.Arr) then
  SetLength(fMessages.Arr,Length(fMessages.Arr) + 8);
fMessages.Arr[fMessages.Count].MessageType := MessageType;
fMessages.Arr[fMessages.Count].Text := Format(Text,Values);
If Position < 0 then
  begin
    If fTokenIndex < fLexer.Count then
      fMessages.Arr[fMessages.Count].Position := fLexer[fTokenIndex].Start
    else
      fMessages.Arr[fMessages.Count].Position := 0;
  end
else fMessages.Arr[fMessages.Count].Position := Position;
Result := fMessages.Count;
Inc(fMessages.Count);
If MessageType = pmtError then
  raise ESVCParserParsingError.Create('Parsing error');
end;

//------------------------------------------------------------------------------

Function TSVCParser_Base.AddParsingMessage(MessageType: TSVCParserMessageType; const Text: String; Position: Integer = -1): Integer;
begin
Result := AddParsingMessage(MessageType,text,[],Position);
end;

//------------------------------------------------------------------------------

Function TSVCParser_Base.AddErrorMessage(const Text: String; Values: array of const; Position: Integer = -1): Integer;
begin
Result := AddParsingMessage(pmtError,Text,Values,Position);
end;

//------------------------------------------------------------------------------

Function TSVCParser_Base.AddErrorMessage(const Text: String; Position: Integer = -1): Integer;
begin
Result := AddParsingMessage(pmtError,Text,[],Position);
end;

//------------------------------------------------------------------------------

Function TSVCParser_Base.AddWarningMessage(const Text: String; Values: array of const; Position: Integer = -1): Integer;
begin
Result := AddParsingMessage(pmtWarning,Text,Values,Position);
end;

//------------------------------------------------------------------------------

Function TSVCParser_Base.AddWarningMessage(const Text: String; Position: Integer = -1): Integer;
begin
Result := AddParsingMessage(pmtWarning,Text,[],Position);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Base.CheckConstRangeAndIssueWarning(Value: TSVCSQuad; ValueSize: TSVCValueSize);
begin
If not CheckRange(Value,ValueSize) then
  AddWarningMessage('Constant out of allowed range');
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Base.InitializeParsing;
begin
fTokenIndex := 0;
end;

//==============================================================================

class Function TSVCParser_Base.ResolveModifier(const Str: String): TSVCParserModifier;
var
  i:  Integer;
begin
Result := pmodNone;
For i := Low(SVC_ASM_PARSER_MODIFIERS) to High(SVC_ASM_PARSER_MODIFIERS) do
  If AnsiSameText(Str,SVC_ASM_PARSER_MODIFIERS[i].Str) then
    begin
      Result := SVC_ASM_PARSER_MODIFIERS[i].Modifier;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

class Function TSVCParser_Base.IsValidIdentifier(const Identifier: String): Boolean;
begin
If Length(Identifier) > 0 then
  Result := CharInSet(Identifier[1],SVC_ASM_PARSER_CHARS_IDENTIFIERSTART)
else
  Result := False;
end;

//------------------------------------------------------------------------------

class Function TSVCParser_Base.IsValidLabel(const Identifier: String): Boolean;
begin
If Length(Identifier) > 1 then
  Result := Identifier[1] = SVC_ASM_PARSER_CHAR_LABELSTART
else
  Result := False;
end;

//------------------------------------------------------------------------------

class Function TSVCParser_Base.CheckRange(Value: TSVCSQuad; ValueSize: TSVCValueSize): Boolean;
begin
case ValueSize of
  vsByte: Result := ((Value <= High(TSVCUByte)) and (Value >= Low(TSVCSByte)));
  vsWord: Result := ((Value <= High(TSVCUWord)) and (Value >= Low(TSVCSWord)));
  vsLong: Result := ((Value <= High(TSVCULong)) and (Value >= Low(TSVCSLong)));
  vsQuad: Result := True;
else
  raise Exception.CreateFmt('TSVCParser_Base.CheckRange: Unknown value size (%d).',[Ord(ValueSize)]);
end;
end;

//------------------------------------------------------------------------------

constructor TSVCParser_Base.Create(Lists: TSVCListManager = nil);
begin
inherited Create;
fOwnsLists := not Assigned(Lists);
fLexer := TSVCLexer.Create;
fLexer.IncludeComments := False;
If not Assigned(Lists) then
  begin
    fLists := TSVCListManager.Create;
    fLists.LoadFromResource(SVC_ASM_LISTS_DEFAULTRESOURCENAME);
  end
else fLists := Lists;
Initialize;
end;

//------------------------------------------------------------------------------

destructor TSVCParser_Base.Destroy;
begin
If fOwnsLists then
  fLists.Free;
fLexer.Free;
inherited;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Base.Initialize;
begin
fLexer.Initialize;
fTokenIndex := 0;
Clear;
end;

//------------------------------------------------------------------------------

Function TSVCParser_Base.Parse(const Line: String): Boolean;
begin
Result := True;
Clear;
fLexer.Tokenize(Line);
InitializeParsing;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Base.Clear;
begin
fMessages.Count := 0;
end;

end.
