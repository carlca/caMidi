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
    // ChatGPT4o code
    procedure SendMIDIMessage;
    procedure SendPGMMessage;
    // live code
    procedure GetInputDevices(Devices, Errors: TStrings);
    procedure GetOutputDevices(Devices, Errors: TStrings);
  protected
    procedure GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings = nil);
    procedure SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil);
  end;

implementation

// private methods

procedure TcaMidiWin.SendMIDIMessage;
const
  MIDI_CONTROL_CHANGE = $B0; // Control Change message type
  MIDI_CC0 = 0;              // Controller number for CC0
  MIDI_CHANNEL = 0;          // MIDI channel (0-15, where 0 is channel 1)
  MIDI_VALUE = 127;          // Value to send (0-127)
var
  MidiOutHandle: HMIDIOUT;
  midiMessage: DWORD;
  result: MMRESULT;
begin
  // Open the first MIDI output device
  result := midiOutOpen(@MidiOutHandle, 0, 0, 0, CALLBACK_NULL);
  if result <> MMSYSERR_NOERROR then
  begin
    writeln('Failed to open MIDI output device.');
    halt(1);
  end;

  // Construct the MIDI message
  midiMessage := MIDI_CONTROL_CHANGE or MIDI_CHANNEL or (MIDI_CC0 shl 8) or (MIDI_VALUE shl 16);

  // Send the MIDI message
  result := midiOutShortMsg(MidiOutHandle, midiMessage);
  if result <> MMSYSERR_NOERROR then
  begin
    writeln('Failed to send MIDI message.');
    midiOutClose(MidiOutHandle);
    halt(1);
  end;

  writeln('MIDI message sent successfully.');

  // Close the MIDI output device
  midiOutClose(MidiOutHandle);
end;

procedure TcaMidiWin.SendPGMMessage;
const
  MIDI_PROGRAM_CHANGE = $C0; // Program Change message type
  MIDI_CHANNEL = 0;          // MIDI channel (0-15, where 0 is channel 1)
  PROGRAM_NUMBER = 10;       // Program number to send (0-127)
var
  MidiOutHandle: HMIDIOUT;
  midiMessage: DWORD;
  result: MMRESULT;
begin
  // Open the first MIDI output device
  result := midiOutOpen(@MidiOutHandle, 0, 0, 0, CALLBACK_NULL);
  if result <> MMSYSERR_NOERROR then
  begin
    writeln('Failed to open MIDI output device.');
    halt(1);
  end;

  // Construct the MIDI message
  midiMessage := MIDI_PROGRAM_CHANGE or MIDI_CHANNEL or (PROGRAM_NUMBER shl 8);

  // Send the MIDI message
  result := midiOutShortMsg(MidiOutHandle, midiMessage);
  if result <> MMSYSERR_NOERROR then
  begin
    writeln('Failed to send MIDI message.');
    midiOutClose(MidiOutHandle);
    halt(1);
  end;

  writeln('Program Change message sent successfully.');

  // Close the MIDI output device
  midiOutClose(MidiOutHandle);
end;

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
