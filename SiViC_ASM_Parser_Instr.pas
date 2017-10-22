unit SiViC_ASM_Parser_Instr;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Registers,
  SiViC_Instructions,
  SiViC_ASM_Lexer,
  SiViC_ASM_Parser_Base,
  SiViC_ASM_Parser_Data;

const
  SVC_ASM_PARSER_CHAR_INSTR_ARGS_DELIMITER = ',';
  SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART  = '[';
  SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND    = ']';

type
  TSVCParserData_Instr_Argument_Mem_TokenType = (mttINV,mttREG,mttIMM,mttADD,mttMUL);

  TSVCParserData_Instr_Argument_Mem_Token = record
    Token:        TSVCLexerToken;
    MemTokenType: TSVCParserData_Instr_Argument_Mem_TokenType;
  end;

  TSVCParserData_Instr_Argument_Mem = record
    Tokens:           array of TSVCParserData_Instr_Argument_Mem_Token;
    Present:          Byte;
    BaseData:         TSVCRegisterID;
    IndexData:        TSVCRegisterID;
    ScaleData:        String;
    ScaleIsNumber:    Boolean;
    DisplaceData:     String;
    DisplaceIsNumber: Boolean;
    AddrMode:         TSVCInstructionAddressingMode;
  end;

  TSVCParserData_Instr_Argument = record
    Modifiers:      TSVCParserModifiers;
    PossibleTypes:  TSVCInstructionArgumentTypes;
    DefinitiveType: TSVCInstructionArgumentType;
    Identifiers:    array of String;
    Data:           TSVCNative;
    Memory:         TSVCParserData_Instr_Argument_Mem;
  end;

  TSVCParserData_Instr = record
    Prefixes:     TSVCByteArray;
    Instruction:  String;
    Arguments:    array of TSVCParserData_Instr_Argument;
  end;

  TSVCParserResult_Instr_Replacement = record
    Identifier: String;
    ValType:    TSVCInstructionArgumentType;
    IsLabel:    Boolean;
    Position:   Integer;
  end;

  TSVCParserResult_Instr = record
    Window:       TSVCInstructionWindow;
    Replacements: array of TSVCParserResult_Instr_Replacement;
  end;
  PSVCParserResult_Instr = ^TSVCParserResult_Instr;

  TSVCParserStage_Instr = (psiInitial,psiPrefix,psiIntruction,psiModifier,
                           psiArgument,psiArgumentMem,psiArgumentMemEnd,
                           psiArgumentDelim,psiFinal);

  TSVCParser_Instr = class(TSVCParser_Data)
  protected
    fParsingResult_Instr: TSVCParserResult_Instr;
    // parsing engine variables
    fParsingStage_Instr:  TSVCParserStage_Instr;
    fParsingData_Instr:   TSVCParserData_Instr;
    procedure InitializeParsing; override;
    // instruction parsing stages
    procedure ResolveMemoryAddressing; virtual;
    procedure Parse_Stage_Instr_Initial; virtual;
    procedure Parse_Stage_Instr_Prefix; virtual;
    procedure Parse_Stage_Instr_Intruction; virtual;
    procedure Parse_Stage_Instr_Modifier; virtual;
    procedure Parse_Stage_Instr_Argument; virtual;
    procedure Parse_Stage_Instr_ArgumentMem; virtual;
    procedure Parse_Stage_Instr_ArgumentMemEnd; virtual;
    procedure Parse_Stage_Instr_ArgumentDelim; virtual;
    procedure Parse_Stage_Instr_Final; virtual;
    procedure Parse_Stage_Instr; virtual;
  end;

implementation

uses
  SysUtils;

procedure TSVCParser_Instr.InitializeParsing;
begin
inherited;
FillChar(fParsingResult_Instr.Window.Data,Length(fParsingResult_Instr.Window.Data),0);
fParsingResult_Instr.Window.Position := Low(fParsingResult_Instr.Window.Data);
SetLength(fParsingResult_Instr.Replacements,0);
fParsingStage_Instr := psiInitial;
SetLength(fParsingData_Instr.Prefixes,0);
fParsingData_Instr.Instruction := '';
SetLength(fParsingData_Instr.Arguments,0);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.ResolveMemoryAddressing;
const
  MEMPARTPRESENT_BASE     = $01;
  MEMPARTPRESENT_INDEX    = $02;
  MEMPARTPRESENT_SCALE    = $04;
  MEMPARTPRESENT_DISPLACE = $08;
