object fmNewGame: TfmNewGame
  Left = 415
  Top = 312
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
  ClientHeight = 178
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object bbOk: TBitBtn
    Left = 72
    Top = 144
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object bbCancel: TBitBtn
    Left = 184
    Top = 144
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 329
    Height = 49
    Caption = #1054' '#1080#1075#1088#1086#1082#1077' '
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 25
      Height = 13
      Caption = #1048#1084#1103':'
    end
    object Label2: TLabel
      Left = 184
      Top = 24
      Width = 45
      Height = 13
      Caption = #1042#1086#1079#1088#1072#1089#1090':'
    end
    object edNameSelf: TEdit
      Left = 48
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object seAgeSelf: TSpinEdit
      Left = 240
      Top = 20
      Width = 81
      Height = 22
      MaxValue = 100
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 64
    Width = 329
    Height = 73
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1090#1080#1074#1085#1080#1082#1072' '
    TabOrder = 3
    object Label4: TLabel
      Left = 16
      Top = 19
      Width = 25
      Height = 13
      Caption = #1048#1084#1103':'
    end
    object Label3: TLabel
      Left = 184
      Top = 19
      Width = 45
      Height = 13
      Caption = #1042#1086#1079#1088#1072#1089#1090':'
    end
    object edNameComp: TEdit
      Left = 48
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object seAgeComp: TSpinEdit
      Left = 240
      Top = 16
      Width = 81
      Height = 22
      MaxValue = 100
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object rbEasy: TRadioButton
      Left = 16
      Top = 48
      Width = 113
      Height = 17
      Caption = '   '#1053#1086#1074#1080#1095#1077#1082
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object rbHard: TRadioButton
      Left = 200
      Top = 48
      Width = 113
      Height = 17
      Caption = '  '#1055#1088#1086#1092#1077#1089#1089#1080#1086#1085#1072#1083
      TabOrder = 3
    end
  end
end
