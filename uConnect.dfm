object fmConnect: TfmConnect
  Left = 207
  Top = 114
  Width = 495
  Height = 228
  Caption = 'fmConnect'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    487
    194)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 487
    Height = 16
    Align = alTop
    AutoSize = False
    Caption = '  '#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1089#1077#1088#1074#1077#1088#1099':'
    Layout = tlCenter
  end
  object lvServers: TListView
    Left = 0
    Top = 16
    Width = 487
    Height = 129
    Align = alTop
    Columns = <
      item
        AutoSize = True
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      end
      item
        AutoSize = True
        Caption = #1040#1076#1088#1077#1089
      end
      item
        Alignment = taCenter
        AutoSize = True
        Caption = #1048#1075#1088#1072
      end>
    ColumnClick = False
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvServersDblClick
    OnSelectItem = lvServersSelectItem
  end
  object ledServer: TLabeledEdit
    Left = 45
    Top = 155
    Width = 137
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 34
    EditLabel.Height = 13
    EditLabel.Caption = #1040#1076#1088#1077#1089':'
    LabelPosition = lpLeft
    LabelSpacing = 4
    TabOrder = 1
  end
  object bRefreshServers: TButton
    Left = 231
    Top = 155
    Width = 75
    Height = 25
    Action = acRefreshServers
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object bOk: TButton
    Left = 318
    Top = 155
    Width = 75
    Height = 25
    Action = acOk
    Anchors = [akRight, akBottom]
    ModalResult = 1
    TabOrder = 3
  end
  object bCancel: TButton
    Left = 398
    Top = 155
    Width = 75
    Height = 25
    Action = acCancel
    Anchors = [akRight, akBottom]
    ModalResult = 2
    TabOrder = 4
  end
  object ActionList: TActionList
    OnUpdate = ActionListUpdate
    Left = 408
    Top = 28
    object acOk: TAction
      Caption = '&'#1054#1050
      ShortCut = 13
      OnExecute = acOkExecute
    end
    object acCancel: TAction
      Caption = '&'#1054#1090#1084#1077#1085#1072
      ShortCut = 27
      OnExecute = acCancelExecute
    end
    object acRefreshServers: TAction
      Caption = '&'#1054#1073#1085#1086#1074#1080#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1089#1077#1088#1074#1077#1088#1086#1074
      OnExecute = acRefreshServersExecute
    end
  end
  object AntiFreeze: TIdAntiFreeze
    Left = 376
    Top = 28
  end
  object UDPClient: TIdUDPServer
    BufferSize = 512
    BroadcastEnabled = True
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = UDPClientUDPRead
    Left = 408
    Top = 59
  end
end
