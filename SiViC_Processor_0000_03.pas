unit SiViC_Processor_0000_03;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common,
  SiViC_Processor_0000_02;

type
  TSVCProcessor_0000_03 = class(TSVCProcessor_0000_02)
  protected
    // repeat prefix helpers
    Function RepeatPrefixActive: Boolean; virtual;
    Function RepeatNextCycle: Boolean; virtual;
    // instruction decoding
    procedure InstructionSelect_L1(InstructionByte: TSVCByte); override;
    procedure InstructionSelect_L2_D2(InstructionByte: TSVCByte); virtual;
    // string manipulation instructions
    procedure Instruction_D2_01; virtual; // LODSB      reg8,   reg16
    procedure Instruction_D2_02; virtual; // LODSW      reg16,  reg16
    procedure Instruction_D2_03; virtual; // STOSB      reg16,  reg8
    procedure Instruction_D2_04; virtual; // STOSW      reg16,  reg16
    procedure Instruction_D2_05; virtual; // MOVSB      reg16,  reg16
    procedure Instruction_D2_06; virtual; // MOVSW      reg16,  reg16
    procedure Instruction_D2_07; virtual; // LOADSB     reg16,  reg16
    procedure Instruction_D2_08; virtual; // LOADSW     reg16,  reg16
    procedure Instruction_D2_09; virtual; // STORESB    reg16,  reg16
    procedure Instruction_D2_0A; virtual; // STORESW    reg16,  reg16
    procedure Instruction_D2_0B; virtual; // CMPSB      reg16,  reg16
    procedure Instruction_D2_0C; virtual; // CMPSW      reg16,  reg16
    procedure Instruction_D2_0D; virtual; // SCASB      reg8,   reg16
    procedure Instruction_D2_0E; virtual; // SCASW      reg16,  reg16
    procedure Instruction_D2_0F; virtual; // INSB       reg16,  imm8
    procedure Instruction_D2_10; virtual; // INSW       reg16,  imm8
    procedure Instruction_D2_11; virtual; // INSB       reg16,  reg8
    procedure Instruction_D2_12; virtual; // INSW       reg16,  reg8
    procedure Instruction_D2_13; virtual; // OUTSB      imm8,   reg16
    procedure Instruction_D2_14; virtual; // OUTSW      imm8,   reg16
    procedure Instruction_D2_15; virtual; // OUTSB      reg8,   reg16
    procedure Instruction_D2_16; virtual; // OUTSW      reg8,   reg16
  end;

implementation

uses
  SiViC_Registers,
  SiViC_Instructions,
  SiViC_Interrupts,
  SiViC_IO;

procedure TSVCProcessor_0000_03.InstructionSelect_L1(InstructionByte: TSVCByte);
begin
case InstructionByte of
  // continuous instructions
  $D2:  InstructionDecode(InstructionSelect_L2_D2,2);
else
  inherited InstructionSelect_L1(InstructionByte);
end;
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.InstructionSelect_L2_D2(InstructionByte: TSVCByte);
begin
case InstructionByte of
  $00:  fCurrentInstruction.InstructionHandler := Instruction_00;     // HALT
  $01:  fCurrentInstruction.InstructionHandler := Instruction_D2_01;  // LODSB      reg8,   reg16
  $02:  fCurrentInstruction.InstructionHandler := Instruction_D2_02;  // LODSW      reg16,  reg16
  $03:  fCurrentInstruction.InstructionHandler := Instruction_D2_03;  // STOSB      reg16,  reg8
  $04:  fCurrentInstruction.InstructionHandler := Instruction_D2_04;  // STOSW      reg16,  reg16
  $05:  fCurrentInstruction.InstructionHandler := Instruction_D2_05;  // MOVSB      reg16,  reg16
  $06:  fCurrentInstruction.InstructionHandler := Instruction_D2_06;  // MOVSW      reg16,  reg16
  $07:  fCurrentInstruction.InstructionHandler := Instruction_D2_07;  // LOADSB     reg16,  reg16
  $08:  fCurrentInstruction.InstructionHandler := Instruction_D2_08;  // LOADSW     reg16,  reg16
  $09:  fCurrentInstruction.InstructionHandler := Instruction_D2_09;  // STORESB    reg16,  reg16
  $0A:  fCurrentInstruction.InstructionHandler := Instruction_D2_0A;  // STORESW    reg16,  reg16
  $0B:  fCurrentInstruction.InstructionHandler := Instruction_D2_0B;  // CMPSB      reg16,  reg16
  $0C:  fCurrentInstruction.InstructionHandler := Instruction_D2_0C;  // CMPSW      reg16,  reg16
  $0D:  fCurrentInstruction.InstructionHandler := Instruction_D2_0D;  // SCASB      reg8,   reg16
  $0E:  fCurrentInstruction.InstructionHandler := Instruction_D2_0E;  // SCASW      reg16,  reg16
  $0F:  fCurrentInstruction.InstructionHandler := Instruction_D2_0F;  // INSB       reg16,  imm8
  $10:  fCurrentInstruction.InstructionHandler := Instruction_D2_10;  // INSW       reg16,  imm8
  $11:  fCurrentInstruction.InstructionHandler := Instruction_D2_11;  // INSB       reg16,  reg8
  $12:  fCurrentInstruction.InstructionHandler := Instruction_D2_12;  // INSW       reg16,  reg8
  $13:  fCurrentInstruction.InstructionHandler := Instruction_D2_13;  // OUTSB      imm8,   reg16
  $14:  fCurrentInstruction.InstructionHandler := Instruction_D2_14;  // OUTSW      imm8,   reg16
  $15:  fCurrentInstruction.InstructionHandler := Instruction_D2_15;  // OUTSB      reg8,   reg16
  $16:  fCurrentInstruction.InstructionHandler := Instruction_D2_16;  // OUTSW      reg8,   reg16
