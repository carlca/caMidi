unit caMidi;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, caMidiIntf;

implementation

uses
  {$IFDEF DARWIN}
  caMidiMac;
  {$ENDIF}
  {$IFDEF LINUX}
  caMidiLinux;
  {$ENDIF}
  {$IFDEF WINDOWS}
  caMidiWin;
  {$ENDIF}

initialization
  {$IFDEF DARWIN}
  Midi := TcaMidiMac.Create;
  {$ENDIF}
  {$IFDEF LINUX}
  Midi := TcaMidiLinux.Create;
  {$ENDIF}
  {$IFDEF WINDOWS}
  Midi := TcaMidiWin.Create;
  {$ENDIF}

finalization
  Midi := nil;

end.

