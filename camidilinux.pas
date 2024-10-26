 unit caMidiLinux;

 {$mode objfpc}{$H+}

 interface

 uses
   Classes, SysUtils, caMidiIntf, caMidiTypes, Dialogs,
   {$IFDEF DARWIN}
   {$LINKFRAMEWORK CoreMIDI}
   {$ENDIF}
   {$IFDEF LINUX}
   ctypes,
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
 //var
 //  stream: PPortMidiStream;
 //  status: PmError;
 //  msg: CInt32;
 begin
   //Result := False;
   //status := Pm_Initialize;
   //if status <> pmNoError then
   //begin
   //  if Assigned(Errors) then
   //    Errors.Add(Pm_GetErrorText(status));
   //  Exit;
   //end;
   //
   //if (DeviceIndex < 0) or (DeviceIndex >= Pm_CountDevices) then
   //begin
   //  if Assigned(Errors) then
   //    Errors.Add('Invalid Device Index');
   //  Pm_Terminate;
   //  Exit;
   //end;
   //
   //// Initialize the stream pointer to nil
   //stream := nil;
   //
   //status := Pm_OpenOutput(@stream, DeviceIndex, nil, 0, nil, nil, 0);
   //if status <> pmNoError then
   //begin
   //  if Assigned(Errors) then
   //    Errors.Add(Pm_GetErrorText(status));
   //  Pm_Terminate;
   //  Exit;
   //end;
   //
   //msg := Pm_Message($B0 or (Channel and $0F), CC, 127); // Control Change message
   //status := Pm_WriteShort(stream, 0, msg);
   //if status <> pmNoError then
   //begin
   //  if Assigned(Errors) then
   //    Errors.Add(Pm_GetErrorText(status));
   //end
   //else
   //begin
     Result := True;
   //end;
   //
   //Pm_Close(stream);
   //Pm_Terminate;
 end;

 function TcaMidiLinux.SendPGM(DeviceIndex, Channel, PGM: Byte; Errors: TStrings = nil): boolean;
 //var
 // stream: PPortMidiStream;
 // status: PmError;
 // msg: CInt32;
begin
  //Result := False;
  //status := Pm_Initialize;
  //if status <> pmNoError then
  //begin
  //  if Assigned(Errors) then
  //    Errors.Add(Pm_GetErrorText(status));
  //  Exit;
  //end;
  //
  //if (DeviceIndex < 0) or (DeviceIndex >= Pm_CountDevices) then
  //begin
  //  if Assigned(Errors) then
  //    Errors.Add('Invalid Device Index');
  //  Pm_Terminate;
  //  Exit;
  //end;
  //
  //// Initialize the stream pointer to nil
  //stream := nil;
  //
  //// Pass the address of the stream pointer to Pm_OpenOutput
  //status := Pm_OpenOutput(@stream, DeviceIndex, nil, 0, nil, nil, 0);
  //if status <> pmNoError then
  //begin
  //  if Assigned(Errors) then
  //    Errors.Add(Pm_GetErrorText(status));
  //  Pm_Terminate;
  //  Exit;
  //end;
  //
  //msg := Pm_Message($C0 or (Channel and $0F), PGM, 0); // Program Change message
  //status := Pm_WriteShort(stream, 0, msg);
  //if status <> pmNoError then
  //begin
  //  if Assigned(Errors) then
  //    Errors.Add(Pm_GetErrorText(status));
  //end
  //else
  //begin
    Result := True;
  //end;
  //
  //Pm_Close(stream);
  //Pm_Terminate;
end;

 procedure TcaMidiLinux.GetDevices(InOut: TcaMidiInOut; Devices, Errors: TStrings);
 //var
 //  i: CInt;
 //  deviceInfo: PPmDeviceInfo;
 begin
   //Devices.Clear;
   //if Pm_Initialize <> pmNoError then
   //begin
   //  if Assigned(Errors) then
   //    Errors.Add('Error initializing PortMidi');
   //  Exit;
   //end;
   //
   //for i := 0 to Pm_CountDevices - 1 do
   //begin
   //  deviceInfo := Pm_GetDeviceInfo(i);
   //  if deviceInfo <> nil then
   //  begin
   //    if ((InOut = ioIn) and (deviceInfo^.input <> 0)) or
   //       ((InOut = ioOut) and (deviceInfo^.output <> 0)) then
   //    begin
   //      Devices.Add(Format('%s: %s', [deviceInfo^.interf, deviceInfo^.name]));
   //    end;
   //  end;
   //end;
   //
   //Pm_Terminate;
 end;

 end.

