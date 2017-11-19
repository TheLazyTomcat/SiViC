unit SiViC_Program;

{$INCLUDE '.\SiViC_defs.inc'}

interface

{
  SVC file format:

    4B(UInt32)  - signature (SVCp - 0x70435653)
    4B(UInt32)  - structure version (0x00000000)

  For version 0 it continues as:

    4B(UInt32)  - stack size in bytes
    4B(UInt32)  - memory size in bytes
    4B(UInt32)  - non-volatile memory size in bytes
    4B(UInt32)  - required processor architecture
    4B(UInt32)  - required minimal processor revision
    4B(UInt32)  - required maximal processor revision
    4B(UInt32)  - size of code in bytes
    []TSVCByte  - code data
    4B(UInt32)  - count of of variable inits...

      2B(TSVCNative) - address where to copy data
      4B(UInt32)     - number of bytes to copy
      []TSVCByte     - data to be copied into memory
}

uses
  Classes,
  AuxTypes,
  SiViC_Common;

const
  SVC_PROGRAM_SVCFILE_MINSIZE   = 8{bytes};
  SVC_PROGRAM_SVCFILE_SIGNATURE = $70435653{SVCp};
  SVC_PROGRAM_SVCFILE_STRUCTDEF = 0;
  
  SVC_PROGRAM_SYSVALNAME_STACKSIZE = 'STACK_SIZE';
  SVC_PROGRAM_SYSVALNAME_MEMSIZE   = 'MEM_SIZE';
  SVC_PROGRAM_SYSVALNAME_NVMEMSIZE = 'NVMEM_SIZE';
  SVC_PROGRAM_SYSVALNAME_REQARCH   = 'REQ_ARCHITECTURE';
  SVC_PROGRAM_SYSVALNAME_REQMINREV = 'REQ_MIN_REVISION';
  SVC_PROGRAM_SYSVALNAME_REQMAXREV = 'REQ_MAX_REVISION';

type
  TSVCProgramSysVal = record
    Identifier: String;
    Value:      TSVCComp;
  end;

const
  SVC_PROGRAM_DEFAULTSYSVALS: array[0..5] of TSVCProgramSysVal = (
    (Identifier: SVC_PROGRAM_SYSVALNAME_STACKSIZE;  Value: 128),
    (Identifier: SVC_PROGRAM_SYSVALNAME_MEMSIZE;    Value: 256),
    (Identifier: SVC_PROGRAM_SYSVALNAME_NVMEMSIZE;  Value: 0),
    (Identifier: SVC_PROGRAM_SYSVALNAME_REQARCH;    Value: TSVCComp($000057C0)),
    (Identifier: SVC_PROGRAM_SYSVALNAME_REQMINREV;  Value: 0),
    (Identifier: SVC_PROGRAM_SYSVALNAME_REQMAXREV;  Value: TSVCComp($FFFFFFFF)));

type
  TSVCProgramVarInit = record
    Address:  TSVCNative;
    Data:     TSVCByteArray;
  end;

  TSVCProgramVarInits = record
    Arr:    array of TSVCProgramVarInit;
    Count:  Integer;
  end;

  TSVCProgram = class(TObject)
  private
    fProgramData:     Pointer;
    fProgramSize:     TMemSize;
    fVarInits:        TSVCProgramVarInits;
    fStackSize:       TMemSize;
    fMemSize:         TMemSize;
    fNVMemSize:       TMemSize;
    fReqArchitecture: TSVCNative;
    fReqMinRevision:  TSVCNative;
    fReqMaxRevision:  TSVCNative;
    procedure SetProgramSize(Value: TMemSize);
    Function GetVarInit(Index: Integer): TSVCProgramVarInit;
  protected
    procedure SaveStruct_00000000(Stream: TStream); virtual;
    procedure LoadStruct_00000000(Stream: TStream); virtual;
  public
    class Function IsProgram(Stream: TStream): Boolean; overload; virtual;
    class Function IsProgram(const FileName: String): Boolean; overload; virtual;
    constructor Create;
    destructor Destroy; override;
    Function AddVariableInit(Address: TSVCNative; Data: TSVCByteArray): Integer; virtual;
    procedure DeleteVariableInit(Index: Integer); virtual;
    procedure ClearVariableInit; virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
    property ProgramData: Pointer read fProgramData;
    property VariableInits[Index: Integer]: TSVCProgramVarInit read GetVarInit;
  published
    property ProgramSize: TMemSize read fProgramSize write SetProgramSize;
    property VariableInitCount: Integer read fVarInits.Count;
    property StackSize: TMemSize read fStackSize write fStackSize;
    property MemorySize: TMemSize read fMemSize write fMemSize;    
    property NVMemorySize: TMemSize read fNVMemSize write fNVMemSize;
    property RequiredArchitecture: TSVCNative read fReqArchitecture write fReqArchitecture;
    property RequiredMinRevision: TSVCNative read fReqMinRevision write fReqMinRevision;
    property RequiredMaxRevision: TSVCNative read fReqMaxRevision write fReqMaxRevision;
  end;

