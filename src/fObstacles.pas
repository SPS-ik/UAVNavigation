unit fObstacles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridsEh, DBGridEh, StdCtrls;

type
  TfrmObstacles = class(TForm)
    grObstacles: TDBGridEh;
    btnOK: TButton;
    grObstaclePoints: TDBGridEh;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmObstacles: TfrmObstacles;

implementation

uses fMain;

{$R *.dfm}

procedure TfrmObstacles.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmObstacles.FormCreate(Sender: TObject);
begin
  frmMain.tblObstaclePoints.Close;
  frmMain.tblObstaclePoints.Open;
end;

end.
