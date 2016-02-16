{------------------------------------------}
//Модуль-класс для отправки пакетов в сеть//
{------------------------------------------}

unit Formirovatel_Paketov;

interface

uses
  Dialogs, SysUtils, StdCtrls, classes, forms, U_ParolPyltaDU, U_ServNastr,
  U_NastrChasov, U_UstrSCenoy, CPortCtl, U_Nastr_Porta, Gauges,
  Messages, Variants, Graphics, Controls, U_StopModal, Windows, ExtCtrls;

Type

  TPaketovshik = Class //Объявление общего класса работы с формированием и отправкой пакетов

  Private
    Fgauge: TGauge;
    Flable: TLabel;

  Public
    procedure ZaprosVrem; //Запрос значения времени у часов, оно же устройство с тестовым адресом 5 (1-й байт)) командой 12 (12-й байт)
    procedure YstNovZnachVrem; // Пакет на часы (устройство с адресом 5 (1-й байт)) для установки нового значения времени командой 2 (12-й) байт
    procedure ZaprosCeny(i:integer); {Запрос значения цены у всех устройств в сети поочереди}
    procedure ZapisCeny;// Процедура отправки пакетов на устройство для записи на них цен, устанавливаемых с компа
    procedure IzmAdrNa(number:integer); //Метод замены адреса одного устройства на другой путем отправки определенного пакета
    procedure ParolPultaDu;//Метод записи пароля пульта ду определенным пакетом
    function CenaonDevice:string;
    procedure YstRegimVrem; //Метод установки режима отображения данных
    procedure IzmSkorPeredDannyh(number_str:integer); // Метод изменения скорости порта
    procedure ZapisCenyNaOdnomUstr(adr: integer; cena: string);
    procedure YznatParolPultaDU;
    procedure VremjaModalnogoOkna(sender: TObject); //событие для таймера работы модального окна
    procedure OprosYstroistv;// Обработчик нажатия кнопки "считать" и "найти устройство"
    procedure DeleteMyEdits; //Очищает поле с лейблами и эдитами при новом сканировании

    property gauge: TGauge read Fgauge write Fgauge;
    property lable: TLabel read Flable write Flable;

  end;


var
  Paketik: array [1..15] of byte;
  P_vhod:array[1..15] of byte;
  realdevice , ceny: TStringList;
  razr: Integer;
  NomerYstr: integer;
  j2,t,tt: integer;
  timer_vait: TTimer;


implementation

uses
  U_Main, cxCustomData, IniFiles, U_PortToolk;


procedure TPaketovshik.DeleteMyEdits;
var
  i: integer;
begin
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
end;

procedure TPaketovshik.OprosYstroistv;
var
  i,x,n,p,k:integer;