var
  i:      Integer;
  Index:  Integer;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Function LookBack(Idx: Integer): TSVCParserData_Instr_Argument_Mem_TokenType;
  begin
    with fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Memory do
      If Idx > Low(Tokens) then
        Result := Tokens[Idx - 1].MemTokenType
      else
        Result := mttINV; // invalid
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Function LookAhead(Idx: Integer): TSVCParserData_Instr_Argument_Mem_TokenType;
  begin
    with fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Memory do
      If Idx < High(Tokens) then
        Result := Tokens[Idx + 1].MemTokenType
      else
        Result := mttINV; // invalid
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

begin
with fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Memory do
  begin
    For i := Low(Tokens) to High(Tokens) do
      case Tokens[i].Token.TokenType of

        lttNumber:    // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          Tokens[i].MemTokenType := mttIMM;

        lttIdentifier:// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          begin
            If fLists.IndexOfPrefix(Tokens[i].Token.Str) >= 0 then
              AddErrorMessage('Register or identifier expected but prefix %s found',
                              [AnsiUpperCase(Tokens[i].Token.Str)],Tokens[i].Token.Start);
            If fLists.IndexOfInstruction(Tokens[i].Token.Str) >= 0 then
              AddErrorMessage('Register or identifier expected but instruction %s found',
                              [AnsiUpperCase(Tokens[i].Token.Str)],Tokens[i].Token.Start);
            Index := fLists.IndexOfRegister(Tokens[i].Token.Str);
            If Index >= 0 then
              begin
                // register, must be full-width
                If fLists.Registers[Index].RegType in [rtWord,rtNative] then
                  Tokens[i].MemTokenType := mttREG
                else
                  AddErrorMessage('Invalid register',Tokens[i].Token.Start);
              end
            else
              begin
                // identifier
                If not IsValidLabel(Tokens[i].Token.Str) then
                  Tokens[i].MemTokenType := mttIMM
                else
                  AddErrorMessage('Register or identifier expected but label "%s" found',[Tokens[i].Token.Str],Tokens[i].Token.Start);
              end;
          end;

        lttGeneral:   // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          begin
            If AnsiSameText(Tokens[i].Token.Str,'+') then
              Tokens[i].MemTokenType := mttADD
            else If AnsiSameText(Tokens[i].Token.Str,'*') then
              Tokens[i].MemTokenType := mttMUL
            else
              AddErrorMessage('"+" or "*" expected but "%s" found',[Tokens[i].Token.Str],Tokens[i].Token.Start);
          end;

      else {case-else}// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        AddErrorMessage('Identifier, number, "+" or "*" expected but "%s" found',[Tokens[i].Token.Str],Tokens[i].Token.Start);
      end;
    {--- end of For i cycle ---}  

    // check proper sequention (val operand val operand val ....)
    For i := Low(Tokens) to High(Tokens) do
      If LookBack(i) in [mttIMM,mttREG] then
        begin
          If not(Tokens[i].MemTokenType in [mttADD,mttMUL]) then
            AddErrorMessage('Syntax error',Tokens[i].Token.Start);
        end
      else
        begin
          {mttINV,mttADD,mttMUL}
          If not(Tokens[i].MemTokenType in [mttIMM,mttREG]) then
            AddErrorMessage('Syntax error',Tokens[i].Token.Start);
        end;

    // assign tokens to individual constituents of memory addressing
    For i := Low(Tokens) to High(Tokens) do
      case Tokens[i].MemTokenType of

        mttREG: // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          If (LookBack(i) <> mttMUL) and (LookAhead(i) <> mttMUL) and ((Present and MEMPARTPRESENT_BASE) = 0) then
            begin
              // register is a base
              Present := Present or MEMPARTPRESENT_BASE;
               // index was checked before
              BaseData := fLists.Registers[fLists.IndexOfRegister(Tokens[i].Token.Str)].ID;
            end
          else
            begin
              // register must be an index
              If Present and MEMPARTPRESENT_INDEX = 0 then
                begin
                  Present := Present or MEMPARTPRESENT_INDEX;
                  // index was checked before
                  IndexData := fLists.Registers[fLists.IndexOfRegister(Tokens[i].Token.Str)].ID;
                end
              else AddErrorMessage('Memory addressing index already assigned',Tokens[i].Token.Start);
            end;

        mttIMM: // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          If (LookBack(i) = mttMUL) or (LookAhead(i) = mttMUL) then
            begin
              // immediate is a scale
              If Present and MEMPARTPRESENT_SCALE = 0 then
                begin
                  Present := Present or MEMPARTPRESENT_SCALE;
                  ScaleData := Tokens[i].Token.Str;
                  ScaleIsNumber := Tokens[i].Token.TokenType = lttNumber;
                end
              else AddErrorMessage('Memory addressing scale already assigned',Tokens[i].Token.Start);
            end
          else
            begin
              // immediate is a displacement
              If Present and MEMPARTPRESENT_DISPLACE = 0 then
                begin
                  Present := Present or MEMPARTPRESENT_DISPLACE;
                  DisplaceData := Tokens[i].Token.Str;
                  DisplaceIsNumber := Tokens[i].Token.TokenType = lttNumber;
                end
              else AddErrorMessage('Memory addressing displacement already assigned',Tokens[i].Token.Start);
            end;

        mttADD, // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        mttMUL:
          If not((LookBack(i) in [mttIMM,mttREG]) and (LookAhead(i) in [mttIMM,mttREG])) then
            AddErrorMessage('Syntax error',Tokens[i].Token.Start);

      else {case-else}// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        AddErrorMessage('Invalid memory addressing token',Tokens[i].Token.Start);
      end;
    {--- end of For i cycle ---}

    // get memory mode from what has been assigned
    case Present and $0F of
      1:  AddrMode := 0;  // base
      3:  AddrMode := 5;  // base + index
      6:  AddrMode := 3;  // index * scale
      7:  AddrMode := 6;  // base + index * scale
      8:  AddrMode := 1;  // displacement
      9:  AddrMode := 2;  // base + displacement
      14: AddrMode := 4;  // index * scale + displacement
      15: AddrMode := 7;  // base + index * scale + displacement
    else
      AddErrorMessage('Invalid memory addressing mode',0);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_Initial;
