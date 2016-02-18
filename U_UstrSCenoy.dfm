object F_Nastr_Ceny: TF_Nastr_Ceny
  Left = 1513
  Top = 580
  Width = 367
  Height = 228
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072' '#1089' '#1094#1077#1085#1086#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Adres: TLabel
    Left = 32
    Top = 8
    Width = 40
    Height = 16
    Caption = #1040#1076#1088#1077#1089
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label_Cena: TLabel
    Left = 40
    Top = 40
    Width = 33
    Height = 16
    Caption = #1062#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label_Skorost: TLabel
    Left = 16
    Top = 72
    Width = 61
    Height = 16
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 104
    Width = 78
    Height = 32
    Caption = #1055#1072#1088#1086#1083#1100' '#1076#1083#1103' '#1087#1091#1083#1100#1090#1072' '#1044#1059
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Edit_Adres: TEdit
    Left = 96
    Top = 8
    Width = 105
    Height = 21
    TabOrder = 0
    OnChange = Edit_AdresChange
  end
  object Edit_Cena: TEdit
    Left = 96
    Top = 40
    Width = 105
    Height = 21
    TabOrder = 1
    OnChange = Edit_CenaChange
    OnKeyPress = Edit_CenaKeyPress
  end
  object Edit_ParolDU: TEdit
    Left = 96
    Top = 104
    Width = 105
    Height = 21
    TabOrder = 2
  end
  object ComComboBox1: TComComboBox
    Left = 96
    Top = 72
    Width = 105
    Height = 21
    ComPort = F_Main.ComPort1
    ComProperty = cpBaudRate
    Text = '9600'
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 7
    TabOrder = 3
    OnChange = ComComboBox1Change
  end
  object Btn_IzmAdres: TButton
    Left = 224
    Top = 8
    Width = 121
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 4
    OnClick = Btn_IzmAdresClick
  end
  object Btn_IzmCenu: TButton
    Left = 224
    Top = 40
    Width = 121
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 5
    OnClick = Btn_IzmCenuClick
  end
  object Btn_IzmSkorost: TButton
    Left = 224
    Top = 72
    Width = 121
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 6
    OnClick = Btn_IzmSkorostClick
  end
  object Btn_PultDU: TButton
    Left = 224
    Top = 104
    Width = 121
    Height = 33
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 7
  end
end