begin
  F_Main.ComPort1.OnRxChar:=nil; //На время опроса устройств отключаем обработчик приема
  If not F_Main.ComPort1.Connected
    then
      if inifile.ValueExists('ComPort','Port')
        then
          try
            F_Main.ComPort1.Port:=inifile.ReadString('ComPort','Port','Com1');
            F_Main.ComPort1.Open;
          except
            ShowMessage('Не удалось подключиться к порту: '+ F_Main.ComPort1.Port);
          end
        else
          begin
            ShowMessage('Программа пытается опросить устройства через порт '+ F_Main.ComPort1.Port
                        + '.' +#13+ 'В данный момент порт недоступен. Выберите другой порт.');
            exit;
          end;
  DeleteMyEdits;
  If realdevice=nil
    then
      begin
        realdevice:= TStringList.Create;
        U_Main.inifile.EraseSection('Из стринг листа');//новый опрос - чистая секция в ини файле
      end
    else
      begin
        realdevice.Clear; //новый опрос - чистый стринглист
        U_Main.inifile.EraseSection('Из стринг листа');//новый опрос - чистая секция в ини файле
      end;
  gauge.MaxValue:= 30;
  gauge.Progress:=0;
  gauge.Visible:=True;
  lable.Visible:=True;
  Application.ProcessMessages;
  For i:=1 to 10 do //Последовательный опрос всех устройств в сети
    begin
      FlagOprosa:=false;
      for j2:=1 to 3 do //По 3 раза шлем каждому устройству в сети пакет
        begin
          Paketik[1]:=i; //Адреса назначения - попорядку
          Paketik[2]:=0;
          Paketik[3]:=0;
          Paketik[4]:=0;
          Paketik[5]:=0;
          Paketik[6]:=0;
          Paketik[7]:=0;
          Paketik[8]:=0;
          Paketik[9]:=0;
          Paketik[10]:=1;
          Paketik[11]:=0;
          Paketik[12]:=15; //Ключевая команда 15 - запрос адреса у устройств
          x:=0;
          for n:=1 to 12 do x:=x+(Paketik[n] xor $FF);
          Paketik[13]:=x;
          Paketik[14]:=$0D;
          Paketik[15]:=$0A;
          F_Main.ComPort1.Write(Paketik,15);
          Sleep(50);
          If F_Main.ComPort1.InputCount>0     //Если в порту хоть что-то есть
            then     //Обрабатываем все пакеты поочереди
              Repeat
                F_Main.ComPort1.Read(P_vhod,15);
                If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=15) and (P_vhod[12]=255) //Если пришел пакет-ответ с часов
                  then
                    begin
                      iniFile.WriteString('Для приема от устройств',IntToStr(i),'часы');
                      iniFile.WriteString('Для отправки на устройства','часы',IntToStr(i));
                      realdevice.Add(IntToStr(i)+'=часы');//Занесли в список реальный адрес устройства в сети
                      FlagOprosa:=True;
                      gauge.MaxValue:=gauge.MaxValue-(3-j2);
                    end;
                If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=15) and (P_vhod[12]=255)//Если пришел пакет-ответ с панели для цены
                  then
                    begin
                      realdevice.Add(IntToStr(i)+'=панель с ценой');//Занесли в список реальний адрес устройства в сети
                      FlagOprosa:=True;
                      gauge.MaxValue:=gauge.MaxValue-(3-j2);
                    end;
                If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//Если пришел пакет на авторизацию и "засыпание" программы
                  then
                    begin
                      FWait:= TFWait.Create(F_Main);
                      FWait.ShowModal;
                    end;
              until (F_Main.ComPort1.InputCount div 15)=0;
          for k:=1 to 15 do P_vhod[k]:=0; //На всякий случай обнуляем массивчик P_vhod
          gauge.Progress:=gauge.Progress+1;
          If FlagOprosa then Break;
        end; {for j2}
    end; {for i}
  gauge.Visible:=False;
  lable.Visible:=False;
  Application.ProcessMessages;
  If realdevice.Count=0
    then
      begin
        FreeAndNil(realdevice); //Если нет устройств, то и стринг лист не нужен
        lable.Visible:=True;
        lable.Caption:='Устройств в сети не обнаружено';
        exit;
      end
    else
      F_Main.ScrollBox1.ShowHint:=False;  
  t:=0;    
  For j2:=0 to realdevice.Count-1 do   //Цикл по количеству реальных устройств в сети, записанному в стринг листе
    If realdevice.ValueFromIndex[j2]='часы'
      then
        begin
          Paket.ZaprosVrem;//Если в сети есть часы, почему бы не спросить время
          Continue;
        end
      else
        begin
          t:=t+1;
          SetLength(MyEdits,t);
          SetLength(MyLables,t);
          Paket.ZaprosCeny(j2);
          If F_Main.ComPort1.InputCount>0     //Если в порту хоть что-то есть
            then
              Repeat    //Обрабатываем все пакеты поочереди
                F_Main.ComPort1.Read(P_vhod,15);
                If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=11) and (P_vhod[12]=255)
                  then
                    begin
                      MyLables[t-1]:=TLabel.Create(F_Main);
                      with MyLables[t-1] do
                        begin
                          Parent:=F_Main.ScrollBox1;
                          Width:=30;
                          Height:=30;
                          Left:=20;
                          Top:=10+(t-1)*50;
                          If inifile.SectionExists('Для приема от устройств')
                            then Caption:= inifile.ReadString('Для приема от устройств',IntToStr(P_vhod[9]),IntToStr(P_vhod[9]))
                            else Caption:= realdevice.Names[j2];
                          Font.Size:=14;
                          Hint:='Тип топлива, которому соотвествует'+#10#13+
                                'информационное табло на стелле и в программе.'+#10#13+
                                'Если в настройках программы не определить'+#10#13+
                                'соответствие поля типу топлива'+#10#13+
                                'будет отображаться порядковый номер'+#10#13+'обнаруженного в сети устройства с ценой';
                          ShowHint:=True;
                        end;
                      MyEdits[t-1]:=TEdit.Create(F_Main);
                      with MyEdits[t-1] do
                        begin
                          Parent:=F_Main.ScrollBox1;
                          Width:=100;
                          Height:=30;
                          Left:=70;
                          Top:=10+(t-1)*50;
                          Text:= Paket.CenaonDevice;
                          Font.Size:=14;
                          Tag:= StrToInt(realdevice.Names[j2]);//Эдит знает за каким адресом он закреплен
                          {Hint:='Поле отображает цену на устройстве.'+#10#13+'Если необходимо сменить цену,'
                                 +#10#13+'нужно ввести новое значение и нажать кнопку "Записать"';    }
                          Hint:= IntToStr(Tag);
                          ShowHint:=True;
                          OnKeyPress:=F_Main.KeyPress;
                          OnChange:= F_Main.ChangeOfEdit;
                        end;
                      for k:=1 to 15 do P_vhod[k]:=0;  
                    end;
                If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//Если пришел пакет на авторизацию и "засыпание" программы
                  then
                    begin
                      FWait:= TFWait.Create(F_Main);
                      FWait.ShowModal;
                    end;
                  until (F_Main.ComPort1.InputCount div 15)=0
            else
              ShowMessage('Нет данных от устройства: '+IntToStr(Paketik[1]));
        end;
  If not F_Main.Btn1_ZapVremsPK.Enabled
    then
      begin
        TimeStart:= now;
        F_Main.Timer1.Enabled:=True;
      end;
  F_Main.ComPort1.OnRxChar:=F_Main.ComPort1RxChar; //Возвращаем событие на место
end;

procedure TPaketovshik.VremjaModalnogoOkna(sender:TObject); // Таймер для модального окна
var
  k2: integer;
begin
  tt:=tt+timer_vait.Interval;
  If F_Main.ComPort1.InputCount > 0 // Циклов таймера будет больше, чем пакетов в буфере. Зачем лишние обработки
    then
      begin
        F_Main.ComPort1.Read(P_vhod,15);
          if (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=21) then  //Если пришел пакет на выход из авторизации
            begin
              timer_vait.Enabled:= False;
              for k2:=1 to 15 do P_vhod[k2]:=0;
              FWait.Close;
              exit;
            end;
          If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=15) and (P_vhod[12]=255) //Если пришел пакет-ответ с часов
            then
              begin
                Inifile.WriteString('Для приема от устройств',IntToStr(Paketik[1]),'часы');
                Inifile.WriteString('Для отправки на устройства','часы',IntToStr(Paketik[1]));
                realdevice.Add(IntToStr(Paketik[1])+'=часы');//Занесли в список реальный адрес устройства в сети
                FlagOprosa:=True;
                gauge.MaxValue:=gauge.MaxValue-(3-j2);
                for k2:=1 to 15 do P_vhod[k2]:=0; //Отработали, обнулили пакет
              end;
          If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=15) and (P_vhod[12]=255)//Если пришел пакет-ответ с панели для цены
            then
              begin
                realdevice.Add(IntToStr(Paketik[1])+'=панель с ценой');//Занесли в список реальний адрес устройства в сети
                FlagOprosa:=True;
                gauge.MaxValue:=gauge.MaxValue-(3-j2);
                for k2:=1 to 15 do P_vhod[k2]:=0; //Обнулили пакет
              end;
          If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=15) and (P_vhod[12]=255) //Если пришло знчение времени с часов
            then
              begin
                F_Main.TimeonDevice;
                F_Main.Btn1_ZapVremsPK.Enabled:=True;
              end;
          If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=11) and (P_vhod[12]=255)//Ответ от каждого устройства о значении цены
            then
              begin
                MyLables[t-1]:=TLabel.Create(F_Main);
                with MyLables[t-1] do
                  begin
                    Parent:=F_Main.ScrollBox1;
                    Width:=30;
                    Height:=30;
                    Left:=20;
                    Top:=10 + (t-1)*50;
                    If inifile.SectionExists('Для приема от устройств')
                      then Caption:= inifile.ReadString('Для приема от устройств',IntToStr(P_vhod[9]),IntToStr(P_vhod[9]))
                      else Caption:= realdevice.Names[j2];
                    Font.Size:=14;
                  end;
                MyEdits[t-1]:=TEdit.Create(F_Main);
                with MyEdits[j2] do
                  begin
                    Parent:=F_Main.ScrollBox1;
                    Width:=100;
                    Height:=30;
                    Left:=70;
                    Top:=10 + (t-1)*50;
                    Text:= Paket.CenaonDevice;
                    Font.Size:=14;
                    OnKeyPress:=F_Main.KeyPress;
                    OnChange:= F_Main.ChangeOfEdit;
                  end;
                for k2:=1 to 15 do P_vhod[k2]:=0; //Обнулили пакет
              end;
      end;
  If tt=5000 then
    begin
      timer_vait.Enabled:= False;
      FWait.Close;
    end;
