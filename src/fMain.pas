unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ColorGrd, ShpAPI129, Math, StdCtrls, Spin, CheckLst,
  uDrawingClasses, DB, ADODB, Grids, DBGrids, DBCtrls, Mask, ComCtrls, GridsEh,
  DBGridEh, ActnList, DBCtrlsEh, ToolWin, Menus;

type
  TfrmMain = class(TForm)
    imgMap: TImage;
    pnlMap: TPanel;
    pnlObjects: TPanel;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    pnlMapImage: TPanel;
    tmrRefresh: TTimer;
    conNavigationDB: TADOConnection;
    DataSource1: TDataSource;
    tblNavObjects: TADOTable;
    edNavObjName: TDBEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    edNavObjX: TDBEdit;
    Label1: TLabel;
    edNavObjY: TDBEdit;
    Label2: TLabel;
    edSpeed: TDBEdit;
    Label3: TLabel;
    edCourse: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    colbNavObjrColor: TColorBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CheckBox1: TCheckBox;
    pnlObjList: TPanel;
    pnlObjDetails: TPanel;
    Splitter4: TSplitter;
    grObjects: TDBGridEh;
    tblNavObjectsID: TAutoIncField;
    tblNavObjectsName: TStringField;
    tblNavObjectsIs_Avilaible: TIntegerField;
    tblNavObjectsIs_Visible: TBooleanField;
    tblNavObjectsX: TFloatField;
    tblNavObjectsY: TFloatField;
    tblNavObjectsTime: TDateTimeField;
    tblNavObjectsSpeed: TFloatField;
    tblNavObjectsCourse: TFloatField;
    tblNavObjectsColor: TStringField;
    cbFollowCurrNavObject: TCheckBox;
    ActionList1: TActionList;
    acMapRefreshFull: TAction;
    edTime: TDBDateTimeEditEh;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    cbScale: TComboBox;
    ToolButton3: TToolButton;
    cbRefreshTime: TComboBox;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    CoolBar1: TCoolBar;
    TrackQuery: TADOQuery;
    DataSource2: TDataSource;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure Scale1Change(Sender: TObject);
    procedure chlbLayersClickCheck(Sender: TObject);
    procedure cbRefreshTimeChange(Sender: TObject);
    procedure colbNavObjrColorChange(Sender: TObject);
    procedure imgMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgMapDblClick(Sender: TObject);
    procedure imgMapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);                
    procedure grObjectsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure tblNavObjectsIs_VisibleChange(Sender: TField);
    procedure tblNavObjectsAfterScroll(DataSet: TDataSet);
    procedure tblNavObjectsColorChange(Sender: TField);
    procedure acMapRefreshFullExecute(Sender: TObject);
    procedure tblNavObjectsNameChange(Sender: TField);
    procedure Button1Click(Sender: TObject);
    procedure imgMapMouseEnter(Sender: TObject);
    procedure dtpDateFromChange(Sender: TObject);
    procedure dtpDateToChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure imgMapMouseLeave(Sender: TObject);
  private
    { Private declarations }
    FocusedComp: TControl;
    procedure RefreshNavObjects;
  public
    { Public declarations }
    function RandomColor: Tcolor;
  end;

var
  frmMain: TfrmMain;
  LayerLoader: TShapeMap;
  StartX,StartY: integer;

implementation

uses fDBMap, fLayers;  


{$R *.dfm}

procedure TfrmMain.cbRefreshTimeChange(Sender: TObject);
begin
    tmrRefresh.Interval := strtoint(cbRefreshTime.Text + '000');
end;

procedure TfrmMain.CheckBox1Click(Sender: TObject);
begin
  LayerLoader.AllowdDrawTrack := (Sender as TCheckBox).Checked;
  acMapRefreshFull.Execute;
end;

procedure TfrmMain.chlbLayersClickCheck(Sender: TObject);
Var
  i: Integer;
begin
  with (sender as TCheckListBox) do
  begin
    for i := 0 to Count - 1 do
      LayerLoader.Layers[i].Visible := Checked[i];
  end;
  LayerLoader.Redraw;
end;

procedure TfrmMain.colbNavObjrColorChange(Sender: TObject);
var
  Index: Integer;
begin
  Index := LayerLoader.IndexOfNavObject(tblNavObjectsID.value);
  if Index >= 0 then
  begin
    with tblNavObjects do
    begin
      DisableControls;
      try
        edit;
        tblNavObjectsColor.value := ColorToString(colbNavObjrColor.Selected);
        post;
      finally
        EnableControls;
      end;
    end;
    LayerLoader.Redraw(cbFollowCurrNavObject.Checked);
  end;
end;

procedure TfrmMain.dtpDateFromChange(Sender: TObject);
begin
  acMapRefreshFull.Execute;
end;

procedure TfrmMain.dtpDateToChange(Sender: TObject);
begin
  acMapRefreshFull.Execute;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  dtpDateFrom.Date := now;  
  dtpDateTo.Date := now;
  LayerLoader := TShapeMap.create(imgMap, strtofloat(cbScale.text));       
  tmrRefresh.Interval := strtoint(cbRefreshTime.Text + '000');
  acMapRefreshFull.Execute;
end;

procedure TfrmMain.grObjectsDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  if (Column.FieldName = 'Is_Visible') then
  begin
    grObjects.canvas.brush.color := StringToColor(Column.Field.Dataset.FieldbyName('Color').AsString);
    grObjects.canvas.pen.color := StringToColor(Column.Field.Dataset.FieldbyName('Color').AsString);
    grObjects.DefaultDrawColumnCell(rect, DataCol, Column, State)
  end;
