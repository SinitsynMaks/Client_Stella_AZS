unit U_StopModal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFWait = class(TForm)
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
  
  public
    { Public declarations }
  end;

var
  FWait: TFWait;
  t,k:integer;
implementation

uses
  U_Main, Formirovatel_Paketov;

{$R *.dfm}

procedure TFWait.FormShow(Sender: TObject);
begin
  tt:=0;
  timer_vait:= TTimer.Create(nil);
  timer_vait.Interval:=50;
  timer_vait.OnTimer:=Paket.VremjaModalnogoOkna;
  timer_vait.Enabled:=True;
end;

procedure TFWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  timer_vait.Free;
  Action:= caFree;
end;

end.