end;

procedure TPaketovshik.ZaprosCeny(i:integer);
var
  x,k:integer;
  begin
    Paketik[1]:= StrToInt(realdevice.Names[i]);
    Paketik[2]:=0;
    Paketik[3]:=0;
    Paketik[4]:=0;
    Paketik[5]:=0;
    Paketik[6]:=0;
    Paketik[7]:=0;
    Paketik[8]:=0;
    Paketik[9]:=0;
    Paketik[10]:=1;
    Paketik[11]:=0;
    Paketik[12]:=11;//Ключевая команда 11 (0B) - запрос цены
    x:=0;
    for k:=1 to 12 do x:=x+(Paketik[k] xor $FF);
    Paketik[13]:=x;
    Paketik[14]:=$0D;
    Paketik[15]:=$0A;
    F_Main.ComPort1.Write(Paketik,15);
    Sleep(50);
end;

procedure TPaketovshik.ZaprosVrem;//Процедура проверена. Пакет соотв формату
var
  x,i,p,k:integer;
begin
  Paketik[1]:=U_Main.inifile.ReadInteger('Для отправки на устройства','часы',8);//В значение 1-го байта будет подставляться адрес часов после сканирования.
  Paketik[2]:=0;
  Paketik[3]:=0;
  Paketik[4]:=0;
  Paketik[5]:=0;
  Paketik[6]:=0;
  Paketik[7]:=0;
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=12; //Ключевая команда 12 - запрос времени
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(50);
  If (F_Main.ComPort1.InputCount div 15)>0     //Вдруг перед пакетом от устройства вклинился пакет на авторизацию или наоборот пристроился сзади
    then     //Обрабатываем их все поочереди
      Repeat
        F_Main.ComPort1.Read(P_vhod,15);
        If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=12) and (P_vhod[12]=255) //Если пришел пакет с часов
          then
            begin
              F_Main.TimeonDevice;
              F_Main.Btn1_ZapVremsPK.Enabled:=True;
            end;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//Если пришел пакет на авторизацию и "засыпание" программы
          then
            begin
              FWait:= TFWait.Create(F_Main);
              FWait.ShowModal;
            end;
      until (F_Main.ComPort1.InputCount div 15)=0 //Пока не проверим все
    else
      ShowMessage('Часы не ответили на запрос времени');
  for k:=1 to 15 do P_vhod[k]:=0; //На всякий случай обнуляем массивчик P_vhod
