object F_Main: TF_Main
  Left = 1565
  Top = 271
  Anchors = [akTop, akBottom]
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'F_Main'
  ClientHeight = 608
  ClientWidth = 322
  Color = clBtnFace
  Constraints.MaxHeight = 800
  Constraints.MaxWidth = 500
  Constraints.MinHeight = 600
  Constraints.MinWidth = 150
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label_ParolPultaDU: TLabel
    Left = 8
    Top = 16
    Width = 170
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1080#1081' '#1087#1072#1088#1086#1083#1100' '#1087#1091#1083#1100#1090#1072' '#1044#1059':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Gauge1: TGauge
    Left = 8
    Top = 176
    Width = 305
    Height = 17
    Progress = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 39
    Width = 305
    Height = 129
    TabOrder = 0
    object Label1: TLabel
      Left = 117
      Top = 44
      Width = 55
      Height = 40
      Caption = #1042#1088#1077#1084#1103#13#10#1044#1072#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Btn1_ZapVremsPK: TSpeedButton
      Left = 0
      Top = 40
      Width = 105
      Height = 65
      Hint = 
        #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1085#1072' '#1101#1090#1091' '#1082#1085#1086#1087#1082#1091' '#1085#1072' '#1095#1072#1089#1072#1093' '#1082#1086#1084#1087#1083#1077#1082#1089#1072#13#10#1091#1089#1090#1072#1085#1086#1074#1080#1090#1089#1103' '#1090#1086' '#1078#1077' ' +
        #1074#1088#1077#1084#1103', '#1095#1090#1086' '#1080' '#1085#1072' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1077' '#1086#1087#1077#1088#1072#1090#1086#1088#1072'.'#13#10#1045#1089#1083#1080' '#1085#1072' '#1082#1086#1084#1087#1083#1077#1082#1089#1077' '#1085#1077#1090' '#1095#1072#1089 +
        #1086#1074' '#1080#1083#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1072#13#10#1085#1077' '#1086#1087#1088#1086#1089#1080#1083#1072' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072', '#1082#1085#1086#1087#1082#1072' '#1073#1091#1076#1077#1090' '#1085#1077#1072#1082#1090#1080#1074#1085#1072 +
        '.'
      Caption = #1042#1088#1077#1084#1103' '#1089' '#1055#1050
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = Btn1_ZapVremsPKClick
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 241
      Height = 33
      Hint = 
        #1044#1072#1085#1085#1099#1081' '#1092#1083#1072#1075' '#1087#1086#1079#1074#1086#1083#1103#1077#1090' '#1087#1088#1086#1075#1088#1072#1084#1084#1077#13#10#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1088#1072#1079' '#1074' '#1089#1091#1090#1082#1080' '#1082#1086#1088#1088#1077 +
        #1082#1090#1080#1088#1086#1074#1072#1090#1100#13#10#1074#1088#1077#1084#1103' '#1085#1072' '#1095#1072#1089#1072#1093' '#1089#1090#1077#1083#1083#1099', '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1080#1088#1091#1103' '#1077#1075#1086#13#10#1089' '#1082#1086#1084#1087#1100#1102#1090#1077#1088 +
        #1085#1099#1084'. '
      Caption = #1040#1074#1090#1086#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1103' '#1074#1088#1077#1084#1077#1085#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 202
    Width = 305
    Height = 351
    Hint = 
      #1054#1073#1083#1072#1089#1090#1100', '#1074' '#1082#1086#1090#1086#1088#1086#1081' '#1076#1086#1083#1078#1085#1099' '#1086#1090#1086#1073#1088#1072#1078#1072#1090#1100#1089#1103#13#10#1094#1077#1085#1099' '#1089' '#1091#1089#1090#1088#1086#1081#1089#1090#1074' '#1087#1086#1089#1083#1077' '#1085 +
      #1072#1078#1072#1090#1080#1103' '#1082#1085#1086#1087#1082#1080' "'#1057#1095#1080#1090#1072#1090#1100'".'
    VertScrollBar.Tracking = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object Label_Vait: TLabel
      Left = 56
      Top = 80
      Width = 191
      Height = 26
      Caption = #1048#1076#1077#1090' '#1089#1095#1080#1090#1099#1074#1072#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1089' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#13#10#1055#1086#1078#1072#1083#1091#1081#1089#1090#1072' '#1078#1076#1080#1090#1077'...'
    end
  end
  object Btn_SchitSoStelly: TButton
    Left = 8
    Top = 568
    Width = 153
    Height = 33
    Hint = 
      #1055#1088#1080' '#1085#1072#1078#1072#1090#1080#1080' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1086#1087#1088#1086#1089' '#1074#1089#1077#1093' '#1091#1089#1090#1088#1086#1081#1089#1090#1074','#13#10#1080#1084#1077#1102#1097#1080#1093#1089#1103' '#1074' '#1089#1077#1090#1080' '#1089 +
      ' '#1087#1086#1089#1083#1077#1076#1091#1102#1097#1080#1084' '#1074#1099#1074#1086#1076#1086#1084#13#10#1076#1072#1085#1085#1099#1093' '#1086' '#1094#1077#1085#1077' '#1074' '#1094#1077#1085#1090#1088#1072#1083#1100#1085#1091#1102' '#1086#1073#1083#1072#1089#1090#1100' '#1086#1082#1085#1072'.'#13 +
      #10#1042#1088#1077#1084#1103' '#1087#1086#1082#1072#1079#1099#1074#1072#1077#1090#1089#1103' '#1088#1103#1076#1086#1084' '#1089' '#1082#1085#1086#1087#1082#1086#1081' "'#1047#1072#1087#1080#1089#1072#1090#1100' '#1074#1088#1077#1084#1103' '#1089' '#1055#1050'"'
    Caption = #1057#1063#1048#1058#1040#1058#1068' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    WordWrap = True
    OnClick = Btn_SchitSoStellyClick
  end
  object Btn_ZapNaStelly: TButton
    Left = 168
    Top = 567
    Width = 145
    Height = 34
    Hint = 
      #1055#1086' '#1085#1072#1078#1072#1090#1080#1102' '#1101#1090#1086#1081' '#1082#1085#1086#1087#1082#1080' '#1085#1072' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072#1093' '#1074' '#1089#1077#1090#1080#13#10#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1102#1090#1089#1103' '#1094#1077 +
      #1085#1099', '#1077#1089#1083#1080' '#1087#1088#1086#1080#1079#1086#1096#1083#1086' '#1080#1079#1084#1077#1085#1077#1085#1080#1077#13#10#1074' '#1086#1076#1085#1086#1084' '#1080#1079' '#1087#1086#1083#1077#1081' '#1089' '#1094#1077#1085#1086#1081'.'
    Caption = #1047#1040#1055#1048#1057#1040#1058#1068
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    WordWrap = True
    OnClick = Btn_ZapNaStellyClick
  end
  object ActionList1: TActionList
    Left = 216
    object Action_PortOptions: TAction
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086#1088#1090#1072
      OnExecute = Action_PortOptionsExecute
    end
    object Action_SohranenieCen: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1094#1077#1085
      OnExecute = Action_SohranenieCenExecute
    end
    object Action_OtkrytieCen: TAction
      Caption = 'Action_OtkrytieCen'
      OnExecute = Action_OtkrytieCenExecute
    end
    object Action_IzmParolPultaDu: TAction
      Caption = 'Action_IzmParolPultaDu'
      OnExecute = Action_IzmParolPultaDuExecute
    end
    object Action_OProgramme: TAction
      Caption = 'Action_OProgramme'
      OnExecute = Action_OProgrammeExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 248
    object MenuFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object Menu_NastroikiPorta: TMenuItem
        Action = Action_PortOptions
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1086#1088#1090#1072'...'
      end
      object Menu_SohrCeny: TMenuItem
        Action = Action_SohranenieCen
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1094#1077#1085#1099' '#1074' '#1092#1072#1081#1083
      end
      object Menu_OtkrytCeny: TMenuItem
        Action = Action_OtkrytieCen
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1094#1077#1085#1099' '#1080#1079' '#1092#1072#1081#1083#1072
      end
      object Menu_IzmParolPultaDU: TMenuItem
        Action = Action_IzmParolPultaDu
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1086#1083#1100' '#1087#1091#1083#1100#1090#1072' '#1044#1059
      end
    end
    object Spravka: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object Menu_oProgramme: TMenuItem
        Action = Action_OProgramme
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 280
  end
  object OpenCeny: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' '#1094#1077#1085' (*.cen)|*.cen'
    Top = 65528
  end
  object SaveCeny: TSaveDialog
    Filter = #1060#1072#1081#1083#1099' '#1094#1077#1085' (*.cen)|*.cen'
    Left = 32
    Top = 65528
  end
  object Timer2: TTimer
    Interval = 50
    Left = 64
    Top = 65528
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = True
    Left = 184
  end
end
