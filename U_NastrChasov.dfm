object F_NastrChasov: TF_NastrChasov
  Left = 1447
  Top = 149
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1095#1072#1089#1086#1074
  ClientHeight = 566
  ClientWidth = 307
  Color = clBtnFace
  Constraints.MaxHeight = 600
  Constraints.MaxWidth = 331
  Constraints.MinHeight = 545
  Constraints.MinWidth = 315
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GB_common: TGroupBox
    Left = 0
    Top = 0
    Width = 307
    Height = 185
    Align = alTop
    Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 0
    object L_Adress: TLabel
      Left = 16
      Top = 24
      Width = 54
      Height = 20
      Caption = #1040#1076#1088#1077#1089
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object L_Speed: TLabel
      Left = 8
      Top = 152
      Width = 81
      Height = 20
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit_Addres: TEdit
      Left = 80
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 0
      OnChange = Edit_AddresChange
    end
    object ComComboBox_Speed: TComComboBox
      Left = 96
      Top = 152
      Width = 73
      Height = 21
      ComPort = F_Main.ComPort1
      ComProperty = cpBaudRate
      Text = '9600'
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 7
      TabOrder = 1
      OnChange = ComComboBox_SpeedChange
    end
    object GB_Date_Time: TGroupBox
      Left = 8
      Top = 48
      Width = 297
      Height = 89
      TabOrder = 2
      object L_Data: TLabel
        Left = 16
        Top = 53
        Width = 44
        Height = 20
        Caption = #1044#1072#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object L_Vremja: TLabel
        Left = 8
        Top = 21
        Width = 55
        Height = 20
        Caption = #1042#1088#1077#1084#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Btn_SohrDateTime: TButton
        Left = 176
        Top = 32
        Width = 113
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        TabOrder = 0
        OnClick = Btn_SohrDateTimeClick
      end
      object MaskEdit_Vremja: TMaskEdit
        Left = 72
        Top = 21
        Width = 81
        Height = 21
        EditMask = '!90:00:00;1;_'
        MaxLength = 8
        TabOrder = 1
        Text = '  :  :  '
        OnChange = MaskEdit_VremjaChange
      end
      object MaskEdit_Data: TMaskEdit
        Left = 72
        Top = 53
        Width = 82
        Height = 21
        EditMask = '!99/99/00;1;_'
        MaxLength = 8
        TabOrder = 2
        Text = '  .  .  '
      end
    end
    object Btn_SohrAdr: TButton
      Left = 184
      Top = 22
      Width = 113
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = Btn_SohrAdrClick
    end
    object Btn_SohrSkorost: TButton
      Left = 184
      Top = 150
      Width = 113
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 4
      OnClick = Btn_SohrSkorostClick
    end
  end
  object GB_FlagiChasov: TGroupBox
    Left = 0
    Top = 184
    Width = 307
    Height = 382
    Align = alBottom
    Caption = #1056#1077#1078#1080#1084#1099' '#1088#1072#1073#1086#1090#1099' '#1095#1072#1089#1086#1074
    TabOrder = 1
    object Label1: TLabel
      Left = 32
      Top = 272
      Width = 183
      Height = 13
      Caption = #1042#1088#1077#1084#1103' '#1084#1077#1078#1076#1091' '#1087#1077#1088#1077#1082#1083#1102#1095#1077#1085#1080#1103#1084#1080', '#1089#1077#1082
    end
    object Label2: TLabel
      Left = 32
      Top = 298
      Width = 162
      Height = 13
      Caption = #1056#1077#1078#1080#1084' '#1095#1072#1089#1086#1074' 24/12 (24=0, 12=1)'
    end
    object Label3: TLabel
      Left = 32
      Top = 324
      Width = 132
      Height = 13
      Caption = 'AM/PM (0 => AM, 1 => PM)'
    end
    object Label4: TLabel
      Left = 216
      Top = 296
      Width = 3
      Height = 13
    end
    object Btn_Flagi: TButton
      Left = 48
      Top = 352
      Width = 209
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = Btn_FlagiClick
    end
    object cxG_Flags: TcxGrid
      Left = 2
      Top = 15
      Width = 303
      Height = 220
      Align = alTop
      Constraints.MaxHeight = 220
      TabOrder = 1
      object cxG_FlagsTV1: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.CellAutoHeight = True
        OptionsView.GroupByBox = False
        object cxG_FlagsTV1Col1: TcxGridColumn
          Caption = #1041#1080#1090
          Options.Editing = False
          Width = 30
        end
        object cxG_FlagsTV1Col2: TcxGridColumn
          Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
          Options.Editing = False
          Width = 75
        end
        object cxG_FlagsTV1Col3: TcxGridColumn
          Caption = #1054#1087#1080#1089#1072#1085#1080#1077
          Options.Editing = False
          Width = 154
        end
        object cxG_FlagsTV1Col4: TcxGridColumn
          Caption = #1060#1083#1072#1075
          PropertiesClassName = 'TcxSpinEditProperties'
          Properties.AssignedValues.MinValue = True
          Properties.LargeIncrement = 1.000000000000000000
          Properties.MaxValue = 1.000000000000000000
          Properties.ReadOnly = False
          Properties.UseCtrlIncrement = True
          Options.ShowEditButtons = isebAlways
          Width = 40
        end
      end
      object cxG_FlagsLevel1: TcxGridLevel
        GridView = cxG_FlagsTV1
      end
    end
    object SpinEdit_sec: TSpinEdit
      Left = 232
      Top = 267
      Width = 41
      Height = 22
      MaxLength = 2
      MaxValue = 60
      MinValue = 1
      TabOrder = 2
      Value = 10
    end
    object SpinEdit_24_12: TSpinEdit
      Left = 232
      Top = 293
      Width = 41
      Height = 22
      MaxLength = 1
      MaxValue = 1
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = SpinEdit_24_12Change
    end
    object SpinEdit_AM_PM: TSpinEdit
      Left = 232
      Top = 319
      Width = 41
      Height = 22
      MaxLength = 1
      MaxValue = 1
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
  end
end
