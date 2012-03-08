unit uGrossberg;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,
  Math,
  RK_Method;

Type

  TNeuron = class(TCollectionItem)
  private
    FX: Double;
    FY: Double;
    FActivity: Double;
    function GetX: Double;
    procedure SetX(X: Double);
    function GetY: Double;
    procedure SetY(Y: Double);
    function GetActivity: Double;
    procedure SetActivity(Activity: Double);
  public
    constructor Create(X: Double; Y: Double; Activity: Double);
    property X: Double read GetX write SetX;
    property Y: Double read GetY write SetY;
    property Activity: Double read GetActivity write SetActivity;
  end;

  TNeuronCollection = class(TCollection)
  private                  
    FVisibilityGraph: array of array of Integer; //заполняется 0-ми при добавлении нейрона
    FStartIndex: Integer;
    FFinishIndex: Integer;
    function GetItem(Index: Integer): TNeuron;
    procedure SetItem(Index: Integer; const Value: TNeuron);  
    procedure SetVisibility(i, j, Value: Integer);
    function GetVisibility(i, j: Integer): Integer;
  public
    function Add: TNeuron; 
    function GetDistance(const i,j: Integer): Extended;
    property Items[Index: Integer]: TNeuron read GetItem write SetItem; default;
    property StartIndex: Integer read FStartIndex write FStartIndex default -1;
    property FinishIndex: Integer read FFinishIndex write FFinishIndex default -1;
    property VisibilityGraph[i, j: Integer]: Integer read GetVisibility write SetVisibility;
  end;

  TGrNetwork = class
  private
    FA: Double;
    FB: Double;
    FMu: Double;
    FAlfa: Double;
    FNeurons: TNeuronCollection;
    procedure SetNeurons(const Value: TNeuronCollection);
    function Equation(Vars: TVarsArray; CurrVar: Integer): Extended;
  public
    constructor Create(A,B, Mu, Alfa: Double);
    destructor Destroy; override;
    property A: Double read FA write FA;
    property B: Double read FB write FB;
    property Mu: Double read FMu write FMu;
    property Alfa: Double read FAlfa write FAlfa;
    property Neurons: TNeuronCollection read FNeurons write SetNeurons;
    procedure CalcActivity;
  end;

implementation

{ TNeuron }

constructor TNeuron.Create(X, Y, Activity: Double);
begin           
  FX := X;
  FY := Y;   
  FActivity := Activity;
end;

function TNeuron.GetActivity: Double;
begin  
  Result := FActivity;
end;

function TNeuron.GetX: Double;
begin
  Result := FX;
end;

function TNeuron.GetY: Double;
begin  
  Result := FY;
end;

procedure TNeuron.SetActivity(Activity: Double);
begin  
  FActivity := Activity;
end;

procedure TNeuron.SetX(X: Double);
begin    
  FX := X;
end;

procedure TNeuron.SetY(Y: Double);
begin
  FY := Y;
end;

{ TNeuronCollection }

function TNeuronCollection.Add: TNeuron;
var
  NewLength, i, j: Integer;
begin          
  Result := TNeuron(inherited Add);
  NewLength := Length(FVisibilityGraph) + 1;
  SetLength(FVisibilityGraph, NewLength);
  for i := 0 to Length(FVisibilityGraph) - 1 do
    SetLength(FVisibilityGraph[i], NewLength);

  for i := 0 to Length(FVisibilityGraph) - 1 do  
    for j := 0 to Length(FVisibilityGraph[i]) - 1 do
      FVisibilityGraph[i,j] := 0;
end;

function TNeuronCollection.GetDistance(const i, j: Integer): Extended;
begin
  Result := Sqrt(Sqr(Items[i].X - Items[j].X) + Sqr(Items[i].Y - Items[j].Y));
end;

function TNeuronCollection.GetItem(Index: Integer): TNeuron;
begin     
  Result := TNeuron(inherited GetItem(Index));
end;

function TNeuronCollection.GetVisibility(i, j: Integer): Integer;
begin
  if (i >= 0) and (i <= Length(FVisibilityGraph) - 1) then
    if (j >= 0) and (j <= Length(FVisibilityGraph[i]) - 1) then
    begin
      Result := FVisibilityGraph[i, j];
    end;
end;

procedure TNeuronCollection.SetItem(Index: Integer; const Value: TNeuron);
begin
  inherited SetItem(Index, Value);
end;

procedure TNeuronCollection.SetVisibility(i, j, Value: Integer);
begin
  if (i >= 0) and (i <= Length(FVisibilityGraph) - 1) then
    if (j >= 0) and (j <= Length(FVisibilityGraph[i]) - 1) then
    begin
      FVisibilityGraph[i, j] := Value;  
      FVisibilityGraph[j, i] := Value;
    end;
end;

{ TGrNetwork }

procedure TGrNetwork.CalcActivity;
var
  i: Integer;
  Fun: TFun;
  Ins: TInitArray;    
  Outs: TResArray;
begin
  Fun := Equation;
  for i := 0 to FNeurons.Count - 1 do
  begin
    SetLength(Ins, Length(Ins) + 1);
    Ins[i] := FNeurons[i].Activity;
  end;
  Runge_Kutt(Fun,FNeurons.Count,1,10,1000,Ins,Outs);
end;

constructor TGrNetwork.Create(A,B, Mu, Alfa: Double);
begin
  FA := A;
  FB := B;
  FMu := Mu;
  FAlfa := Alfa;
  FNeurons := TNeuronCollection.Create(TNeuron);
end;

destructor TGrNetwork.Destroy;
begin
  FNeurons.Free;
  inherited;
end;

function TGrNetwork.Equation(Vars: TVarsArray; CurrVar: Integer): Extended;

  function E(i: Integer): Extended;
  var
    E1, E2, Dist: Extended;
  begin
    Dist := FNeurons.GetDistance(i, FNeurons.FinishIndex);
    if Dist > (Alfa/100) then    
      E1 := Alfa / Dist
    //исправить на расстояние до перпендикуляра к отрезку старт-финиш!!!!
    else
      E1 := 100;

    if i = FNeurons.FinishIndex then
    begin
      E2 := 100;
    end
    else
    begin
      E2 := 0;
    end;
    Result := E1 + E2;
  end;

var
  SumNeibs: Extended;
  i: Integer;
begin
  SumNeibs := 0;
  for i := 0 to Length(Vars) - 2 do
  begin
    if i <> CurrVar then    
      SumNeibs := SumNeibs + Vars[i+1]*(Mu / FNeurons.GetDistance(CurrVar, i))*FNeurons.VisibilityGraph[CurrVar, i];
  end;
    
  Result:= -A * Vars[CurrVar+1] + (B - Vars[CurrVar+1]) * (E(CurrVar) + SumNeibs)
end;

procedure TGrNetwork.SetNeurons(const Value: TNeuronCollection);
begin
  FNeurons.Assign(Value);
end;

end.
