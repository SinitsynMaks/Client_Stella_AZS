object F_Nastr_Porta: TF_Nastr_Porta
  Left = 1603
  Top = 863
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086#1088#1090#1072
  ClientHeight = 113
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Nomerporta: TLabel
    Left = 16
    Top = 8
    Width = 42
    Height = 16
    Caption = #1055#1086#1088#1090#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label_SkorPorta: TLabel
    Left = 0
    Top = 40
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
  object ComboBox_NomerPorta: TComboBox
    Left = 72
    Top = 8
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox_NomerPortaChange
    OnDropDown = ComboBox_NomerPortaDropDown
  end
  object ComComboBox1: TComComboBox
    Left = 72
    Top = 40
    Width = 113
    Height = 21
    ComPort = F_Main.ComPort1
    ComProperty = cpBaudRate
    Text = '9600'
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 7
    TabOrder = 1
    OnChange = ComComboBox1Change
  end
  object Btn_Sohr: TButton
    Left = 16
    Top = 80
    Width = 161
    Height = 25
    Caption = #1057' '#1054' '#1061' '#1056' '#1040' '#1053' '#1048' '#1058' '#1068
    TabOrder = 2
    OnClick = Btn_SohrClick
  end
end