end;

procedure TfrmMain.imgMapDblClick(Sender: TObject);  
var
  P: TPoint;
begin
  GetCursorPos(P);
  LayerLoader.MoveMapImg(ScreenToClient(P).X - pnlMapImage.Left,
    imgMap.Height - (ScreenToClient(P).Y - pnlMapImage.top));
 //zoom after doubleclick
 { if cbScale.ItemIndex <> pred(cbScale.Items.Count) then
    cbScale.ItemIndex := cbScale.ItemIndex + 1; }
  LayerLoader.ReDraw();
end;

procedure TfrmMain.imgMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 StartX:=X;
 StartY:=Y;
 Screen.Cursor := crSizeAll;
end;

procedure TfrmMain.imgMapMouseEnter(Sender: TObject);
begin
  FocusedComp := ActiveControl;
  cbScale.SetFocus;
end;

procedure TfrmMain.imgMapMouseLeave(Sender: TObject);
begin
  (FocusedComp as TWinControl).SetFocus;
end;

procedure TfrmMain.imgMapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewC_x, NewC_y: Integer;
begin
  NewC_x := imgMap.Width div 2 + (StartX - X);
  NewC_y := imgMap.Height div 2 - (StartY - Y);
  LayerLoader.MoveMapImg(NewC_x, NewC_y);
  Screen.Cursor := crDefault;
end;

function TfrmMain.RandomColor: Tcolor;
var
  R, G, B: Integer;
begin
  Randomize;
  R := Random(255);
  G := Random(255);
  B := Random(255);
  Result := RGB(R, G, B);
end;

procedure TfrmMain.RefreshNavObjects;

  procedure RefreshTrack(NavObject: TNavObject);
  var
    sql: string;
    Point: TMyPoint;
  begin
  if LayerLoader.AllowdDrawTrack then
  begin
    sql := format('Select X, Y from Obj_history where Obj_ID = %d and Time between convert(datetime, ''%s'', 104) and convert(datetime, ''%s'', 104)',
      [tblNavObjectsID.Value,  DateTimeToStr(dtpDateFrom.DateTime), DateTimeToStr(dtpDateTo.DateTime)]);

    TrackQuery.SQL.Clear;
    TrackQuery.SQL.Add(sql);
    TrackQuery.Active := false;
    TrackQuery.Active := True;

    with TrackQuery do
      begin
        DisableControls;
        try
          First;
          while not Eof do
          begin
            Point.X := FindField('X').Value;
            Point.Y := FindField('Y').Value;
            NavObject.addTrackPoint(Point);
            next;
          end;
        finally
          EnableControls;
        end;
      end;
  end;
  end;

var
  IniID: Integer;
  NavObject: TNavObject;
begin
  conNavigationDB.Connected := True;
  tblNavObjects.Active := True;
  IniID := tblNavObjectsID.value;

  tblNavObjects.Close;
  tblNavObjects.Open;

  LayerLoader.ClearNavObject;
  with tblNavObjects do
  begin
    DisableControls;
    try
      First;
      while not Eof do
      begin
        NavObject := TNavObject.Create(tblNavObjectsID.value,
          tblNavObjectsName.value, tblNavObjectsX.value,
          tblNavObjectsY.value, StringToColor(tblNavObjectsColor.Value),
          tblNavObjectsIs_Visible.Value);  
        RefreshTrack(NavObject);
        LayerLoader.addNavObject(NavObject);
        Next;
      end;

      LayerLoader.SelectedNavObjectIndex := LayerLoader.IndexOfNavObject(IniID);
      Locate('ID', IniID, []);

    finally
      EnableControls;
    end;
  end;
end;


procedure TfrmMain.Scale1Change(Sender: TObject);
begin
  LayerLoader.Scale := strtofloat(cbScale.text);
  LayerLoader.ReDraw();
end;

procedure TfrmMain.tblNavObjectsAfterScroll(DataSet: TDataSet);
var
  Index: Integer;
begin
  Index := LayerLoader.IndexOfNavObject(tblNavObjectsID.value);
  if Index >= 0 then
  begin
    colbNavObjrColor.Selected := LayerLoader.NavObjects[Index].Color;
    LayerLoader.SelectedNavObjectIndex := Index;
    //LayerLoader.ReDraw(cbFollowCurrNavObject.Checked);
  end;
end;

procedure TfrmMain.tblNavObjectsColorChange(Sender: TField);
var
  Index: Integer;
begin
  Index := LayerLoader.IndexOfNavObject(tblNavObjectsID.value);
  LayerLoader.NavObjects[Index].Color := StringToColor(tblNavObjectsColor.value);
end;

procedure TfrmMain.tblNavObjectsIs_VisibleChange(Sender: TField);
Var
  Index: Integer;
begin
  Index := LayerLoader.IndexOfNavObject(tblNavObjectsID.Value);
  LayerLoader.NavObjects[Index].Visible := tblNavObjectsIs_Visible.Value;
  LayerLoader.Redraw;
end;

procedure TfrmMain.tblNavObjectsNameChange(Sender: TField);
Var
  Index: Integer;
begin
  Index := LayerLoader.IndexOfNavObject(tblNavObjectsID.Value);
  LayerLoader.NavObjects[Index].Name := tblNavObjectsName.Value;
end;

procedure TfrmMain.acMapRefreshFullExecute(Sender: TObject);
begin    
  tmrRefresh.Enabled := False;
  RefreshNavObjects;
  LayerLoader.ReDraw(cbFollowCurrNavObject.Checked); 
  tmrRefresh.Enabled := True;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmLayers.ShowModal;
end;

end.
