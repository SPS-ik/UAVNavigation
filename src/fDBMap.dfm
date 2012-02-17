object frmDBMaps: TfrmDBMaps
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmDBMaps'
  ClientHeight = 73
  ClientWidth = 301
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
  object Label1: TLabel
    Left = 9
    Top = 15
    Width = 35
    Height = 13
    Caption = #1050#1072#1088#1090#1072':'
  end
  object DBComboBox1: TDBComboBox
    Left = 50
    Top = 12
    Width = 240
    Height = 21
    DataField = 'Name'
    DataSource = DSrcMaps
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 215
    Top = 39
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
  end
  object Button2: TButton
    Left = 134
    Top = 39
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
  end
  object Button3: TButton
    Left = 9
    Top = 39
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 3
  end
  object conNavigationDB: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=Navigation_DB;Data Source=SPS-IK-'#1055#1050'\SQL' +
      'EXPRESS'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 64
    Top = 40
  end
  object DSrcMaps: TDataSource
    DataSet = tblMaps
    Left = 32
    Top = 40
  end
  object tblMaps: TADOTable
    Connection = conNavigationDB
    CursorType = ctStatic
    MaxRecords = 100
    TableName = 'Maps'
    Left = 96
    Top = 40
    object tblMapsID: TIntegerField
      FieldName = 'ID'
    end
    object tblMapsName: TStringField
      FieldName = 'Name'
      Size = 100
    end
  end
end
