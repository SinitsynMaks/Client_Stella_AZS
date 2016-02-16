{------------------------------------------}
//������-����� ��� �������� ������� � ����//
{------------------------------------------}

unit Formirovatel_Paketov;

interface

uses
  Dialogs, SysUtils, StdCtrls, classes, forms, U_ParolPyltaDU, U_ServNastr,
  U_NastrChasov, U_UstrSCenoy, CPortCtl, U_Nastr_Porta, Gauges,
  Messages, Variants, Graphics, Controls, U_StopModal, Windows, ExtCtrls;

Type

  TPaketovshik = Class //���������� ������ ������ ������ � ������������� � ��������� �������

  Private
    Fgauge: TGauge;
    Flable: TLabel;

  Public
    procedure ZaprosVrem; //������ �������� ������� � �����, ��� �� ���������� � �������� ������� 5 (1-� ����)) �������� 12 (12-� ����)
    procedure YstNovZnachVrem; // ����� �� ���� (���������� � ������� 5 (1-� ����)) ��� ��������� ������ �������� ������� �������� 2 (12-�) ����
    procedure ZaprosCeny(i:integer); {������ �������� ���� � ���� ��������� � ���� ���������}
    procedure ZapisCeny;// ��������� �������� ������� �� ���������� ��� ������ �� ��� ���, ��������������� � �����
    procedure IzmAdrNa(number:integer); //����� ������ ������ ������ ���������� �� ������ ����� �������� ������������� ������
    procedure ParolPultaDu;//����� ������ ������ ������ �� ������������ �������
    function CenaonDevice:string;
    procedure YstRegimVrem; //����� ��������� ������ ����������� ������
    procedure IzmSkorPeredDannyh(number_str:integer); // ����� ��������� �������� �����
    procedure ZapisCenyNaOdnomUstr(adr: integer; cena: string);
    procedure YznatParolPultaDU;
    procedure VremjaModalnogoOkna(sender: TObject); //������� ��� ������� ������ ���������� ����
    procedure OprosYstroistv;// ���������� ������� ������ "�������" � "����� ����������"
    procedure DeleteMyEdits; //������� ���� � �������� � ������� ��� ����� ������������

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
  F_Main.ComPort1.OnRxChar:=nil; //�� ����� ������ ��������� ��������� ���������� ������
  If not F_Main.ComPort1.Connected
    then
      if inifile.ValueExists('ComPort','Port')
        then
          try
            F_Main.ComPort1.Port:=inifile.ReadString('ComPort','Port','Com1');
            F_Main.ComPort1.Open;
          except
            ShowMessage('�� ������� ������������ � �����: '+ F_Main.ComPort1.Port);
          end
        else
          begin
            ShowMessage('��������� �������� �������� ���������� ����� ���� '+ F_Main.ComPort1.Port
                        + '.' +#13+ '� ������ ������ ���� ����������. �������� ������ ����.');
            exit;
          end;
  DeleteMyEdits;
  If realdevice=nil
    then
      begin
        realdevice:= TStringList.Create;
        U_Main.inifile.EraseSection('�� ������ �����');//����� ����� - ������ ������ � ��� �����
      end
    else
      begin
        realdevice.Clear; //����� ����� - ������ ����������
        U_Main.inifile.EraseSection('�� ������ �����');//����� ����� - ������ ������ � ��� �����
      end;
  gauge.MaxValue:= 30;
  gauge.Progress:=0;
  gauge.Visible:=True;
  lable.Visible:=True;
  Application.ProcessMessages;
  For i:=1 to 10 do //���������������� ����� ���� ��������� � ����
    begin
      FlagOprosa:=false;
      for j2:=1 to 3 do //�� 3 ���� ���� ������� ���������� � ���� �����
        begin
          Paketik[1]:=i; //������ ���������� - ���������
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
          Paketik[12]:=15; //�������� ������� 15 - ������ ������ � ���������
          x:=0;
          for n:=1 to 12 do x:=x+(Paketik[n] xor $FF);
          Paketik[13]:=x;
          Paketik[14]:=$0D;
          Paketik[15]:=$0A;
          F_Main.ComPort1.Write(Paketik,15);
          Sleep(50);
          If F_Main.ComPort1.InputCount>0     //���� � ����� ���� ���-�� ����
            then     //������������ ��� ������ ���������
              Repeat
                F_Main.ComPort1.Read(P_vhod,15);
                If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=15) and (P_vhod[12]=255) //���� ������ �����-����� � �����
                  then
                    begin
                      iniFile.WriteString('��� ������ �� ���������',IntToStr(i),'����');
                      iniFile.WriteString('��� �������� �� ����������','����',IntToStr(i));
                      realdevice.Add(IntToStr(i)+'=����');//������� � ������ �������� ����� ���������� � ����
                      FlagOprosa:=True;
                      gauge.MaxValue:=gauge.MaxValue-(3-j2);
                    end;
                If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=15) and (P_vhod[12]=255)//���� ������ �����-����� � ������ ��� ����
                  then
                    begin
                      realdevice.Add(IntToStr(i)+'=������ � �����');//������� � ������ �������� ����� ���������� � ����
                      FlagOprosa:=True;
                      gauge.MaxValue:=gauge.MaxValue-(3-j2);
                    end;
                If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//���� ������ ����� �� ����������� � "���������" ���������
                  then
                    begin
                      FWait:= TFWait.Create(F_Main);
                      FWait.ShowModal;
                    end;
              until (F_Main.ComPort1.InputCount div 15)=0;
          for k:=1 to 15 do P_vhod[k]:=0; //�� ������ ������ �������� ��������� P_vhod
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
        FreeAndNil(realdevice); //���� ��� ���������, �� � ������ ���� �� �����
        lable.Visible:=True;
        lable.Caption:='��������� � ���� �� ����������';
        exit;
      end
    else
      F_Main.ScrollBox1.ShowHint:=False;  
  t:=0;    
  For j2:=0 to realdevice.Count-1 do   //���� �� ���������� �������� ��������� � ����, ����������� � ������ �����
    If realdevice.ValueFromIndex[j2]='����'
      then
        begin
          Paket.ZaprosVrem;//���� � ���� ���� ����, ������ �� �� �������� �����
          Continue;
        end
      else
        begin
          t:=t+1;
          SetLength(MyEdits,t);
          SetLength(MyLables,t);
          Paket.ZaprosCeny(j2);
          If F_Main.ComPort1.InputCount>0     //���� � ����� ���� ���-�� ����
            then
              Repeat    //������������ ��� ������ ���������
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
                          If inifile.SectionExists('��� ������ �� ���������')
                            then Caption:= inifile.ReadString('��� ������ �� ���������',IntToStr(P_vhod[9]),IntToStr(P_vhod[9]))
                            else Caption:= realdevice.Names[j2];
                          Font.Size:=14;
                          Hint:='��� �������, �������� ������������'+#10#13+
                                '�������������� ����� �� ������ � � ���������.'+#10#13+
                                '���� � ���������� ��������� �� ����������'+#10#13+
                                '������������ ���� ���� �������'+#10#13+
                                '����� ������������ ���������� �����'+#10#13+'������������� � ���� ���������� � �����';
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
                          Tag:= StrToInt(realdevice.Names[j2]);//���� ����� �� ����� ������� �� ���������
                          {Hint:='���� ���������� ���� �� ����������.'+#10#13+'���� ���������� ������� ����,'
                                 +#10#13+'����� ������ ����� �������� � ������ ������ "��������"';    }
                          Hint:= IntToStr(Tag);
                          ShowHint:=True;
                          OnKeyPress:=F_Main.KeyPress;
                          OnChange:= F_Main.ChangeOfEdit;
                        end;
                      for k:=1 to 15 do P_vhod[k]:=0;  
                    end;
                If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//���� ������ ����� �� ����������� � "���������" ���������
                  then
                    begin
                      FWait:= TFWait.Create(F_Main);
                      FWait.ShowModal;
                    end;
                  until (F_Main.ComPort1.InputCount div 15)=0
            else
              ShowMessage('��� ������ �� ����������: '+IntToStr(Paketik[1]));
        end;
  If not F_Main.Btn1_ZapVremsPK.Enabled
    then
      begin
        TimeStart:= now;
        F_Main.Timer1.Enabled:=True;
      end;
  F_Main.ComPort1.OnRxChar:=F_Main.ComPort1RxChar; //���������� ������� �� �����
end;

procedure TPaketovshik.VremjaModalnogoOkna(sender:TObject); // ������ ��� ���������� ����
var
  k2: integer;
begin
  tt:=tt+timer_vait.Interval;
  If F_Main.ComPort1.InputCount > 0 // ������ ������� ����� ������, ��� ������� � ������. ����� ������ ���������
    then
      begin
        F_Main.ComPort1.Read(P_vhod,15);
          if (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=21) then  //���� ������ ����� �� ����� �� �����������
            begin
              timer_vait.Enabled:= False;
              for k2:=1 to 15 do P_vhod[k2]:=0;
              FWait.Close;
              exit;
            end;
          If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=15) and (P_vhod[12]=255) //���� ������ �����-����� � �����
            then
              begin
                Inifile.WriteString('��� ������ �� ���������',IntToStr(Paketik[1]),'����');
                Inifile.WriteString('��� �������� �� ����������','����',IntToStr(Paketik[1]));
                realdevice.Add(IntToStr(Paketik[1])+'=����');//������� � ������ �������� ����� ���������� � ����
                FlagOprosa:=True;
                gauge.MaxValue:=gauge.MaxValue-(3-j2);
                for k2:=1 to 15 do P_vhod[k2]:=0; //����������, �������� �����
              end;
          If (P_vhod[9] = Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=15) and (P_vhod[12]=255)//���� ������ �����-����� � ������ ��� ����
            then
              begin
                realdevice.Add(IntToStr(Paketik[1])+'=������ � �����');//������� � ������ �������� ����� ���������� � ����
                FlagOprosa:=True;
                gauge.MaxValue:=gauge.MaxValue-(3-j2);
                for k2:=1 to 15 do P_vhod[k2]:=0; //�������� �����
              end;
          If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=15) and (P_vhod[12]=255) //���� ������ ������� ������� � �����
            then
              begin
                F_Main.TimeonDevice;
                F_Main.Btn1_ZapVremsPK.Enabled:=True;
              end;
          If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=2) and (P_vhod[11]=11) and (P_vhod[12]=255)//����� �� ������� ���������� � �������� ����
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
                    If inifile.SectionExists('��� ������ �� ���������')
                      then Caption:= inifile.ReadString('��� ������ �� ���������',IntToStr(P_vhod[9]),IntToStr(P_vhod[9]))
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
                for k2:=1 to 15 do P_vhod[k2]:=0; //�������� �����
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
    Paketik[12]:=11;//�������� ������� 11 (0B) - ������ ����
    x:=0;
    for k:=1 to 12 do x:=x+(Paketik[k] xor $FF);
    Paketik[13]:=x;
    Paketik[14]:=$0D;
    Paketik[15]:=$0A;
    F_Main.ComPort1.Write(Paketik,15);
    Sleep(50);
