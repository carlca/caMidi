unit caMidiIntf;

interface

uses
  Classes, SysUtils, caMidiTypes;

type
  IcaMidiInterface = interface
    procedure GetDevices(InOut: TcaMidiInOut; Devices: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings);
    procedure SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings);
  end;

var
  Midi: IcaMidiInterface;

implementation

end.


