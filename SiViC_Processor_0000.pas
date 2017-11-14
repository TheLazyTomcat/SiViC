unit SiViC_Processor_0000;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Instructions,
  SiViC_Processor,
  SiViC_Processor_0000_03;

type
  TSVCProcessor_0000 = class(TSVCProcessor_0000_03)
  protected
    // instruction decoding
    procedure PrefixSelect(Prefix: TSVCInstructionPrefix); override;
  public
    class Function GetRevision: TSVCProcessorInfoData; override;
  end;

implementation

procedure TSVCProcessor_0000.PrefixSelect(Prefix: TSVCInstructionPrefix);
begin
with fCurrentInstruction do
  case Prefix of
    $E1:  begin                                         // REP
            Include(Prefixes,ipfxREP);
            Prefixes := Prefixes - [ipfxREPZ,ipfxREPNZ];
          end;
    $E2:  begin                                         // REP(Z/E)
            Include(Prefixes,ipfxREPZ);
            Prefixes := Prefixes - [ipfxREP,ipfxREPNZ];
          end;
    $E3:  begin                                         // REP(NZ/NE)
            Include(Prefixes,ipfxREPNZ);
            Prefixes := Prefixes - [ipfxREP,ipfxREPZ];
          end;
  else
    inherited PrefixSelect(Prefix);
  end;
end;

//==============================================================================

class Function TSVCProcessor_0000.GetRevision: TSVCProcessorInfoData;
begin
Result := 0;
end;

end.
