unit SiViC_ASM_Parser_Data;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_ASM_Parser_Label;

const
  SVC_ASM_PARSER_PCR_ID_TOINSTRUCTION = 1;

  SVC_ASM_PARSER_DATA_CHAR_ITEMDELIMITER = ',';

type
  TSVCParserDataIntroItem = record
    Identifier: String;
    ItemSize:   TSVCValueSize;
  end;

const
  SVC_ASM_PARSER_DATA_INTROS: array[0..4] of TSVCParserDataIntroItem =
    ((Identifier: 'db'; ItemSize: vsByte),
     (Identifier: 'dw'; ItemSize: vsWord),
     (Identifier: 'dd'; ItemSize: vsLong),(Identifier: 'dl'; ItemSize: vsLong),
     (Identifier: 'dq'; ItemSize: vsQuad));

type
  TSVCParserData_Data = record
    ItemSize: TSVCValueSize;
    Data:     TSVCByteArray;
  end;

  TSVCParserResult_Data = record
    Data: TSVCByteArray;
  end;
  PSVCParserResult_Data = ^TSVCParserResult_Data;

  TSVCParserStage_Data = (psdInitial,psdItem,psdItemDelim,psdFinal);

  TSVCParser_Data = class(TSVCParser_Label)
  protected
    fParsingResult_Data: TSVCParserResult_Data;
    // parsing engine variables
    fParsingStage_Data:  TSVCParserStage_Data;
    fParsingData_Data:   TSVCParserData_Data;
    procedure InitializeParsing; override;
    // data parsing stages
    procedure Parse_Stage_Data_Initial; virtual;
    procedure Parse_Stage_Data_Item; virtual;
    procedure Parse_Stage_Data_ItemDelim; virtual;
    procedure Parse_Stage_Data_Final; virtual;
    procedure Parse_Stage_Data; virtual;
  public
    class Function IsDataIntro(const Str: String): Boolean; virtual;
    class Function GetDataItemSize(const Str: String): TSVCValueSize; virtual;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base;

procedure TSVCParser_Data.InitializeParsing;
begin
inherited;
SetLength(fParsingResult_Data.Data,0);
fParsingStage_Data := psdInitial;
SetLength(fParsingData_Data.Data,0);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Data.Parse_Stage_Data_Initial;
begin
// psdInitial -> psdItemDelim
// psdInitial -> psdFinal
// psdInitial -> change to instruction parsing
If (fLexer[fTokenIndex].TokenType = lttIdentifier) and IsValidIdentifier(fLexer[fTokenIndex].Str) then
  begin
    If IsDataIntro(fLexer[fTokenIndex].Str) then
      begin
        fParsingData_Data.ItemSize := GetDataItemSize(fLexer[fTokenIndex].Str);
        If fParsingData_Data.ItemSize <> vsUndefined then
          begin
            If fTokenIndex < Pred(fLexer.Count) then
              fParsingStage_Data := psdItemDelim
            else
              fParsingStage_Data := psdFinal;
          end
        else AddErrorMessage('Valid data introducer expected but "%s" found',[fLexer[fTokenIndex].Str]);
      end
    else
      begin
        fParsingStage_Data := psdInitial;
        Dec(fTokenIndex);
        ParsingChangeRequest(SVC_ASM_PARSER_PCR_ID_TOINSTRUCTION);
      end;
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Data.Parse_Stage_Data_Item;
begin
// psdItem -> psdItemDelim
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_DATA_CHAR_ITEMDELIMITER then
      fParsingStage_Data := psdItemDelim
    else
      AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_DATA_CHAR_ITEMDELIMITER,fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_DATA_CHAR_ITEMDELIMITER,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Data.Parse_Stage_Data_ItemDelim;
var
  Num:  Int64;
begin
// psdItemDelim -> psdItem
// psdItemDelim -> psdFinal
If (fLexer[fTokenIndex].TokenType = lttNumber) then
  begin
    If TryStrToInt64(fLexer[fTokenIndex].Str,Num) then
      begin
        CheckConstRangeAndIssueWarning(Num,fParsingData_Data.ItemSize);
        AddToArray(fParsingData_Data.Data,Num,ValueSize(fParsingData_Data.ItemSize));
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Data := psdItem
        else
          fParsingStage_Data := psdFinal;
      end
    else AddErrorMessage('Error converting "%s" to number',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Number expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Data.Parse_Stage_Data_Final;
begin
// psdFinal -> psdInitial
If fTokenIndex >= fLexer.Count then
  begin
    If fParsingStage_Data = psdFinal then
      try
        fParsingResult_Data.Data := fParsingData_Data.Data;
        PassResult;
      finally
        fParsingStage_Data := psdInitial;
      end
    else AddErrorMessage('Unfinished data',0);
  end
else AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Data.Parse_Stage_Data;
begin
case fParsingStage_Data of
  psdInitial:   Parse_Stage_Data_Initial;
  psdItem:      Parse_Stage_Data_Item;
  psdItemDelim: Parse_Stage_Data_ItemDelim;
  psdFinal:     Parse_Stage_Data_Final;
else
  raise Exception.CreateFmt('TSVCParser_Data.Parse_Stage_Data: Invalid parsing stage (%d).',[Ord(fParsingStage_Label)]);
end;
end;

//==============================================================================

class Function TSVCParser_Data.IsDataIntro(const Str: String): Boolean;
var
  i:  Integer;
begin
Result := False;
For i := Low(SVC_ASM_PARSER_DATA_INTROS) to High(SVC_ASM_PARSER_DATA_INTROS) do
  If AnsiSameText(Str,SVC_ASM_PARSER_DATA_INTROS[i].Identifier) then
    begin
      Result := True;
      Break{For i};
    end;
end;

//------------------------------------------------------------------------------

class Function TSVCParser_Data.GetDataItemSize(const Str: String): TSVCValueSize;
var
  i:  Integer;
begin
Result := vsUndefined;
For i := Low(SVC_ASM_PARSER_DATA_INTROS) to High(SVC_ASM_PARSER_DATA_INTROS) do
  If AnsiSameText(Str,SVC_ASM_PARSER_DATA_INTROS[i].Identifier) then
    begin
      Result := SVC_ASM_PARSER_DATA_INTROS[i].ItemSize;
      Break{For i};
    end;
end;

end.
