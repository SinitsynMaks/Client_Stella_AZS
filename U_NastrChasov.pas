unit U_NastrChasov;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl, Grids, cxContainer, cxEdit, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxGridCustomTableView, cxGridTableView,
  cxGridCustomView, cxClasses, cxGridLevel, cxGrid, Math, Mask, RXSpin,
  Spin, cxDropDownEdit, cxSpinEdit, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle,
  dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxNavigator;

type
  TF_NastrChasov = class(TForm)
    L_Adress: TLabel;
    Edit_Addres: TEdit;
    L_Vremja: TLabel;
    L_Data: TLabel;
    ComComboBox_Speed: TComComboBox;
    L_Speed: TLabel;
    GB_common: TGroupBox;
    GB_FlagiChasov: TGroupBox;
    Btn_Flagi: TButton;
    cxG_FlagsLevel1: TcxGridLevel;
    cxG_Flags: TcxGrid;
    cxG_FlagsTV1: TcxGridTableView;
    cxG_FlagsTV1Col1: TcxGridColumn;
    cxG_FlagsTV1Col2: TcxGridColumn;
    cxG_FlagsTV1Col3: TcxGridColumn;
    cxG_FlagsTV1Col4: TcxGridColumn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit_sec: TSpinEdit;
    SpinEdit_24_12: TSpinEdit;
    SpinEdit_AM_PM: TSpinEdit;
    GB_Date_Time: TGroupBox;
    Btn_SohrAdr: TButton;
    Btn_SohrDateTime: TButton;
    Btn_SohrSkorost: TButton;
    MaskEdit_Vremja: TMaskEdit;
    MaskEdit_Data: TMaskEdit;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_FlagiClick(Sender: TObject);
    procedure SpinEdit_24_12Change(Sender: TObject);
    procedure Edit_AddresChange(Sender: TObject);
    procedure ComComboBox_SpeedChange(Sender: TObject);
    procedure Btn_SohrAdrClick(Sender: TObject);
    procedure Btn_SohrDateTimeClick(Sender: TObject);
    procedure MaskEdit_VremjaChange(Sender: TObject);
    procedure Btn_SohrSkorostClick(Sender: TObject);
  private
    x1: integer;
  public
    {}
  end;

var
  F_NastrChasov: TF_NastrChasov;

implementation

uses
 U_ServNastr, U_Main, Formirovatel_Paketov, IniFiles;

{$R *.dfm}

function BinaryToInt(Str: string): integer;
var
  i: integer;
begin
  Result:=0;
  for i:=length(str) downto 1 do
    Result:=Result+StrToInt(str[i])*Round(IntPower(2,length(str)-i));
end;

procedure TF_NastrChasov.FormCreate(Sender: TObject);
var
  i: integer;
begin
  x1:= row;
  cxG_FlagsTV1.DataController.RecordCount:=8;
  For i:=1 to 8 do cxG_FlagsTV1.DataController.Values[i-1,0]:= IntToStr(i);
  With cxG_FlagsTV1.DataController do
    begin
      Values[0,1]:='NC';
      Values[1,1]:='rAdi';
      Values[2,1]:='Hu';
      Values[3,1]:='PrES';
      Values[4,1]:='T2';
      Values[5,1]:='T1';
      Values[6,1]:='DATE';
      Values[7,1]:='AUTO';
      Values[0,2]:='Не используется';
      Values[1,2]:='Радиация';
      Values[2,2]:='Влажность';
      Values[3,2]:='Давление';
      Values[4,2]:='Температура (датчик2)';
      Values[5,2]:='Температура (датчик1)';
      Values[6,2]:='Дата';
      Values[7,2]:='1 - перебор режимов.'+#13+'0 - только время.';
      Values[0,3]:= U_main.inifile.ReadString('Режимы часов','NC','0');
      Values[1,3]:= U_main.inifile.ReadString('Режимы часов','rAdi','0');
      Values[2,3]:= U_main.inifile.ReadString('Режимы часов','Hu','0');
      Values[3,3]:= U_main.inifile.ReadString('Режимы часов','PrES','0');
      Values[4,3]:= U_main.inifile.ReadString('Режимы часов','T2','0');
      Values[5,3]:= U_main.inifile.ReadString('Режимы часов','T1','1');
      Values[6,3]:= U_main.inifile.ReadString('Режимы часов','DATE','1');
      Values[7,3]:= U_main.inifile.ReadString('Режимы часов','AUTO','1');
    end;
   SpinEdit_sec.Value:= U_main.inifile.ReadInteger('Режимы часов','время между перекл',10);
   SpinEdit_24_12.Value:= U_main.inifile.ReadInteger('Режимы часов','12-24',0);
   SpinEdit_AM_PM.Value:= U_main.inifile.ReadInteger('Режимы часов','AM-PM',0);
end;

procedure TF_NastrChasov.FormShow(Sender: TObject);
begin
  U_Main.Paket.ZaprosVrem;
  Edit_Addres.Text:= F_ServNastr.cxGrid1TableView1.DataController.Values[x1,2];
  MaskEdit_Vremja.Text:= FormatDateTime('hh:nn:ss', U_Main.TimeStart);
  MaskEdit_Data.Text:= FormatDateTime('dd.mm.yy', U_Main.TimeStart);
  If SpinEdit_24_12.Value=1
     then
       SpinEdit_AM_PM.Enabled:= True
     else
       SpinEdit_AM_PM.Enabled:= False;
  Btn_SohrAdr.Enabled:= False;
  Btn_SohrDateTime.Enabled:=False;
  Btn_SohrSkorost.Enabled:=False;     
