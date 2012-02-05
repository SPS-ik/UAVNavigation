object frmLayers: TfrmLayers
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1083#1086#1080
  ClientHeight = 315
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLayers: TPanel
    Left = 0
    Top = 0
    Width = 259
    Height = 315
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 293
    ExplicitHeight = 326
    DesignSize = (
      259
      315)
    object btnAddLayer: TButton
      Left = 95
      Top = 284
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btnAddLayerClick
    end
    object chlbLayers: TCheckListBox
      Left = 0
      Top = 0
      Width = 259
      Height = 274
      OnClickCheck = chlbLayersClickCheck
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = 2
      ItemHeight = 13
      TabOrder = 1
      OnClick = chlbLayersClick
    end
    object colbLayerColor: TColorBox
      Left = 8
      Top = 286
      Width = 81
      Height = 22
      Style = [cbStandardColors, cbCustomColor, cbPrettyNames]
      Anchors = [akLeft, akBottom]
      Enabled = False
      ItemHeight = 16
      TabOrder = 2
      OnChange = colbLayerColorChange
      OnEnter = colbLayerColorEnter
    end
    object btnOk: TButton
      Left = 176
      Top = 284
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 3
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Shape files|*.SHP'
    Left = 64
    Top = 280
  end
end