var
  Index:  Integer;
begin
// psiInitial -> psiPrefix
// psiInitial -> psiIntruction
// psiInitial -> psiFinal
If (fLexer[fTokenIndex].TokenType = lttIdentifier) and IsValidIdentifier(fLexer[fTokenIndex].Str) then
  begin
    Index := fLists.IndexOfPrefix(fLexer[fTokenIndex].Str);
    If Index >= 0 then
      begin
        // identifier is a prefix
        SetLength(fParsingData_Instr.Prefixes,Length(fParsingData_Instr.Prefixes) + 1);
        fParsingData_Instr.Prefixes[High(fParsingData_Instr.Prefixes)] := TSVCByte(fLists.Prefixes[Index].Code);
        fParsingStage_Instr := psiPrefix;
        Exit;
      end;
    Index := fLists.IndexOfInstruction(fLexer[fTokenIndex].Str);
    If Index >= 0 then
      begin
        // identifier is an instruction
        fParsingData_Instr.Instruction := fLexer[fTokenIndex].Str;
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Instr := psiIntruction
        else
          fParsingStage_Instr := psiFinal;
      end
    else AddErrorMessage('Prefix or instruction expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end
else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_Prefix;
begin
// psiPrefix -> psiPrefix
// psiPrefix -> psiIntruction
// psiPrefix -> psiFinal
Parse_Stage_Instr_Initial;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_Intruction;
begin
// psiIntruction -> psiModifier, psiArgument, psiArgumentMem, psiFinal
// there MUST be an argument (nothing else is allowed after an instruction)
fParsingStage_Instr := psiArgumentDelim;
Dec(fTokenIndex);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_Modifier;
var
  Num:      Integer;
  Index:    Integer;
  Modifier: TSVCParserModifier;
begin
// psiModifier -> psiModifier, psiArgument, psiArgumentMem, psiFinal
case fLexer[fTokenIndex].TokenType of

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  lttNumber:
    If TryStrToInt(fLexer[fTokenIndex].Str,Num) then
      begin
        If (Num > 65535) or (Num < -32768) then
          AddWarningMessage('Constant out of allowed range');
        If (Num <= 255) and (Num >= -128) then
          fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].PossibleTypes := [iatREL8,iatREL16,iatIMM8,iatIMM16]
        else
          fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].PossibleTypes := [iatREL16,iatIMM16];
        fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Data := TSVCNative(Num);
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Instr := psiArgument
        else
          fParsingStage_Instr := psiFinal;
      end
    else AddErrorMessage('Error converting number "%s"',[fLexer[fTokenIndex].Str]);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  lttIdentifier:
    If IsValidIdentifier(fLexer[fTokenIndex].Str) then
      begin
        // modifier, register, label or constant (must not be prefix or instruction)
        If fLists.IndexOfPrefix(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but prefix %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        If fLists.IndexOfInstruction(fLexer[fTokenIndex].Str) >= 0 then
          AddErrorMessage('Identifier expected but instruction %s found',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
        // check for modifier
        Modifier := ResolveModifier(fLexer[fTokenIndex].Str);
        If Modifier <> pmodNone then
          begin
            with fParsingData_Instr do
              If not ((Modifier = pmodByte) and (pmodWord in Arguments[High(Arguments)].Modifiers)) or
                     ((Modifier = pmodWord) and (pmodByte in Arguments[High(Arguments)].Modifiers)) then
                begin
                  Include(Arguments[High(Arguments)].Modifiers,Modifier);
                  fParsingStage_Instr := psiModifier;
                  Exit;
                end
              else AddErrorMessage('Two different size modifiers not allowed');
          end;
        // check for register
        Index := fLists.IndexOfRegister(fLexer[fTokenIndex].Str);
        If Index >= 0 then
          begin
            // register
            with fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)] do
              If not fLists.Registers[Index].Implicit then
                begin
                  // GPR
                  If fLists.Registers[Index].RegType in [rtLoByte,rtHiByte] then
                    PossibleTypes := [iatREG8]
                  else
                    PossibleTypes := [iatREG16];
                  Data := TSVCNative(fLists.Registers[Index].ID);
                end
              else
                begin
                  // implicit register
                  case fLists.Registers[Index].Index of
                    SVC_REG_IMPL_IDX_IP:    PossibleTypes := [iatIP];
                    SVC_REG_IMPL_IDX_FLAGS: PossibleTypes := [iatFLAGS];
                    SVC_REG_IMPL_IDX_CNTR:  PossibleTypes := [iatCNTR];
                    SVC_REG_IMPL_IDX_CR:    PossibleTypes := [iatCR];
                  else
                    AddErrorMessage('Invalid register %s',[AnsiUpperCase(fLexer[fTokenIndex].Str)]);
                  end;
                end;
          end
        else
          begin
            // label or constant
            If IsValidLabel(fLexer[fTokenIndex].Str) then
              fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].PossibleTypes := [iatREL8,iatREL16]
            else
              fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].PossibleTypes := [iatREL8,iatREL16,iatIMM8,iatIMM16];
            SetLength(fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Identifiers,1);
            fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Identifiers[0] := fLexer[fTokenIndex].Str;
          end;
        If fTokenIndex < Pred(fLexer.Count) then
          fParsingStage_Instr := psiArgument
        else
          fParsingStage_Instr := psiFinal; 
      end
    else AddErrorMessage('Identifier expected but "%s" found',[fLexer[fTokenIndex].Str]);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  lttGeneral:
    If Length(fLexer[fTokenIndex].Str) = 1 then
      begin
        If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMSTART then
          begin
            fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].PossibleTypes := [iatMEM8,iatMEM16,iatMEM];
            fParsingStage_Instr := psiArgumentMem;
          end
        else AddErrorMessage('"[" expected but "%s" found',[fLexer[fTokenIndex].Str]);
      end
    else AddErrorMessage('"[" expected but "%s" found',[fLexer[fTokenIndex].Str]);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

