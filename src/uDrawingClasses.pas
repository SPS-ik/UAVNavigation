unit uDrawingClasses;

interface

uses ColorGrd, Graphics, ExtCtrls, Types, shpAPI129, Math, SysUtils;

Type
  TPointsArr = array of TPoint;
  TMyPoint = packed record
    X: Double;
    Y: Double;
  end;
  TMyPointsArr = array of TMyPoint;


  TLayer = class(TObject)
    private
     FHandle: SHPHandle;
     FName: string;
     FMinBounds, FMaxBounds: Array [0..3] Of Double;
     FEntitiesCount, FShapeType: LongInt;
     FVisible: Boolean;
     FColor: TColor;

     function getVisible(): Boolean;
     procedure setVisible(Vis: Boolean);

     function getColor(): TColor;
     procedure setColor(Clr: TColor );
     
     function GetMinBounds(Index: Integer): Double;
     function GetMaxBounds(Index: Integer): Double;

    public
     constructor Create(FileName: string; Color: TColor = clBlue; name: string = '';
        Visible: Boolean = True);

     property Handle: SHPHandle read FHandle;
     property Name: string read FName write FName;
     property MinBounds[Index : integer]: Double read GetMinBounds;
     property MaxBounds[Index : integer]: Double read GetMaxBounds;
     property MinX: Double Index 0 read GetMinBounds;
     property MaxX: Double Index 0 read GetMaxBounds;
     property MinY: Double Index 1 read GetMinBounds;
     property MaxY: Double Index 1 read GetMaxBounds;
     property ShapeType: LongInt read FShapeType;
     property EntitiesCount: LongInt read FEntitiesCount;

     property Visible: Boolean read getVisible write setVisible;
     property Color: TColor read getColor write setColor;

  end;

  TNavObject = class(TObject)
    private
     FID: Integer;
     FName: string;
     FVisible: Boolean;
     FColor: TColor;
     FX: Double;   
     FY: Double;
     FTrackPoints: TMyPointsArr;

     function getVisible(): Boolean;
     procedure setVisible(Vis: Boolean);

     function getColor(): TColor;
     procedure setColor(Clr: TColor );

     function GetX: Double;
     procedure SetX(X: Double);

     function GetY: Double;
     procedure SetY(Y: Double);

     function getTrackPoint(Index: Integer): TMyPoint;
     procedure setTrackPoint(Index: Integer; Value: TMyPoint);

    public
     constructor Create(ID: integer; name: string; X: Double; Y: Double;
        Color: TColor = clBlue; Visible: Boolean = True);

     
     property ID: Integer read FID;
     property Name: string read FName write FName;
     property X: Double read GetX write SetX;
     property Y: Double read GetY write SetY;
     property TrackPoints[Index: Integer]: TMyPoint read getTrackPoint write setTrackPoint;
     property Visible: Boolean read getVisible write setVisible;
     property Color: TColor read getColor write setColor; 

     procedure addTrackPoint(TrackPoint: TMyPoint);

  end;

  TShapeMap = class
    private
      FImg: TImage;
      FLayerCount: Integer; 
      FNavObjectCount: Integer;
      FScale: double;
      FX_c, FY_c: double;
      FLayers: array of TLayer;     
      FNavObjects: array of TNavObject;
      FCurrNavObjectIndex: Integer;
      FAllowDrawTrack: Boolean;

      procedure draw_point(obj: PSHPObject; var  img: TImage);
      procedure draw_arc(obj: PSHPObject; var  img: TImage);
      procedure draw_polygon(obj: PSHPObject; var  img: TImage);
      procedure draw_multipoint(obj: PSHPObject; var img: TImage);
      function castCoor_X(x: double): Integer;
      function castCoor_Y(y: double): Integer;

      function getScale(): double;
      procedure setScale(s: double);

      function getLayer(Index: Integer): TLayer;
      procedure setLayer(Index: Integer; Value: TLayer);
      function getNavObject(Index: Integer): TNavObject;
      procedure setNavObject(Index: Integer; Value: TNavObject);
      procedure DrawLayer(Layer: TLayer);
      procedure DrawNavObject(NavObject: TNavObject; IsCurrObj: Boolean = False);

    public
      constructor create(var Img: TImage; Scale: double);

      property LayerCount: Integer read FLayerCount;
      property NavObjectCount: Integer read FNavObjectCount;
      property Scale: Double read getScale write setScale;
      property Layers[Index: Integer]: TLayer read getLayer write setLayer;
      property NavObjects[Index: Integer]: TNavObject read getNavObject write setNavObject;
      property SelectedNavObjectIndex: Integer read FCurrNavObjectIndex write FCurrNavObjectIndex;
      property AllowdDrawTrack: Boolean read FAllowDrawTrack write FAllowDrawTrack;
      procedure addLayer(layer: TLayer);
      procedure addNavObject(NavObject: TNavObject);
      procedure ClearNavObject;
      function IndexOfNavObject(ID: Integer): Integer;
      procedure ReDraw(AFollowCurrNavObject: Boolean = False);
      procedure SetMapCenter(X_c, Y_c: double); 
      procedure MoveMapImg(NewImgC_x, NewImgC_y: Double);

  end;