implementation

uses
  SysUtils,
  StrRect, BinaryStreaming;

procedure TSVCProgram.SetProgramSize(Value: TMemSize);
begin
If Value <> fProgramSize then
  begin
    fProgramSize := Value;
    ReallocMem(fProgramData,fProgramSize);
  end;
end;

//------------------------------------------------------------------------------

Function TSVCProgram.GetVarInit(Index: Integer): TSVCProgramVarInit;
begin
If (Index >= Low(fVarInits.Arr)) and (Index < fVarInits.Count) then
  Result := fVarInits.Arr[Index] 
else
  raise Exception.CreateFmt('TSVCProgram.GetVarInit: Index (%d) out of bounds.',[Index]);
end;

//==============================================================================

procedure TSVCProgram.SaveStruct_00000000(Stream: TStream);
var
  i:  Integer;
begin
Stream_WriteUInt32(Stream,UInt32(fStackSize));
Stream_WriteUInt32(Stream,UInt32(fMemSize));
Stream_WriteUInt32(Stream,UInt32(fNVMemSize));
Stream_WriteUInt32(Stream,UInt32(fReqArchitecture));
Stream_WriteUInt32(Stream,UInt32(fReqMinRevision));
Stream_WriteUInt32(Stream,UInt32(fReqMaxRevision));
Stream_WriteUInt32(Stream,UInt32(fProgramSize));
Stream_WriteBuffer(Stream,fProgramData^,fProgramSize);
Stream_WriteUInt32(Stream,UInt32(fVarInits.Count));
For i := Low(fVarInits.Arr) to Pred(fVarInits.Count) do
  begin
    Stream_WriteUInt16(Stream,UInt16(fVarInits.Arr[i].Address));
    Stream_WriteUInt16(Stream,UInt16(Length(fVarInits.Arr[i].Data)));
    Stream_WriteBytes(Stream,fVarInits.Arr[i].Data);
  end;
end;

//------------------------------------------------------------------------------

procedure TSVCProgram.LoadStruct_00000000(Stream: TStream);
var
  i,j:  Integer;
  Addr: TSVCNative;
  Temp: TSVCByteArray;
begin
fStackSize := TMemSize(Stream_ReadUInt32(Stream));
fMemSize := TMemSize(Stream_ReadUInt32(Stream));
fNVMemSize := TMemSize(Stream_ReadUInt32(Stream));
fReqArchitecture := TMemSize(Stream_ReadUInt32(Stream));
fReqMinRevision := TMemSize(Stream_ReadUInt32(Stream));
fReqMaxRevision := TMemSize(Stream_ReadUInt32(Stream));
SetProgramSize(TMemSize(Stream_ReadUInt32(Stream)));
Stream_ReadBuffer(Stream,fProgramData^,fProgramSize);
ClearVariableInit;
For i := 0 to Pred(Integer(Stream_ReadUInt32(Stream))) do
  begin
    Addr := TSVCNative(Stream_ReadUInt16(Stream));
    SetLength(Temp,Stream_ReadUInt16(Stream));
    For j := Low(Temp) to High(Temp) do
      Temp[j] := TSVCByte(Stream_ReadUInt8(Stream));
    AddVariableInit(Addr,Temp);  
  end;
