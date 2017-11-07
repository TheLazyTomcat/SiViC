unit SiViC_ASM_Parser_Label;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_ASM_Parser_Var;

const
  SVC_ASM_PARSER_PCR_ID_TODATA = 0;

  SVC_ASM_PARSER_LABEL_CHAR_TERMINATOR = ':';

type
  TSVCParserData_Label = record
    Identifier:     String;
    IdentifierPos:  Integer;
  end;

  TSVCParserResult_Label = TSVCParserData_Label;
  PSVCParserResult_Label = ^TSVCParserResult_Label;

  TSVCParserStage_Label = (pslInitial,pslIdentifier,pslTerminator,pslFinal);

  TSVCParser_Label = class(TSVCParser_Var)
  protected
    fParsingResult_Label: TSVCParserResult_Label;
    // parsing engine variables
    fParsingStage_Label:  TSVCParserStage_Label;
    fParsingData_Label:   TSVCParserData_Label;
    procedure InitializeParsing; override;
    // label parsing stages
    procedure Parse_Stage_Label_Initial; virtual;
    procedure Parse_Stage_Label_Identifier; virtual;
    procedure Parse_Stage_Label_Terminator; virtual;
    procedure Parse_Stage_Label_Final; virtual;
    procedure Parse_Stage_Label; virtual;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base;

procedure TSVCParser_Label.InitializeParsing;
begin
inherited;
fParsingResult_Label.Identifier := '';
fParsingStage_Label := pslInitial;
fParsingData_Label.Identifier := '';
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Label.Parse_Stage_Label_Initial;
begin
// pslInitial -> pslIdentifier
// pslInitial -> change to data parsing
If (fLexer[fTokenIndex].TokenType = lttIdentifier) and IsValidIdentifier(fLexer[fTokenIndex].Str) then
  begin
    If IsValidLabel(fLexer[fTokenIndex].Str) then
      begin
        fParsingData_Label.Identifier := fLexer[fTokenIndex].Str;
        fParsingData_Label.IdentifierPos := fLexer[fTokenIndex].Start;
        fParsingStage_Label := pslIdentifier;
      end
    else
      begin
        fParsingStage_Label := pslInitial;
        Dec(fTokenIndex);
        ParsingChangeRequest(SVC_ASM_PARSER_PCR_ID_TODATA);
      end;
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Label.Parse_Stage_Label_Identifier;
begin
// pslIdentifier -> pslFinal
// pslIdentifier -> change to data parsing
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_LABEL_CHAR_TERMINATOR then
      begin
        If fTokenIndex < Pred(fLexer.Count) then
          begin
            try
              fParsingResult_Label := fParsingData_Label;
              PassResult;
            finally
              fParsingStage_Label := pslInitial;
            end;
            ParsingChangeRequest(SVC_ASM_PARSER_PCR_ID_TODATA);
          end
        else fParsingStage_Label := pslFinal;
      end
    else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_LABEL_CHAR_TERMINATOR,fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('"%s" expected but "%s" found',[SVC_ASM_PARSER_LABEL_CHAR_TERMINATOR,fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Label.Parse_Stage_Label_Terminator;
begin
// not alloved
If fTokenIndex < fLexer.Count then
  AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Label.Parse_Stage_Label_Final;
begin
// pslFinal -> pslInitial
If fTokenIndex >= fLexer.Count then
  begin
    If fParsingStage_Label = pslFinal then
      try
        fParsingResult_Label := fParsingData_Label;
        PassResult;
      finally
        fParsingStage_Label := pslInitial;
      end
    else AddErrorMessage('Unfinished label declaration',0);
  end
else AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);  
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Label.Parse_Stage_Label;
begin
case fParsingStage_Label of
  pslInitial:     Parse_Stage_Label_Initial;
  pslIdentifier:  Parse_Stage_Label_Identifier;
  pslTerminator:  Parse_Stage_Label_Terminator;
  pslFinal:       Parse_Stage_Label_Final;
else
  raise Exception.CreateFmt('TSVCParser_Label.Parse_Stage_Label: Invalid parsing stage (%d).',[Ord(fParsingStage_Label)]);
end;
end;

end.