implementation

uses
  Windows;



{ TLayer }

constructor TLayer.create(FileName: string; Color: TColor = clBlue; name: string = '';
        Visible: Boolean = True);
begin
  FHandle := SHPOpen(PAnsiChar(FileName),'rb');
  if name <> '' then
    Fname := Name
  else
    Fname := ChangeFileExt(ExtractFileName(FileName), '');

  FVisible := true;
  SHPGetInfo (FHandle, @FEntitiesCount, @FShapeType, @FMinBounds[0], @FMaxBounds[0]);
  FColor := Color;
end;



function TLayer.getColor: TColor;
begin 
  Result := FColor;
end;

function TLayer.GetMaxBounds(Index: Integer): Double;
begin
  if (Index >= 0) and (Index <= 3) then
    Result := FMaxBounds[Index]
  else
    Result := -1;
end;

function TLayer.GetMinBounds(Index: Integer): Double;
begin 
  if (Index >= 0) and (Index <= 3) then
    Result := FMinBounds[Index]
  else Result := -1;
end;


function TLayer.getVisible: Boolean;
begin     
  Result := FVisible;
end;


procedure TLayer.setColor(Clr: TColor);
begin          
  FColor := Clr;
end;


procedure TLayer.setVisible(Vis: Boolean);
begin
  FVisible := Vis;
end;

{ TLayerStorage }

procedure TShapeMap.addLayer(layer: TLayer);
begin
  if not Assigned(layer) then
    Exit;
  SetLength(FLayers, length(FLayers) + 1);
  FLayers[length(FLayers) - 1] := layer;
  inc(FLayerCount);
end;

procedure TShapeMap.addNavObject(NavObject: TNavObject);
begin
  if not Assigned(NavObject) then
    Exit;
  SetLength(FNavObjects, length(FNavObjects) + 1);
  FNavObjects[length(FNavObjects) - 1] := NavObject;
  inc(FNavObjectCount);
end;



function TShapeMap.castCoor_X(x: double): Integer;
begin
	 result := (FImg.Width div 2) + floor((x - FX_c)*FScale);
end;

function TShapeMap.castCoor_Y(y: double): Integer;
begin
	 result := (FImg.Height div 2) - floor((y - FY_c)*FScale);
end;

procedure TShapeMap.ClearNavObject;
var
  i,j: Integer;
begin
  for i := 0 to length(FNavObjects) - 1 do
  begin
    for j  := 0 to length(FNavObjects[i].FTrackPoints) - 1 do
      begin
        FNavObjects[i].FTrackPoints[j].X := 0;
        FNavObjects[i].FTrackPoints[j].Y := 0;
      end;
    SetLength(FNavObjects[i].FTrackPoints, 0);
    FNavObjects[i].Free;
  end;
  SetLength(FNavObjects, 0);
  FNavObjectCount := 0;
end;

constructor TShapeMap.create(var Img: TImage; Scale: double);
begin
  FImg := Img;
  FCurrNavObjectIndex := -1;
  FLayerCount := 0;
  FAllowDrawTrack := False;
  FScale := Scale * 1000;
  FX_c := 0;
  FY_c := 0;
end;


procedure TShapeMap.DrawLayer(Layer: TLayer);
var
  obj: PShpObject;
  i: integer;
begin
	 if ((not Assigned(Layer.Handle)) or (not Layer.Visible)) then
     exit;

   Fimg.Picture.Bitmap.Width := Fimg.Width;
   Fimg.Picture.Bitmap.Height := Fimg.Height;

	 Fimg.Canvas.Brush.Color := Layer.Color;
	 Fimg.Canvas.Pen.Color := Layer.Color;

	 for i := 0 to Layer.EntitiesCount - 1 do
   begin
   obj := SHPReadObject(Layer.Handle, i);
   if (castCoor_X(obj.dfXMin) < Fimg.Width) and
      (castCoor_X(obj.dfXMax) > 0) and
      (castCoor_Y(obj.dfYMin) < Fimg.Height) and
      (castCoor_Y(obj.dfYMax) > 0) then
    begin
      case(obj.nSHPType) of
        SHPT_POINT: draw_point(obj, Fimg);
        SHPT_ARC: draw_arc(obj, Fimg);
		    SHPT_POLYGON: draw_polygon(obj, Fimg);
		    SHPT_MULTIPOINT: draw_multipoint(obj, Fimg);
      end;
    end;
    SHPDestroyObject(obj);
   end;
