unit SiViC_ASM_Parser_Sys;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_ASM_Parser_Base;

type
  TSVCParserData_Sys = record
    Identifier: String;
    Value:      TSVCNumber;
  end;

  TSVCParserResult_Sys = TSVCParserData_Sys;
  PSVCParserResult_Sys = ^TSVCParserResult_Sys;

  TSVCParserStage_Sys = (pssInitial,pssIdentifier,pssEquals,pssValue,pssFinal);

  TSVCParser_Sys = class(TSVCParser_Base)
  protected
    fParsingResult_Sys: TSVCParserResult_Sys;
    // parsing engine variables
    fParsingStage_Sys:  TSVCParserStage_Sys;
    fParsingData_Sys:   TSVCParserData_Sys;
    procedure InitializeParsing; override;
    // sys parsing stages
    procedure Parse_Stage_Sys_Initial; virtual;
    procedure Parse_Stage_Sys_Identifier; virtual;
    procedure Parse_Stage_Sys_Equals; virtual;
    procedure Parse_Stage_Sys_Value; virtual;
    procedure Parse_Stage_Sys_Final; virtual;
    procedure Parse_Stage_Sys; virtual;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Lexer;

procedure TSVCParser_Sys.InitializeParsing;
begin
inherited;
fParsingResult_Sys.Identifier := '';
fParsingResult_Sys.Value := 0;
fParsingStage_Sys := pssInitial;
fParsingData_Sys.Identifier := '';
fParsingData_Sys.Value := 0;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Sys.Parse_Stage_Sys_Initial;
begin
// pssInitial -> pssIdentifier
If (fLexer[fTokenIndex].TokenType = lttIdentifier) and IsValidIdentifier(fLexer[fTokenIndex].Str) then
  begin
    If not IsValidLabel(fLexer[fTokenIndex].Str) then
      begin
        If fLists.IsReservedWord(fLexer[fTokenIndex].Str) then
          AddErrorMessage('Identifier expected but reserved word %s found',[AnsiLowerCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfPrefix(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but prefix %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfRegister(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but register %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfInstruction(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but instruction %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If ResolveModifier(fLexer[fTokenIndex].Str) <> pmodNone then
          AddErrorMessage('Identifier expected but modifier %s found',[AnsiLowerCase(fLexer[fTokenIndex].Str)]);
        fParsingData_Sys.Identifier := fLexer[fTokenIndex].Str;
        fParsingStage_Sys := pssIdentifier;      
      end
    else AddErrorMessage('Identifier expected but label "%s" found',[fLexer[fTokenIndex].Str]);        
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Sys.Parse_Stage_Sys_Identifier;
begin
// pssIdentifier -> pssEquals
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_CHAR_EQUALS then
      fParsingStage_Sys := pssEquals
    else
      AddErrorMessage('"=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Sys.Parse_Stage_Sys_Equals;
var
  Num:  Integer;
begin
// pssEquals -> pssValue
If fLexer[fTokenIndex].TokenType = lttNumber then
  begin
    If TryStrToInt(fLexer[fTokenIndex].Str,Num) then
      begin
        CheckConstRangeAndIssueWarning(Num,vsNative);
        fParsingData_Sys.Value := TSVCNumber(Num);
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Sys := pssValue
        else
          fParsingStage_Sys := pssFinal;
      end
    else AddErrorMessage('Error converting "%s" to number',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Sys.Parse_Stage_Sys_Value;
begin
// not alloved
If fTokenIndex < fLexer.Count then
  AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Sys.Parse_Stage_Sys_Final;
begin
// pssFinal -> pssInitial
If fTokenIndex >= fLexer.Count then
  begin
    If fParsingStage_Sys = pssFinal then
      try
        fParsingResult_Sys := fParsingData_Sys;
        PassResult;
      finally
        fParsingStage_Sys := pssInitial;
      end
    else AddErrorMessage('Unfinished system value declaration',0);
  end
else AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Sys.Parse_Stage_Sys;
begin
case fParsingStage_Sys of
  pssInitial:     Parse_Stage_Sys_Initial;
  pssIdentifier:  Parse_Stage_Sys_Identifier;
  pssEquals:      Parse_Stage_Sys_Equals;
  pssValue:       Parse_Stage_Sys_Value;
  pssFinal:       Parse_Stage_Sys_Final;
else
  raise Exception.CreateFmt('TSVCParser_Sys.Parse_Stage_Sys: Invalid parsing stage (%d).',[Ord(fParsingStage_Sys)]);
end;
end;

end.
