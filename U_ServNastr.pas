unit U_ServNastr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxGridCustomTableView, cxGridTableView, cxGridCustomView,
  cxClasses, cxGridLevel, cxGrid, cxDropDownEdit, cxCheckBox, Gauges,
  CPort, U_UstrSCenoy, U_NastrChasov, U_Nastr_Porta, CPortCtl, Spin,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxNavigator;

type
  TF_ServNastr = class(TForm)
    GrB_monitoring: TGroupBox;
    GroupBox1: TGroupBox;
    Btn_OprosYstr: TButton;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1TableView1: TcxGridTableView;
    cxGrid2Level1: TcxGridLevel;
    cxGrid2: TcxGrid;
    cxGrid2TableView1: TcxGridTableView;
    cxGrid1TV1Col1: TcxGridColumn;
    cxGrid1TV1Col2: TcxGridColumn;
    cxGrid1TV1Col3: TcxGridColumn;
    cxGrid2TV1Col1: TcxGridColumn;
    cxGrid2TV1Col2: TcxGridColumn;
    cxGrid2TV1Col3: TcxGridColumn;
    cxGrid2TV1Col4: TcxGridColumn;
    cxGrid2TV1Col6: TcxGridColumn;
    Btn_SohrOtobr: TButton;
    Gauge1: TGauge;
    CmBx_VyberiPort: TComboBox;
    cxGrid2TV1Col5: TcxGridColumn;
    ComComboBox1: TComComboBox;
    Label_RazrTablo: TLabel;
    SpinEdit_Razr: TSpinEdit;
    Label_Vait: TLabel;
    Label_Vait2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Btn_OprosYstrClick(Sender: TObject);
    procedure Btn_SohrOtobrClick(Sender: TObject);
    procedure CmBx_VyberiPortChange(Sender: TObject);
    procedure cxGrid1TableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    //procedure CmBx_VyberiPortDropDown(Sender: TObject);
    procedure ComComboBox1Change(Sender: TObject);
    procedure Slegy_za_portami;
    procedure DannyeVGrid;
    procedure SpinEdit_RazrChange(Sender: TObject);
    //procedure CmBx_VyberiPortCloseUp(Sender: TObject);
    procedure cxGrid2TV1Col6PropertiesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_ServNastr: TF_ServNastr;
  MyForms: array of TForm;
  row: integer;
  
implementation

uses
  U_Pass1, U_Main, Formirovatel_Paketov, IniFiles, U_StopModal;

{$R *.dfm}

procedure TF_ServNastr.FormShow(Sender: TObject);
begin
  If F_Main.ComPort1.Connected
    then F_Main.ComPort1.Close;
  Gauge1.Visible:=False;
  Label_Vait.Visible:=False;
  Label_Vait2.Visible:=False;
  Slegy_za_portami;
  CmBx_VyberiPort.ItemIndex:= U_Main.inifile.ReadInteger('ComPort','Port_index',0);//Если в ини файле такого значения нет, индекс=0
  ComComboBox1.ItemIndex:= U_Main.inifile.ReadInteger('ComPort','BaudRate_index',7);
    If inifile.ValueExists('ComPort','Port')
      then
        try
          F_Main.ComPort1.Port:=inifile.ReadString('ComPort','Port','Com1');
          F_Main.ComPort1.Open;
        except
          ShowMessage('Не удалось подключиться к порту: '+ F_Main.ComPort1.Port);
        end
      else
        try
          F_Main.ComPort1.Port:=CmBx_VyberiPort.Items[CmBx_VyberiPort.ItemIndex];
          F_Main.ComPort1.Open;
        except
          ShowMessage('Не удалось подключиться к порту: '+ F_Main.ComPort1.Port);
        end;
end;

procedure TF_ServNastr.Btn_OprosYstrClick(Sender: TObject);
begin
  Paket.gauge:= Gauge1;
  Paket.lable:= Label_Vait;
  Paket.OprosYstroistv;
  DannyeVGrid;
end;

procedure TF_ServNastr.DannyeVGrid;
var
  i: integer;