end;

procedure TPaketovshik.ZaprosVrem;//��������� ���������. ����� ����� �������
var
  x,i,p,k:integer;
begin
  Paketik[1]:=U_Main.inifile.ReadInteger('��� �������� �� ����������','����',8);//� �������� 1-�� ����� ����� ������������� ����� ����� ����� ������������.
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
  Paketik[12]:=12; //�������� ������� 12 - ������ �������
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(50);
  If (F_Main.ComPort1.InputCount div 15)>0     //����� ����� ������� �� ���������� ��������� ����� �� ����������� ��� �������� ����������� �����
    then     //������������ �� ��� ���������
      Repeat
        F_Main.ComPort1.Read(P_vhod,15);
        If (P_vhod[9]=Paketik[1]) and (P_vhod[10]=3) and (P_vhod[11]=12) and (P_vhod[12]=255) //���� ������ ����� � �����
          then
            begin
              F_Main.TimeonDevice;
              F_Main.Btn1_ZapVremsPK.Enabled:=True;
            end;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//���� ������ ����� �� ����������� � "���������" ���������
          then
            begin
              FWait:= TFWait.Create(F_Main);
              FWait.ShowModal;
            end;
      until (F_Main.ComPort1.InputCount div 15)=0 //���� �� �������� ���
    else
      ShowMessage('���� �� �������� �� ������ �������');
  for k:=1 to 15 do P_vhod[k]:=0; //�� ������ ������ �������� ��������� P_vhod
