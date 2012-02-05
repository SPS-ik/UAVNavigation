object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Navigation'
  ClientHeight = 618
  ClientWidth = 900
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
  object Splitter1: TSplitter
    Left = 693
    Top = 0
    Height = 618
    Align = alRight
    ResizeStyle = rsUpdate
    ExplicitLeft = 0
    ExplicitTop = 421
    ExplicitHeight = 767
  end
  object pnlMap: TPanel
    Left = 0
    Top = 0
    Width = 693
    Height = 618
    Align = alClient
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 691
      Height = 616
      Align = alClient
      Caption = #1050#1072#1088#1090#1072
      TabOrder = 0
      object pnlMapImage: TPanel
        Left = 2
        Top = 49
        Width = 687
        Height = 565
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object imgMap: TImage
          Left = 0
          Top = 0
          Width = 687
          Height = 565
          Align = alClient
          OnDblClick = imgMapDblClick
          OnMouseDown = imgMapMouseDown
          OnMouseEnter = imgMapMouseEnter
          OnMouseLeave = imgMapMouseLeave
          OnMouseUp = imgMapMouseUp
          ExplicitTop = -3
        end
      end
      object CoolBar1: TCoolBar
        Left = 2
        Top = 15
        Width = 687
        Height = 34
        Bands = <
          item
            Control = ToolBar1
            ImageIndex = -1
            Width = 685
          end>
        Color = clWhite
        EdgeBorders = [ebTop]
        ParentColor = False
        object ToolBar1: TToolBar
          Left = 11
          Top = 0
          Width = 676
          Height = 25
          ButtonHeight = 21
          ButtonWidth = 112
          Caption = 'ToolBar1'
          Customizable = True
          ShowCaptions = True
          TabOrder = 0
          object ToolButton1: TToolButton
            Left = 0
            Top = 0
            Caption = #1057#1083#1086#1080
            ImageIndex = 0
            OnClick = Button1Click
          end
          object ToolButton2: TToolButton
            Left = 112
            Top = 0
            Width = 8
            Caption = 'ToolButton2'
            ImageIndex = 1
            Style = tbsSeparator
          end
          object ToolButton7: TToolButton
            Left = 120
            Top = 0
            Caption = #1052#1072#1089#1096#1090#1072#1073':'
            ImageIndex = 4
          end
          object cbScale: TComboBox
            Left = 232
            Top = 0
            Width = 45
            Height = 21
            ItemHeight = 13
            TabOrder = 0
            Text = '10'
            OnChange = Scale1Change
            Items.Strings = (
              '100'
              '50'
              '25'
              '10'
              '5'
              '2'
              '1'
              '0,5'
              '0,25'
              '0,1'
              '0,05')
          end
          object ToolButton3: TToolButton
            Left = 277
            Top = 0
            Width = 8
            Caption = 'ToolButton3'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object ToolButton6: TToolButton
            Left = 285
            Top = 0
            Caption = #1040#1074#1090#1086#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077' ('#1089'):'
            ImageIndex = 4
          end
          object cbRefreshTime: TComboBox
            Left = 397
            Top = 0
            Width = 45
            Height = 21
            ItemHeight = 13
            ItemIndex = 3
            TabOrder = 1
            Text = '60'
            OnChange = cbRefreshTimeChange
            Items.Strings = (
              '5'
              '15'
              '30'
              '60'
              '360')
          end
          object ToolButton5: TToolButton
            Left = 442
            Top = 0
            Action = acMapRefreshFull
          end
        end
      end
    end
  end
  object pnlObjects: TPanel
    Left = 696
    Top = 0
    Width = 204
    Height = 618
    Align = alRight
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 202
      Height = 616
      Align = alClient
      Caption = #1054#1073#1098#1077#1082#1090#1099
      TabOrder = 0
      object Splitter4: TSplitter
        Left = 2
        Top = 185
        Width = 198
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitLeft = 5
        ExplicitTop = 237
        ExplicitWidth = 185
      end
      object pnlObjList: TPanel
        Left = 2
        Top = 15
        Width = 198
        Height = 170
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          198
          170)
        object grObjects: TDBGridEh
          Left = 3
          Top = 0
          Width = 193
          Height = 141
          AllowedOperations = [alopUpdateEh]
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoFitColWidths = True
          DataSource = DataSource1
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
          OnDrawColumnCell = grObjectsDrawColumnCell
          Columns = <
            item
              AutoFitColWidth = False
              Checkboxes = True
              EditButtons = <>
              FieldName = 'Is_Visible'
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
        object cbFollowCurrNavObject: TCheckBox
          Left = 3
          Top = 147
          Width = 139
          Height = 17
          Anchors = [akLeft]
          Caption = #1057#1083#1077#1076#1080#1090#1100' '#1079#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1084
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object pnlObjDetails: TPanel
        Left = 2
        Top = 188
        Width = 198
        Height = 426
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          198
          426)
        object PageControl1: TPageControl
          Left = 3
          Top = 6
          Width = 194
          Height = 411
          ActivePage = TabSheet1
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          object TabSheet1: TTabSheet
            Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
            object Label1: TLabel
              Left = 8
              Top = 78
              Width = 47
              Height = 13
              Caption = #1044#1086#1083#1075#1086#1090#1072':'
            end
            object Label2: TLabel
              Left = 11
              Top = 111
              Width = 44
              Height = 13
              Caption = #1064#1080#1088#1086#1090#1072':'
            end
            object Label3: TLabel
              Left = 3
              Top = 145
              Width = 52
              Height = 13
              Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
            end
            object Label4: TLabel
              Left = 27
              Top = 178
              Width = 28
              Height = 13
              Caption = #1050#1091#1088#1089':'
            end
            object Label5: TLabel
              Left = 21
              Top = 212
              Width = 34
              Height = 13
              Caption = #1042#1088#1077#1084#1103':'
            end
            object Label6: TLabel
              Left = 3
              Top = 11
              Width = 52
              Height = 13
              Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
            end
            object Label7: TLabel
              Left = 25
              Top = 44
              Width = 30
              Height = 13
              Caption = #1062#1074#1077#1090':'
            end
            object edNavObjName: TDBEdit
              Left = 61
              Top = 7
              Width = 109
              Height = 21
              DataField = 'Name'
              DataSource = DataSource1
              TabOrder = 0
            end
            object edNavObjX: TDBEdit
              Left = 61
              Top = 107
              Width = 106
              Height = 21
              DataField = 'X'
              DataSource = DataSource1
              ReadOnly = True
              TabOrder = 1
            end
            object edNavObjY: TDBEdit
              Left = 61
              Top = 75
              Width = 106
              Height = 21
              DataField = 'Y'
              DataSource = DataSource1
              ReadOnly = True
              TabOrder = 2
            end
            object edSpeed: TDBEdit
              Left = 61
              Top = 141
              Width = 41
              Height = 21
              DataField = 'Speed'
              DataSource = DataSource1
              ReadOnly = True
              TabOrder = 3
            end
            object edCourse: TDBEdit
              Left = 61
              Top = 174
              Width = 65
              Height = 21
              DataField = 'Course'
              DataSource = DataSource1
              ReadOnly = True
              TabOrder = 4
            end
            object colbNavObjrColor: TColorBox
              Left = 61
              Top = 39
              Width = 81
              Height = 22
              Style = [cbStandardColors, cbCustomColor, cbPrettyNames]
              ItemHeight = 16
              TabOrder = 5
              OnChange = colbNavObjrColorChange
            end
            object edTime: TDBDateTimeEditEh
              Left = 61
              Top = 208
              Width = 122
              Height = 21
              DataField = 'Time'
              DataSource = DataSource1
              EditButton.Visible = False
              EditButtons = <>
              Kind = dtkDateTimeEh
              ReadOnly = True
              TabOrder = 6
              Visible = True
            end
          end
          object TabSheet2: TTabSheet
            Caption = #1048#1089#1090#1086#1088#1080#1103
            ImageIndex = 1
            object Label8: TLabel
              Left = 10
              Top = 15
              Width = 11
              Height = 13
              Caption = #1057':'
            end
            object Label9: TLabel
              Left = 4
              Top = 45
              Width = 17
              Height = 13
              Caption = #1055#1086':'
            end
            object CheckBox1: TCheckBox
              Left = 27
              Top = 72
              Width = 150
              Height = 17
              Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1090#1088#1072#1077#1082#1090#1086#1088#1080#1102
              TabOrder = 0
              OnClick = CheckBox1Click
            end
            object dtpDateFrom: TDateTimePicker
              Left = 27
              Top = 11
              Width = 154
              Height = 21
              Date = 40657.812675983800000000
              Time = 40657.812675983800000000
              TabOrder = 1
              OnChange = dtpDateFromChange
            end
            object dtpDateTo: TDateTimePicker
              Left = 27
              Top = 41
              Width = 154
              Height = 21
              Date = 40657.812720879630000000
              Time = 40657.812720879630000000
              TabOrder = 2
              OnChange = dtpDateToChange
            end
          end
        end
      end
    end
  end
  object tmrRefresh: TTimer
    OnTimer = acMapRefreshFullExecute
    Left = 616
    Top = 16
  end
  object conNavigationDB: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;Data Source=Nav_D' +
      'B'
    DefaultDatabase = 'Nav_DB2'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 816
    Top = 524
  end
  object DataSource1: TDataSource
    DataSet = tblNavObjects
    Left = 784
    Top = 496
  end
  object tblNavObjects: TADOTable
    Connection = conNavigationDB
    CursorType = ctStatic
    AfterScroll = tblNavObjectsAfterScroll
    TableName = 'NavigationObjects'
    Left = 784
    Top = 524
    object tblNavObjectsID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object tblNavObjectsName: TStringField
      FieldName = 'Name'
      OnChange = tblNavObjectsNameChange
      Size = 500
    end
    object tblNavObjectsIs_Avilaible: TIntegerField
      FieldName = 'Is_Avilaible'
    end
    object tblNavObjectsIs_Visible: TBooleanField
      FieldName = 'Is_Visible'
      OnChange = tblNavObjectsIs_VisibleChange
    end
    object tblNavObjectsX: TFloatField
      FieldName = 'X'
    end
    object tblNavObjectsY: TFloatField
      FieldName = 'Y'
    end
    object tblNavObjectsTime: TDateTimeField
      FieldName = 'Time'
    end
    object tblNavObjectsSpeed: TFloatField
      FieldName = 'Speed'
    end
    object tblNavObjectsCourse: TFloatField
      FieldName = 'Course'
    end
    object tblNavObjectsColor: TStringField
      FieldName = 'Color'
      OnChange = tblNavObjectsColorChange
      Size = 50
    end
  end
  object ActionList1: TActionList
    Left = 648
    Top = 16
    object acMapRefreshFull: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnExecute = acMapRefreshFullExecute
    end
  end
  object pmRefreshTimes: TPopupMenu
    Left = 584
    Top = 16
    object N101: TMenuItem
      Caption = '5'
    end
    object N151: TMenuItem
      Caption = '15'
    end
    object N301: TMenuItem
      Caption = '30'
    end
    object N601: TMenuItem
      Caption = '60'
    end
    object N6001: TMenuItem
      Caption = '300'
    end
    object N6002: TMenuItem
      Caption = '600'
    end
  end
  object TrackQuery: TADOQuery
    Connection = conNavigationDB
    Parameters = <>
    Left = 753
    Top = 524
  end
  object DataSource2: TDataSource
    DataSet = TrackQuery
    Left = 753
    Top = 496
  end
end
