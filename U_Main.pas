unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Menus, ExtCtrls, U_OProgr,
  U_ServNastr, Formirovatel_Paketov, inifiles, U_Pass1, U_ParolPyltaDU, U_NastrChasov,
  RXSwitch, rxToolEdit, Mask, U_UstrSCenoy, U_Nastr_Porta, Gauges, U_StopModal,
  U_PortToolk, Math, Buttons, CPort, CPortCtl;

type
  TF_Main = class(TForm)
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    Action_PortOptions: TAction;
    MenuFile: TMenuItem;
    Menu_NastroikiPorta: TMenuItem;
    Menu_SohrCeny: TMenuItem;
    Menu_OtkrytCeny: TMenuItem;
    Menu_IzmParolPultaDU: TMenuItem;
    Spravka: TMenuItem;
    Menu_oProgramme: TMenuItem;
    Action_SohranenieCen: TAction;
    Action_OtkrytieCen: TAction;
    Action_IzmParolPultaDu: TAction;
    Action_OProgramme: TAction;
    Label_ParolPultaDU: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    ScrollBox1: TScrollBox;
    Btn_SchitSoStelly: TButton;
    Btn_ZapNaStelly: TButton;
    Timer1: TTimer;
    Gauge1: TGauge;
    Label_Vait: TLabel;
    OpenCeny: TOpenDialog;
    SaveCeny: TSaveDialog;
    Timer2: TTimer;
    Btn1_ZapVremsPK: TSpeedButton;
    ComPort1: TComPort;
    procedure FormCreate(Sender: TObject);
    procedure Action_PortOptionsExecute(Sender: TObject);
    procedure Action_OProgrammeExecute(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Action_OtkrytieCenExecute(Sender: TObject);
    procedure Action_IzmParolPultaDuExecute(Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: Char);
    procedure Btn_SchitSoStellyClick(Sender: TObject);
    procedure Btn_ZapNaStellyClick(Sender: TObject);
    procedure ChangeOfEdit(Sender: TObject);
    procedure Action_SohranenieCenExecute(Sender: TObject);
    procedure Btn1_ZapVremsPKClick(Sender: TObject);

  public

    procedure TimeonDevice;

  end;

var
  F_Main: TF_Main;
  TimeStart, t1: TDateTime;
  inifile: TIniFile;
  Paket: TPaketovshik;
  MyEdits: array of TEdit;
  MyLables: array of TLabel;
  flag: integer=0;
  filename: string;
  Simbol: set of byte = [8,44,46,48,49,50,51,52,53,54,55,56,57,127];
  Adress: set of byte = [1..255];
  FlagOprosa: Boolean;
  Nomer_ystroistva: integer;
  Ocheredn_ystr: integer;
  AdresaIzmYstr: TStringList;
  IsEditChange: Boolean = False;

implementation


{$R *.dfm}

procedure TF_Main.FormCreate(Sender: TObject);
begin
  Application.HintHidePause := 10000; //Время отображения подсказок - 5 сек 
  Timer1.Enabled:= false;
  Panel1.Left:=Round((F_Main.ClientWidth-Panel1.Width)/2);
  Label_ParolPultaDU.Left:= 10;
  ScrollBox1.Left:= 10;
  Gauge1.Visible:=False;
  Label_Vait.Visible:=False;
  iniFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'settings.ini');
  razr:=inifile.ReadInteger('Табло','razr',4);
  Paket:= TPaketovshik.Create;
  Btn1_ZapVremsPK.Enabled:= False;
  Btn1_ZapVremsPK.Caption:= 'Записать'+#10#13+'Время с ПК';
  Timer2.Enabled:= False;
  If inifile.ValueExists('ComPort','Port')
    then
      try
        ComPort1.Port:=inifile.ReadString('ComPort','Port','Com1');
        ComPort1.Open;
        Paket.YznatParolPultaDU; //Считаем что первое устройство есть и спрашиваем пароль пульта
      except
        ShowMessage('Программа пытается подключиться к порту '+ ComPort1.Port+'.'+
                    #13 +'Данный порт занят какой-то программой или устройством.'+#13
                    +'Выберите другой порт в настройках.');
      end
    else
      ShowMessage('Программа запущена, но не подключена к COM порту.'+#13+
                  'Для дальнейшей работы выберите необходимый COM порт в настройках.');