end;

procedure TShapeMap.DrawNavObject(NavObject: TNavObject; IsCurrObj: Boolean = False);
var     
  points: TPointsArr; 
  i: Integer;
  mode: TPenMode;
  wid: Integer;
  col: TColor;
begin
	if  (not NavObject.Visible) then
    exit;

  Fimg.Picture.Bitmap.Width := Fimg.Width;
  Fimg.Picture.Bitmap.Height := Fimg.Height;

  mode := Fimg.Canvas.Pen.Mode;
  col := Fimg.Canvas.Pen.Color;
  wid := Fimg.Canvas.Pen.Width;

  Fimg.Canvas.Pen.Mode  := pmMask;
  Fimg.Canvas.Pen.Color := NavObject.Color;
  if IsCurrObj then
    Fimg.Canvas.Pen.Width := 5
  else
    Fimg.Canvas.Pen.Width := 2;

  Fimg.Canvas.MoveTo(castCoor_X(NavObject.x) - 15, castCoor_Y(NavObject.Y));
  Fimg.Canvas.LineTo(castCoor_X(NavObject.x) + 15, castCoor_Y(NavObject.Y));
  Fimg.Canvas.MoveTo(castCoor_X(NavObject.x), castCoor_Y(NavObject.Y) - 15);
  Fimg.Canvas.LineTo(castCoor_X(NavObject.x), castCoor_Y(NavObject.Y) + 15);
  Fimg.Canvas.Refresh();

  if FAllowDrawTrack and IsCurrObj then
  begin
    SetLength(points, length(NavObject.FTrackPoints));
	  for i := 0 to length(NavObject.FTrackPoints) - 1 do
    begin
      points[i].X :=  castCoor_X(NavObject.TrackPoints[i].X);
      points[i].Y :=  castCoor_Y(NavObject.TrackPoints[i].Y);
    end;

    for i := 0 to length(points) - 1 do
    begin                         
      Fimg.Canvas.Pen.Color := clBlack;
      Fimg.Canvas.Pen.Width := 5;
      Fimg.Canvas.MoveTo(points[i].X, points[i].Y);
      Fimg.Canvas.LineTo(points[i].X, points[i].Y);

      Fimg.Canvas.Pen.Color := clRed;
      Fimg.Canvas.Pen.Width := 2;
      Fimg.Canvas.Ellipse(points[i].X-10, points[i].Y-10, points[i].X+10, points[i].Y+10);
    end;

    Fimg.Canvas.Pen.Color := clBlack;
    Fimg.Canvas.Pen.Width := 1;
    Fimg.Canvas.Polyline(points);
  end;

  Fimg.Canvas.Pen.Mode := mode;
  Fimg.Canvas.Pen.Color := col;
  Fimg.Canvas.Pen.Width := wid;
end;

procedure TShapeMap.draw_arc(obj: PSHPObject; var img: TImage);
var
  i: Integer;
begin
//
	for i := 0 to obj.nVertices - 2 do
  begin
    img.Canvas.MoveTo(castCoor_X(obj.padfX[i]), castCoor_Y(obj.padfY[i]));
	  img.Canvas.LineTo(castCoor_X(obj.padfX[i+1]), castCoor_Y(obj.padfY[i+1]));
  end;
end;

procedure TShapeMap.draw_multipoint(obj: PSHPObject; var img: TImage);
begin
//
end;

procedure TShapeMap.draw_point(obj: PSHPObject; var img: TImage);
begin 
  img.Canvas.MoveTo(castCoor_X(obj.padfX[0]), castCoor_Y(obj.padfY[0]));
	img.Canvas.LineTo(castCoor_X(obj.padfX[0]), castCoor_Y(obj.padfY[0]));
end;

procedure TShapeMap.draw_polygon(obj: PSHPObject; var img: TImage);
var
  points: TPointsArr;
  i: Integer;
begin
  SetLength(points, obj.nVertices);
	for i := 0 to obj.nVertices - 1 do
  begin
    points[i].X :=  castCoor_X(obj.padfX[i]);
    points[i].Y :=  castCoor_Y(obj.padfY[i]);
  end;
  img.Canvas.Polygon(points);
end;


function TShapeMap.getLayer(Index: Integer): TLayer;
begin
  if((Index >= 0) and (Index <= Length(FLayers) - 1)) then
  begin
    Result := FLayers[Index];
  end
  else
    Result := nil;
