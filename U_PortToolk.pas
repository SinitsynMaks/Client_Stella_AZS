unit U_PortToolk;

interface

uses
  Classes, CPortCtl, ExtCtrls, CPort, Dialogs, Windows, Messages,
  SysUtils, Formirovatel_Paketov, U_StopModal, Forms;

type
  ToolkPort = class(TThread)
  ComPort: TComPort;// �������� ����������-��������� �� ����� TComPort;

  private
    //procedure OtpravkaDannyh;
  protected
    procedure Execute; override;
  end;

implementation

uses
  U_Main;

procedure ToolkPort.Execute;
begin
Repeat
   ComPort.Read(P_vhod,15);
   //Sleep(15);
until terminated;

end;

end.
 