unit fLayers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Dialogs, ExtCtrls, CheckLst;

type
  TfrmLayers = class(TForm)  
    OpenDialog: TOpenDialog;
    btnAddLayer: TButton;  
    chlbLayers: TCheckListBox;
    pnlLayers: TPanel;
    colbLayerColor: TColorBox;
    btnOk: TButton;
    procedure btnAddLayerClick(Sender: TObject);
    procedure chlbLayersClickCheck(Sender: TObject);
    procedure chlbLayersClick(Sender: TObject);
    procedure colbLayerColorEnter(Sender: TObject);
    procedure colbLayerColorChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLayers: TfrmLayers;

implementation

uses fMain, uDrawingClasses;

{$R *.dfm}

procedure TfrmLayers.chlbLayersClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := (sender as TCheckListBox).ItemIndex;
  if Index >= 0 then
  begin
    colbLayerColor.Enabled := True;
    colbLayerColor.Selected := LayerLoader.Layers[Index].Color;
  end;
end;

procedure TfrmLayers.chlbLayersClickCheck(Sender: TObject);
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

procedure TfrmLayers.colbLayerColorChange(Sender: TObject);
begin
  if chlbLayers.ItemIndex >= 0 then
  begin
    LayerLoader.Layers[chlbLayers.ItemIndex].Color := colbLayerColor.Selected;
    LayerLoader.Redraw;
  end;
end;

procedure TfrmLayers.colbLayerColorEnter(Sender: TObject);
begin
  if chlbLayers.ItemIndex < 0 then
  begin
    colbLayerColor.Enabled := False;
  end;
end;

procedure TfrmLayers.btnAddLayerClick(Sender: TObject);
var
  Layer: TLayer;
begin
if(OpenDialog.Execute()) then
  begin
    Layer := TLayer.Create(OpenDialog.FileName, frmMain.RandomColor);
    LayerLoader.addLayer(Layer);
    chlbLayers.Items.Add(Layer.Name);
    chlbLayers.Checked[LayerLoader.LayerCount - 1] := Layer.Visible;
    if not frmMain.cbFollowCurrNavObject.Checked then
      LayerLoader.SetMapCenter(Layer.MinX + (Layer.MaxX - Layer.MinX) / 2,
        Layer.MinY + (Layer.MaxY - Layer.MinY) / 2);
    LayerLoader.Redraw;
  end;
end;

end.
