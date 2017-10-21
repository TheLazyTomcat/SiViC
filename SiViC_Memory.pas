unit SiViC_Memory;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  AuxTypes,
  SiViC_Common;

type
  TSVCMemory = class(TObject)
  private
    fMemory:  Pointer;
    fSize:    TMemSize;
  public
    constructor Create(Size: TMemSize);
    destructor Destroy; override;
    Function AddrPtr(Address: TSVCNative): Pointer; virtual;
    Function IsValidAddr(Address: TSVCNative): Boolean; virtual;
    Function IsValidArea(Address,Size: TSVCNative): Boolean; virtual;
    procedure CopyMemoryArea(Address,Size: TSVCNative; out Buff); virtual;
    Function FetchMemoryArea(Address,Size: TSVCNative; out Buff): TSVCNative; virtual;
    property Memory: Pointer read fMemory;
  published
    property Size: TMemSize read fSize;
  end;

implementation

uses
  SysUtils;

constructor TSVCMemory.Create(Size: TMemSize);
begin
inherited Create;
GetMem(fMemory,Size);
fSize := Size;
FillChar(fMemory^,fSize,0);
end;

//------------------------------------------------------------------------------

destructor TSVCMemory.Destroy;
begin
FreeMem(fMemory,fSize);
inherited;
end;

//------------------------------------------------------------------------------

Function TSVCMemory.AddrPtr(Address: TSVCNative): Pointer;
begin
Result := {%H-}Pointer({%H-}PtrUInt(fMemory) + Address);
end;

//------------------------------------------------------------------------------

Function TSVCMemory.IsValidAddr(Address: TSVCNative): Boolean;
begin
Result := TMemSize(Address) < fSize;
end;

//------------------------------------------------------------------------------

Function TSVCMemory.IsValidArea(Address,Size: TSVCNative): Boolean;
begin
Result := (TSVCComp(Address) + TSVCComp(Size) <= (TSVCComp(High(TSVCNative)) + 1)) and
          (TMemSize(Address) + TMemSize(Size) <= fSize);
end;

//------------------------------------------------------------------------------

procedure TSVCMemory.CopyMemoryArea(Address,Size: TSVCNative; out Buff);
begin
If IsValidArea(Address,Size) then
  Move(AddrPtr(Address)^,{%H-}Buff,Size)
else
  raise Exception.Create('TSVCMemory.CopyMemory: Out of memory bounds.');
end;

//------------------------------------------------------------------------------

Function TSVCMemory.FetchMemoryArea(Address,Size: TSVCNative; out Buff): TSVCNative;
var
  MemTop: TMemSize;
begin
If IsValidArea(Address,Size) then
  begin
    Move(AddrPtr(Address)^,{%H-}Buff,Size);
    Result := Size;
  end
else
  begin
    FillChar(Buff,Size,0);
    MemTop := MemMin(TMemSize(High(TSVCNative)) + 1,fSize);
    If TMemSize(Address) < MemTop then
      begin
        Result := TSVCNative(MemTop - TMemSize(Address));
        Move(AddrPtr(Address)^,Buff,Result);
      end
    else Result := 0;
  end;
end;

end.
