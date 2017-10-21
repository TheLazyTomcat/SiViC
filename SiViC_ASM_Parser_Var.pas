unit SiViC_ASM_Parser_Var;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_ASM_Parser_Const;

const
  SVC_ASM_PARSER_VAR_CHAR_DATADELIMITER = ',';

type
  TSVCParserData_Var = record
    Identifier:   String;
    Size:         TSVCNative;
    Data:         TSVCByteArray;
    ExplicitSize: Boolean;
  end;

  TSVCParserResult_Var = record
    Identifier:   String;
    Size:         TSVCNative;
    Data:         TSVCByteArray;
  end;
  PSVCParserResult_Var = ^TSVCParserResult_Var;

  TSVCParserStage_Var = (psvInitial,psvIdentifier,psvSizeLBrc,psvSize,
                         psvSizeRBrc,psvEquals,psvData,psvDataDelim,psvFinal);

  TSVCParser_Var = class(TSVCParser_Const)
  protected
    fParsingResult_Var: TSVCParserResult_Var;
    // parsing engine variables
    fParsingStage_Var:  TSVCParserStage_Var;
    fParsingData_Var:   TSVCParserData_Var;
    procedure InitializeParsing; override;
    // var parsing stages
    procedure Parse_Stage_Var_Initial; virtual;
    procedure Parse_Stage_Var_Identifier; virtual;
    procedure Parse_Stage_Var_SizeLBrc; virtual;
    procedure Parse_Stage_Var_Size; virtual;
    procedure Parse_Stage_Var_SizeRBrc; virtual;
    procedure Parse_Stage_Var_Equals; virtual;
    procedure Parse_Stage_Var_Data; virtual;
    procedure Parse_Stage_Var_DataDelim; virtual;
    procedure Parse_Stage_Var_Final; virtual;
    procedure Parse_Stage_Var; virtual;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base;

procedure TSVCParser_Var.InitializeParsing;
begin
inherited;
fParsingResult_Var.Identifier := '';
fParsingResult_Var.Size := 0;
SetLength(fParsingResult_Var.Data,0);
fParsingStage_Var := psvInitial;
fParsingData_Var.Identifier := '';
fParsingData_Var.Size := 0;
fParsingData_Var.ExplicitSize := False;
SetLength(fParsingData_Var.Data,0);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Initial;
begin
// psvInitial -> psvIdentifier
// psvInitial -> psvFinal
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
        fParsingData_Var.Identifier := fLexer[fTokenIndex].Str;
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Var := psvIdentifier
        else
          fParsingStage_Var := psvFinal;
      end
    else AddErrorMessage('Identifier expected but label "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Identifier;
begin
// psvIdentifier -> psvSizeLBrc
// psvIdentifier -> psvEquals
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    case fLexer[fTokenIndex].Str[1] of
      SVC_ASM_PARSER_CHAR_EQUALS:   fParsingStage_Var := psvEquals;
      SVC_ASM_PARSER_CHAR_LBRACKET: fParsingStage_Var := psvSizeLBrc;
    else
      AddErrorMessage('"(" or "=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
    end;
  end
else AddErrorMessage('"(" or "=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_SizeLBrc;
var
  Num:  Integer;
begin
// psvSizeLBrc -> psvSize
If fLexer[fTokenIndex].TokenType = lttNumber then
  begin
    If TryStrToInt(fLexer[fTokenIndex].Str,Num) then
      begin
        If (Num > 65535) or (Num < -32768) then
          AddWarningMessage('Constant out of allowed range');
        fParsingData_Var.Size := TSVCNative(Num);
        fParsingData_Var.ExplicitSize := True;
        fParsingStage_Var := psvSize;
      end
    else AddErrorMessage('Error converting number "%s"',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Size;
begin
// psvSize -> psvSizeRBrc
// psvSize -> psvFinal
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_CHAR_RBRACKET then
      begin
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Var := psvSizeRBrc
        else
          fParsingStage_Var := psvFinal;
      end
    else AddErrorMessage('")" expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('")" expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_SizeRBrc;
begin
// psvIdentifier -> psvEquals
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_CHAR_EQUALS then
      fParsingStage_Var := psvEquals
    else
      AddErrorMessage('"=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"=" expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Equals;
var
  Num:  Integer;
begin
// psvEquals -> psvData
// psvEquals -> psvFinal
If (fLexer[fTokenIndex].TokenType = lttNumber) then
  begin
    If TryStrToInt(fLexer[fTokenIndex].Str,Num) then
      begin
        If (Num > 255) or (Num < -128) then
          AddWarningMessage('Constant out of allowed range');
        SetLength(fParsingData_Var.Data,Length(fParsingData_Var.Data) + 1);
        fParsingData_Var.Data[High(fParsingData_Var.Data)] := TSVCByte(Num);
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Var := psvData
        else
          fParsingStage_Var := psvFinal;
      end
    else AddErrorMessage('Error converting number "%s"',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Data;
begin
// psvData -> psvDataSep
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_VAR_CHAR_DATADELIMITER then
      fParsingStage_Var := psvDataDelim
    else
      AddErrorMessage('"," expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"," expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_DataDelim;
begin
// psvDataDelim -> psvData
// psvDataDelim -> psvFinal
Parse_Stage_Var_Equals;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Final;
var
  i:  Integer;
begin
// psvFinal -> psvInitial
If fTokenIndex >= fLexer.Count then
  begin
    If fParsingStage_Var = psvFinal then
      try
        If fParsingData_Var.ExplicitSize then
          begin
            If (Length(fParsingData_Var.Data) > fParsingData_Var.Size) then
              AddWarningMessage('Provided data cannot fit into declared memory, they will be truncated');
            If (Length(fParsingData_Var.Data) < fParsingData_Var.Size) and (Length(fParsingData_Var.Data) > 0) then
              AddWarningMessage('Declared size is larger than provided data, missing bytes will be undefined');
          end;
        fParsingResult_Var.Identifier := fParsingData_Var.Identifier;
        fParsingResult_Var.Size := fParsingData_Var.Size;
        If fParsingData_Var.Size < Length(fParsingData_Var.Data) then
          SetLength(fParsingResult_Var.Data,fParsingData_Var.Size)
        else
          SetLength(fParsingResult_Var.Data,Length(fParsingData_Var.Data));
        For i := Low(fParsingResult_Var.Data) to High(fParsingResult_Var.Data) do
          fParsingResult_Var.Data[i] := fParsingData_Var.Data[i];          
        PassResult;
      finally
        fParsingStage_Var := psvInitial;
      end
    else AddErrorMessage('Unfinished variable declaration',0);
  end
else AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var;
begin
case fParsingStage_Var of
  psvInitial:     Parse_Stage_Var_Initial;
  psvIdentifier:  Parse_Stage_Var_Identifier;
  psvSizeLBrc:    Parse_Stage_Var_SizeLBrc;
  psvSize:        Parse_Stage_Var_Size;
  psvSizeRBrc:    Parse_Stage_Var_SizeRBrc;
  psvEquals:      Parse_Stage_Var_Equals;
  psvData:        Parse_Stage_Var_Data;
  psvDataDelim:   Parse_Stage_Var_DataDelim;
  psvFinal:       Parse_Stage_Var_Final;
else
  raise Exception.CreateFmt('TSVCParser_Var.Parse_Stage_Var: Invalid parsing stage (%d).',[Ord(fParsingStage_Var)]);
end;
end;

end.
