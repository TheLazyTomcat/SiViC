unit SiViC_Common;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  AuxTypes;

type
  TSVCValueSize = (vsUndefined,vsByte,vsWord,vsLong,vsQuad,vsNative = vsWord{%H-});

  // basic integer types
  TSVCUByte = UInt8;        TSVCByte = TSVCUByte;
  TSVCSByte = Int8;
  TSVCUWord = UInt16;       TSVCWord = TSVCUWord;
  TSVCSWord = Int16;
  TSVCULong = UInt32;       TSVCLong = TSVCULong;
  TSVCSLong = Int32;
  TSVCUQuad = UInt64;       TSVCQuad = TSVCUQuad;
  TSVCSQuad = Int64;

  // native integers (width of a register)
  TSVCUNative = TSVCUWord;  TSVCNative = TSVCUNative;
  TSVCSNative = TSVCSWord;

  // smallest signed integer larger than native (used for computations on natives)
  TSVCComp = TSVCSLong;

  // some other integer types
  TSVCRel8   = TSVCSByte;
  TSVCRel16  = TSVCSWord;
  TSVCRel32  = TSVCSLong;
  TSVCRel64  = TSVCSQuad;
  TSVCNumber = TSVCSLong;

  // dynamic array types
  TSVCByteArray   = array of TSVCByte;
  TSVCWordArray   = array of TSVCWord;
  TSVCNativeArray = array of TSVCNative;

const
  SVC_SZ_BYTE   = SizeOf(TSVCByte);
  SVC_SZ_WORD   = SizeOf(TSVCWord);
  SVC_SZ_LONG   = SizeOf(TSVCLong);
  SVC_SZ_QUAD   = SizeOf(TSVCQuad);
  SVC_SZ_NATIVE = SizeOf(TSVCNative);

Function ByteParity(Value: TSVCByte): Boolean;
Function WordParity(Value: TSVCWord): Boolean;

Function IntMin(A,B: Integer): Integer;{$IFDEF CanInline} inline;{$ENDIF}
Function MemMin(A,B: TMemSize): TMemSize;{$IFDEF CanInline} inline;{$ENDIF}

Function BoolToByte(Val: Boolean): TSVCByte;{$IFDEF CanInline} inline;{$ENDIF}

Function ValueSize(ValueSize: TSVCValueSize): TSVCNumber;

procedure AddToArray(var Arr: TSVCByteArray; const Data; Size: TSVCNative);

type
  TSVCCharSet = set of AnsiChar;

Function CharInSet(C: AnsiChar; const CharSet: TSVCCharSet): Boolean; overload;{$IFDEF CanInline} inline;{$ENDIF}
Function CharInSet(C: WideChar; const CharSet: TSVCCharSet): Boolean; overload;{$IFDEF CanInline} inline;{$ENDIF}

implementation

Function ByteParity(Value: TSVCByte): Boolean;
begin
Value := Value xor (Value shr 4);
Value := Value xor (Value shr 2);
Value := Value xor (Value shr 1);
Result := (Value and 1) = 0; 
end;

//------------------------------------------------------------------------------

Function WordParity(Value: TSVCWord): Boolean;
begin
Value := Value xor (Value shr 8);
Value := Value xor (Value shr 4);
Value := Value xor (Value shr 2);
Value := Value xor (Value shr 1);
Result := (Value and 1) = 0;
end;

//------------------------------------------------------------------------------

Function IntMin(A,B: Integer): Integer;
begin
If A > B then Result := B
  else Result := A;
end;

//------------------------------------------------------------------------------

Function MemMin(A,B: TMemSize): TMemSize;
begin
If A > B then Result := B
  else Result := A;
end;

//------------------------------------------------------------------------------

Function BoolToByte(Val: Boolean): TSVCByte;
begin
If Val then Result := 1
  else Result := 0;
end;

//------------------------------------------------------------------------------

Function ValueSize(ValueSize: TSVCValueSize): TSVCNumber;
begin
case ValueSize of
  vsByte: Result := SVC_SZ_BYTE;
  vsWord: Result := SVC_SZ_WORD;
  vsLong: Result := SVC_SZ_LONG;
  vsQuad: Result := SVC_SZ_QUAD;
else
  Result := 0;
end;
end;

//------------------------------------------------------------------------------

procedure AddToArray(var Arr: TSVCByteArray; const Data; Size: TSVCNative);
var
  i:  Integer;
begin
If size > 0 then
  begin
    SetLength(Arr,Length(Arr) + Size);
    For i := 0 to Pred(Size) do
      Arr[Length(Arr) - Size + i] := TSVCByte(Pointer(PtrUInt(Addr(Data)) + PtrUInt(i))^);
  end;
end;

//------------------------------------------------------------------------------

Function CharInSet(C: AnsiChar; const CharSet: TSVCCharSet): Boolean; overload;
begin
Result := C in CharSet;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Function CharInSet(C: WideChar; const CharSet: TSVCCharSet): Boolean; overload;
begin
If Ord(C) <= 255 then
  Result := AnsiChar(C) in CharSet
else
  Result := False;
end;

end.
