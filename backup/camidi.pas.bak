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
  {$IFDEF WINDOWS}
  caMidiWin;
  {$ENDIF}
  {$IFDEF LINUX}
  caMidiLinux;
  {$ENDIF}

initialization
  {$IFDEF DARWIN}
  Midi := TcaMidiMac.Create;
  {$ENDIF}
  {$IFDEF WINDOWS}
  {$ENDIF}
  {$IFDEF LINUX}
  {$ENDIF}

finalization
  Midi := nil;

end.

