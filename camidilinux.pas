unit caMidiLinux;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, caMidiIntf, caMidiTypes,
  {$IFDEF DARWIN}
  {$LINKFRAMEWORK CoreMIDI}
  {$ENDIF}
  {$IFDEF LINUX}
  {$ENDIF}
  {$IFDEF WINDOWS}
  {$ENDIF}
  caHelper;

type
  TcaMidiLinux = class(TInterfacedObject, IcaMidiInterface)
  protected
    function SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil): boolean;
    function SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil): boolean;
    procedure GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
  end;

implementation

function TcaMidiLinux.SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil): boolean;
begin
  Result := True;
end;

function TcaMidiLinux.SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil): boolean;
begin
  Result := True;
end;

procedure TcaMidiLinux.GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
begin
end;

end.

