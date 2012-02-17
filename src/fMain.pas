unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ColorGrd, ShpAPI129, Math, StdCtrls, Spin, CheckLst,
  uDrawingClasses, DB, ADODB, Grids, DBGrids, DBCtrls, Mask, ComCtrls, GridsEh,
  DBGridEh, ActnList, DBCtrlsEh, ToolWin, Menus, ImgList, Buttons;

type
  TMapMouseMode = (mmmDefault = 0, mmmZoom, mmmDrag);
  TListMode = (lmNone = 0, lmAdd, lmEdit);
  TfrmMain = class(TForm)
    imgMap: TImage;
    pnlMap: TPanel;
    pnlObjects: TPanel;
    Splitter1: TSplitter;
    grbNavOdjects: TGroupBox;
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
    chbTrack: TCheckBox;
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
    btnEditLayers: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    cbRefreshTime: TComboBox;
    btnRefresh: TToolButton;
    btnZoomMode: TToolButton;
    TrackQuery: TADOQuery;
    DataSource2: TDataSource;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    acEditLayers: TAction;
    btnDragMode: TToolButton;
    ImageList1: TImageList;
    trbScale: TTrackBar;
    acChangeScale: TAction;
    acSetMapMouseMode: TAction;
    btnZoomOut: TToolButton;
    btnZoomIn: TToolButton;
    ToolButton5: TToolButton;
    btnZoomAll: TToolButton;
    acZoomIn: TAction;
    acZoomOut: TAction;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N7: TMenuItem;
    grbRealTrack: TGroupBox;
    grbDesiredTrack: TGroupBox;
    chbDesiredTrack: TCheckBox;
    edDesiredPointLong: TEdit;
    edDesiredPointLatt: TEdit;
    btnAcceptDesiredPoint: TButton;
    Label10: TLabel;
    Label11: TLabel;
    btnDefaultMode: TToolButton;
    sbMap: TStatusBar;
    Label12: TLabel;
    pnlAddDesiredPoint: TPanel;
    grDesiredPoints: TStringGrid;
    pnlDesiredPoints: TPanel;
    btnAddDesiredPoint: TButton;
    btnClearDesiredPoints: TButton;
    acAddDesiredPoint: TAction;
    acAcceptDesiredPoint: TAction;
    acClearDesiredPoints: TAction;
    Button1: TButton;
    acDeclineDesiredPoint: TAction;
    btnEditDesiredPoint: TButton;
    acEditDesiredPoint: TAction;
    acSetTrackAvilaible: TAction;
    acSetDesiredTrackAvilaible: TAction;
    procedure FormCreate(Sender: TObject);
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
    procedure imgMapMouseEnter(Sender: TObject);
    procedure dtpDateFromChange(Sender: TObject);
    procedure dtpDateToChange(Sender: TObject);
    procedure imgMapMouseLeave(Sender: TObject);
    procedure acEditLayersExecute(Sender: TObject);
    procedure acChangeScaleExecute(Sender: TObject);
    procedure acSetMapMouseModeExecute(Sender: TObject);
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acAcceptDesiredPointExecute(Sender: TObject);
    procedure acAddDesiredPointExecute(Sender: TObject);
    procedure acAcceptDesiredPointUpdate(Sender: TObject);
    procedure acDeclineDesiredPointExecute(Sender: TObject);
    procedure acSetTrackAvilaibleExecute(Sender: TObject);
    procedure acSetDesiredTrackAvilaibleExecute(Sender: TObject);
    procedure acClearDesiredPointsExecute(Sender: TObject);
    procedure acEditDesiredPointExecute(Sender: TObject);
    procedure acEditDesiredPointUpdate(Sender: TObject);
  private
    { Private declarations }
    FocusedComp: TControl;
    FMapMouseMode: TMapMouseMode;
    FDesiredTrackPointsListMode: TListMode;
//  Изменение выбранного объекта производилось вручную
    FManualObjectChange: Boolean;
    procedure RefreshNavObjects;
    procedure RefreshDesiredTrackPointsList;
    procedure ShowDesiredTrackPointsPanel;
  public
    { Public declarations }
    function RandomColor: Tcolor;
  end;

