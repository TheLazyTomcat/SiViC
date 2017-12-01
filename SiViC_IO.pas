unit SiViC_IO;

{$INCLUDE '.\SiViC_defs.inc'}

interface

uses
  SiViC_Common;

type
  TSVCPortIndex = TSVCByte;

  TSVCPortEvent = procedure(Sender: TObject; PortIndex: TSVCPortIndex; var Data: TSVCNative) of object;

  TSVCPort = record
    Data:       TSVCNative;
    InHandler:  TSVCPortEvent;
    OutHandler: TSVCPortEvent;
    Connected:  Boolean;
  end;

  TSVCPorts = array[TSVCPortIndex] of TSVCPort;

//implement simple console as an example

implementation

end.
