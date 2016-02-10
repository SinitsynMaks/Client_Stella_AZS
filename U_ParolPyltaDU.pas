unit U_ParolPyltaDU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TF_ParolDU = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ParolDU: TF_ParolDU;

implementation

uses
  U_Main, Formirovatel_Paketov;

{$R *.dfm}

procedure TF_ParolDU.FormShow(Sender: TObject);
begin
  Edit1.Height:=30;
  Edit1.SetFocus;
  Edit1.Font.Size:=14;
end;

procedure TF_ParolDU.Button1Click(Sender: TObject);
begin
  If Edit1.Text=''
     then
       begin
         Application.MessageBox('Введи 4-х значный пароль','Внимание!',MB_OK);
         Edit1.SetFocus;
         Exit;
       end
     else
      if Length(Edit1.Text)<>4
        then
          begin
            Application.MessageBox('Пароль должен состоять из 4-х цифр','Внимание!',MB_OK);
            Edit1.SetFocus;
            Exit;
          end;
  U_main.Paket.ParolPultaDu;
 // F_Main.ComPort1.Read(P_vhod,15);
 // If (P_vhod[9]=1) and (P_vhod[11]=6)
   // then
      //begin
        ShowMessage('Пароль успешно изменен');
        F_ParolDU.Close;
        F_Main.Label_ParolPultaDU.Caption:= 'Текущий пароль пульта ДУ: '+ Edit1.Text;
        F_Main.Label_ParolPultaDU.Left:= Round((F_Main.ClientWidth-F_Main.Label_ParolPultaDU.Width)/2);
        inifile.WriteString('Пароль пульта ДУ','Pass',Edit1.Text);
     // end
   { else
      begin
        ShowMessage('Устройство '+ IntToStr(Paketik[1]) + ' не отвечает');
        exit;
      end;          }
end;

procedure TF_ParolDU.Edit1KeyPress(Sender: TObject; var Key: Char);
type
  TDigit = set of byte;
var
  Simbol: TDigit;
begin
  Simbol:=[8,13,48,49,50,51,52,53,54,55,56,57,127];
  if not(ord(Key) in Simbol) then Key:=#0;
  If Key = #13 then Button1Click(Sender);
end;

end.
