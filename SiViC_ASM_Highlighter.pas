unit SiViC_ASM_Highlighter;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_ASM_Lists,
  SiViC_ASM_Lexer;

type
  TSVCHighlighterTokenType = (httReservedWord,httLabel,httPrefix,httInstruction,
                              httModifier,httRegister,httNumber,httComment,
                              httString,httOthers);

  TSVCHighlighterToken = record
    Token:          TSVCLexerToken;
    HighlightType:  TSVCHighlighterTokenType;
  end;

  TSVCHighlighterTokens = record
    Arr:    array of TSVCHighlighterToken;
    Count:  Integer;
  end;

  TSVCHighlighter = class(TObject)
  private
    fLexer:     TSVCLexer;
    fOwnsLists: Boolean;    
    fLists:     TSVCListManager;
    fLine:      String;
    fTokens:    TSVCHighlighterTokens;
    Function GetToken(Index: Integer): TSVCHighlighterToken;
    Function GetContComment: Boolean;
    procedure SetContComment(Value: Boolean);
  protected
    procedure ProcessTokens; virtual;
  public
    constructor Create(Lists: TSVCListManager = nil);
    destructor Destroy; override;
    procedure Analyze(const Line: String); virtual;
    property Tokens[Index: Integer]: TSVCHighlighterToken read GetToken; default;
  published
    property Line: String read fLine;
    property ContinuousComment: Boolean read GetContComment write SetContComment;
    property Count: Integer read fTokens.Count;
  end;

implementation

uses
  SysUtils,
  SiViC_ASM_Parser_Base,
  SiViC_ASM_Parser_Label;

Function TSVCHighlighter.GetToken(Index: Integer): TSVCHighlighterToken;
begin
If (Index >= Low(fTokens.Arr)) and (Index < fTokens.Count) then
  Result := fTokens.Arr[Index]
else
  raise Exception.CreateFmt('TSVCHighlighter.GetToken: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

Function TSVCHighlighter.GetContComment: Boolean;
begin
Result := fLexer.ContinuousComment;
end;

//------------------------------------------------------------------------------

procedure TSVCHighlighter.SetContComment(Value: Boolean);
begin
fLexer.ContinuousComment := Value;
end;

//==============================================================================

procedure TSVCHighlighter.ProcessTokens;
var
  i:  Integer;
begin
fTokens.Count := fLexer.Count;
If Length(fTokens.Arr) < fTokens.Count then
  SetLength(fTokens.Arr,fTokens.Count);
For i := 0 to Pred(fLexer.Count) do
  begin
    fTokens.Arr[i].Token := fLexer[i];
    case fTokens.Arr[i].Token.TokenType of
      lttIdentifier:
        begin
          If TSVCListManager.IsReservedWord(fLexer[i].Str) then
            fTokens.Arr[i].HighlightType := httReservedWord
          else If fLists.IndexOfPrefix(fLexer[i].Str) >= 0 then
            fTokens.Arr[i].HighlightType := httPrefix
          else If fLists.IndexOfInstruction(fLexer[i].Str) >= 0 then
            fTokens.Arr[i].HighlightType := httInstruction
          else If fLists.IndexOfRegister(fLexer[i].Str) >= 0 then
            fTokens.Arr[i].HighlightType := httRegister
          else If TSVCParser_Base.IsValidLabel(fLexer[i].Str) then
            fTokens.Arr[i].HighlightType := httLabel
          else If TSVCParser_Base.ResolveModifier(fLexer[i].Str) <> pmodNone then
            fTokens.Arr[i].HighlightType := httModifier
          else
            fTokens.Arr[i].HighlightType := httOthers;
        end;
      lttNumber:
        fTokens.Arr[i].HighlightType := httNumber;
      lttComment:
        fTokens.Arr[i].HighlightType := httComment;
      lttGeneral:
        If (i > 0) then
          begin
            If AnsiSameText(fTokens.Arr[i].Token.Str,SVC_ASM_PARSER_LABEL_CHAR_TERMINATOR) and
               (fTokens.Arr[Pred(i)].HighlightType = httLabel) then
              fTokens.Arr[i].HighlightType := httLabel
            else
              fTokens.Arr[i].HighlightType := httOthers;
          end
        else fTokens.Arr[i].HighlightType := httOthers;
      lttString:
        fTokens.Arr[i].HighlightType := httString;
    else {case-else}
      fTokens.Arr[i].HighlightType := httOthers;
    end;
  end;
end;

//==============================================================================

constructor TSVCHighlighter.Create(Lists: TSVCListManager = nil);
begin
inherited Create;
fLexer := TSVCLexer.Create;
fLexer.IncludeComments := True;
fOwnsLists := not Assigned(Lists);
If not Assigned(Lists) then
  begin
    fLists := TSVCListManager.Create;
    fLists.LoadFromResource(SVC_ASM_LISTS_DEFAULTRESOURCENAME);
  end
else fLists := Lists;
end;

//------------------------------------------------------------------------------

destructor TSVCHighlighter.Destroy;
begin
If fOwnsLists then
  fLists.Free;
fLexer.Free;
inherited;
end;

//------------------------------------------------------------------------------

procedure TSVCHighlighter.Analyze(const Line: String);
begin
fLine := Line;
fLexer.Tokenize(fLine);
ProcessTokens;
end;

end.
