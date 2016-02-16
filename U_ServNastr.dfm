object F_ServNastr: TF_ServNastr
  Left = 1104
  Top = 140
  Width = 417
  Height = 647
  Caption = #1057#1077#1088#1074#1080#1089#1085#1099#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GrB_monitoring: TGroupBox
    Left = 0
    Top = 0
    Width = 401
    Height = 273
    Align = alTop
    Caption = #1052#1086#1085#1080#1090#1086#1088#1080#1085#1075' '#1091#1089#1090#1088#1086#1081#1089#1090#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      401
      273)
    object Gauge1: TGauge
      Left = 2
      Top = 251
      Width = 397
      Height = 20
      Align = alBottom
      Progress = 0
    end
    object Label_RazrTablo: TLabel
      Left = 16
      Top = 168
      Width = 97
      Height = 16
      Caption = #1056#1072#1079#1088#1103#1076#1085#1086#1089#1090#1100
    end
    object Label_Vait2: TLabel
      Left = 8
      Top = 216
      Width = 133
      Height = 26
      Caption = #1048#1076#1077#1090' '#1086#1087#1088#1086#1089' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#13#10#1085#1072' '#1085#1086#1074#1086#1081' '#1089#1082#1086#1088#1086#1089#1090#1080'...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label_Vait: TLabel
      Left = 8
      Top = 216
      Width = 137
      Height = 26
      Caption = #1048#1076#1077#1090' '#1086#1087#1088#1086#1089' '#1091#1089#1090#1088#1086#1081#1089#1090#1074','#13#10#1046#1076#1080#1090#1077'...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Btn_OprosYstr: TButton
      Left = 16
      Top = 128
      Width = 145
      Height = 25
      Caption = #1053#1072#1081#1090#1080' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
      TabOrder = 0
      OnClick = Btn_OprosYstrClick
    end
    object cxGrid1: TcxGrid
      Left = 184
      Top = 24
      Width = 214
      Height = 209
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object cxGrid1TableView1: TcxGridTableView
        NavigatorButtons.ConfirmDelete = False
        OnCellDblClick = cxGrid1TableView1CellDblClick
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Editing = False
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object cxGrid1TV1Col1: TcxGridColumn
          Caption = #8470
          DataBinding.ValueType = 'Integer'
          Width = 25
        end
        object cxGrid1TV1Col2: TcxGridColumn
          Caption = #1058#1080#1087' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
          Width = 118
        end
        object cxGrid1TV1Col3: TcxGridColumn
          Caption = #1040#1076#1088#1077#1089
          Width = 57
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1TableView1
      end
    end
    object CmBx_VyberiPort: TComboBox
      Left = 16
      Top = 48
      Width = 145
      Height = 24
      ItemHeight = 16
      TabOrder = 2
      Text = #1042#1099#1073#1077#1088#1080' '#1087#1086#1088#1090
      OnChange = CmBx_VyberiPortChange
      OnCloseUp = CmBx_VyberiPortCloseUp
      OnDropDown = CmBx_VyberiPortDropDown
    end
    object ComComboBox1: TComComboBox
      Left = 16
      Top = 88
      Width = 145
      Height = 24
      ComPort = F_Main.ComPort1
      ComProperty = cpBaudRate
      Text = '9600'
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 7
      TabOrder = 3
      OnChange = ComComboBox1Change
    end
    object SpinEdit_Razr: TSpinEdit
      Left = 128
      Top = 165
      Width = 33
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxValue = 6
      MinValue = 1
      ParentFont = False
      TabOrder = 4
      Value = 4
      OnChange = SpinEdit_RazrChange
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 276
    Width = 401
    Height = 333
    Align = alBottom
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1091#1089#1090#1088#1086#1081#1089#1090#1074
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      401
      333)
    object cxGrid2: TcxGrid
      Left = 8
      Top = 24
      Width = 390
      Height = 249
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object cxGrid2TableView1: TcxGridTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object cxGrid2TV1Col1: TcxGridColumn
          Caption = #8470
          DataBinding.ValueType = 'Integer'
          Width = 27
        end
        object cxGrid2TV1Col2: TcxGridColumn
          Caption = #1040#1082#1090#1080#1074#1085#1086#1089#1090#1100
          DataBinding.ValueType = 'Boolean'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Width = 76
        end
        object cxGrid2TV1Col3: TcxGridColumn
          Caption = #1052#1077#1090#1082#1072
          Width = 49
        end
        object cxGrid2TV1Col4: TcxGridColumn
          Caption = #1058#1080#1087
          Width = 104
        end
        object cxGrid2TV1Col5: TcxGridColumn
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 67
        end
        object cxGrid2TV1Col6: TcxGridColumn
          Caption = #1040#1076#1088#1077#1089
          PropertiesClassName = 'TcxComboBoxProperties'
          Properties.Sorted = True
          Properties.OnChange = cxGrid2TV1Col6PropertiesChange
          Options.ShowEditButtons = isebAlways
          Width = 53
        end
      end
      object cxGrid2Level1: TcxGridLevel
        GridView = cxGrid2TableView1
      end
    end
    object Btn_SohrOtobr: TButton
      Left = 115
      Top = 281
      Width = 177
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      TabOrder = 1
      OnClick = Btn_SohrOtobrClick
    end
  end
end