begin
  cxGrid1TableView1.DataController.RecordCount:=realdevice.Count;
  cxGrid2TableView1.DataController.RecordCount:= realdevice.Count;
  TcxComboBoxProperties(cxGrid2TV1Col6.Properties).Items.Clear;
  If Length(MyForms)>0
    then
      begin
        for i:=0 to Length(MyForms)-1 do MyForms[i].Free;
        SetLength(MyForms,realdevice.Count); //Массив тоже по количеству элементов
      end
    else
      SetLength(MyForms,realdevice.Count); //Массив тоже по количеству элементов
  For i:=0 to realdevice.Count-1 do
    begin
      U_Main.inifile.WriteString('Из стринг листа',realdevice.Names[i],realdevice.ValueFromIndex[i]);
      with cxGrid1TableView1.DataController do
        begin
          Values[i,0]:= i+1;
          Values[i,1]:= realdevice.ValueFromIndex[i];
          Values[i,2]:= realdevice.Names[i];
        end;
      with cxGrid2TableView1.DataController do
        begin
          If Formirovatel_Paketov.realdevice.ValueFromIndex[i]='часы'
            then
              begin
                RecordCount:= RecordCount-1;
                Continue;
              end
            else
              begin
                Values[i,0]:=i+1;
                Values[i,1]:=True;
                Values[i,3]:=Formirovatel_Paketov.realdevice.ValueFromIndex[i];
                TcxComboBoxProperties(cxGrid2TV1Col6.Properties).Items.Add(realdevice.Names[i]); //Заполняем комбобокс всеми реальными адресами
                Paket.ZaprosCeny(i);
                F_Main.ComPort1.Read(P_vhod,15);
                if (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=11) and (P_vhod[12]=255)
                  then Values[i,4]:= Paket.CenaonDevice;
              end;
          Values[i,5]:=TcxComboBoxProperties(cxGrid2TV1Col6.Properties).Items[i];
        end;
    end;
end;

procedure TF_ServNastr.CmBx_VyberiPortChange(Sender: TObject);
begin
  F_Main.ComPort1.Close;
  F_Main.ComPort1.Port:=CmBx_VyberiPort.Items[CmBx_VyberiPort.ItemIndex];
  F_Main.ComPort1.Open;
  U_Main.iniFile.WriteString('ComPort','Port',CmBx_VyberiPort.Items[CmBx_VyberiPort.ItemIndex]);
  U_Main.inifile.WriteInteger('ComPort','Port_index',CmBx_VyberiPort.ItemIndex);
  ShowMessage('Текущий порт: '+F_Main.ComPort1.Port);
end;

procedure TF_ServNastr.Btn_SohrOtobrClick(Sender: TObject);
var
  i,t: integer;
begin
  t:=0;
  Paket.DeleteMyEdits;
  U_Main.inifile.EraseSection('Для приема от устройств');
  U_Main.inifile.EraseSection('Для отправки на устройства');
  With cxGrid2TableView1.DataController do
    For i:=0 to RecordCount-1 do
      If Values[i,1]=True
        then
          begin
            Inc(t); //t:=t+1;
            SetLength(MyEdits,t);
            SetLength(MyLables,t);
            MyEdits[t-1]:=TEdit.Create(F_Main);
              with MyEdits[t-1] do
                begin
                  Parent:=F_Main.ScrollBox1;
                  Width:=100;
                  Height:=30;
                  Left:=70;
                  Top:=10+(t-1)*50;
                  Text:= VarToStr(Values[i,4]);
                  Font.Size:=14;
                  Tag:= StrToInt(Values[i,5]);
                  Hint:='Поле отображает цену на устройстве.'+#10#13+'Если необходимо сменить цену,'
                                 +#10#13+'нужно ввести новое значение и нажать кнопку "Записать"';
                  ShowHint:=True;
                  OnKeyPress:=F_Main.KeyPress;
                  OnChange:= F_Main.ChangeOfEdit;
                end;
            If VarToStr(Values[i,2])=''
              then
                begin
                  U_Main.inifile.WriteString('Для приема от устройств',
                                              Values[i,5],Values[i,0]);
                  U_Main.inifile.WriteString('Для отправки на устройства',
                                              Values[i,0],Values[i,5]);
                  MyLables[t-1]:=TLabel.Create(F_Main);
                  with MyLables[t-1] do
                    begin
                      Parent:=F_Main.ScrollBox1;
                      Width:=30;
                      Height:=30;
                      Left:=20;
                      Top:=10+(t-1)*50;
                      Caption:= Values[i,0];
                      Font.Size:=14;
                      Hint:='Тип топлива, которому соотвествует'+#10#13+
                                'информационное табло на стелле и в программе.'+#10#13+
                                'Если в настройках программы не определить'+#10#13+
                                'соответствие поля типу топлива'+#10#13+
                                'будет отображаться порядковый номер'+#10#13+'обнаруженного в сети устройства с ценой';
                      ShowHint:=True;
                    end;
                end
              else
                begin
                  U_Main.inifile.WriteString('Для приема от устройств',
                                              Values[i,5],Values[i,2]);
                  U_Main.inifile.WriteString('Для отправки на устройства',
                                              Values[i,2],Values[i,5]);
                  MyLables[t-1]:=TLabel.Create(F_Main);
                  with MyLables[t-1] do
                    begin
                      Parent:=F_Main.ScrollBox1;
                      Width:=30;
                      Height:=30;
                      Left:=20;
                      Top:=10+(t-1)*50;
                      Caption:= Values[i,2];
                      Font.Size:=14;
                      Hint:='Тип топлива, которому соотвествует'+#10#13+
                                'информационное табло на стелле и в программе.'+#10#13+
                                'Если в настройках программы не определить'+#10#13+
                                'соответствие поля типу топлива'+#10#13+
                                'будет отображаться порядковый номер'+#10#13+'обнаруженного в сети устройства с ценой';
                      ShowHint:=True;
                    end;
                end; // end else
          end //end If Values[i,1]=True
        else
          Continue;
