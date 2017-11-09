unit SiViC_ASM_Parser;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_ASM_Parser_Instr;

type
  TSVCParserResultType = (prtNone,prtSys,prtConst,prtVar,prtLabel,prtData,prtInstr);

  // event called on result
  TSVCParserResultEvent = procedure(Sender: TObject; ResultType: TSVCParserResultType; Result: Pointer) of object;

  TSVCParserStage = (psInitial,psMain_Sys,psMain_Const,psMain_Var,
                     psMain_Label,psMain_Data,psMain_Instr,psFinal);

  TSVCParser = class(TSVCParser_Instr)
  private
    fParsingStage:  TSVCParserStage;
    fOnResult:      TSVCParserResultEvent;
  protected
    procedure ParsingChangeRequest(RequestID: Integer); override;
    procedure InitializeParsing; override;
    procedure Parse_Stage_Initial; virtual;
    procedure Parse_Stage_Final; virtual;
    procedure PassResult; override;
  public  
    Function Parse(const Line: String): Boolean; override;
  published
    property OnResult: TSVCParserResultEvent read fOnResult write fOnResult;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Lists,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base,
  SiViC_ASM_Parser_Label,
  SiViC_ASM_Parser_Data;


procedure TSVCParser.ParsingChangeRequest(RequestID: Integer);
begin
case RequestID of
  SVC_ASM_PARSER_PCR_ID_TODATA:         fParsingStage := psMain_Data;
  SVC_ASM_PARSER_PCR_ID_TOINSTRUCTION:  fParsingStage := psMain_Instr;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCParser.InitializeParsing;
begin
inherited;
fParsingStage := psInitial;
end;

//------------------------------------------------------------------------------

procedure TSVCParser.Parse_Stage_Initial;
begin
If fLexer[fTokenIndex].TokenType = lttIdentifier then
  begin
    If AnsiSameText(fLexer[fTokenIndex].Str,SVC_ASM_LISTS_RESERVEDWORDS[0]) then
      fParsingStage := psMain_Sys
    else If AnsiSameText(fLexer[fTokenIndex].Str,SVC_ASM_LISTS_RESERVEDWORDS[1]) then
      fParsingStage := psMain_Const
    else If AnsiSameText(fLexer[fTokenIndex].Str,SVC_ASM_LISTS_RESERVEDWORDS[2]) then
      fParsingStage := psMain_Var
    else If IsDataIntro(fLexer[fTokenIndex].Str) then
      begin
        fParsingStage := psMain_Data;
        Dec(fTokenIndex);
      end
    else
      begin // label or instruction
        fParsingStage := psMain_Label;
        Dec(fTokenIndex);
      end;
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser.Parse_Stage_Final;
begin
case fParsingStage of
  psMain_Sys:   Parse_Stage_Sys_Final;
  psMain_Const: Parse_Stage_Const_Final;
  psMain_Var:   Parse_Stage_Var_Final;
  psMain_Label: Parse_Stage_Label_Final;
  psMain_Data:  Parse_Stage_Data_Final;
  psMain_Instr: Parse_Stage_Instr_Final;
end;
fParsingStage := psInitial;
end;

//------------------------------------------------------------------------------

procedure TSVCParser.PassResult;
begin
If Assigned(fOnResult) then
  case fParsingStage of
    psMain_Sys:   fOnResult(Self,prtSys,Addr(fParsingResult_Sys));
    psMain_Const: fOnResult(Self,prtConst,Addr(fParsingResult_Const));
    psMain_Var:   fOnResult(Self,prtVar,Addr(fParsingResult_Var));
    psMain_Label: fOnResult(Self,prtLabel,Addr(fParsingResult_Label));
    psMain_Data:  fOnResult(Self,prtData,Addr(fParsingResult_Data));
    psMain_Instr: fOnResult(Self,prtInstr,Addr(fParsingResult_Instr));
  end;
end;

//------------------------------------------------------------------------------

Function TSVCParser.Parse(const Line: String): Boolean;
begin                                                
Result := inherited Parse(Line);
try
  while (fTokenIndex < fLexer.Count) do
    begin
      case fParsingStage of
        psInitial:    Parse_Stage_Initial;
        psMain_Sys:   Parse_Stage_Sys;
        psMain_Const: Parse_Stage_Const;
        psMain_Var:   Parse_Stage_Var;
        psMain_Label: Parse_Stage_Label;
        psMain_Data:  Parse_Stage_Data;
        psMain_Instr: Parse_Stage_Instr;
      end;
      Inc(fTokenIndex);
    end;
  Parse_Stage_Final;
except
  on ESVCParsingError do Result := False
    else raise;
end;
end;

end.
