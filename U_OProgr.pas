unit U_OProgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, U_Pass1;

type
  TF_OProgramme = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Label3DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_OProgramme: TF_OProgramme;

implementation

uses
  U_Main;

{$R *.dfm}

procedure TF_OProgramme.FormShow(Sender: TObject);
var
  t: TDateTime;
begin
  t:=Now;
  Label2.Caption:='Все права защищены, '+ FormatDateTime('yyyy',t)+' год';
end;

procedure TF_OProgramme.Label3DblClick(Sender: TObject);
begin
  If F_pass1=nil
    then
      begin
        F_pass1:= TF_pass1.Create(self);
        F_pass1.Show;
        F_OProgramme.Close;
      end
    else
      begin
        F_pass1.Show;
        F_OProgramme.Close;
      end;  
end;

end.
