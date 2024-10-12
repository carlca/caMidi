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
    procedure GetDevices(InOut: TcaMidiInOut; Devices: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil);
    procedure SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil);
  end;