var
  frmMain: TfrmMain;
  LayerLoader: TShapeMap;
  StartPoint: TPoint;
  RealPoint: TMyPoint;

implementation

uses fDBMap, fLayers;  


{$R *.dfm}

procedure TfrmMain.cbRefreshTimeChange(Sender: TObject);
begin
    tmrRefresh.Interval := strtoint(cbRefreshTime.Text + '000');
end;

procedure TfrmMain.colbNavObjrColorChange(Sender: TObject);
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
  FManualObjectChange := True;
  LayerLoader := TShapeMap.create(imgMap, trbScale.Position);
  tmrRefresh.Interval := strtoint(cbRefreshTime.Text + '000');
  grDesiredPoints.ColWidths[0] := 30;
  grDesiredPoints.Cells[0,0] := 'Т. №';
  grDesiredPoints.Cells[1,0] := 'Широта';
  grDesiredPoints.Cells[2,0] := 'Долгота';
  acSetMapMouseMode.Execute;
  acSetTrackAvilaible.Execute;
  acSetDesiredTrackAvilaible.Execute; 
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
  end
  else
    if (Column.FieldName = 'Name') and
      (LayerLoader.IndexOfNavObject(Column.Field.Dataset.FieldbyName('ID').Value) =
      LayerLoader.SelectedNavObjectIndex) then
    begin
      grObjects.canvas.brush.color := clSilver;
      grObjects.canvas.pen.color := clSilver;
      grObjects.DefaultDrawColumnCell(rect, DataCol, Column, State)
    end;
end;