end;

//==============================================================================

class Function TSVCProgram.IsProgram(Stream: TStream): Boolean;
begin
Result := Stream_ReadUInt32(Stream,False) = SVC_PROGRAM_SVCFILE_SIGNATURE;
end;

//------------------------------------------------------------------------------

class Function TSVCProgram.IsProgram(const FileName: String): Boolean;
var
  FileStream: TFileStream;
begin
FileStream := TFileStream.Create(StrToRTL(FileName),fmOpenRead or fmShareDenyWrite);
try
  Result := IsProgram(FileStream);
finally
  FileStream.Free;
end;
end;

//------------------------------------------------------------------------------

constructor TSVCProgram.Create;
begin
inherited;
SetProgramSize(0);
end;

//------------------------------------------------------------------------------

destructor TSVCProgram.Destroy;
begin
FreeMem(fProgramData,fProgramSize);
inherited;
end;

//------------------------------------------------------------------------------

Function TSVCProgram.AddVariableInit(Address: TSVCNative; Data: TSVCByteArray): Integer;
begin
If Length(Data) <= High(TSVCNative) then
  begin
    If fVarInits.Count >= Length(fVarInits.Arr) then
      SetLength(fVarInits.Arr,Length(fVarInits.Arr) + 32);
    fVarInits.Arr[fVarInits.Count].Address := Address;
    fVarInits.Arr[fVarInits.Count].Data := Data;
    Result := fVarInits.Count;
    Inc(fVarInits.Count);
  end
else raise Exception.Create('TSVCProgram.AddVariableInit: Too much data');
end;

//------------------------------------------------------------------------------

procedure TSVCProgram.DeleteVariableInit(Index: Integer);
var
  i:  Integer;
begin
If (Index >= Low(fVarInits.Arr)) and (Index < fVarInits.Count) then
  begin
    For i := Index to Pred(High(fVarInits.Count)) do
      fVarInits.Arr[i] := fVarInits.Arr[i + 1];
    Dec(fVarInits.Count);
  end
else raise Exception.CreateFmt('TSVCProgram.GetVarInit: Index (%d) out of bounds.',[Index]);
end;

//------------------------------------------------------------------------------

procedure TSVCProgram.ClearVariableInit;
var
  i:  Integer;
begin
For i := Low(fVarInits.Arr) to Pred(fVarInits.Count) do
  SetLength(fVarInits.Arr[i].Data,0);
fVarInits.Count := 0;
end;

//------------------------------------------------------------------------------

procedure TSVCProgram.SaveToStream(Stream: TStream);
begin
Stream_WriteUInt32(Stream,SVC_PROGRAM_SVCFILE_SIGNATURE);
Stream_WriteUInt32(Stream,SVC_PROGRAM_SVCFILE_STRUCTDEF);
case SVC_PROGRAM_SVCFILE_STRUCTDEF of
  0:  SaveStruct_00000000(Stream);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProgram.LoadFromStream(Stream: TStream);
var
  Signature:  UInt32;
  Version:    UInt32;
begin
If (Stream.Size - Stream.Position) >= SVC_PROGRAM_SVCFILE_MINSIZE then
  begin
    Signature := Stream_ReadUInt32(Stream);
    If Signature <> SVC_PROGRAM_SVCFILE_SIGNATURE then
      raise Exception.CreateFmt('TSVCProgram.LoadFromStream: Unknonw file format (0x%.8x).',[Signature]);
    Version := Stream_ReadUInt32(Stream);
    case Version of
      0:  LoadStruct_00000000(Stream);
    else
      raise Exception.CreateFmt('TSVCProgram.LoadFromStream: Unknonw structure (0x%.8x).',[Version]);
    end;
  end
else raise Exception.CreateFmt('TSVCProgram.LoadFromStream: File is too small (%d bytes).',[Stream.Size - Stream.Position]);
end;

//------------------------------------------------------------------------------

procedure TSVCProgram.SaveToFile(const FileName: String);
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

procedure TSVCProgram.LoadFromFile(const FileName: String);
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