else
  raise ESVCInterruptException.Create(SVC_EXCEPTION_INVALIDINSTRUCTION);
end;
end;

//==============================================================================

Function TSVCProcessor_0000_03.RepeatPrefixActive: Boolean;
begin
Result := (ipfxREP   in fCurrentInstruction.Prefixes) or
          (ipfxREPZ  in fCurrentInstruction.Prefixes) or
          (ipfxREPNZ in fCurrentInstruction.Prefixes);
end;

//------------------------------------------------------------------------------

Function TSVCProcessor_0000_03.RepeatNextCycle: Boolean;
begin
fRegisters.CNTR := TSVCNative(TSVCComp(fRegisters.CNTR) - 1);
If ipfxREPZ in fCurrentInstruction.Prefixes then
  Result := not GetFlag(SVC_REG_FLAGS_ZERO)
else If ipfxREPNZ in fCurrentInstruction.Prefixes then
  Result := GetFlag(SVC_REG_FLAGS_ZERO)
else
  Result := True;
end;

//==============================================================================

procedure TSVCProcessor_0000_03.Instruction_D2_01;   // LODSB      reg8,   reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        TSVCByte(GetArgPtr(0)^) := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_02;   // LODSW      reg16,  reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        TSVCWord(GetArgPtr(0)^) := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_03;   // STOSB      reg16,  reg8
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}
  LowAddr:      TSVCComp;

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(GetArgVal(1));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          LowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE)
        else
          LowAddr := GetArgVal(0);
        If (LowAddr >= 0) and fMemory.IsValidArea(TSVCNative(LowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
          {$IFDEF SVC_Debug}
            MemAccessed := True;
          {$ENDIF SVC_Debug}
            FillChar(fMemory.AddrPtr(TSVCNative(LowAddr))^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE,TSVCByte(GetArgVal(1)));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr - SVC_SZ_BYTE)
            else
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(LowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryWriteEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_04;   // STOSW      reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}
  LowAddr:      TSVCComp;

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(GetArgVal(1));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) and (TSVCByte(GetArgVal(1)) = TSVCByte(GetArgVal(1) shr 8)) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          LowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD)
        else
          LowAddr := GetArgVal(0);
        If (LowAddr >= 0) and fMemory.IsValidArea(TSVCNative(LowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
          {$IFDEF SVC_Debug}
            MemAccessed := True;
          {$ENDIF SVC_Debug}
            FillChar(fMemory.AddrPtr(TSVCNative(LowAddr))^,TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD,TSVCByte(GetArgVal(1)));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr - SVC_SZ_WORD)
            else
              TSVCNative(GetArgPtr(0)^) := TSVCNative(LowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(LowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryWriteEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_05;   // MOVSB      reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  SrcMemAddr:   TSVCNative;
  DstMemAddr:   TSVCNative;
{$ENDIF SVC_Debug}
  SrcLowAddr:   TSVCComp;
  DstLowAddr:   TSVCComp;

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
SrcMemAddr := GetArgVal(1);
DstMemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
              begin
              {$IFDEF SVC_Debug}
                MemAccessed := True;
              {$ENDIF SVC_Debug}
                Move(fMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_BYTE);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_BYTE);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoMemoryReadEvent(SrcMemAddr);
    DoMemoryWriteEvent(DstMemAddr);
  end;
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_06;   // MOVSW      reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  SrcMemAddr:   TSVCNative;
  DstMemAddr:   TSVCNative;
{$ENDIF SVC_Debug}
  SrcLowAddr:   TSVCComp;
  DstLowAddr:   TSVCComp;

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
SrcMemAddr := GetArgVal(1);
DstMemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
              begin
              {$IFDEF SVC_Debug}
                MemAccessed := True;
              {$ENDIF SVC_Debug}
                Move(fMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_WORD);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_WORD);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoMemoryReadEvent(SrcMemAddr);
    DoMemoryWriteEvent(DstMemAddr);
  end; 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_07;   // LOADSB     reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  SrcMemAddr:   TSVCNative;
  DstMemAddr:   TSVCNative;
{$ENDIF SVC_Debug}
  SrcLowAddr:   TSVCComp; // vn-mem
  DstLowAddr:   TSVCComp; // ram

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fNVMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fNVMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
SrcMemAddr := GetArgVal(1);
DstMemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
              begin
              {$IFDEF SVC_Debug}
                MemAccessed := True;
              {$ENDIF SVC_Debug}
                Move(fNVMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_BYTE);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_BYTE);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoNVMemoryReadEvent(SrcMemAddr);
    DoMemoryWriteEvent(DstMemAddr);
  end;
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_08;   // LOADSW     reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  SrcMemAddr:   TSVCNative;
  DstMemAddr:   TSVCNative;
{$ENDIF SVC_Debug}
  SrcLowAddr:   TSVCComp; // vn-mem
  DstLowAddr:   TSVCComp; // ram

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fNVMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fNVMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
SrcMemAddr := GetArgVal(1);
DstMemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            If (DstLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
              begin
              {$IFDEF SVC_Debug}
                MemAccessed := True;
              {$ENDIF SVC_Debug}  
                Move(fNVMemory.AddrPtr(SrcLowAddr)^,fMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_WORD);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_WORD);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(DstLowAddr));  
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoNVMemoryReadEvent(SrcMemAddr);
    DoMemoryWriteEvent(DstMemAddr);
  end;
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_09;   // STORESB    reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  SrcMemAddr:   TSVCNative;
  DstMemAddr:   TSVCNative;
{$ENDIF SVC_Debug}
  SrcLowAddr:   TSVCComp; // ram
  DstLowAddr:   TSVCComp; // nv-mem

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fNVMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            TSVCByte(fNVMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
SrcMemAddr := GetArgVal(1);
DstMemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_BYTE);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
          begin
            If (DstLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE)) then
              begin
              {$IFDEF SVC_Debug}
                MemAccessed := True;
              {$ENDIF SVC_Debug}
                Move(fMemory.AddrPtr(SrcLowAddr)^,fNVMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_BYTE);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_BYTE);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(DstLowAddr));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoMemoryReadEvent(SrcMemAddr);
    DoNVMemoryWriteEvent(DstMemAddr);
  end;
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_0A;   // STORESW    reg16,  reg16
var
{$IFDEF SVC_Debug}
  MemAccessed:  Boolean;
  SrcMemAddr:   TSVCNative;
  DstMemAddr:   TSVCNative;
{$ENDIF SVC_Debug}
  SrcLowAddr:   TSVCComp; // ram
  DstLowAddr:   TSVCComp; // nv-mem

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fNVMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            TSVCWord(fNVMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
SrcMemAddr := GetArgVal(1);
DstMemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  begin
    If GetCRFlag(SVC_REG_CR_FASTSTRING) and (fRegisters.CNTR > 1) then
      begin
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          begin
            SrcLowAddr := TSVCComp(GetArgVal(1)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
            DstLowAddr := TSVCComp(GetArgVal(0)) - (TSVCComp(Pred(fRegisters.CNTR)) * SVC_SZ_WORD);
          end
        else
          begin
            SrcLowAddr := GetArgVal(1);
            DstLowAddr := GetArgVal(0);
          end;
        If (SrcLowAddr >= 0) and fMemory.IsValidArea(TSVCNative(SrcLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
          begin
            If (DstLowAddr >= 0) and fNVMemory.IsValidArea(TSVCNative(DstLowAddr),TSVCNative(TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD)) then
              begin
              {$IFDEF SVC_Debug}
                MemAccessed := True;
              {$ENDIF SVC_Debug}  
                Move(fMemory.AddrPtr(SrcLowAddr)^,fNVMemory.AddrPtr(DstLowAddr)^,TSVCComp(fRegisters.CNTR) * SVC_SZ_BYTE);
                If GetFlag(SVC_REG_FLAGS_DIRECTION) then
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr - SVC_SZ_WORD);
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr - SVC_SZ_WORD);
                  end
                else
                  begin
                    TSVCNative(GetArgPtr(1)^) := TSVCNative(SrcLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                    TSVCNative(GetArgPtr(0)^) := TSVCNative(DstLowAddr + (TSVCComp(fRegisters.CNTR) * SVC_SZ_WORD));
                  end;
              end
            else raise ESVCInterruptException.Create(SVC_EXCEPTION_NVMEMORYACCESS,TSVCNative(DstLowAddr));
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,TSVCNative(SrcLowAddr));
        fRegisters.CNTR := 0;
      end
    else
      while fRegisters.CNTR > 0 do begin
        InstructionCycle;
        If not RepeatNextCycle then
          Break{while...};
      end;
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoMemoryReadEvent(SrcMemAddr);
    DoNVMemoryWriteEvent(DstMemAddr);
  end; 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_0B;   // CMPSB      reg16,  reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr1:     TSVCNative;
  MemAddr2:     TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True; 
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
          begin
            FlaggedSUB_B(TSVCByte(fMemory.AddrPtr(GetArgVal(0))^),TSVCByte(fMemory.AddrPtr(GetArgVal(1))^));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr1 := GetArgVal(1);
MemAddr2 := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoMemoryReadEvent(MemAddr1);
    DoMemoryReadEvent(MemAddr2);
  end;
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_0C;   // CMPSW      reg16,  reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr1:     TSVCNative;
  MemAddr2:     TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
          begin
            FlaggedSUB_W(TSVCWord(fMemory.AddrPtr(GetArgVal(0))^),TSVCWord(fMemory.AddrPtr(GetArgVal(1))^));
            If GetFlag(SVC_REG_FLAGS_DIRECTION) then
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD);
              end
            else
              begin
                TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
                TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
              end;
          end
        else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr1 := GetArgVal(1);
MemAddr2 := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  begin
    DoMemoryReadEvent(MemAddr1);
    DoMemoryReadEvent(MemAddr2);
  end;
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_0D;   // SCASB      reg8,   reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        FlaggedSUB_B(TSVCByte(GetArgVal(0)),TSVCByte(fMemory.AddrPtr(GetArgVal(1))^));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_0E;   // SCASW      reg16,  reg16 
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        FlaggedSUB_W(TSVCWord(GetArgVal(0)),TSVCWord(fMemory.AddrPtr(GetArgVal(1))^));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_0F;   // INSB       reg16,  imm8
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryWriteEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_10;   // INSW       reg16,  imm8
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatIMM8]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryWriteEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_11;   // INSB       reg16,  reg8
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_BYTE) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCByte(fMemory.AddrPtr(GetArgVal(0))^) := TSVCByte(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryWriteEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_12;   // INSW       reg16,  reg8
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(0),SVC_SZ_WORD) then
      begin
        PortRequested(TSVCPortIndex(GetArgVal(1)));
        TSVCWord(fMemory.AddrPtr(GetArgVal(0))^) := TSVCWord(fPorts[TSVCPortIndex(GetArgVal(1))].Data);
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(0)^) := TSVCNative(TSVCComp(GetArgVal(0)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(0));
  end;

begin
ArgumentsDecode(False,[iatREG16,iatREG8]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(0);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryWriteEvent(MemAddr); 
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_13;   // OUTSB      imm8,   reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative; 
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatIMM8,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_14;   // OUTSW      imm8,   reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True; 
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatIMM8,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_15;   // OUTSB      reg8,   reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}

  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_BYTE) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCByte(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_BYTE)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_BYTE);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