end;

procedure TPaketovshik.YstNovZnachVrem; //Процедура проверена. Пакет соответствует формату.
var
  x,i:integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(TimeStart,Year,Month,Day);
  DecodeTime(TimeStart,Hour,Min,Sec,MSec);
  Paketik[1]:= U_Main.inifile.ReadInteger('Для отправки на устройства','часы',8);
  Paketik[2]:=Sec; //Секунды
  Paketik[3]:=Min; //Минуты
  Paketik[4]:=Hour; //Часы
  Case DayOfWeek(TimeStart) of //Преобразуем к "нашему" пониманию дней недели: 1-пн...7-вс
    2..7 : Paketik[5]:= DayOfWeek(TimeStart)-1;
    1 : Paketik[5]:=7;
  end;
  Paketik[6]:=Day; //Дата
  Paketik[7]:=Month; //Месяц
  Paketik[8]:=StrToInt(copy(IntToStr(Year),3,4)); //Год из формата 2014 переходит в формат 14, 15 или 16 и т.д.
  Paketik[9]:=0; //Адрес отправителя, 00 - ПК
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=2; //Ключевая команда - 2 (02): запись нового значения времени
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF); //Вычисление CRC
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(50);
  If F_Main.ComPort1.InputCount>0     //Если в порту хоть что-то есть
    then     //Обрабатываем все пакеты поочереди
      Repeat
        F_Main.ComPort1.Read(P_vhod,15);
        If (P_vhod[9]=U_Main.inifile.ReadInteger('Для отправки на устройстваа','часы',8)) and (P_vhod[10]=3)
               and (P_vhod[11]=2) and (P_vhod[12]=255)
          then
            begin
              ShowMessage('Время на часах: '+ TimeToStr(TimeStart));
            end;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//Если пришел пакет на авторизацию и "засыпание" программы
          then
            begin
              FWait:= TFWait.Create(F_Main);
              FWait.ShowModal;
            end;
      until (F_Main.ComPort1.InputCount div 15)=0
    else
      ShowMessage('Часы не ответили на установку времени');
