unit caMidiWin;

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
  Windows,
  MMSystem,
  {$ENDIF}
  caHelper;

type
  TcaMidiWin = class(TInterfacedObject, IcaMidiInterface)
  private
    procedure GetInputDevices(Devices, Errors: TStrings);
    procedure GetOutputDevices(Devices, Errors: TStrings);
  protected
    procedure GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil);
    procedure SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil);
  end;

implementation

// private methods

procedure TcaMidiWin.GetInputDevices(Devices, Errors: TStrings);
begin

end;

procedure TcaMidiWin.GetOutputDevices(Devices, Errors: TStrings);
var
  DeviceCount: integer;
  Index: integer;
  MidiOutCaps: TMidiOutCaps;
begin
  DeviceCount := midiOutGetNumDevs;
  for Index := 0 to DeviceCount.Pred do
  begin
    if midiOutGetDevCaps(Index, @midiOutCaps, SizeOf(midiOutCaps)) = MMSYSERR_NOERROR then
      Devices.Add(midiOutCaps.szPname)
    else
      Errors.Add(Format('Device %d: Error retrieving device information', [Index]));
  end;
end;

// protected methods

procedure TcaMidiWin.GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
begin
  case InOut of
    ioIn:   GetInputDevices(Devices, Errors);
    ioOut:  GetOutputDevices(Devices, Errors);
  end;
end;

procedure TcaMidiWin.SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings);
begin

end;

procedure TcaMidiWin.SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings);
begin

end;

end.