end;

procedure TF_ServNastr.cxGrid1TableView1CellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  row:= cxGrid1TableView1.Controller.FocusedRowIndex;
  If cxGrid1TableView1.DataController.Values[row,1]='панель с ценой'
    then
      If MyForms[row]=nil
        then
          begin
            MyForms[row]:= TF_Nastr_Ceny.Create(F_ServNastr);
            MyForms[row].Show;
          end
        else
          MyForms[row].Show;
  If cxGrid1TableView1.DataController.Values[row,1]='часы'
    then
      If MyForms[row]=nil
        then
          begin
            MyForms[row]:= TF_NastrChasov.Create(F_ServNastr);
            MyForms[row].Show;
          end
        else
          MyForms[row].Show;
end;

{procedure TF_ServNastr.CmBx_VyberiPortDropDown(Sender: TObject);
begin
//  Slegy_za_portami;
end;  }

procedure TF_ServNastr.ComComboBox1Change(Sender: TObject);
begin
  ComComboBox1.ApplySettings;
  U_Main.inifile.WriteInteger('ComPort','BaudRate_index',ComComboBox1.ItemIndex);
  Paket.OprosYstroistv;
  DannyeVGrid;
  ShowMessage('Скорость порта изменена и составляет: '+ ComComboBox1.Items[ComComboBox1.ItemIndex]+' бит/с');
end;

procedure TF_ServNastr.Slegy_za_portami;
var
  i: integer;
begin
  i:=0;
  CmBx_VyberiPort.Items.Clear;
  EnumComPorts(CmBx_VyberiPort.Items);
  While i<CmBx_VyberiPort.Items.Count do
    begin
      F_Main.ComPort1.Port:= CmBx_VyberiPort.Items[i];
      try
        F_Main.ComPort1.Open;
        F_Main.ComPort1.Close;
        i:=i+1;
      except
        CmBx_VyberiPort.Items.Delete(i);
      end;
    end;
end;

procedure TF_ServNastr.SpinEdit_RazrChange(Sender: TObject);
begin
  razr:=SpinEdit_Razr.Value;
  U_Main.inifile.WriteInteger('Табло','razr',razr);
end;

{procedure TF_ServNastr.CmBx_VyberiPortCloseUp(Sender: TObject);
begin
  If inifile.ValueExists('ComPort','Port')
    then
      try
        F_Main.ComPort1.Port:=inifile.ReadString('ComPort','Port','Com1');
        F_Main.ComPort1.Open;
      except
        ShowMessage('Не удалось подключиться к порту: '+ F_Main.ComPort1.Port);
      end
    else
      try
        F_Main.ComPort1.Port:= CmBx_VyberiPort.Items[CmBx_VyberiPort.ItemIndex];
        F_Main.ComPort1.Open;
      except
        ShowMessage('Не удалось подключиться к порту: '+ F_Main.ComPort1.Port);
      end;
end;  }

procedure TF_ServNastr.cxGrid2TV1Col6PropertiesChange(Sender: TObject);
begin
  try
    Paket.ZaprosCeny(realdevice.IndexOfName(TcxComboBox(sender).Text));
    F_Main.ComPort1.Read(P_vhod,15);
      begin
        if (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=11) and (P_vhod[12]=255)
          then
            With cxGrid2TableView1.DataController do
              begin
                Values[FocusedRecordIndex,5] := TcxComboBox(sender).Text;
                Values[FocusedRecordIndex,4] := Paket.CenaonDevice;
              end;
      end;
  except
    if TcxComboBox(sender).Text = ''
      then ShowMessage('Не задан адрес для устройства')
      else ShowMessage('Выбран адрес несуществующего устройства в сети');
  end;
end;

end.