end;

function TPaketovshik.CenaonDevice;
 var
   j:integer;
   s:string;
begin
  s:='';
  If P_vhod[8]>0
    then
      begin
        for j:=1 to razr do
          if (P_vhod[j+1]=11)
            then
              Continue
            else
              begin
                s:=s+IntToStr(P_vhod[j+1]);
              end;
        Insert('.',s,(Length(s)+1-P_vhod[8]));
        Result:=s;
      end
    else
      begin
        for j:=1 to razr do
          if P_vhod[j+1] <> 11
            then
              s:=s+IntToStr(P_vhod[j+1]) //Формируем строку данных
            else
              Continue;
        Result:=s;      
      end;
end;

procedure TPaketovshik.ZapisCeny;
var
  i,k,x:integer;
  s,s1: string;
begin
  For i:=0 to Length(MyLables)-1 do
    begin
      s1:='';
      x:=1;
      s:= MyEdits[i].Text;
      Paketik[1]:=StrToInt(U_Main.inifile.ReadString('Для отправки на устройства',MyLables[i].Caption,'1'));//По лэйблу определили адрес
      Paketik[8]:=0; //Первоначальное смещение точки
      If (Pos('.',s)>0) or (Pos(',',s)>0)
        then
          for k:=1 to Length(s) do
            if (s[k]='.') or (s[k]=',')
              then
                begin
                  Paketik[8]:=Length(s)-k;//Уточненное смещение точки
                  Continue;
                end
              else
                s1:=s1+s[k]
        else
          s1:=s;
      If length(s1)<razr
        then
          begin
            for k:=1 to (razr-length(s1)) do
              Paketik[k+1]:=255;
            for k:= ((razr-length(s1))+1) to razr do
              begin
                Paketik[k+1]:=StrToInt(s1[x]);
                x:=x+1;
              end;  
          end
        else
          for k:=1 to razr do
            Paketik[k+1]:=StrToInt(s1[k]);
      For k:= (razr+2) to 7 do Paketik[k]:=255;//Оставшиеся байты данных в пакете заполняются значениями FF (255)
      Paketik[9]:=0;//Адрес компа
      Paketik[10]:=1; //Тип устройства - комп
      Paketik[11]:=0;//С компа эта команда пустая
      Paketik[12]:=1; //Команда на запись цены (01)
      x:=0;
      for k:=1 to 12 do x:=x+(Paketik[k] xor $FF);
      Paketik[13]:=x;
      Paketik[14]:=$0D;
      Paketik[15]:=$0A;
      F_Main.ComPort1.Write(Paketik,15);
      Sleep(100);
      If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2)
          and (P_vhod[11]=1) and (P_vhod[12]=255)
        then
          begin
          end
        else
          ShowMessage('Устройство '+ IntToStr(Paketik[1])+' не ответило на установку цены');
    end;
end;

procedure TPaketovshik.IzmAdrNa(number:integer);
var
  i,x:Integer;