end;

procedure TF_Main.ComPort1RxChar(Sender: TObject; Count: Integer);
begin
  ComPort1.Read(P_vhod,15);
  If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//Если пришел пакет на авторизацию и "засыпание" программы
    then
      begin
        FWait:= TFWait.Create(Self);
        FWait.ShowModal;
      end;
end;

procedure TF_Main.Action_PortOptionsExecute(Sender: TObject);
begin
  If F_Nastr_Porta=nil
    then
      begin
        F_Nastr_Porta:= TF_Nastr_Porta.Create(F_Main);
        F_Nastr_Porta.Show;
      end
    else
      F_Nastr_Porta.Show;
end;

procedure TF_Main.Action_OProgrammeExecute(Sender: TObject);
begin
  If F_OProgramme=nil
    then
      begin
        F_OProgramme:= TF_OProgramme.Create(Self);
        F_OProgramme.Show;
      end
    else
      F_OProgramme.Show;
end;

procedure TF_Main.TimeonDevice;
 var
   s:string; //Чтобы преобразовать строку в дату и время, строка должна быть вида "день.месяц.год час:минута:секунда"
 begin
   try
      s:='';
      s:=s+IntToStr(P_vhod[6])+'.'+IntToStr(P_vhod[7])+'.'+IntToStr(P_vhod[8])+
         ' ' +IntToStr(P_vhod[4])+':'+IntToStr(P_vhod[3])+':'+IntToStr(P_vhod[2]);
      TimeStart:=StrToDateTime(s);
      Label1.Caption:= FormatDateTime('Время:'+#13+'hh:nn:ss'+#13+'Дата: dd.mm.yy', TimeStart);
      Timer1.Enabled:=True;
   except
      ShowMessage('От часов поступили некорректные данные: '+ s);
      exit;
   end;
end;

procedure TF_Main.Timer1Timer(Sender: TObject);
begin
  Label1.Caption := FormatDateTime('Время:'+#13+'hh:nn:ss'+#13+'Дата: dd.mm.yy', TimeStart);
  TimeStart:=TimeStart+1/(24*3600);
end;

procedure TF_Main.Action_OtkrytieCenExecute(Sender: TObject);
var
  i: integer;
begin
  Label_Vait.Visible:=False;
  Application.ProcessMessages;
  If Length(MyLables)>0
    then
      begin
        for i:=0 to Length(MyLables)-1 do MyLables[i].Free;
        SetLength(MyLables,0);
      end;
  If Length(MyEdits)>0
    then
      begin
        for i:=0 to Length(MyEdits)-1 do MyEdits[i].Free;
         SetLength(MyEdits,0);
      end;
  If OpenCeny.Execute
    then
      begin
        filename:=OpenCeny.FileName;
        If ceny=nil
          then
            begin
              ceny:=TStringList.Create;
              ceny.LoadFromFile(filename);
            end
          else
            ceny.LoadFromFile(filename);
      end;
  SetLength(MyEdits,ceny.Count);
  SetLength(MyLables,ceny.Count);
  for i:=0 to ceny.Count-1 do
    begin
      MyLables[i]:=TLabel.Create(F_Main);
      with MyLables[i] do
        begin
          Parent:=F_Main.ScrollBox1;
          Width:=30;
          Height:=30;
          Left:=20;
          Top:=10+i*50;
          Caption:= ceny.Names[i];
          Font.Size:=14;
        end;
      MyEdits[i]:=TEdit.Create(F_Main);
      with MyEdits[i] do
        begin
          Parent:=F_Main.ScrollBox1;
          Width:=100;
          Height:=30;
          Left:=70;
          Top:=10+i*50;
          Text:= ceny.ValueFromIndex[i];
          Font.Size:=14;
          OnKeyPress:=KeyPress;
          OnChange:= ChangeOfEdit;
        end;
    end;
end;

procedure TF_Main.Action_IzmParolPultaDuExecute(Sender: TObject);
begin
  If F_ParolDU=nil
    then
      begin
        F_ParolDU:= TF_ParolDU.Create(Self);
        F_ParolDU.Show;
      end
    else
      F_ParolDU.Show;
end;

procedure TF_Main.KeyPress(Sender: TObject; var Key: Char);
begin
  If not(ord(Key) in Simbol) then Key:=#0;
  If ((ord(Key)=44) or (ord(Key)=46)) and (flag=1)
    then
      key:=#0;
end;

procedure TF_Main.ChangeOfEdit(Sender: TObject);
begin
  //ShowMessage((Sender as TEdit).Text);
  If (Pos('.',(Sender as TEdit).Text)>0) or (Pos(',',(Sender as TEdit).Text)>0)
    then
      begin
        (Sender as TEdit).MaxLength:=razr+1;
        flag:=1;
      end
    else
      begin
        (Sender as TEdit).MaxLength:=razr;
        flag:=0;
      end;
  If AdresaIzmYstr = nil
    then AdresaIzmYstr:= TStringList.Create;
  If AdresaIzmYstr.IndexOfName(IntToStr((Sender as TEdit).Tag)) >= 0 //Если там имеется уже измененное значение...
    then
      begin
        AdresaIzmYstr.Delete(AdresaIzmYstr.IndexOfName(IntToStr((Sender as TEdit).Tag)));
        AdresaIzmYstr.Add(IntToStr((Sender as TEdit).Tag)+'='+(Sender as TEdit).Text);
        {ShowMessage('Сейчас в стринглисте строк: '+ IntToStr(AdresaIzmYstr.Count)+#10+#13+
                    'Изменения произошли в строке с индексом: '+ IntToStr(AdresaIzmYstr.IndexOfName(IntToStr((Sender as TEdit).Tag))));  }
      end
    else
      begin
        AdresaIzmYstr.Add(IntToStr((Sender as TEdit).Tag)+'='+(Sender as TEdit).Text); //Запомнили адрес устройства, где было изменение
        //ShowMessage('Добавилась новая измененная строчечка '+s+'  и индекс у нее '+IntToStr(AdresaIzmYstr.IndexOfName(IntToStr((Sender as TEdit).Tag))));
      end;
end;

procedure TF_Main.Btn1_ZapVremsPKClick(Sender: TObject);
begin
  TimeStart:=Now;
  //ShowMessage('Время на часах: '+ TimeToStr(TimeStart));
  //Label1.Caption := FormatDateTime('Время на стелле:'+#13+'hh:nn:ss'+#13+'Дата: dd.mm.yy', TimeStart);
  Paket.YstNovZnachVrem;
  Timer1.Enabled:=True;
end;

procedure TF_Main.Btn_SchitSoStellyClick(Sender: TObject);
begin
  Paket.gauge:= Gauge1;
  Paket.lable:= Label_Vait;
  Paket.OprosYstroistv;
end;

procedure TF_Main.Btn_ZapNaStellyClick(Sender: TObject);
var
  i: integer;
begin
  If AdresaIzmYstr = nil
    then
      begin
        ShowMessage('Вы не сделали изменений в ценах');
        exit;
      end  
    else
      For i:=0 to AdresaIzmYstr.Count-1 do
        begin
         { ShowMessage('Изменения произошли на устройстве с адресом: ' + AdresaIzmYstr.Names[i] + #10#13+
                  'Измененное значение равно' + AdresaIzmYstr.ValueFromIndex[i]);  }
          Paket.ZapisCenyNaOdnomUstr(StrToInt(AdresaIzmYstr.Names[i]),AdresaIzmYstr.ValueFromIndex[i]);
        end;
  FreeAndNil(AdresaIzmYstr);
  {If Length(MyLables)>0
    then Paket.ZapisCeny
    else ShowMessage('Нет данных для записи на устройства');  }
end;

procedure TF_Main.Action_SohranenieCenExecute(Sender: TObject);
var
  i:integer;
begin
  If Length(MyLables)>0
    then
      begin
        If ceny=nil
          then
            ceny:=TStringList.Create;
        ceny.Clear;
        If SaveCeny.Execute
          then
            begin
              For i:=0 to Length(MyLables)-1 do
                ceny.Add(MyLables[i].Caption+'='+MyEdits[i].Text);
              filename:= SaveCeny.FileName;
              ceny.SaveToFile(filename);
            end;
      end
    else
      begin
        ShowMessage('Нет данных для записи цен в файл');
        exit;
      end;
end;

end.
