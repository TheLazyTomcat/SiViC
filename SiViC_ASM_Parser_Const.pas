unit SiViC_ASM_Parser_Const;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_ASM_Parser_Sys;

type
  TSVCParserData_Const = record
    Identifier: String;
    Value:      TSVCNumber;
    Size:       TSVCValueSize;
  end;

  TSVCParserResult_Const = TSVCParserData_Const;
  PSVCParserResult_Const = ^TSVCParserResult_Const;

  TSVCParserStage_Const = (pscInitial,pscIdentifier,pscEquals,pscModifier,pscValue,pscFinal);

  TSVCParser_Const = class(TSVCParser_Sys)
  protected
    fParsingResult_Const: TSVCParserResult_Const;
    // parsing engine variables
    fParsingStage_Const:  TSVCParserStage_Const;
    fParsingData_Const:   TSVCParserData_Const;
    procedure InitializeParsing; override;
    // const parsing stages
    procedure Parse_Stage_Const_Initial; virtual;
    procedure Parse_Stage_Const_Identifier; virtual;
    procedure Parse_Stage_Const_Equals; virtual;
    procedure Parse_Stage_Const_Modifier; virtual;
    procedure Parse_Stage_Const_Value; virtual;
    procedure Parse_Stage_Const_Final; virtual;
    procedure Parse_Stage_Const; virtual;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base;

procedure TSVCParser_Const.InitializeParsing;
begin
inherited;
fParsingResult_Const.Identifier := '';
fParsingResult_Const.Value := 0;
fParsingResult_Const.Size := vsUndefined;
fParsingStage_Const := pscInitial;
fParsingData_Const.Identifier := '';
fParsingData_Const.Value := 0;
fParsingData_Const.Size := vsUndefined;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const_Initial;
begin
// pscInitial -> pscIdentifier
If (fLexer[fTokenIndex].TokenType = lttIdentifier) and IsValidIdentifier(fLexer[fTokenIndex].Str) then
  begin
    If not IsValidLabel(fLexer[fTokenIndex].Str) then
      begin
        If fLists.IsReservedWord(fLexer[fTokenIndex].Str) then
          AddErrorMessage('Identifier expected but resrved word %s found',[AnsiLowerCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfPrefix(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but prefix %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfRegister(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but register %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfInstruction(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but instruction %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If ResolveModifier(fLexer[fTokenIndex].Str) <> pmodNone then
          AddErrorMessage('Identifier expected but modifier %s found',[AnsiLowerCase(fLexer[fTokenIndex].Str)]);
        fParsingData_Const.Identifier := fLexer[fTokenIndex].Str;
        fParsingStage_Const := pscIdentifier;
      end
    else AddErrorMessage('Identifier expected but label "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const_Identifier;
begin
// pscIdentifier -> pscEquals
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_CHAR_EQUALS then
      fParsingStage_Const := pscEquals
    else
      AddErrorMessage('"=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const_Equals;
begin
// pscEquals -> pscModifier
// pscEquals -> pscValue
If (fLexer[fTokenIndex].TokenType = lttIdentifier) and IsValidIdentifier(fLexer[fTokenIndex].Str) then
  begin
    case ResolveModifier(fLexer[fTokenIndex].Str) of
      pmodByte: fParsingData_Const.Size := vsByte;
      pmodWord: fParsingData_Const.Size := vsWord;
    else
      AddErrorMessage('Size modifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
    end;
    fParsingStage_Const := pscModifier;
  end
else
  begin
    fParsingData_Const.Size := vsWord;
    fParsingStage_Const := pscModifier;
    Parse_Stage_Const_Modifier;
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const_Modifier;
var
  Num:  Integer;
begin
// pscModifier -> pscValue
If fLexer[fTokenIndex].TokenType = lttNumber then
  begin
    If TryStrToInt(fLexer[fTokenIndex].Str,Num) then
      begin
        case fParsingData_Const.Size of
          vsByte: If (Num > 255) or (Num < -128) then
                    AddWarningMessage('Constant out of allowed range');
          vsWord: If (Num > 65535) or (Num < -32768) then
                    AddWarningMessage('Constant out of allowed range');
        end;                    
        fParsingData_Const.Value := TSVCNative(Num);
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Const := pscValue
        else
          fParsingStage_Const := pscFinal;
      end
    else AddErrorMessage('Error converting number "%s"',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const_Value;
begin
// not alloved
If fTokenIndex < fLexer.Count then
  AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const_Final;
begin
// pscFinal -> pscInitial
If fTokenIndex >= fLexer.Count then
  begin
    If fParsingStage_Const = pscFinal then
      try
        fParsingResult_Const := fParsingData_Const;
        PassResult;
      finally
        fParsingStage_Const := pscInitial;
      end
    else AddErrorMessage('Unfinished constant declaration',0);
  end
else AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Const.Parse_Stage_Const;
begin
case fParsingStage_Const of
  pscInitial:     Parse_Stage_Const_Initial;
  pscIdentifier:  Parse_Stage_Const_Identifier;
  pscEquals:      Parse_Stage_Const_Equals;
  pscModifier:    Parse_Stage_Const_Modifier;
  pscValue:       Parse_Stage_Const_Value;
  pscFinal:       Parse_Stage_Const_Final;
else
  raise Exception.CreateFmt('TSVCParser_Const.Parse_Stage_Const: Invalid parsing stage (%d).',[Ord(fParsingStage_Const)]);
end;
end;

end.