begin
  Paketik[1]:=StrToInt(F_ServNastr.cxGrid1TableView1.DataController.Values[number,2]);
  if (MyForms[number] is TF_NastrChasov)
    then
      Paketik[2]:=StrToInt(TF_NastrChasov(MyForms[number]).Edit_Addres.Text)
    else
      Paketik[2]:=StrToInt(TF_Nastr_Ceny(MyForms[number]).Edit_Adres.Text);
  For i:=3 to 7 do Paketik[i]:=0;
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=5;
  x:=0;
  For i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  Sleep(50);
end;

procedure TPaketovshik.ParolPultaDu; //Сменить пароль пульта ДУ
var
  i,x:Integer;
begin
  Paketik[1]:=1;//Пакет адресуется только 1-му (управляющему) устройству 
  For i:=1 to Length(F_ParolDU.Edit1.Text) do Paketik[i+1]:=StrToInt(F_ParolDU.Edit1.Text[i]);
  For i:=(Length(F_ParolDU.Edit1.Text)+2) to 7 do Paketik[i]:=11;// Оставшиеся байты забиваются пустышками (11 или 0В)
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=6; //Ключевая команда 6 (06) - смена пароля пульта ДУ
  x:=0;
  For i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  Sleep(20);
end;

procedure TPaketovshik.YstRegimVrem;
var
  x,i:integer;
begin
  Paketik[1]:=U_Main.inifile.ReadInteger('Для отправки на устройства','часы',8);
  Paketik[2]:=U_Main.inifile.ReadInteger('Режимы часов','режимы переключений',224);
  Paketik[3]:=U_Main.inifile.ReadInteger('Режимы часов','время между перекл',10);
  Paketik[4]:=U_Main.inifile.ReadInteger('Режимы часов','12-24',0);
  Paketik[5]:=U_Main.inifile.ReadInteger('Режимы часов','AM-PM',0);
  Paketik[6]:=0;
  Paketik[7]:=0;
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=3; //Ключевая команда 3 - установка режимов
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(100);
  F_Main.ComPort1.Read(P_vhod,15);
  If (P_vhod[9]=U_Main.inifile.ReadInteger('Для отправки на устройства','часы',8)) and (P_vhod[10]=3)
     and (P_vhod[11]=3) and (P_vhod[12]=255)
    then
      begin
      end
    else
      ShowMessage('Часы не ответили на установку режима отображения данных');
end;

procedure TPaketovshik.IzmSkorPeredDannyh(number_str:integer);
var
  x,i:integer;
begin
  if (MyForms[number_str] is TF_NastrChasov)
    then
      begin
        Paketik[1]:=StrToInt(TF_NastrChasov(MyForms[number_str]).Edit_Addres.Text);
        Case StrToInt(TF_NastrChasov(MyForms[number_str]).ComComboBox_Speed.Items[TF_NastrChasov(MyForms[number_str]).ComComboBox_Speed.ItemIndex]) of
          2400 : Paketik[2]:= 0;
          4800 : Paketik[2]:= 1;
          9600 : Paketik[2]:= 2;
          14400 : Paketik[2]:= 3;
          19200 : Paketik[2]:= 4;
          38400 : Paketik[2]:= 5;
          57600 : Paketik[2]:= 6;
          115200 : Paketik[2]:= 7;
        else
          Paketik[2]:=2;
        end;
      end
    else
      begin
        Paketik[1]:=StrToInt(TF_NastrChasov(MyForms[number_str]).Edit_Addres.Text);
        Case StrToInt(TF_Nastr_Ceny(MyForms[number_str]).ComComboBox1.Items[TF_Nastr_Ceny(MyForms[number_str]).ComComboBox1.ItemIndex]) of
          2400 : Paketik[2]:= 0;
          4800 : Paketik[2]:= 1;
          9600 : Paketik[2]:= 2;
          14400 : Paketik[2]:= 3;
          19200 : Paketik[2]:= 4;
          38400 : Paketik[2]:= 5;
          57600 : Paketik[2]:= 6;
          115200 : Paketik[2]:= 7;
        else
          Paketik[2]:=2;
        end;
      end;
  Paketik[3]:=0;
  Paketik[4]:=0;
  Paketik[5]:=0;
  Paketik[6]:=0;
  Paketik[7]:=0;
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=4; //Ключевая команда 4 - установка скорости порта
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(50);
  F_Main.ComPort1.Read(P_vhod,15);
  If (P_vhod[9]=U_Main.inifile.ReadInteger('Для отправки на устройства','часы',8)) and (P_vhod[10]=3)
     and (P_vhod[11]=4) and (P_vhod[12]=255) and (P_vhod[2]=Paketik[2])
    then
      begin
      end
    else
      ShowMessage('Часы не ответили на установку скорости передачи данных');
