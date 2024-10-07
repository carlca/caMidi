unit caMidiMac;

{$if fpc_fullversion < 30301}{$error this program needs trunk}{$endif}
{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  Classes, SysUtils, caMidiIntf, caMidiTypes,
  {$IFDEF DARWIN}
  MacOsAll,
  {$ELSE}
  {$ENDIF}
  caDbg;

type
  TcaIntegerHelper = type helper for Integer
  public
    function Pred: Integer;
  end;

  TcaInt64Helper = type helper for int64
  public
    function Pred: int64;
  end;

  TcaMidiMac = class(TInterfacedObject, IcaMidiInterface)
  private
    FMidiClient: longword;
    FOutputPort: longword;
    function CFStringToStr(AString: CFStringRef): string;
    function GetMidiClient(Errors: TStrings): longword;
    function GetOutputPort(Errors: TStrings): longword;
    function SelectDevice(Index: integer): MIDIEndpointRef;
    procedure SendMidiPacket(OutputPort: longword; Device: MIDIEndpointRef; Packet: MIDIPacket; Errors: TStrings);
  protected
    procedure GetDevices(InOut: TcaMidiInOut; Devices: TStrings);
    procedure SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings);
    procedure SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings);
  end;

implementation

function TcaIntegerHelper.Pred: Integer;
begin
  Result := Self - 1;
end;

function TcaInt64Helper.Pred: int64;
begin
  Result := Self - 1;
end;

function TcaMidiMac.CFStringToStr(AString: CFStringRef): string;
var
  Index: integer;
  Uni: UniChar;
begin
  if AString = nil then
  begin
    Result := '';
    Exit;
  end;
  Result := '';
  for Index := 0 to CFStringGetLength(AString).Pred do
  begin
    Uni := CFStringGetCharacterAtIndex(AString, Index);
    Result := Result + Chr(Uni);
  end;
  Result := AnsiToUtf8(Result);
end;

function TcaMidiMac.GetMidiClient(Errors: TStrings): longword;
var
  Stat: OSStatus;
begin
  if FMidiClient = 0 then
  begin
    Stat := MIDIClientCreate(CFSTR('MIDI CLIENT'), nil, nil, FMidiClient);
    if (Stat <> noErr) then
    begin
      Errors.Add('Error creating MIDI client: ' + GetMacOSStatusErrorString(Stat) + '  ' + GetMacOSStatusCommentString(Stat));
      FMidiClient := 0;
    end;
  end;
  Result := FMidiClient;
end;

function TcaMidiMac.GetOutputPort(Errors: TStrings): longword;
var
  Stat: OSStatus;
begin
  if FOutputPort = 0 then
  begin
    Stat := MIDIOutputPortCreate(GetMidiClient(Errors), CFSTR('Output'), FOutputPort);
    if Stat <> noErr then
    begin
      Errors.Add('Error creating MIDI output port: ' + GetMacOSStatusErrorString(Stat) + '  ' + GetMacOSStatusCommentString(Stat));
      FOutputPort := 0;
    end;
  end;
  Result := FOutputPort;
end;

procedure TcaMidiMac.GetDevices(InOut: TcaMidiInOut; Devices: TStrings);
var
  Count, Index: integer;
  Source: MIDIEndpointRef;
  PDevName: CFStringRef;
  DevName: string;
begin
  Devices.Clear;
  Count := specialize IfThen<integer>(InOut = ioIn, MIDIGetNumberOfSources, MIDIGetNumberOfDestinations);
  if Count > 0 then
  begin
    for Index := 0 to Count.Pred do
    begin
      Source := specialize IfThen<MIDIEndpointRef>(InOut = ioIn, MIDIGetSource(Index), MIDIGetDestination(Index));
      MIDIObjectGetStringProperty(Source, kMIDIPropertyName, PDevName);
      DevName := CFStringToStr(PDevName);
      if DevName <> '' then
        Devices.Add(DevName);
    end;
  end;
end;

function TcaMidiMac.SelectDevice(Index: integer): MIDIEndpointRef;
begin
  Result := MIDIGetDestination(Index);
end;

procedure TcaMidiMac.SendMidiPacket(OutputPort: longword; Device: MIDIEndpointRef; Packet: MIDIPacket; Errors: TStrings);
var
  Stat: OSStatus;
  PacketList: MIDIPacketList;
begin
  // Build packetlist
  PacketList.numPackets := 1;
  PacketList.packet[0] := Packet;
  Stat := MIDISend(OutputPort, Device, PacketList);
  if Stat <> noErr then
    Errors.Add('Error sending MIDI message: ' + GetMacOSStatusErrorString(Stat) + '  ' + GetMacOSStatusCommentString(Stat));
end;

procedure TcaMidiMac.SendCC(DeviceIndex, Channel, CC: Byte; Errors: TStrings);
var
  Device: MIDIEndpointRef;
  Packet: MIDIPacket;
begin
  Device := SelectDevice(DeviceIndex);
  if Device <> 0 then
  begin
    // Build packet
    Packet.TimeStamp := 0; // Send immediately
    Packet.length := 3;
    Packet.Data[0] := $B0 or (Channel and $0F); // CC status
    Packet.Data[1] := 0;  // CC number (0 in this case)
    Packet.Data[2] := CC;
    // Send MIDI data
    SendMidiPacket(GetOutputPort(Errors), Device, Packet, Errors);
  end
  else
    Errors.Add('No MIDI Destination available');
end;

procedure TcaMidiMac.SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings);
var
  Device: MIDIEndpointRef;
  Packet: MIDIPacket;
begin
  Device := SelectDevice(DeviceIndex);
  if Device <> 0 then
  begin
    // Build packet
    Packet.TimeStamp := 0; // Send immediately
    Packet.length := 2;
    Packet.Data[0] := $C0 or (Channel and $0F);
    Packet.Data[1] := PGM;
    // Send MIDI data
    SendMidiPacket(GetOutputPort(Errors), Device, Packet, Errors);
  end
  else
    Errors.Add('No MIDI Destination available');
end;

end.