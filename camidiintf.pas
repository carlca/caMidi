unit caMidiIntf;

interface

uses
  Classes, SysUtils, caMidiTypes;

type
  IcaMidiInterface = interface
    function SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil): boolean;
    function SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil): boolean;
    procedure GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
  end;

var
  Midi: IcaMidiInterface;

implementation

end.


