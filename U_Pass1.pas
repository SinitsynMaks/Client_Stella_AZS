unit U_Pass1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, U_ServNastr;

type
  TF_pass1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_pass1: TF_pass1;

implementation

uses
  U_OProgr, U_Main;

{$R *.dfm}


procedure TF_pass1.Button1Click(Sender: TObject);
begin
  If Edit1.Text='1234'
    then
      If F_ServNastr=nil
        then
          begin
            F_ServNastr:= TF_ServNastr.Create(Self);
            F_ServNastr.Show;
            F_pass1.Close;
          end
        else
          begin
            F_ServNastr.Show;
            F_pass1.Close;
          end  
    else
      begin
        ShowMessage('ѕароль неверный');
        Edit1.SetFocus;
        exit;
      end;
end;

procedure TF_pass1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then Button1Click(Sender);
end;

procedure TF_pass1.FormShow(Sender: TObject);
begin
  Edit1.Text:='';
  Edit1.SetFocus;
end;

procedure TF_pass1.Button2Click(Sender: TObject);
begin
  Edit1.Text:='';
  ShowMessage('¬веди в поле ввода новый пароль');
  Edit1.SetFocus;
  //U_Main.inifile.WriteString('Pass','serv_nastr',);
end;

end.
