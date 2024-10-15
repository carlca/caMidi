unit caMidiWin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, caMidiIntf, caMidiTypes,
  {$IFDEF DARWIN}
  {$LINKFRAMEWORK CoreMIDI}
  {$ENDIF}
  {$IFDEF LINUX}
  {$ENDIF}
  {$IFDEF WINDOWS}
  Windows,
  MMSystem,
  {$ENDIF}
  caDbg,
  caHelper;

type

  TcaMidiWin = class(TInterfacedObject, IcaMidiInterface)
  private
    // live code
    procedure GetInputDevices(Devices, Errors: TStrings);
    procedure GetOutputDevices(Devices, Errors: TStrings);
    function OpenMidiOutDevice(var MidiOutHandle: HMIDIOUT; var Errors: TStrings; var mResult: MMRESULT; const DeviceIndex: byte): boolean;
  protected
    procedure GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: byte; Errors: TStrings = nil);
    procedure SendPGM(DeviceIndex, Channel, PGM: byte; Errors: TStrings = nil);
  end;

const
  MIDI_CONTROL_CHANGE = $B0;  // Control Change message type
  MIDI_CC0 = 0;    // Controller number for CC0
  MIDI_CHANNEL = 0;    // MIDI channel (0-15, where 0 is channel 1)
  MIDI_VALUE = 127;  // Value to send (0-127)
  MIDI_PROGRAM_CHANGE = $C0;  // Program Change message type
  PROGRAM_NUMBER = 10;   // Program number to send (0-127)

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
    if midiOutGetDevCaps(Index, @midiOutCaps, SizeOf(midiOutCaps)) =
      MMSYSERR_NOERROR then
      Devices.Add(midiOutCaps.szPname)
    else
    begin
      ShowMessage(Format('Device %d: Error retrieving device information', [Index]));
      Errors.Add(Format('Device %d: Error retrieving device information', [Index]));
    end;
  end;
end;

// protected methods

procedure TcaMidiWin.GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
begin
  Devices.Clear;
  case InOut of
    ioIn: GetInputDevices(Devices, Errors);
    ioOut: GetOutputDevices(Devices, Errors);
  end;
end;

function TcaMidiWin.OpenMidiOutDevice(var MidiOutHandle:HMIDIOUT;var Errors:
  TStrings;var mResult:MMRESULT;const DeviceIndex:byte):boolean;
begin
  mResult := MidiOutOpen(@MidiOutHandle, DeviceIndex, 0, 0, CALLBACK_NULL);
  Result := mResult = MMSYSERR_NOERROR;
  if not Result then
    Errors.Add(Format('Failed to open PGM MIDI output device: %d', [DeviceIndex]));
end;

procedure TcaMidiWin.SendCC(DeviceIndex, Channel, CC: byte; Errors: TStrings);
var
  MidiOutHandle: HMIDIOUT;
  MidiMessage: DWORD;
  Result: MMRESULT;

  procedure SendCCInner;
  begin
    // open the MIDI output device
    if OpenMidiOutDevice(MidiOutHandle, Errors, Result, DeviceIndex) then
    begin
      MidiMessage := MIDI_CONTROL_CHANGE or Channel or (MIDI_CC0 shl 8) or (CC shl 16);
      // send the MIDI message
      Result := MidiOutShortMsg(MidiOutHandle, MidiMessage);
      if Result <> MMSYSERR_NOERROR then
      begin
        Errors.Add(Format('Failed to send CC MIDI message: %d', [MidiMessage]));
        Exit;
      end;
      // close the MIDI output device
      MidiOutClose(MidiOutHandle);
    end;
  end;

begin
  try
    SendCCInner;
  except
    Sleep(1000);
    SendCCInner;
  end;
end;

procedure TcaMidiWin.SendPGM(DeviceIndex, Channel, PGM: byte; Errors: TStrings);
var
  MidiOutHandle: HMIDIOUT;
  MidiMessage: DWORD;
  Result: MMRESULT;

  procedure SendPGMInner;
  begin
    if OpenMidiOutDevice(MidiOutHandle, Errors, Result, DeviceIndex) then
    begin
      // build the MIDI message
      MidiMessage := MIDI_PROGRAM_CHANGE or Channel or (PGM shl 8);
      // send the MIDI message
      Result := MidiOutShortMsg(MidiOutHandle, MidiMessage);
      if Result <> MMSYSERR_NOERROR then
      begin
        Errors.Add(Format('Failed to send MIDI message: %d', [MidiMessage]));
        Exit;
      end;
      // close the MIDI output device
      MidiOutClose(MidiOutHandle);
    end;
  end;

begin
  try
    SendPGMInner;
  except
    Sleep(1000);
    SendPGMInner;
  end;
end;

end.
