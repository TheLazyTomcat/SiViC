unit SiViC_ASM_Parser_Var;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_ASM_Parser_Const;

const
  SVC_ASM_PARSER_VAR_CHAR_DATADELIMITER = ',';
  SVC_ASM_PARSER_VAR_CHAR_REFERENCE     = '@';
  SVC_ASM_PARSER_VAR_CHAR_REFPLUS       = '+';

  SVC_ASM_PARSER_VAR_NULLSTR = 'null';

type
  TSVCParserData_Var = record
    Identifier:             String;
    IdentifierPos:          Integer;
    Size:                   TSVCNative;
    ItemSize:               TSVCValueSize;
    Data:                   TSVCByteArray;
    ExplicitSize:           Boolean;
    Referencing:            Boolean;
    ReferenceIdentifier:    String;
    ReferenceIdentifierPos: Integer;
    ReferenceOffset:        TSVCNative;
  end;

  TSVCParserResult_Var = record
    Identifier:             String;
    IdentifierPos:          Integer;
    Size:                   TSVCNative;
    Data:                   TSVCByteArray;
    Referencing:            Boolean;
    ReferenceIdentifier:    String;
    ReferenceIdentifierPos: Integer;
    ReferenceOffset:        TSVCNative;
  end;
  PSVCParserResult_Var = ^TSVCParserResult_Var;

  TSVCParserStage_Var = (psvInitial,psvIdentifier,psvSizeLBrc,psvSize,psvSizeRBrc,
                         psvEquals,psvModifier,psvData,psvDataDelim,psvNull,psvString,
                         psvReference,psvRefIdentifier,psvRefPlus,psvRefOffset,
                         psvFinal);

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
    procedure Parse_Stage_Var_Modifier; virtual;
    procedure Parse_Stage_Var_Data; virtual;
    procedure Parse_Stage_Var_DataDelim; virtual;
    procedure Parse_Stage_Var_Null; virtual;
    procedure Parse_Stage_Var_String; virtual;
    procedure Parse_Stage_Var_Reference; virtual;
    procedure Parse_Stage_Var_RefIdentifier; virtual;
    procedure Parse_Stage_Var_RefPlus; virtual;
    procedure Parse_Stage_Var_RefOffset; virtual;
    procedure Parse_Stage_Var_Final; virtual;
    procedure Parse_Stage_Var; virtual;
  end;

implementation

uses
  SysUtils,
  StrRect,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base;

