unit U_UstrSCenoy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl, cxDropDownEdit;

type
  TF_Nastr_Ceny = class(TForm)
    Label_Adres: TLabel;
    Label_Cena: TLabel;
    Label_Skorost: TLabel;
    Label1: TLabel;
    Edit_Adres: TEdit;
    Edit_Cena: TEdit;
    Edit_ParolDU: TEdit;
    ComComboBox1: TComComboBox;
    Btn_IzmAdres: TButton;
    Btn_IzmCenu: TButton;
    Btn_IzmSkorost: TButton;
    Btn_PultDU: TButton;
    procedure FormShow(Sender: TObject);
    procedure Edit_AdresChange(Sender: TObject);
    procedure Btn_IzmAdresClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_IzmCenuClick(Sender: TObject);
    procedure Edit_CenaChange(Sender: TObject);
    procedure Edit_CenaKeyPress(Sender: TObject; var Key: Char);
    procedure ComComboBox1Change(Sender: TObject);
    procedure Btn_IzmSkorostClick(Sender: TObject);
  private
    x2: integer;
  public
     {}
  end;

var
  F_Nastr_Ceny: TF_Nastr_Ceny;


implementation

uses

  U_ServNastr, U_Main, Formirovatel_Paketov;

{$R *.dfm}

procedure TF_Nastr_Ceny.FormCreate(Sender: TObject);
begin
  x2:= row;
end;

procedure TF_Nastr_Ceny.FormShow(Sender: TObject);
begin
  If VarToStr(F_ServNastr.cxGrid1TableView1.DataController.Values[row,2])='1'
    then
      begin
        Height:= 180;
        Btn_IzmAdres.Enabled:=False;
        Btn_IzmCenu.Enabled:=False;
        Btn_IzmSkorost.Enabled:=False;
        Btn_PultDU.Enabled:=False;
        Edit_Adres.Text:=F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2];
        Paket.ZaprosCeny(x2);
        F_Main.ComPort1.Read(P_vhod,15);
        If (P_vhod[1]= 0) and (P_vhod[9]= StrToInt(Edit_Adres.Text))
          and (P_vhod[11]=11) and (P_vhod[12]=255)
            then
              Edit_Cena.Text:= Paket.CenaonDevice
            else
              Edit_Cena.Text:= 'Определить не удалось';
        Edit_ParolDU.Text:= U_Main.inifile.ReadString('Пароль пульта ДУ','Pass','');
      end
    else
      begin
        Height:=137;
        Label1.Visible:=False;
        Edit_ParolDU.Visible:=False;
        Btn_PultDU.Visible:=False;
        Btn_IzmAdres.Enabled:=False;
        Btn_IzmCenu.Enabled:=False;
        Btn_IzmSkorost.Enabled:=False;
        Edit_Adres.Text:=F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2];
        Paket.ZaprosCeny(x2);
        F_Main.ComPort1.Read(P_vhod,15);
        Edit_Cena.Text:= Paket.CenaonDevice;
      end;
end;

procedure TF_Nastr_Ceny.Edit_AdresChange(Sender: TObject);
begin
  If Edit_Adres.Text=''
    then
      Btn_IzmAdres.Enabled:=False
    else
      if U_Main.inifile.ValueExists('Из стринг листа',Edit_Adres.Text)
        then
          begin
            Btn_IzmAdres.Enabled:=False;
            Btn_IzmAdres.Caption:='Адрес уже используется';
          end
        else
          begin
            Btn_IzmAdres.Enabled:= True;
            Btn_IzmAdres.Caption:='Сохранить';
          end;
end;

procedure TF_Nastr_Ceny.Btn_IzmAdresClick(Sender: TObject);
var
  index:Integer;
begin
  U_Main.Paket.IzmAdrNa(x2);
  F_Main.ComPort1.Read(P_vhod,15);
  If (P_vhod[1]= 0) and (P_vhod[9]= StrToInt(Edit_Adres.Text))
    and (P_vhod[11]=5) and (P_vhod[12]=255)
      then
        begin
          Btn_IzmAdres.Enabled:=False;
          Btn_IzmAdres.Caption:='Изменить';
          index:=TcxComboBoxProperties(F_ServNastr.cxGrid2TV1Col6.Properties).Items.IndexOf(F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2]);
          U_Main.inifile.DeleteKey('Из стринг листа',F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2]);//Удаляем текущий адрес
          U_Main.inifile.WriteString('Из стринг листа',Edit_Adres.Text,'панель с ценой');
          realdevice.Delete(realdevice.IndexOfName(F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2]));
          F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2]:= Edit_Adres.Text;
          TcxComboBoxProperties(F_ServNastr.cxGrid2TV1Col6.Properties).Items[index]:=Edit_Adres.Text;
          F_ServNastr.cxGrid2TableView1.DataController.Values[x2,5]:= TcxComboBoxProperties(F_ServNastr.cxGrid2TV1Col6.Properties).Items[index];
          realdevice.Add(Edit_Adres.Text+'=панель с ценой');
          Edit_Adres.SetFocus;
        end
      else
        begin
          ShowMessage('Часы не ответили на установку времени');
        end;
end;

procedure TF_Nastr_Ceny.Btn_IzmCenuClick(Sender: TObject);
var
  adr_ystr: integer;
  novaja_cena: string;
begin
  adr_ystr:= StrToInt(F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2]);
  novaja_cena:= Edit_Cena.Text;
  Paket.ZapisCenyNaOdnomUstr(adr_ystr, novaja_cena);
  F_Main.ComPort1.Read(P_vhod,15);
  If (P_vhod[9]=StrToInt(F_ServNastr.cxGrid1TableView1.DataController.Values[x2,2])) and (P_vhod[10]=2)
      and (P_vhod[11]=1) and (P_vhod[12]=255)
    then
      begin
      end
    else
      ShowMessage('Устройство '+ IntToStr(Paketik[1])+' не ответило на установку цены');
  Btn_IzmCenu.Enabled:=False;
end;

procedure TF_Nastr_Ceny.Edit_CenaChange(Sender: TObject);
var
  s: string;
begin
  s:='';
  s:=Edit_Cena.Text;
  If s='' then Btn_IzmCenu.Enabled:=False;
  If (Pos('.',s)>0) or (Pos(',',s)>0)
    then
      begin
        Edit_Cena.MaxLength:=razr+1;
        flag:=1;
        Btn_IzmCenu.Enabled:=True;
      end
    else
      begin
        Edit_Cena.MaxLength:=razr;
        flag:=0;
        Btn_IzmCenu.Enabled:=True;
      end;
end;

procedure TF_Nastr_Ceny.Edit_CenaKeyPress(Sender: TObject; var Key: Char);
begin
  If not(ord(Key) in Simbol) then Key:=#0;
  If ((ord(Key)=44) or (ord(Key)=46)) and (flag=1)
    then
      key:=#0;
end;

procedure TF_Nastr_Ceny.ComComboBox1Change(Sender: TObject);
begin
  Btn_IzmSkorost.Enabled:=True; 
end;

procedure TF_Nastr_Ceny.Btn_IzmSkorostClick(Sender: TObject);
begin
  Paket.IzmSkorPeredDannyh(x2); 
end;

end.
