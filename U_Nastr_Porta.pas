unit U_Nastr_Porta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl, CPort;

type
  TF_Nastr_Porta = class(TForm)
    Label_Nomerporta: TLabel;
    Label_SkorPorta: TLabel;
    ComboBox_NomerPorta: TComboBox;
    ComComboBox1: TComComboBox;
    Btn_Sohr: TButton;
    procedure FormShow(Sender: TObject);
    procedure ComboBox_NomerPortaChange(Sender: TObject);
    procedure ComComboBox1Change(Sender: TObject);
    procedure Btn_SohrClick(Sender: TObject);
    procedure Slegy_za_portami;
    procedure ComboBox_NomerPortaDropDown(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Nastr_Porta: TF_Nastr_Porta;
  flag_porta:integer = 0;
  flag_skorosti:integer = 0;
  err: EComPort;

implementation

uses
  U_Main, U_ServNastr, Formirovatel_Paketov;

{$R *.dfm}

procedure TF_Nastr_Porta.FormShow(Sender: TObject);
begin
  If F_Main.ComPort1.Connected
    then F_Main.ComPort1.Close;
  Slegy_za_portami;
  ComboBox_NomerPorta.ItemIndex:=U_Main.inifile.ReadInteger('ComPort','Port_index',0);
  ComComboBox1.ItemIndex:=U_Main.inifile.ReadInteger('ComPort','BaudRate_index',7);
end;

procedure TF_Nastr_Porta.ComboBox_NomerPortaChange(Sender: TObject);
begin
  flag_porta:=1;
  Btn_Sohr.Enabled:=True;
end;

procedure TF_Nastr_Porta.ComboBox_NomerPortaDropDown(Sender: TObject);
begin
  Slegy_za_portami;
end;

procedure TF_Nastr_Porta.ComComboBox1Change(Sender: TObject);
begin
  flag_skorosti:=1;
  Btn_Sohr.Enabled:=True;
end;

procedure TF_Nastr_Porta.Btn_SohrClick(Sender: TObject);
var
  i: integer;
begin
  If flag_porta=1
    then
      begin
        F_Main.ComPort1.Port:= ComboBox_NomerPorta.Items[ComboBox_NomerPorta.ItemIndex];
        F_Main.ComPort1.Open;
        U_Main.inifile.WriteInteger('ComPort','Port_index',ComboBox_NomerPorta.ItemIndex);
        U_Main.inifile.WriteString('ComPort','Port',F_Main.ComPort1.Port);
        flag_porta:=0;
      end
    else
      begin
        F_Main.ComPort1.Port:= ComboBox_NomerPorta.Items[0];
        F_Main.ComPort1.Open;
        U_Main.inifile.WriteInteger('ComPort','Port_index',ComboBox_NomerPorta.ItemIndex);
        U_Main.inifile.WriteString('ComPort','Port',F_Main.ComPort1.Port);
      end;
  If flag_skorosti=1
    then
      begin
        ComComboBox1.ApplySettings;
        U_Main.inifile.WriteInteger('ComPort','BaudRate_index',ComComboBox1.ItemIndex);
        //Paket.OprosYstroistv(Gauge1);
        flag_skorosti:=0;
      end
    else
      begin
        F_Main.ComPort1.BaudRate:=br9600;
      end;
  ShowMessage('Подключение к порту '+F_Main.ComPort1.Port+' выполнено'+#13+
              'Скорость передачи данных: '+ComComboBox1.Items[ComComboBox1.ItemIndex]);
  Btn_Sohr.Enabled:=False;
end;

procedure TF_Nastr_Porta.Slegy_za_portami;
var
  i: integer;
begin
  i:=0;
  ComboBox_NomerPorta.Items.Clear;
  EnumComPorts(ComboBox_NomerPorta.Items);
  While i<ComboBox_NomerPorta.Items.Count do
    begin
      F_Main.ComPort1.Port:= ComboBox_NomerPorta.Items[i];
      try
        F_Main.ComPort1.Open;
        F_Main.ComPort1.Close;
        i:=i+1;
      except
        ComboBox_NomerPorta.Items.Delete(i);
      end;
    end;
end;

procedure TF_Nastr_Porta.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    F_Main.ComPort1.Port:=inifile.ReadString('ComPort','Port','Com1');
    F_Main.ComPort1.Open;
    F_Main.ComPort1.BaudRate:=br9600;
  except
    FreeAndNil(F_Nastr_Porta);
  end;  
end;

end.