procedure TSVCParser_Var.InitializeParsing;
begin
inherited;
fParsingResult_Var.Identifier := '';
fParsingResult_Var.IdentifierPos := 0;
fParsingResult_Var.Size := 0;
SetLength(fParsingResult_Var.Data,0);
fParsingResult_Var.Referencing := False;
fParsingResult_Var.ReferenceIdentifier := '';
fParsingResult_Var.ReferenceIdentifierPos := 0;
fParsingResult_Var.ReferenceOffset := 0;
fParsingStage_Var := psvInitial;
fParsingData_Var.Identifier := '';
fParsingData_Var.IdentifierPos := 0;
fParsingData_Var.Size := 0;
fParsingData_Var.ItemSize := vsByte;
SetLength(fParsingData_Var.Data,0);
fParsingData_Var.ExplicitSize := False;
fParsingData_Var.Referencing := False;
fParsingData_Var.ReferenceIdentifier := '';
fParsingData_Var.ReferenceIdentifierPos := 0;
fParsingData_Var.ReferenceOffset := 0;
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
        fParsingData_Var.IdentifierPos := fLexer[fTokenIndex].Start;
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
// psvIdentifier -> psvReference
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    case fLexer[fTokenIndex].Str[1] of
      SVC_ASM_PARSER_CHAR_LBRACKET:       fParsingStage_Var := psvSizeLBrc;
      SVC_ASM_PARSER_CHAR_EQUALS:         fParsingStage_Var := psvEquals;
      SVC_ASM_PARSER_VAR_CHAR_REFERENCE:  fParsingStage_Var := psvReference;
    else
      AddErrorMessage('"%s", "%s" or "%s" expected but "%s" found',[SVC_ASM_PARSER_CHAR_LBRACKET,
        SVC_ASM_PARSER_CHAR_EQUALS,SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
    end;
  end
else AddErrorMessage('"%s", "%s" or "%s" expected but "%s" found',[SVC_ASM_PARSER_CHAR_LBRACKET,
       SVC_ASM_PARSER_CHAR_EQUALS,SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
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
        CheckConstRangeAndIssueWarning(Num,vsNative);
        fParsingData_Var.Size := TSVCNative(Num);
        fParsingData_Var.ExplicitSize := True;
        fParsingStage_Var := psvSize;
      end
    else AddErrorMessage('Error converting "%s" to number',[fLexer[fTokenIndex].Str]);
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
    else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_CHAR_RBRACKET,fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_CHAR_RBRACKET,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_SizeRBrc;
begin
// psvSizeRBrc -> psvEquals
// psvSizeRBrc -> psvReference
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    case fLexer[fTokenIndex].Str[1] of
      SVC_ASM_PARSER_CHAR_EQUALS:         fParsingStage_Var := psvEquals;
      SVC_ASM_PARSER_VAR_CHAR_REFERENCE:  fParsingStage_Var := psvReference;
    else
      AddErrorMessage('"%s" or "%s" expected but "%s" found',[SVC_ASM_PARSER_CHAR_EQUALS,
        SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
    end;
  end
else AddErrorMessage('"%s" or "%s" expected but "%s" found',[SVC_ASM_PARSER_CHAR_EQUALS,
       SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Equals;
var
  Modifier: TSVCParserModifier;
  TempStr:  UTF8String;
  i:        Integer;

  Function EffectiveSizeCheckAndRaise(Modifier: TSVCComp): Boolean;
  begin
    Result := (TSVCComp(fParsingData_Var.Size) * Modifier) <= TSVCComp(High(TSVCNative) + 1);
    If not Result then
      AddErrorMessage('Size modifier makes the variable too large to fit into a valid memory space');
  end;

begin
// psvEquals -> psvModifier
// psvEquals -> psvData
// psvEquals -> psvNull
// psvEquals -> psvString
// psvEquals -> psvFinal
case fLexer[fTokenIndex].TokenType of
  lttIdentifier:
    begin
      Modifier := ResolveModifier(fLexer[fTokenIndex].Str);
      If Modifier <> pmodNone then
        begin
          // calculate effective size
          case Modifier of
            pmodByte: fParsingData_Var.ItemSize := vsByte;
            pmodWord: begin
                        fParsingData_Var.ItemSize := vsWord;
                        If EffectiveSizeCheckAndRaise(SVC_SZ_WORD) then
                          fParsingData_Var.Size := TSVCNative(TSVCComp(fParsingData_Var.Size) * SVC_SZ_WORD);
                      end;
            pmodLong: begin
                        fParsingData_Var.ItemSize := vsLong;
                        If EffectiveSizeCheckAndRaise(SVC_SZ_LONG) then
                          fParsingData_Var.Size := TSVCNative(TSVCComp(fParsingData_Var.Size) * SVC_SZ_LONG);
                      end;
            pmodQuad: begin
                        fParsingData_Var.ItemSize := vsQuad;
                        If EffectiveSizeCheckAndRaise(SVC_SZ_QUAD) then
                          fParsingData_Var.Size := TSVCNative(TSVCComp(fParsingData_Var.Size) * SVC_SZ_QUAD);
                      end;
            pmodPtr:  AddErrorMessage('Size modifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
          else
            raise Exception.CreateFmt('TSVCParser_Var.Parse_Stage_Var_Equals: Invalid modifier (%d).',[Ord(Modifier)]);
          end;
          If fTokenIndex < Pred(fLexer.Count) then
            fParsingStage_Var := psvModifier
          else
            fParsingStage_Var := psvFinal;
        end
      else Parse_Stage_Var_Modifier;
    end;
  lttString:
    begin
      TempStr := StrToUTF8(fLexer.UnquoteString(fLexer[fTokenIndex].Str));
      fParsingData_Var.Size := Length(TempStr);
      SetLength(fParsingData_Var.Data,Length(TempStr));
      For i := Low(fParsingData_Var.Data) to High(fParsingData_Var.Data) do
        fParsingData_Var.Data[i] := TSVCByte(TempStr[i + 1]);
      If fTokenIndex < Pred(fLexer.Count) then
        fParsingStage_Var := psvString
      else
        fParsingStage_Var := psvFinal;
    end;
else
  Parse_Stage_Var_Modifier;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Modifier;
var
  i:  Integer;
begin
// psvModifier -> psvData
// psvModifier -> psvNull
// psvModifier -> psvReference
// psvModifier -> psvFinal
If (fLexer[fTokenIndex].TokenType = lttIdentifier) then
  begin
    If AnsiSameText(fLexer[fTokenIndex].Str,SVC_ASM_PARSER_VAR_NULLSTR) then
      begin
        SetLength(fParsingData_Var.Data,fParsingData_Var.Size);
        For i := Low(fParsingData_Var.Data) to High(fParsingData_Var.Data) do
          fParsingData_Var.Data[i] := 0;
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Var := psvNull
        else
          fParsingStage_Var := psvFinal;
      end
    else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_VAR_CHAR_REFERENCE then
      fParsingStage_Var := psvReference
    else
      AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
  end
else If (fLexer[fTokenIndex].TokenType = lttNumber) then
  Parse_Stage_Var_DataDelim
else
  AddErrorMessage('Number or "%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Data;
begin
// psvData -> psvDataSep
// psvData -> psvReference
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    case fLexer[fTokenIndex].Str[1] of
      SVC_ASM_PARSER_VAR_CHAR_DATADELIMITER:  fParsingStage_Var := psvDataDelim;
      SVC_ASM_PARSER_VAR_CHAR_REFERENCE:      fParsingStage_Var := psvReference;
    else
      AddErrorMessage('"%s" or "%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_DATADELIMITER,
        SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
    end;
  end
else AddErrorMessage('"%s" or "%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_DATADELIMITER,
       SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_DataDelim;
var
  Num:  Int64;
begin
// psvDataDelim -> psvData
// psvDataDelim -> psvFinal
If (fLexer[fTokenIndex].TokenType = lttNumber) then
  begin
    If TryStrToInt64(fLexer[fTokenIndex].Str,Num) then
      begin
        CheckConstRangeAndIssueWarning(Num,fParsingData_Var.ItemSize);
        AddToArray(fParsingData_Var.Data,Num,ValueSize(fParsingData_Var.ItemSize));
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Var := psvData
        else
          fParsingStage_Var := psvFinal;
      end
    else AddErrorMessage('Error converting "%s" to number',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Null;
begin
// psvNull -> psvReference
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_VAR_CHAR_REFERENCE then
      fParsingStage_Var := psvReference
    else
      AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_REFERENCE,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_String;
begin
// psvNull -> psvReference
Parse_Stage_Var_Null;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_Reference;
begin
// psvReference -> psvRefIdentifier
// psvReference -> psvFinal
If fLexer[fTokenIndex].TokenType = lttIdentifier then
  begin
    fParsingData_Var.Referencing := True;
    fParsingData_Var.ReferenceIdentifier := fLexer[fTokenIndex].Str;
    fParsingData_Var.ReferenceIdentifierPos := fLexer[fTokenIndex].Start;
    If fTokenIndex < Pred(fLexer.Count) then
      fParsingStage_Var := psvRefIdentifier
    else
      fParsingStage_Var := psvFinal;
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_RefIdentifier;
begin
// psvRefIdentifier -> psvRefPlus
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_VAR_CHAR_REFPLUS then
      fParsingStage_Var := psvRefPlus
    else
      AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_REFPLUS,fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_VAR_CHAR_REFPLUS,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_RefPlus;
var
  Num:  Integer;
begin
// psvRefPlus -> psvFinal
If fLexer[fTokenIndex].TokenType = lttNumber then
  begin
    If TryStrToInt(fLexer[fTokenIndex].Str,Num) then
      begin
        CheckConstRangeAndIssueWarning(Num,vsNative);
        fParsingData_Var.ReferenceOffset := TSVCNative(Num);
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Var := psvRefOffset
        else
          fParsingStage_Var := psvFinal;
      end
    else AddErrorMessage('Error converting "%s" to number',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Var.Parse_Stage_Var_RefOffset;
begin
// not alloved
If fTokenIndex < fLexer.Count then
  AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
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
          end
        else fParsingData_Var.Size := Length(fParsingData_Var.Data);
        // create result from data
        fParsingResult_Var.Identifier := fParsingData_Var.Identifier;
        fParsingResult_Var.IdentifierPos := fParsingData_Var.IdentifierPos;
        fParsingResult_Var.Size := fParsingData_Var.Size;
        If fParsingData_Var.Size < Length(fParsingData_Var.Data) then
          SetLength(fParsingResult_Var.Data,fParsingData_Var.Size)
        else
          SetLength(fParsingResult_Var.Data,Length(fParsingData_Var.Data));
        For i := Low(fParsingResult_Var.Data) to High(fParsingResult_Var.Data) do
          fParsingResult_Var.Data[i] := fParsingData_Var.Data[i];
        fParsingResult_Var.Referencing := fParsingData_Var.Referencing;
        fParsingResult_Var.ReferenceIdentifier := fParsingData_Var.ReferenceIdentifier;
        fParsingResult_Var.ReferenceIdentifierPos := fParsingData_Var.ReferenceIdentifierPos;
        fParsingResult_Var.ReferenceOffset := fParsingData_Var.ReferenceOffset;
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
  psvInitial:       Parse_Stage_Var_Initial;
  psvIdentifier:    Parse_Stage_Var_Identifier;
  psvSizeLBrc:      Parse_Stage_Var_SizeLBrc;
  psvSize:          Parse_Stage_Var_Size;
  psvSizeRBrc:      Parse_Stage_Var_SizeRBrc;
  psvEquals:        Parse_Stage_Var_Equals;
  psvModifier:      Parse_Stage_Var_Modifier;
  psvData:          Parse_Stage_Var_Data;
  psvDataDelim:     Parse_Stage_Var_DataDelim;
  psvNull:          Parse_Stage_Var_Null;
  psvString:        Parse_Stage_Var_String;
  psvReference:     Parse_Stage_Var_Reference;
  psvRefIdentifier: Parse_Stage_Var_RefIdentifier;
  psvRefPlus:       Parse_Stage_Var_RefPlus;
  psvRefOffset:     Parse_Stage_Var_RefOffset;
  psvFinal:         Parse_Stage_Var_Final;
else
  raise Exception.CreateFmt('TSVCParser_Var.Parse_Stage_Var: Invalid parsing stage (%d).',[Ord(fParsingStage_Var)]);
end;
end;

end.
