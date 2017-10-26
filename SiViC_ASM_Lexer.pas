unit SiViC_ASM_Lexer;

{$INCLUDE '.\SiViC_defs.inc'}

interface

const
  SVC_ASM_LEXER_CHAR_STRINGQUOTE = '''';

  SVC_ASM_LEXER_CHARS_WHITESPACE      = [#0..#32];
  SVC_ASM_LEXER_CHARS_NUMBERSTART     = ['$','0'..'9'];
  SVC_ASM_LEXER_CHARS_NUMBER          = ['0'..'9','a'..'f','A'..'F','x','X'];
  SVC_ASM_LEXER_CHARS_UNARYOPERATORS  = ['+','-'];
  SVC_ASM_LEXER_CHARS_IDENTIFIER      = ['a'..'z','A'..'Z','0'..'9','_','@'];

type                            //      {}       (**)     /**/
  TSVCLexerCommentType = (lcmtNone,lcmtType1,lcmtType2,lcmtType3,lcmtType4);
  TSVCLexerTokenType   = (lttNumber,lttUnaryOp,lttIdentifier,lttGeneral,
                          lttComment,lttString,lttInvalid);
  TSVCLexerCharType    = (lctWhiteSpace,lctNumber,lctUnaryOp,lctIdentifier,
                          lctStringQuote,lctOthers,lctInvalid);
  TSVCLexerStage       = (lsTraverse,lsIdentifier,lsNumber,lsComment,lsString);

  TSVCLexerToken = record
    Str:        String;
    Start:      Integer;
    TokenType:  TSVCLexerTokenType;
  end;

  TSVCLexerTokens = record
    Arr:    array of TSVCLexerToken;
    Count:  Integer;
  end;

  TSVCLexer = class(TObject)
  private
    fLine:              String;
    fIncludeComments:   Boolean;
    fContinuousComment: Boolean;
    fTokens:            TSVCLexerTokens;
    // tokenizing engine variables
    fStage:             TSVCLexerStage;
    fPosition:          Integer;
    fTokenStart:        Integer;
    fTokenLength:       Integer;
    fCommentType:       TSVCLexerCommentType;
    Function GetToken(Index: Integer): TSVCLexerToken;
  protected
    procedure AddToken(const Str: String; Start: Integer; TokenType: TSVCLexerTokenType); virtual;
    // tokenizing engine
    Function GetCurrCharType: TSVCLexerCharType; virtual;
    Function CommentStart: TSVCLexerCommentType; virtual;
    Function CommentEnd: Boolean; virtual;
    procedure Process_Traverse; virtual;
    procedure Process_Identifier; virtual;
    procedure Process_Number; virtual;
    procedure Process_Comment; virtual;
    procedure Process_String; virtual;
  public
    class Function TrimComment(const Str: String): String; virtual;
    class Function UnquoteString(const Str: String): String; virtual;
    constructor Create;
    destructor Destroy; override;
    procedure Initialize; virtual;
    Function Tokenize(const Line: String): Boolean; virtual;
    procedure Clear; virtual;
    property Tokens[Index: Integer]: TSVCLexerToken read GetToken; default;
  published
    property IncludeComments: Boolean read fIncludeComments write fIncludeComments;
    property ContinuousComment: Boolean read fContinuousComment write fContinuousComment;
    property ContinuousCommentType: TSVCLexerCommentType read fCommentType write fCommentType;
    property Count: Integer read fTokens.Count;
  end;

implementation

uses
  SysUtils,
  SiViC_Common;


Function TSVCLexer.GetToken(Index: Integer): TSVCLexerToken;
begin
If (Index >= Low(fTokens.Arr)) and (Index < fTokens.Count) then
  Result := fTokens.Arr[Index]
else
  raise Exception.CreateFmt('TSVCLexer.GetToken: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TSVCLexer.AddToken(const Str: String; Start: Integer; TokenType: TSVCLexerTokenType);
begin
If Length(fTokens.Arr) <= fTokens.Count then
  SetLength(fTokens.Arr,Length(fTokens.Arr) + 8);
fTokens.Arr[fTokens.Count].Str := Str;
fTokens.Arr[fTokens.Count].Start := Start;
fTokens.Arr[fTokens.Count].TokenType := TokenType;
Inc(fTokens.Count);
end;

//------------------------------------------------------------------------------

Function TSVCLexer.GetCurrCharType: TSVCLexerCharType;
begin
If CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_WHITESPACE) then
  Result := lctWhiteSpace
else If CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_NUMBERSTART) then
  Result := lctNumber
else If CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_UNARYOPERATORS) then
  Result := lctUnaryOp
else If CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_IDENTIFIER) then
  Result := lctIdentifier
else If fLine[fPosition] = SVC_ASM_LEXER_CHAR_STRINGQUOTE then
  Result := lctStringQuote
else If Ord(fLine[fPosition]) <= 127 then
  Result := lctOthers
else
  Result := lctInvalid;
end;

//------------------------------------------------------------------------------

Function TSVCLexer.CommentStart: TSVCLexerCommentType;
begin
Result := lcmtNone;
case fLine[fPosition] of
  '/':  If fPosition < Length(fLine) then
          case fLine[fPosition + 1] of
            '/':  Result := lcmtType1;
            '*':  Result := lcmtType4;
          end;
  '{':  Result := lcmtType2;
  '(':  If fPosition < Length(fLine) then
          If fLine[fPosition + 1] = '*' then
            Result := lcmtType3;
end;
end;

//------------------------------------------------------------------------------

Function TSVCLexer.CommentEnd: Boolean;
begin
Result := False;
case fLine[fPosition] of
  '}':  begin
          Result := fCommentType = lcmtType2;
          Inc(fTokenLength);
        end;
  '*':  If fPosition < Length(fLine) then
          begin
            Result := ((fLine[fPosition + 1] = ')') and (fCommentType = lcmtType3)) or
                      ((fLine[fPosition + 1] = '/') and (fCommentType = lcmtType4));
            If Result then
              begin
                Inc(fPosition);
                Inc(fTokenLength,2);
              end
          end;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Process_Traverse;

  procedure InitToken(Stage: TSVCLexerStage; Start: Integer; Length: Integer = 1);
  begin
    fStage := Stage;
    fTokenStart := Start;
    fTokenLength := Length;
  end;

begin
case GetCurrCharType of
  lctWhiteSpace:; // continue
  lctNumber:      If fTokens.Count > 0 then
                    begin
                      If (fTokens.Arr[Pred(fTokens.Count)].TokenType = lttUnaryOp) and
                        (fTokens.Arr[Pred(fTokens.Count)].Start = Pred(fPosition)) then
                        begin
                          Dec(fTokens.Count);
                          InitToken(lsNumber,Pred(fPosition),2);
                        end
                      else InitToken(lsNumber,fPosition);
                    end
                  else InitToken(lsNumber,fPosition);
  lctUnaryOp:     AddToken(fLine[fPosition],fPosition,lttUnaryOp);
  lctIdentifier:  InitToken(lsIdentifier,fPosition);
  lctStringQuote: If fPosition < Length(fLine) then
                    InitToken(lsString,fPosition)
                  else
                    AddToken(fLine[fPosition],fPosition,lttGeneral);
  lctOthers:      begin
                    fCommentType := CommentStart;
                    If fCommentType <> lcmtNone then
                      begin
                        InitToken(lsComment,fPosition);
                        If fCommentType in [lcmtType1,lcmtType3,lcmtType4] then
                          begin
                            Inc(fPosition);
                            Inc(fTokenLength);
                          end;
                      end
                    else AddToken(fLine[fPosition],fPosition,lttGeneral);
                  end;
  lctInvalid:     AddToken(fLine[fPosition],fPosition,lttInvalid);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Process_Identifier;
begin
If not(CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_IDENTIFIER)) then
  begin
    AddToken(Trim(Copy(fLine,fTokenStart,fTokenLength)),fTokenStart,lttIdentifier);
    fStage := lsTraverse;
    Dec(fPosition);
  end
else Inc(fTokenLength);
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Process_Number;
begin
If not(CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_NUMBER)) then
  begin
    If CharInSet(fLine[fPosition],SVC_ASM_LEXER_CHARS_IDENTIFIER) then
      begin
        fStage := lsIdentifier;
        Inc(fTokenLength);
      end
    else
      begin
        AddToken(Trim(Copy(fLine,fTokenStart,fTokenLength)),fTokenStart,lttNumber);
        fStage := lsTraverse;
        Dec(fPosition);
      end;
  end
else Inc(fTokenLength);
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Process_Comment;
begin
If CommentEnd then
  begin
    If fIncludeComments then
      AddToken(Copy(fLine,fTokenStart,fTokenLength),fTokenStart,lttComment);
    fStage := lsTraverse;
  end
else Inc(fTokenLength);
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Process_String;
begin
If fLine[fPosition] = SVC_ASM_LEXER_CHAR_STRINGQUOTE then
  begin
    fStage := lsTraverse;
    If fPosition < Length(fLine) then
      begin
        If fLine[fPosition + 1] = SVC_ASM_LEXER_CHAR_STRINGQUOTE then
          begin
            Inc(fPosition);
            Inc(fTokenLength,2);
            fStage := lsString;
          end
        else AddToken(Copy(fLine,fTokenStart,fTokenLength + 1),fTokenStart,lttString);
      end
    else AddToken(Copy(fLine,fTokenStart,fTokenLength + 1),fTokenStart,lttString);
  end
else Inc(fTokenLength);
end;

//==============================================================================

class Function TSVCLexer.TrimComment(const Str: String): String;
var
  StartCommentType: TSVCLexerCommentType;
  EndCommentType:   TSVCLexerCommentType;
begin
StartCommentType := lcmtNone;
EndCommentType := lcmtNone;
If Length(Str) > 0 then
  begin
    // check start of the string
    case Str[1] of
      '/':  If Length(Str) >= 2 then
              case Str[2] of
                '/':  begin
                        StartCommentType := lcmtType1;
                        EndCommentType := lcmtType1;
                      end;
                '*':  StartCommentType := lcmtType4;
              end;
      '{':  StartCommentType := lcmtType2;
      '(':  If Length(Str) >= 2 then
              If Str[2] = '*' then
                StartCommentType := lcmtType3;
    end;
    //check end of the string
    If StartCommentType <> lcmtType1 then
      case Str[Length(Str)] of
        '/':  If Length(Str) >= 4 then
                If Str[Length(Str) - 1] = '*' then
                  EndCommentType := lcmtType4;
        '}':  If Length(Str) >= 2 then
                EndCommentType := lcmtType2;
        ')':  If Length(Str) >= 4 then
                If Str[Length(Str) - 1] = '*' then
                  EndCommentType := lcmtType3;
      end;
    // do trimming
    If EndCommentType = StartCommentType then
      case StartCommentType of
        lcmtType1:  Result := Copy(Str,3,Length(Str) - 2);
        lcmtType2:  Result := Copy(Str,2,Length(Str) - 2);
        lcmtType3:  Result := Copy(Str,3,Length(Str) - 4);
        lcmtType4:  Result := Copy(Str,3,Length(Str) - 4);
      else
        Result := Str;
      end
    else Result := Str;
  end
else Result := '';
end;

//------------------------------------------------------------------------------

class Function TSVCLexer.UnquoteString(const Str: String): String;
var
  i,ResPos: Integer;
begin
SetLength(Result,Length(Str));
ResPos := 0;
i := 1;
while i <= Length(Str) do
  begin
    If Str[i] = SVC_ASM_LEXER_CHAR_STRINGQUOTE then
      begin
        If (i > 1 )and (i < Length(Str)) then
          begin
            If Str[i + 1] = SVC_ASM_LEXER_CHAR_STRINGQUOTE then
              begin
                Inc(ResPos);
                Result[ResPos] := Str[i];
                Inc(i);
              end
            else Break{while i};
          end;
      end
    else
      begin
        Inc(ResPos);
        Result[ResPos] := Str[i];
      end;
    Inc(i);
  end;
SetLength(Result,ResPos);
end;

//------------------------------------------------------------------------------

constructor TSVCLexer.Create;
begin
inherited;
Initialize;
fIncludeComments := False;
end;

//------------------------------------------------------------------------------

destructor TSVCLexer.Destroy;
begin
SetLength(fTokens.Arr,0);
inherited;
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Initialize;
begin
fStage := lsTraverse;
Clear;
fContinuousComment := False;
end;

//------------------------------------------------------------------------------

Function TSVCLexer.Tokenize(const Line: String): Boolean;
var
  i:  Integer;
begin
Clear;
fLine := Line;
If fContinuousComment then
  fStage := lsComment
else
  fStage := lsTraverse;
fContinuousComment := False;
fPosition := 1;
fTokenStart := 1;
fTokenLength := 0;
If Length(fLine) > 0 then
  begin
    while (fPosition >= 1) and (fPosition <= Length(fLine)) do
      begin
        case fStage of
          lsTraverse:   Process_Traverse;
          lsIdentifier: Process_Identifier;
          lsNumber:     Process_Number;
          lsComment:    Process_Comment;
          lsString:     Process_String;
        end;
        Inc(fPosition);
      end;
    case fStage of
      lsIdentifier:
        AddToken(Trim(Copy(fLine,fTokenStart,fTokenLength)),fTokenStart,lttIdentifier);
      lsNumber:
        AddToken(Trim(Copy(fLine,fTokenStart,fTokenLength)),fTokenStart,lttNumber);
      lsComment:
        begin
          If fIncludeComments then
            AddToken(Copy(fLine,fTokenStart,fTokenLength),fTokenStart,lttComment);
          fContinuousComment := fCommentType in [lcmtType2,lcmtType3,lcmtType4];
        end;
      lsString:
        AddToken(Copy(fLine,fTokenStart,fTokenLength),fTokenStart,lttString);
    end;
  end;
{
  check whether there are invalid tokens, change unary operators that are not
  combined with numbers to general tokens
}
Result := True;
For i := 0 to Pred(fTokens.Count) do
  begin
    If fTokens.Arr[i].TokenType = lttUnaryOp then
      fTokens.Arr[i].TokenType := lttGeneral;
    If fTokens.Arr[i].TokenType = lttInvalid then
      begin
        Result := False;
        Break{For i};
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCLexer.Clear;
begin
fTokens.Count := 0;
end;

end.