end;

procedure TPaketovshik.ZapisCenyNaOdnomUstr(adr: integer; cena: string);
var
  k,x:integer;
  s,s1: string;
begin
  F_Main.Memo1.Lines.Clear;
  s1:='';
  x:=1;
  Paketik[1]:= adr;
  Paketik[8]:=0; //Первоначальное смещение точки
  If (Pos('.',cena)>0) or (Pos(',',cena)>0)
    then
      for k:=1 to Length(cena) do
        if (cena[k]='.') or (cena[k]=',')
          then
            begin
              Paketik[8]:=Length(cena)-k;//Уточненное смещение точки
              Continue;
            end
          else
            s1:=s1+cena[k]
    else
      s1:=cena;
  If length(s1)<4
    then
      begin
        for k:=1 to (4-length(s1)) do
          Paketik[k+1]:=11;
        for k:= ((4-length(s1))+1) to 4 do
          begin
            Paketik[k+1]:=StrToInt(s1[x]);
            x:=x+1;
          end;
      end
    else
      for k:=1 to 4 do
        Paketik[k+1]:=StrToInt(s1[k]);
  For k:= 6 to 7 do Paketik[k]:=255;//Оставшиеся байты данных в пакете заполняются значениями FF (255)
  Paketik[9]:=0;//Адрес компа
  Paketik[10]:=1; //Тип устройства - комп
  Paketik[11]:=0;//С компа эта команда пустая
  Paketik[12]:=1; //Команда на запись цены (01)
  x:=0;
  for k:=1 to 12 do x:=x+(Paketik[k] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  s:='';
  For k:=1 to 15 do s:= s + IntToHex(Paketik[k],2)+ ' ';
  F_Main.Memo1.Lines.Add(s);
  Sleep(100);
  F_Main.ComPort1.Read(P_vhod,15);
  s:='';
  For k:=1 to 15 do  s:= s + IntToHex(P_vhod[k],2) + ' ';
  F_Main.Memo1.Lines.Add(s);
  If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=1) and (P_vhod[12]=255)
    then
      begin
      end
    else
      ShowMessage('Устройство '+ IntToStr(Paketik[1])+' не ответило на установку цены');
end;

procedure TPaketovshik.YznatParolPultaDU;
var
  x,k,p:integer;
  s:string;
begin
  s:='';
  Paketik[1]:=1; //Запрос пароля пульта ДУ всегда только у первого устройства
  Paketik[2]:=0;
  Paketik[3]:=0;
  Paketik[4]:=0;
  Paketik[5]:=0;
  Paketik[6]:=0;
  Paketik[7]:=0;
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=16; //Ключевая команда 16 - запрос пульта ДУ
  x:=0;
  for k:=1 to 12 do x:=x+(Paketik[k] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  Sleep(50);
  p:= F_Main.ComPort1.InputCount div 15;//Количество пакетов, накопившихся в буфере
  F_Main.ComPort1.Read(P_vhod,15);
  If p>0     //Вдруг перед пакетом от устройства вклинился пакет на авторизацию или наоборот пристроился сзади
    then     //Обрабатываем их все поочереди
      Repeat
        F_Main.ComPort1.Read(P_vhod,15);
        p:=p-1;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[11]=16) and (P_vhod[12]=255) //Если пакет с 1-го устройства
          then
            begin
              For k:=2 to 5 do
                s:=s+IntToStr(P_vhod[k]);
              F_Main.Label_ParolPultaDU.Caption:= 'Текущий пароль пульта ДУ: '+ s;
            end;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//Если пришел пакет на авторизацию и "засыпание" программы
          then
            begin
              FWait:= TFWait.Create(F_Main);
              FWait.ShowModal;
            end;
      until p=0 //Пока не проверим все
    else
      F_Main.Label_ParolPultaDU.Caption:='Текущий пароль пульта ДУ: определить не удалось';
  for k:=1 to 15 do P_vhod[k]:=0; //На всякий случай обнуляем массивчик P_vhod
end;

end.