end;

procedure TPaketovshik.YstNovZnachVrem; //��������� ���������. ����� ������������� �������.
var
  x,i:integer;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(TimeStart,Year,Month,Day);
  DecodeTime(TimeStart,Hour,Min,Sec,MSec);
  Paketik[1]:= U_Main.inifile.ReadInteger('��� �������� �� ����������','����',8);
  Paketik[2]:=Sec; //�������
  Paketik[3]:=Min; //������
  Paketik[4]:=Hour; //����
  Case DayOfWeek(TimeStart) of //����������� � "������" ��������� ���� ������: 1-��...7-��
    2..7 : Paketik[5]:= DayOfWeek(TimeStart)-1;
    1 : Paketik[5]:=7;
  end;
  Paketik[6]:=Day; //����
  Paketik[7]:=Month; //�����
  Paketik[8]:=StrToInt(copy(IntToStr(Year),3,4)); //��� �� ������� 2014 ��������� � ������ 14, 15 ��� 16 � �.�.
  Paketik[9]:=0; //����� �����������, 00 - ��
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=2; //�������� ������� - 2 (02): ������ ������ �������� �������
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF); //���������� CRC
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(50);
  If F_Main.ComPort1.InputCount>0     //���� � ����� ���� ���-�� ����
    then     //������������ ��� ������ ���������
      Repeat
        F_Main.ComPort1.Read(P_vhod,15);
        If (P_vhod[9]=U_Main.inifile.ReadInteger('��� �������� �� �����������','����',8)) and (P_vhod[10]=3)
               and (P_vhod[11]=2) and (P_vhod[12]=255)
          then
            begin
              ShowMessage('����� �� �����: '+ TimeToStr(TimeStart));
            end;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//���� ������ ����� �� ����������� � "���������" ���������
          then
            begin
              FWait:= TFWait.Create(F_Main);
              FWait.ShowModal;
            end;
      until (F_Main.ComPort1.InputCount div 15)=0
    else
      ShowMessage('���� �� �������� �� ��������� �������');
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
              s:=s+IntToStr(P_vhod[j+1]) //��������� ������ ������
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
      Paketik[1]:=StrToInt(U_Main.inifile.ReadString('��� �������� �� ����������',MyLables[i].Caption,'1'));//�� ������ ���������� �����
      Paketik[8]:=0; //�������������� �������� �����
      If (Pos('.',s)>0) or (Pos(',',s)>0)
        then
          for k:=1 to Length(s) do
            if (s[k]='.') or (s[k]=',')
              then
                begin
                  Paketik[8]:=Length(s)-k;//���������� �������� �����
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
      For k:= (razr+2) to 7 do Paketik[k]:=255;//���������� ����� ������ � ������ ����������� ���������� FF (255)
      Paketik[9]:=0;//����� �����
      Paketik[10]:=1; //��� ���������� - ����
      Paketik[11]:=0;//� ����� ��� ������� ������
      Paketik[12]:=1; //������� �� ������ ���� (01)
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
          ShowMessage('���������� '+ IntToStr(Paketik[1])+' �� �������� �� ��������� ����');
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

