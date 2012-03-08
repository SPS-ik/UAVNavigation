program MyGIS;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  shpAPI129 in 'shpAPI129.pas',
  uDrawingClasses in 'uDrawingClasses.pas',
  fDBMap in 'fDBMap.pas' {frmDBMaps},
  fLayers in 'fLayers.pas' {frmLayers},
  uGrossberg in 'uGrossberg.pas',
  uRK in 'uRK.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDBMaps, frmDBMaps);
  Application.CreateForm(TfrmLayers, frmLayers);
  Application.Run;
end.