end;

function TShapeMap.getNavObject(Index: Integer): TNavObject;
begin
  if((Index >= 0) and (Index <= Length(FNavObjects) - 1)) then
  begin
    Result := FNavObjects[Index];
  end
  else
    Result := nil;
end;

function TShapeMap.getScale: double;
begin
  Result := FScale / 1000;
end;



function TShapeMap.IndexOfNavObject(ID: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(FNavObjects) - 1 do
  begin
    if FNavObjects[i].ID = ID then
    begin
      Result := i;
      exit;
    end;
  end;
  Result := -1;
end;

procedure TShapeMap.MoveMapImg(NewImgC_x, NewImgC_y: Double);
begin
  FX_c := FX_c + (NewImgC_x - (FImg.Width div 2))/FScale;
  FY_c := FY_c + (NewImgC_y - (FImg.Height div 2))/FScale;
  ReDraw;
end;

procedure TShapeMap.ReDraw(AFollowCurrNavObject: Boolean);
var
  i: Integer;
  IsCurrObj: Boolean;
begin
  if AFollowCurrNavObject and (FCurrNavObjectIndex >= 0) then
  begin
    FX_c := FNavObjects[FCurrNavObjectIndex].X;
    FY_c := FNavObjects[FCurrNavObjectIndex].Y;
  end;
  Fimg.canvas.Brush.Color := clWhite;
  Fimg.canvas.fillrect(Fimg.canvas.cliprect);
  for i := 0 to FLayerCount - 1 do
  begin
    DrawLayer(FLayers[i]);
  end;


  for i := 0 to FNavObjectCount - 1 do
  begin
    if i = FCurrNavObjectIndex then
    begin
      IsCurrObj := True;
    end
    Else
      IsCurrObj := False;
    DrawNavObject(FNavObjects[i], IsCurrObj);
  end;
end;

procedure TShapeMap.setLayer(Index: Integer; Value: TLayer);
begin
  // “олько разрешенные допустимые индексные значени€
  if (Index >= 0) and (Index <= Length(FLayers) - 1)
  then
  begin
    // —охранений нового значени€
    FLayers[Index] := Value;
  end;
end;

procedure TShapeMap.SetMapCenter(X_c, Y_c: double);
begin
  FX_c := X_c;
  FY_c := Y_c;
end;

procedure TShapeMap.setNavObject(Index: Integer; Value: TNavObject);
begin
  // “олько разрешенные допустимые индексные значени€
  if (Index >= 0) and (Index <= Length(FNavObjects) - 1)
  then
  begin
    // —охранений нового значени€
    FNavObjects[Index] := Value;
  end;
end;

procedure TShapeMap.setScale(s: double);
begin
  FScale := s * 1000;
end;



{ TNavObject }

procedure TNavObject.addTrackPoint(TrackPoint: TMyPoint);
begin
  SetLength(FTrackPoints, length(FTrackPoints) + 1);
  FTrackPoints[length(FTrackPoints) - 1] := TrackPoint;
end;

constructor TNavObject.Create(ID: integer; name: string; X: Double; Y: Double;
        Color: TColor = clBlue; Visible: Boolean = True);
begin        
  FID := ID;
  Fname := Name;
  FX := X;
  FY := Y;
  FVisible := Visible;
  FColor := Color;
end;

function TNavObject.getColor: TColor;
begin
  Result := FColor;
end;

function TNavObject.getTrackPoint(Index: Integer): TMyPoint;
begin
  if((Index >= 0) and (Index <= Length(FTrackPoints) - 1)) then
  begin
    Result := FTrackPoints[Index];
  end;
end;

function TNavObject.getVisible: Boolean;
begin
  Result := FVisible;
end;

function TNavObject.GetX: Double;
begin
 Result := FX;
end;

function TNavObject.GetY: Double;
begin
  Result := FY;
end;

procedure TNavObject.setColor(Clr: TColor);
begin
  FColor := Clr;
end;

procedure TNavObject.setTrackPoint(Index: Integer; Value: TMyPoint);
begin
  // “олько разрешенные допустимые индексные значени€
  if (Index >= 0) and (Index <= Length(FTrackPoints) - 1)
  then
  begin
    // —охранений нового значени€
    FTrackPoints[Index] := Value;
  end;
end;

procedure TNavObject.setVisible(Vis: Boolean);
begin
  FVisible := Vis;
end;

procedure TNavObject.SetX(X: Double);
begin
  FX := X;
end;

procedure TNavObject.SetY(Y: Double);
begin  
  FY := Y;
end;

end.