procedure TPaketovshik.ParolPultaDu; //������� ������ ������ ��
var
  i,x:Integer;
begin
  Paketik[1]:=1;//����� ���������� ������ 1-�� (������������) ���������� 
  For i:=1 to Length(F_ParolDU.Edit1.Text) do Paketik[i+1]:=StrToInt(F_ParolDU.Edit1.Text[i]);
  For i:=(Length(F_ParolDU.Edit1.Text)+2) to 7 do Paketik[i]:=11;// ���������� ����� ���������� ���������� (11 ��� 0�)
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=6; //�������� ������� 6 (06) - ����� ������ ������ ��
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
  Paketik[1]:=U_Main.inifile.ReadInteger('��� �������� �� ����������','����',8);
  Paketik[2]:=U_Main.inifile.ReadInteger('������ �����','������ ������������',224);
  Paketik[3]:=U_Main.inifile.ReadInteger('������ �����','����� ����� ������',10);
  Paketik[4]:=U_Main.inifile.ReadInteger('������ �����','12-24',0);
  Paketik[5]:=U_Main.inifile.ReadInteger('������ �����','AM-PM',0);
  Paketik[6]:=0;
  Paketik[7]:=0;
  Paketik[8]:=0;
  Paketik[9]:=0;
  Paketik[10]:=1;
  Paketik[11]:=0;
  Paketik[12]:=3; //�������� ������� 3 - ��������� �������
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(100);
  F_Main.ComPort1.Read(P_vhod,15);
  If (P_vhod[9]=U_Main.inifile.ReadInteger('��� �������� �� ����������','����',8)) and (P_vhod[10]=3)
     and (P_vhod[11]=3) and (P_vhod[12]=255)
    then
      begin
      end
    else
      ShowMessage('���� �� �������� �� ��������� ������ ����������� ������');
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
  Paketik[12]:=4; //�������� ������� 4 - ��������� �������� �����
  x:=0;
  for i:=1 to 12 do x:=x+(Paketik[i] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  sleep(50);
  F_Main.ComPort1.Read(P_vhod,15);
  If (P_vhod[9]=U_Main.inifile.ReadInteger('��� �������� �� ����������','����',8)) and (P_vhod[10]=3)
     and (P_vhod[11]=4) and (P_vhod[12]=255) and (P_vhod[2]=Paketik[2])
    then
      begin
      end
    else
      ShowMessage('���� �� �������� �� ��������� �������� �������� ������');
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
  Paketik[8]:=0; //�������������� �������� �����
  If (Pos('.',cena)>0) or (Pos(',',cena)>0)
    then
      for k:=1 to Length(cena) do
        if (cena[k]='.') or (cena[k]=',')
          then
            begin
              Paketik[8]:=Length(cena)-k;//���������� �������� �����
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
  For k:= 6 to 7 do Paketik[k]:=255;//���������� ����� ������ � ������ ����������� ���������� FF (255)
  Paketik[9]:=0;//����� �����
  Paketik[10]:=1; //��� ���������� - ����
  Paketik[11]:=0;//� ����� ��� ������� ������
  Paketik[12]:=1; //������� �� ������ ���� (01)
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
      ShowMessage('���������� '+ IntToStr(Paketik[1])+' �� �������� �� ��������� ����');
end;

procedure TPaketovshik.YznatParolPultaDU;
var
  x,k,p:integer;
  s:string;
begin
  s:='';
  Paketik[1]:=1; //������ ������ ������ �� ������ ������ � ������� ����������
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
  Paketik[12]:=16; //�������� ������� 16 - ������ ������ ��
  x:=0;
  for k:=1 to 12 do x:=x+(Paketik[k] xor $FF);
  Paketik[13]:=x;
  Paketik[14]:=$0D;
  Paketik[15]:=$0A;
  F_Main.ComPort1.Write(Paketik,15);
  Sleep(50);
  p:= F_Main.ComPort1.InputCount div 15;//���������� �������, ������������ � ������
  F_Main.ComPort1.Read(P_vhod,15);
  If p>0     //����� ����� ������� �� ���������� ��������� ����� �� ����������� ��� �������� ����������� �����
    then     //������������ �� ��� ���������
      Repeat
        F_Main.ComPort1.Read(P_vhod,15);
        p:=p-1;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[11]=16) and (P_vhod[12]=255) //���� ����� � 1-�� ����������
          then
            begin
              For k:=2 to 5 do
                s:=s+IntToStr(P_vhod[k]);
              F_Main.Label_ParolPultaDU.Caption:= '������� ������ ������ ��: '+ s;
            end;
        If (P_vhod[9]=1) and (P_vhod[10]=2) and (P_vhod[12]=20)//���� ������ ����� �� ����������� � "���������" ���������
          then
            begin
              FWait:= TFWait.Create(F_Main);
              FWait.ShowModal;
            end;
      until p=0 //���� �� �������� ���
    else
      F_Main.Label_ParolPultaDU.Caption:='������� ������ ������ ��: ���������� �� �������';
  for k:=1 to 15 do P_vhod[k]:=0; //�� ������ ������ �������� ��������� P_vhod
end;

end.