procedure TfrmMain.imgMapDblClick(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  LayerLoader.MoveMapImg(ScreenToClient(P).X - pnlMap.Left,
    imgMap.Height - (ScreenToClient(P).Y - pnlMap.top));
 //zoom after doubleclick
 { if cbScale.ItemIndex <> pred(cbScale.Items.Count) then
    cbScale.ItemIndex := cbScale.ItemIndex + 1; }
  LayerLoader.ReDraw;
end;

procedure TfrmMain.imgMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RealPoint.X := LayerLoader.X_c + (X - (imgMap.Width div 2))/LayerLoader.Scale;
  RealPoint.Y := LayerLoader.Y_c + (-Y + (imgMap.Height div 2))/LayerLoader.Scale;

  StartPoint.X := X;
  StartPoint.Y := Y;

  if FMapMouseMode = mmmDrag then
  begin
    Screen.Cursor := crSizeAll;
  end;
  
  if FMapMouseMode = mmmDefault then
  begin
    edDesiredPointLong.Text := FloatToStr(RealPoint.X);
    edDesiredPointLatt.Text := FloatToStr(RealPoint.Y);
    sbMap.Panels[0].Text := FloatToStr(RealPoint.X) + '; ' + FloatToStr(RealPoint.Y);
  end
  else
    sbMap.Panels[0].Text := '';
end;

procedure TfrmMain.imgMapMouseEnter(Sender: TObject);
begin
  FocusedComp := ActiveControl;
  trbScale.SetFocus;
end;

procedure TfrmMain.imgMapMouseLeave(Sender: TObject);
begin
  if Assigned(FocusedComp) then
    (FocusedComp as TWinControl).SetFocus;
end;

procedure TfrmMain.imgMapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  NewC_x, NewC_y: Integer;
begin
  if FMapMouseMode = mmmDrag then
  begin
    NewC_x := imgMap.Width div 2 + (StartPoint.X - X);
    NewC_y := imgMap.Height div 2 - (StartPoint.Y - Y);
    LayerLoader.MoveMapImg(NewC_x, NewC_y);
    Screen.Cursor := crDefault;
  end;
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
    NavObject.ClearTrack;
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

var
  IniID, CurrIndex: Integer;
  NavObject: TNavObject;
begin
  FManualObjectChange := False;
  conNavigationDB.Connected := True;
  tblNavObjects.Active := True;
  IniID := tblNavObjectsID.value;

  tblNavObjects.Close;
  tblNavObjects.Open;

  //LayerLoader.ClearNavObjects;
  with tblNavObjects do
  begin
    DisableControls;
    try
      First;
      while not Eof do
      begin
        CurrIndex := LayerLoader.IndexOfNavObject(tblNavObjectsID.value);
        if CurrIndex = -1 then
        begin
          NavObject := TNavObject.Create(tblNavObjectsID.value,
            tblNavObjectsName.value, tblNavObjectsX.value,
            tblNavObjectsY.value, StringToColor(tblNavObjectsColor.Value),
            tblNavObjectsIs_Visible.Value);
          RefreshTrack(NavObject);
          LayerLoader.addNavObject(NavObject);
        end
        else
        begin
          LayerLoader.NavObjects[CurrIndex].X := tblNavObjectsX.value;
          LayerLoader.NavObjects[CurrIndex].Y := tblNavObjectsY.value;
          RefreshTrack(LayerLoader.NavObjects[CurrIndex]);
        end;
        Next;
      end;
      LayerLoader.SelectedNavObjectIndex := LayerLoader.IndexOfNavObject(IniID);
      Locate('ID', IniID, []);
    finally
      EnableControls;
    end;
  end;  
  FManualObjectChange := True;
end;

procedure TfrmMain.ShowDesiredTrackPointsPanel;
begin
  edDesiredPointLatt.Text := '';
  edDesiredPointLong.Text := '';
  pnlAddDesiredPoint.Visible := True;
  btnDefaultMode.Down := True;
  acSetMapMouseMode.Execute;
end;

procedure TfrmMain.RefreshDesiredTrackPointsList;
var
  i: Integer;
begin
  //Всегда минимум 2 строки
  grDesiredPoints.RowCount := Max(LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].DesiredTrackPointsCount + 1, 2);
  grDesiredPoints.Cells[0,1] := '';
  grDesiredPoints.Cells[1,1] := '';
  grDesiredPoints.Cells[2,1] := '';
  for i := 0 to LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].DesiredTrackPointsCount - 1 do
  begin
    grDesiredPoints.Cells[0,i+1] := IntToStr(i+1);
    grDesiredPoints.Cells[1,i+1] := FloatToStr(LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].DesiredTrackPoints[i].X);
    grDesiredPoints.Cells[2,i+1] := FloatToStr(LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].DesiredTrackPoints[i].Y);
  end;
end;

procedure TfrmMain.tblNavObjectsAfterScroll(DataSet: TDataSet);
var
  Index: Integer;
begin
  Index := LayerLoader.IndexOfNavObject(tblNavObjectsID.value);
  if Index >= 0 then
  begin
    LayerLoader.SelectedNavObjectIndex := Index; 
    colbNavObjrColor.Selected :=
      LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].Color;
  end;
  if FManualObjectChange then
  begin
    RefreshDesiredTrackPointsList;
    LayerLoader.ReDraw(cbFollowCurrNavObject.Checked);
  end;
end;

procedure TfrmMain.tblNavObjectsColorChange(Sender: TField);
begin
  LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].Color :=
    StringToColor(tblNavObjectsColor.value);
end;

procedure TfrmMain.tblNavObjectsIs_VisibleChange(Sender: TField);
begin
  LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].Visible :=
    tblNavObjectsIs_Visible.Value;
  LayerLoader.ReDraw(cbFollowCurrNavObject.Checked);
end;

procedure TfrmMain.tblNavObjectsNameChange(Sender: TField);
begin
  LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].Name :=
    tblNavObjectsName.Value;
end;

procedure TfrmMain.acAcceptDesiredPointExecute(Sender: TObject);
var
  Point: TMyPoint;
begin
  Point.X := StrToFloat(edDesiredPointLong.Text);
  Point.Y := StrToFloat(edDesiredPointLatt.Text);
  if FDesiredTrackPointsListMode = lmAdd then
    LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].
      addDesiredTrackPoint(Point)
  else      
  if FDesiredTrackPointsListMode = lmEdit then
    LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].
      DesiredTrackPoints[grDesiredPoints.Selection.Top-1] := Point;
  
  FDesiredTrackPointsListMode := lmNone;
  RefreshDesiredTrackPointsList;
  pnlDesiredPoints.Enabled := True;
  pnlAddDesiredPoint.Visible := False;
  LayerLoader.ReDraw();
