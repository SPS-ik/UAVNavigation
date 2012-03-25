object frmObstacles: TfrmObstacles
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1087#1088#1077#1087#1103#1090#1089#1090#1074#1080#1081
  ClientHeight = 423
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 70
    Height = 13
    Caption = #1055#1088#1077#1087#1103#1090#1089#1090#1074#1080#1103':'
  end
  object Label2: TLabel
    Left = 8
    Top = 199
    Width = 118
    Height = 13
    Caption = #1042#1077#1088#1096#1080#1085#1099' '#1087#1088#1077#1087#1103#1090#1089#1090#1074#1080#1081':'
  end
  object grObstacles: TDBGridEh
    Left = 0
    Top = 27
    Width = 305
    Height = 166
    AllowedOperations = [alopUpdateEh]
    AutoFitColWidths = True
    DataSource = frmMain.DataSource3
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgEditing, dgColumnResize, dgTabs, dgConfirmDelete]
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
    RowHeight = 3
    RowLines = 1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        AutoFitColWidth = False
        Checkboxes = True
        EditButtons = <>
        FieldName = 'Enable'
        Footers = <>
        Width = 20
      end
      item
        EditButtons = <>
        EndEllipsis = True
        FieldName = 'Name'
        Footers = <>
        ReadOnly = True
        Width = 100
        WordWrap = False
      end>
  end
  object btnOK: TButton
    Left = 218
    Top = 390
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 1
    OnClick = btnOKClick
  end
  object grObstaclePoints: TDBGridEh
    Left = -4
    Top = 218
    Width = 305
    Height = 166
    AllowedOperations = [alopUpdateEh]
    AutoFitColWidths = True
    DataSource = frmMain.DataSource4
    Flat = False
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    Options = [dgEditing, dgColumnResize, dgTabs, dgConfirmDelete]
    OptionsEh = [dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind]
    RowHeight = 3
    RowLines = 1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        EditButtons = <>
        FieldName = 'X'
        Footers = <>
      end
      item
        EditButtons = <>
        FieldName = 'Y'
        Footers = <>
      end>
  end
end