end;

procedure TF_NastrChasov.Btn_FlagiClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  s:='';
  For i:=8 downto 1 do
    s:= s+cxG_FlagsTV1.DataController.Values[i-1,3];
  with U_main.inifile do
    begin
     WriteString('Режимы часов','NC',cxG_FlagsTV1.DataController.Values[0,3]);
     WriteString('Режимы часов','rAdi',cxG_FlagsTV1.DataController.Values[1,3]);
     WriteString('Режимы часов','Hu',cxG_FlagsTV1.DataController.Values[2,3]);
     WriteString('Режимы часов','PrES',cxG_FlagsTV1.DataController.Values[3,3]);
     WriteString('Режимы часов','T2',cxG_FlagsTV1.DataController.Values[4,3]);
     WriteString('Режимы часов','T1',cxG_FlagsTV1.DataController.Values[5,3]);
     WriteString('Режимы часов','DATE',cxG_FlagsTV1.DataController.Values[6,3]);
     WriteString('Режимы часов','AUTO',cxG_FlagsTV1.DataController.Values[7,3]);
     WriteInteger('Режимы часов','время между перекл',SpinEdit_sec.Value);
     WriteInteger('Режимы часов','12-24',SpinEdit_24_12.Value);
     WriteInteger('Режимы часов','AM-PM',SpinEdit_AM_PM.Value);
     WriteInteger('Режимы часов','режимы переключений',BinaryToInt(s));
    end;
  U_Main.Paket.YstRegimVrem;
end;

procedure TF_NastrChasov.SpinEdit_24_12Change(Sender: TObject);
begin
   If SpinEdit_24_12.Value=1
     then
       SpinEdit_AM_PM.Enabled:= True
     else
       SpinEdit_AM_PM.Enabled:= False;
end;

procedure TF_NastrChasov.Edit_AddresChange(Sender: TObject);
begin
  If Edit_Addres.Text=''
    then
      Btn_SohrAdr.Enabled:= False
    else
      if U_Main.inifile.ValueExists('Из стринг листа',Edit_Addres.Text)
        then
          begin
            Btn_SohrAdr.Enabled:= False;
            Btn_SohrAdr.Caption:='Данный адрес занят';
          end
        else
          begin
            Btn_SohrAdr.Enabled:= True;
            Btn_SohrAdr.Caption:='Сохранить';
          end;
end;

procedure TF_NastrChasov.ComComboBox_SpeedChange(Sender: TObject);
begin
  Btn_SohrSkorost.Enabled:=True;
end;

procedure TF_NastrChasov.Btn_SohrAdrClick(Sender: TObject);
var
  index:Integer;
begin
  U_Main.Paket.IzmAdrNa(x1);
  F_Main.ComPort1.Read(Formirovatel_Paketov.P_vhod,15);
  If (P_vhod[1]= 0) and (P_vhod[9]= StrToInt(Edit_Addres.Text))
    and (P_vhod[11]=5) and (P_vhod[12]=255)
      then
        begin
          Btn_SohrAdr.Enabled:=False;
          Btn_SohrAdr.Caption:='Сохранить';
          index:=TcxComboBoxProperties(F_ServNastr.cxGrid2TV1Col6.Properties).Items.IndexOf(F_ServNastr.cxGrid1TableView1.DataController.Values[x1,2]);
          U_Main.inifile.DeleteKey('Из стринг листа',F_ServNastr.cxGrid1TableView1.DataController.Values[x1,2]);//Удаляем текущий адрес
          U_Main.inifile.WriteString('Из стринг листа',Edit_Addres.Text,'часы');
          realdevice.Delete(realdevice.IndexOfName(F_ServNastr.cxGrid1TableView1.DataController.Values[x1,2]));
          F_ServNastr.cxGrid1TableView1.DataController.Values[x1,2]:= Edit_Addres.Text;
          TcxComboBoxProperties(F_ServNastr.cxGrid2TV1Col6.Properties).Items[index]:=Edit_Addres.Text;
          F_ServNastr.cxGrid2TableView1.DataController.Values[x1,5]:= TcxComboBoxProperties(F_ServNastr.cxGrid2TV1Col6.Properties).Items[index];
          realdevice.Add(Edit_Addres.Text+'=часы');
          Edit_Addres.SetFocus;
        end
      else
        begin
          ShowMessage('Часы не ответили на установку времени');
        end; 
end;

procedure TF_NastrChasov.Btn_SohrDateTimeClick(Sender: TObject);
var
  s:string; //Чтобы преобразовать строку в дату и время, строка должна быть вида "день.месяц.год час:минута:секунда"
begin
  try
    s:= MaskEdit_Data.Text+' '+MaskEdit_Vremja.Text;
    TimeStart:=StrToDateTime(s);
    Paket.YstNovZnachVrem;
  except
    on EDBEditError do
      ShowMessage('Некорректно введена дата или время');
  end;
  
end;

procedure TF_NastrChasov.MaskEdit_VremjaChange(Sender: TObject);
begin
   Btn_SohrDateTime.Enabled:=True;
end;

procedure TF_NastrChasov.Btn_SohrSkorostClick(Sender: TObject);
begin
  Paket.IzmSkorPeredDannyh(x1);
end;

end.