end;

procedure TfrmMain.acAcceptDesiredPointUpdate(Sender: TObject);
var
  Temp: Double;
begin
  (Sender as TAction).Enabled := trystrtofloat(edDesiredPointLatt.Text, Temp) and
    trystrtofloat(edDesiredPointLong.Text, Temp);
end;

procedure TfrmMain.acAddDesiredPointExecute(Sender: TObject);
begin
  FDesiredTrackPointsListMode := lmAdd;
  pnlDesiredPoints.Enabled := False;
  ShowDesiredTrackPointsPanel;
end;

procedure TfrmMain.acSetMapMouseModeExecute(Sender: TObject);
begin
  if btnZoomMode.Down then
    FMapMouseMode := mmmZoom
  else
  if btnDragMode.Down then
  begin
    FMapMouseMode := mmmDrag;
  end
  else
  if btnDefaultMode.Down then
  begin
    FMapMouseMode := mmmDefault;
  end;
end;

procedure TfrmMain.acChangeScaleExecute(Sender: TObject);
begin
  acZoomOut.Enabled := trbScale.Position <> trbScale.Min;
  acZoomIn.Enabled := trbScale.Position <> trbScale.Max;

  LayerLoader.Scale := trbScale.Position * 1000;
  LayerLoader.ReDraw();
end;

procedure TfrmMain.acClearDesiredPointsExecute(Sender: TObject);
begin
  LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].ClearDesiredTrack;
  RefreshDesiredTrackPointsList;
  LayerLoader.ReDraw();
end;

procedure TfrmMain.acDeclineDesiredPointExecute(Sender: TObject);
begin
  FDesiredTrackPointsListMode := lmNone;
  pnlDesiredPoints.Enabled := True;
  pnlAddDesiredPoint.Visible := False;
end;

procedure TfrmMain.acEditDesiredPointExecute(Sender: TObject);
begin
  FDesiredTrackPointsListMode := lmEdit;
  pnlDesiredPoints.Enabled := False;
  ShowDesiredTrackPointsPanel;
end;

procedure TfrmMain.acEditDesiredPointUpdate(Sender: TObject);
begin
  acEditDesiredPoint.Enabled :=
    LayerLoader.NavObjects[LayerLoader.SelectedNavObjectIndex].DesiredTrackPointsCount > 0;
end;

procedure TfrmMain.acEditLayersExecute(Sender: TObject);
begin
  frmLayers.ShowModal;
end;

procedure TfrmMain.acMapRefreshFullExecute(Sender: TObject);
begin    
  tmrRefresh.Enabled := False;
  RefreshNavObjects;
  LayerLoader.ReDraw(cbFollowCurrNavObject.Checked);
  tmrRefresh.Enabled := True;
end;

procedure TfrmMain.acSetDesiredTrackAvilaibleExecute(Sender: TObject);
begin
  LayerLoader.AllowDrawDesiredTrack := chbDesiredTrack.Checked;
  grbDesiredTrack.Enabled := chbDesiredTrack.Checked;  
  LayerLoader.ReDraw();
end;

procedure TfrmMain.acSetTrackAvilaibleExecute(Sender: TObject);
begin
  LayerLoader.AllowDrawTrack := chbTrack.Checked;
  grbRealTrack.Enabled := chbTrack.Checked;
  LayerLoader.ReDraw();
end;

procedure TfrmMain.acZoomInExecute(Sender: TObject);
begin
  trbScale.Position := trbScale.Position + trbScale.Frequency;
  acChangeScale.Execute;
end;

procedure TfrmMain.acZoomOutExecute(Sender: TObject);
begin
  trbScale.Position := trbScale.Position - trbScale.Frequency;
  acChangeScale.Execute;
end;

end.