else {case-else}
  AddErrorMessage('Identifier, number or "[" expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_Argument;
begin
// psiArgument -> psiArgumentDelim
If (fLexer[fTokenIndex].TokenType = lttGeneral) and (Length(fLexer[fTokenIndex].Str) = 1) then
  begin
    If fLexer[fTokenIndex].Str[1] = SVC_ASM_PARSER_CHAR_INSTR_ARGS_DELIMITER then
      fParsingStage_Instr := psiArgumentDelim
    else
      AddErrorMessage('"," expected but "%s" found',[fLexer[fTokenIndex].Str])
  end
else AddErrorMessage('"," expected but "%s" found',[fLexer[fTokenIndex].Str]);
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_ArgumentMem;
begin
// psiArgumentMem -> psiArgumentMem, psiArgumentMemEnd, psiFinal
If (fLexer[fTokenIndex].TokenType = lttGeneral) and AnsiSameText(fLexer[fTokenIndex].Str[1],SVC_ASM_PARSER_CHAR_INSTR_ARGS_MEMEND) then
  begin
    ResolveMemoryAddressing;
    If fTokenIndex < Pred(fLexer.Count) then
      fParsingStage_Instr := psiArgumentMemEnd
    else
      fParsingStage_Instr := psiFinal;
  end
else
  begin
    If fLexer[fTokenIndex].TokenType in [lttNumber,lttIdentifier,lttGeneral] then
      begin
        with fParsingData_Instr.Arguments[High(fParsingData_Instr.Arguments)].Memory do
          begin
            SetLength(Tokens,Length(Tokens) + 1);
            Tokens[High(Tokens)].Token := fLexer[fTokenIndex];
          end;
      end
    else AddErrorMessage('Identifier, number, "+" or "*" expected but "%s" found',[fLexer[fTokenIndex].Str]);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_ArgumentMemEnd;
begin
// psiArgumentMemEnd -> psiArgumentDelim
Parse_Stage_Instr_Argument;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_ArgumentDelim;
begin
// psiArgumentDelim -> psiModifier, psiArgument, psiArgumentMem, psiFinal
SetLength(fParsingData_Instr.Arguments,Length(fParsingData_Instr.Arguments) + 1);
Parse_Stage_Instr_Modifier;
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr_Final;
var
  i,Num:    Integer;
  PfxArr:   TSVCByteArray;
  Indices:  array of Integer;
  Index:    Integer;
  AddrMode: TSVCInstructionAddressingMode;  

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Function PrefixListed(Prefix: TSVCInstructionPrefix): Boolean;
  var
    ii: Integer;
  begin
    Result := False;
    For ii := Low(PfxArr) to High(PfxArr) do
      If PfxArr[ii] = Prefix then
        begin
          Result := True;
          Break{For ii};
        end;
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Function InstructionArgumentsQualify(InstructionIndex: Integer): Boolean;
  var
    ii: Integer;
  begin
    If Length(fParsingData_Instr.Arguments) = Length(fLists.Instructions[InstructionIndex].Arguments) then
      begin
        Result := True;
        For ii := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
          If not(fLists.Instructions[InstructionIndex].Arguments[ii] in fParsingData_Instr.Arguments[ii].PossibleTypes) then
            begin
              Result := False;
              Break{For ii};
            end;
      end
    else Result := False;
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  procedure StoreMemoryAddressingDisplacement(ArgIdx,Offset: Integer);
  begin
    with fParsingData_Instr.Arguments[ArgIdx] do
      If Length(Memory.DisplaceData) > 0 then
        begin
          If Memory.DisplaceIsNumber then
            begin
              // displacement is given as a number
              If TryStrToInt(Memory.DisplaceData,Num) then
                begin
                  If (Num > 65535) or (Num < -32768) then
                    AddWarningMessage('Constant out of allowed range',0);
                  fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + Offset] := TSVCByte(Num);
                  fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + Offset + 1] := TSVCByte(Num shr 8);
                end
              else AddErrorMessage('Error converting number "%s"',[Memory.DisplaceData],0);
            end
          else
            begin
              // displacement is given as a reference
              SetLength(fParsingResult_Instr.Replacements,Length(fParsingResult_Instr.Replacements) + 1);
              with fParsingResult_Instr.Replacements[High(fParsingResult_Instr.Replacements)] do
                begin
                  Identifier := Memory.DisplaceData;
                  ValType := iatIMM16;
                  IsLabel := False;
                  Position := fParsingResult_Instr.Window.Position + Offset;
                end;
            end;
        end
      else AddErrorMessage('Syntax error',0);
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  procedure StoreMemoryAddressingScale(ArgIdx,Offset: Integer);
  begin
    with fParsingData_Instr.Arguments[ArgIdx] do
      If Length(Memory.ScaleData) > 0 then
        begin
          If Memory.ScaleIsNumber then
            begin
              // scale is given as a number
              If TryStrToInt(Memory.ScaleData,Num) then
                begin
                  If (Num > 255) or (Num < -128) then
                    AddWarningMessage('Constant out of allowed range',0);
                  fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + Offset] := TSVCByte(Num);
                end
              else AddErrorMessage('Error converting number "%s"',[Memory.ScaleData],0);
            end
          else
            begin
              // scale is given as a reference
              SetLength(fParsingResult_Instr.Replacements,Length(fParsingResult_Instr.Replacements) + 1);
              with fParsingResult_Instr.Replacements[High(fParsingResult_Instr.Replacements)] do
                begin
                  Identifier := Memory.ScaleData;
                  ValType := iatIMM8;
                  IsLabel := False;
                  Position := fParsingResult_Instr.Window.Position + Offset;
                end;
            end;
        end
      else AddErrorMessage('Syntax error',0);
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
begin
// psiFinal -> psiInitial
If fTokenIndex >= fLexer.Count then
  begin
    If fParsingStage_Instr = psiFinal then
      try
        // remove duplicit prefixes
        SetLength(PfxArr,0);
        For i := Low(fParsingData_Instr.Prefixes) to High(fParsingData_Instr.Prefixes) do
          If not PrefixListed(fParsingData_Instr.Prefixes[i]) then
            begin
              SetLength(PfxArr,Length(PfxArr) + 1);
              PfxArr[High(PfxArr)] := fParsingData_Instr.Prefixes[i];
            end;
        fParsingData_Instr.Prefixes := PfxArr;

        // error if a register have any modifier
        For i := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
          If (fParsingData_Instr.Arguments[i].PossibleTypes <= [iatREG8,iatREG16,iatNone]) and
            (fParsingData_Instr.Arguments[i].Modifiers <> []) then
              AddErrorMessage('Modifiers not allowed for register arguments',0);

        // error on PTR modifier for constant arguments
        For i := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
          If (fParsingData_Instr.Arguments[i].PossibleTypes <= [iatREL8,iatREL16,iatIMM8,iatIMM16]) and
            (pmodPtr in fParsingData_Instr.Arguments[i].Modifiers) then
              AddErrorMessage('PTR modifier not allowed for constant arguments',0);

        // set sizes for memory and constant arguments when size modifier is present
        For i := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
          If fParsingData_Instr.Arguments[i].PossibleTypes <= [iatREL8,iatREL16,iatIMM8,iatIMM16,iatMEM8,iatMEM16,iatMEM] then
            begin
              If pmodByte in fParsingData_Instr.Arguments[i].Modifiers then
                fParsingData_Instr.Arguments[i].PossibleTypes := fParsingData_Instr.Arguments[i].PossibleTypes -
                  [iatREL16,iatIMM16,iatMEM16,iatMEM];
              If pmodWord in fParsingData_Instr.Arguments[i].Modifiers then
                fParsingData_Instr.Arguments[i].PossibleTypes := fParsingData_Instr.Arguments[i].PossibleTypes -
                  [iatREL8,iatIMM8,iatMEM8,iatMEM];
            end;

        // select ONE instruction matching the argument list
        // if none is found -> invalid combination of instruction and arguments
        // if more that one is found -> ambiguous argument combination
        SetLength(Indices,0);
        Index := fLists.IndexOfInstruction(fParsingData_Instr.Instruction);
        while Index >= 0 do
          begin
            // check if all arguments qualify
            If InstructionArgumentsQualify(Index) then
              begin
                SetLength(Indices,Length(Indices) + 1);
                Indices[High(Indices)] := Index;
              end;
            Index := fLists.IndexOfInstruction(fParsingData_Instr.Instruction,Succ(Index));
          end;

        // select default instruction if any
        If Length(Indices) > 1 then
          For i := Low(Indices) to High(Indices) do
            If fLists.Instructions[Indices[i]].Default then
              begin
                Indices[0] := Indices[i];
                SetLength(Indices,1);
                Break{For i};
              end;

        // instruction selection errors
        If Length(Indices) <= 0 then
          AddErrorMessage('Invalid combination of instruction and arguments',0);
        If Length(Indices) > 1 then
          AddErrorMessage('Ambiguous argument combination',0);

        // set definite argument type
        For i := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
          fParsingData_Instr.Arguments[i].DefinitiveType := fLists.Instructions[Indices[0]].Arguments[i];

        //--- result building --- - - - - - - - - - - - - - - - - - - - - - - -

        // store prefixes if they fit (al least one byte must stay free for an instruction opcode)
        If (Length(fParsingData_Instr.Prefixes) + fParsingResult_Instr.Window.Position) >= Length(fParsingResult_Instr.Window.Data) then
          AddErrorMessage('Prefixes cannot fit into instruction window',0);
        For i := Low(fParsingData_Instr.Prefixes) to High(fParsingData_Instr.Prefixes) do
           fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + i] := TSVCByte(fParsingData_Instr.Prefixes[i]);
        fParsingResult_Instr.Window.Position := fParsingResult_Instr.Window.Position + Length(fParsingData_Instr.Prefixes);

        // store opcode if it fits
        If (Length(fLists.Instructions[Indices[0]].OpCode) + fParsingResult_Instr.Window.Position) > Length(fParsingResult_Instr.Window.Data) then
          AddErrorMessage('Opcode cannot fit into instruction window',0);
        For i := Low(fLists.Instructions[Indices[0]].OpCode) to High(fLists.Instructions[Indices[0]].OpCode) do
          fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + i] := TSVCByte(fLists.Instructions[Indices[0]].OpCode[i]);
        fParsingResult_Instr.Window.Position := fParsingResult_Instr.Window.Position + Length(fLists.Instructions[Indices[0]].OpCode);

        // store suffix when needed and if it fits
        If fLists.Instructions[Indices[0]].MemSuffix or fLists.Instructions[Indices[0]].CCSuffix then
          begin
            If fParsingResult_Instr.Window.Position < Length(fParsingResult_Instr.Window.Data) then
              begin
                AddrMode := 0;
                If fLists.Instructions[Indices[0]].MemSuffix then
                  For i := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
                    If fParsingData_Instr.Arguments[i].PossibleTypes <= [iatMEM8,iatMEM16,iatMEM] then
                      begin
                        AddrMode := fParsingData_Instr.Arguments[i].Memory.AddrMode;
                        Break{For i};
                      end;
                fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] :=
                  TSVCByte(BuildSuffix(AddrMode,fLists.Instructions[Indices[0]].CCCode));
                Inc(fParsingResult_Instr.Window.Position);
              end
            else AddErrorMessage('Suffix cannot fit into instruction window',0);
          end;

        // store arguments
        For i := Low(fParsingData_Instr.Arguments) to High(fParsingData_Instr.Arguments) do
          with fParsingData_Instr.Arguments[i] do
            case DefinitiveType of

              iatIP,
              iatFLAGS,
              iatCNTR,
              iatCR:;   // - - - - - - - - - - - - - - - - - - - - - - - - - - -
                // implicit registers, no action, nothing to add

              iatREL8,
              iatIMM8:  // - - - - - - - - - - - - - - - - - - - - - - - - - - -
                If fParsingResult_Instr.Window.Position < Length(fParsingResult_Instr.Window.Data) then
                  begin
                    If Length(Identifiers) > 0 then
                      begin
                        // number is set by reference
                        SetLength(fParsingResult_Instr.Replacements,Length(fParsingResult_Instr.Replacements) + 1);
                        with fParsingResult_Instr.Replacements[High(fParsingResult_Instr.Replacements)] do
                          begin
                            Identifier := Identifiers[0];
                            ValType := DefinitiveType;
                            IsLabel := IsValidLabel(Identifier);
                            If IsLabel and (ValType <> iatREL8) then
                              AddErrorMessage('Label not allowed',0);
                            Position := fParsingResult_Instr.Window.Position;
                          end;
                      end
                    else
                      begin
                        // number is set explicitly
                        If (SmallInt(Data) > 255) or (SmallInt(Data) < -128) then
                          AddWarningMessage('Constant out of allowed range',0);
                        fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Data);
                      end;
                    Inc(fParsingResult_Instr.Window.Position);
                  end
                else AddErrorMessage('Argument cannot fit into instruction window',0);

              iatREL16,
              iatIMM16: // - - - - - - - - - - - - - - - - - - - - - - - - - - -
                If (fParsingResult_Instr.Window.Position + 1) < Length(fParsingResult_Instr.Window.Data) then
                  begin
                    If Length(Identifiers) > 0 then
                      begin
                        // number is set by reference
                        SetLength(fParsingResult_Instr.Replacements,Length(fParsingResult_Instr.Replacements) + 1);
                        with fParsingResult_Instr.Replacements[High(fParsingResult_Instr.Replacements)] do
                          begin
                            Identifier := Identifiers[0];
                            ValType := DefinitiveType;
                            IsLabel := IsValidLabel(Identifier);
                            If IsLabel and (ValType <> iatREL16) then
                              AddErrorMessage('Label not allowed',0);
                            Position := fParsingResult_Instr.Window.Position;
                          end;
                      end
                    else
                      begin
                        // number is set explicitly
                        fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Data);
                        fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + 1] := TSVCByte(Data shr 8);
                      end;
                    Inc(fParsingResult_Instr.Window.Position,2);
                  end
                else AddErrorMessage('Argument cannot fit into instruction window',0);

              iatREG8,
              iatREG16: // - - - - - - - - - - - - - - - - - - - - - - - - - - -
                If fParsingResult_Instr.Window.Position < Length(fParsingResult_Instr.Window.Data) then
                  begin
                    fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Data);
                    Inc(fParsingResult_Instr.Window.Position);
                  end
                else AddErrorMessage('Argument cannot fit into instruction window',0);

              iatMEM8,
              iatMEM16,
              iatMEM:   // - - - - - - - - - - - - - - - - - - - - - - - - - - -
                If (fParsingResult_Instr.Window.Position + AddressingModeLength(Memory.AddrMode)) <= Length(fParsingResult_Instr.Window.Data) then
                  begin
                    case Memory.AddrMode of
                          // base
                      0:  fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.BaseData);
                          // displacement
                      1:  StoreMemoryAddressingDisplacement(i,0);
                          // base + displacement
                      2:  begin
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.BaseData);
                            StoreMemoryAddressingDisplacement(i,1);
                          end;
                          // index * scale
                      3:  begin
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.IndexData);
                            StoreMemoryAddressingScale(i,1);
                          end;
                          // index * scale + displacement
                      4:  begin
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.IndexData);
                            StoreMemoryAddressingScale(i,1);
                            StoreMemoryAddressingDisplacement(i,2);
                          end;
                          // base + index
                      5:  begin
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.BaseData);
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + 1] := TSVCByte(Memory.IndexData);
                          end;
                          // base + index * scale
                      6:  begin
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.BaseData);
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + 1] := TSVCByte(Memory.IndexData);
                            StoreMemoryAddressingScale(i,2);
                          end;
                          // base + index * scale + displacement
                      7:  begin
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position] := TSVCByte(Memory.BaseData);
                            fParsingResult_Instr.Window.Data[fParsingResult_Instr.Window.Position + 1] := TSVCByte(Memory.IndexData);
                            StoreMemoryAddressingScale(i,2);
                            StoreMemoryAddressingDisplacement(i,3);
                          end;
                    else
                      AddErrorMessage('Syntax error',0);
                    end;
                    Inc(fParsingResult_Instr.Window.Position,AddressingModeLength(Memory.AddrMode));
                  end
                else AddErrorMessage('Argument cannot fit into instruction window',0);

            else {case-else}// - - - - - - - - - - - - - - - - - - - - - - - - -
              AddErrorMessage('Syntax error',0);
            end;

        // result is complete, pass it
        PassResult;
      finally
        fParsingStage_Instr := psiInitial;
      end
    else AddErrorMessage('Unfinished instruction',0); // stage <> stgFinal
  end
else AddErrorMessage('End of line expected but "%s" found',[fLexer[fTokenIndex].Str]);  
end;

//------------------------------------------------------------------------------

procedure TSVCParser_Instr.Parse_Stage_Instr;
begin
case fParsingStage_Instr of
  psiInitial:         Parse_Stage_Instr_Initial;
  psiPrefix:          Parse_Stage_Instr_Prefix;
  psiIntruction:      Parse_Stage_Instr_Intruction;
  psiModifier:        Parse_Stage_Instr_Modifier;
  psiArgument:        Parse_Stage_Instr_Argument;
  psiArgumentMem:     Parse_Stage_Instr_ArgumentMem;
  psiArgumentMemEnd:  Parse_Stage_Instr_ArgumentMemEnd;
  psiArgumentDelim:   Parse_Stage_Instr_ArgumentDelim;
  psiFinal:           Parse_Stage_Instr_Final;
else
  raise Exception.CreateFmt('TSVCParser_Instr.Parse_Stage_Instr: Invalid parsing stage (%d).',[Ord(fParsingStage_Label)]);
end;
end;

end.
