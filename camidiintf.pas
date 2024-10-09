unit caMidiIntf;

interface

uses
  Classes, SysUtils, caMidiTypes;

type
  IcaMidiInterface = interface
    procedure GetDevices(InOut: TcaMidiInOut; Devices: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil);
    procedure SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil);
  end;

var
  Midi: IcaMidiInterface;

implementation

end.