//------------------------------------------------------------------------------

procedure TSVCProcessor_0000_03.Instruction_D2_16;   // OUTSW      reg8,   reg16
{$IFDEF SVC_Debug}
var
  MemAccessed:  Boolean;
  MemAddr:      TSVCNative;
{$ENDIF SVC_Debug}
  
  procedure InstructionCycle;
  begin
  {$IFDEF SVC_Debug}
    MemAccessed := True;
  {$ENDIF SVC_Debug}
    If fMemory.IsValidArea(GetArgVal(1),SVC_SZ_WORD) then
      begin
        fPorts[TSVCPortIndex(GetArgVal(0))].Data := TSVCWord(fMemory.AddrPtr(GetArgVal(1))^);
        PortUpdated(TSVCPortIndex(GetArgVal(0)));
        If GetFlag(SVC_REG_FLAGS_DIRECTION) then
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) - SVC_SZ_WORD)
        else
          TSVCNative(GetArgPtr(1)^) := TSVCNative(TSVCComp(GetArgVal(1)) + SVC_SZ_WORD);
      end
    else raise ESVCInterruptException.Create(SVC_EXCEPTION_MEMORYACCESS,GetArgVal(1));
  end;

begin
ArgumentsDecode(False,[iatREG8,iatREG16]);
{$IFDEF SVC_Debug}
MemAccessed := False;
MemAddr := GetArgVal(1);
{$ENDIF SVC_Debug}
If RepeatPrefixActive then
  while fRegisters.CNTR > 0 do begin
    InstructionCycle;
    If not RepeatNextCycle then
      Break{while...};
  end
else InstructionCycle;
{$IFDEF SVC_Debug}
If MemAccessed then
  DoMemoryReadEvent(MemAddr);
{$ENDIF SVC_Debug}
end;

end.
