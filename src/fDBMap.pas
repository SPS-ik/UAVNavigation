unit fDBMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, DBCtrls;

type
  TfrmDBMaps = class(TForm)
    DBComboBox1: TDBComboBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    conNavigationDB: TADOConnection;
    DSrcMaps: TDataSource;
    tblMaps: TADOTable;
    tblMapsID: TIntegerField;
    tblMapsName: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDBMaps: TfrmDBMaps;

implementation

{$R *.dfm}

end.
