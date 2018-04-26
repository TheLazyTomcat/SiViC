unit SiViC_Memory;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  Classes,
  AuxTypes,
  SiViC_Common;

type
  TSVCMemoryAccessEvent = procedure(Sender: TObject; Address: TSVCNative) of object;

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
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TSTream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
    property Memory: Pointer read fMemory;
  published
    property Size: TMemSize read fSize;
  end;

implementation

uses
  SysUtils,
  StrRect;

{$IFDEF FPC_DisableWarns}
  {$WARN 4055 OFF} // Conversion between ordinals and pointers is not portable
  {$WARN 5058 OFF} // Variable "$1" does not seem to be initialized
{$ENDIF}

constructor TSVCMemory.Create(Size: TMemSize);
begin
inherited Create;
If Size > TMemSize(High(TSVCNative) + 1) then
  fSize := TMemSize(High(TSVCNative) + 1)
else
  fSize := (Size + 255) and not TMemSize($FF);
GetMem(fMemory,fSize);
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
Result := Pointer(PtrUInt(fMemory) + Address);
end;

//------------------------------------------------------------------------------

Function TSVCMemory.IsValidAddr(Address: TSVCNative): Boolean;
begin
Result := TMemSize(Address) <= fSize;
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
  Move(AddrPtr(Address)^,Buff,Size)
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
    Move(AddrPtr(Address)^,Buff,Size);
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

//------------------------------------------------------------------------------

procedure TSVCMemory.SaveToStream(Stream: TStream);
begin
Stream.WriteBuffer(fMemory^,fSize);
end;

//------------------------------------------------------------------------------

procedure TSVCMemory.LoadFromStream(Stream: TSTream);
begin
FillChar(fMemory^,fSize,0);
Stream.Read(fMemory^,fSize);
end;

//------------------------------------------------------------------------------

procedure TSVCMemory.SaveToFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(StrToRTL(FileName),fmCreate or fmShareDenyWrite);
try
  SaveToStream(FileStream);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

procedure TSVCMemory.LoadFromFile(const FileName: String);
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(StrToRTL(FileName),fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(FileStream);
finally
  FileStream.Free;
end;
end;

end.
