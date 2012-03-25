unit uGrossberg;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes,
  Math,
  uRK;

Type
  TIntArray = array of Integer;
  TNeuron = class(TCollectionItem)
  private
    FX: Double;
    FY: Double;
    FActivity: Double;
  public
    constructor Create(X: Double; Y: Double; Activity: Double);
    property X: Double read FX write FX;
    property Y: Double read FY write FY;
    property Activity: Double read FActivity write FActivity;
  end;

  TNeuronCollection = class(TCollection)
  private                  
    function GetItem(Index: Integer): TNeuron;
    procedure SetItem(Index: Integer; const Value: TNeuron);
  public
    function Add: TNeuron;
    property Items[Index: Integer]: TNeuron read GetItem write SetItem; default;
  end;

  TGrNetwork = class
  private
    FA: Double;
    FB: Double;
    FMu: Double;
    FAlfa: Double;
    FNeurons: TNeuronCollection;
    FFinishIndex: Integer;   
    FStartIndex: Integer;
    FVisibilityGraph: array of array of Integer; //заполн€етс€ 0-ми при добавлении нейрона
    procedure SetNeurons(const Value: TNeuronCollection);
    procedure CalcEquations(var t: TFloat; var X: TFloatVector; var RP: TFloatVector);   
    procedure SetVisibility(i, j, Value: Integer);
    function GetVisibility(i, j: Integer): Integer; 
    procedure CalcActivity;
  public
    constructor Create(A,B, Mu, Alfa: Double);
    destructor Destroy; override;
    property A: Double read FA write FA;
    property B: Double read FB write FB;
    property Mu: Double read FMu write FMu;
    property Alfa: Double read FAlfa write FAlfa;
    property Neurons: TNeuronCollection read FNeurons write SetNeurons;
    property VisibilityGraph[i, j: Integer]: Integer read GetVisibility write SetVisibility;
    procedure AddNeuron(X, Y, Activity: Double);                   
    procedure InitVisibilityGraph;
    function GetDistance(const i,j: Integer): Double;
    function GetOptimalPath(const StartIndex, FinishIndex: Integer;
      var Path: TIntArray): Integer;
  end;

implementation

{ TNeuron }

constructor TNeuron.Create(X, Y, Activity: Double);
begin           
  FX := X;
  FY := Y;   
  FActivity := Activity;
end;

{ TNeuronCollection }

function TNeuronCollection.Add: TNeuron;
begin          
  Result := TNeuron(inherited Add);
end;

function TNeuronCollection.GetItem(Index: Integer): TNeuron;
begin     
  Result := TNeuron(inherited GetItem(Index));
end;

procedure TNeuronCollection.SetItem(Index: Integer; const Value: TNeuron);
begin
  inherited SetItem(Index, Value);
end;

{ TGrNetwork }

procedure TGrNetwork.AddNeuron(X, Y, Activity: Double);
var
  Neuron: TNeuron;
begin
  Neuron := FNeurons.Add;
  Neuron.X := X;
  Neuron.Y := Y;
  Neuron.Activity := Activity;
end;

procedure TGrNetwork.CalcActivity;
var
  i: Integer;
  tOut, InitConds: TFloatVector;
  XOuts: TFloatMatrix;
  Points: Cardinal;
  First, Last: TFloat;
  StepsFact: Cardinal;
begin
  First := 0.0;
  Last  := 10.0;
  Points := 2; //points for output
  StepsFact := 10000; //all steps inside function = 10*StepsFact

  SetLength(InitConds, FNeurons.Count);
  for i := 0 to FNeurons.Count - 1 do
  begin
    InitConds[i] := FNeurons[i].Activity;
  end;
  SetLength(tOut, Points);
  SetLength(XOuts, FNeurons.Count, Points);

  if rk4fixed(CalcEquations, InitConds, First, Last, tOut, XOuts, StepsFact ) = 0 then
  begin
    for i := 0 to FNeurons.Count - 1 do
    begin
      FNeurons[i].Activity := XOuts[i, Points-1];
    end;
  end;
  XOuts := Nil; tOut := Nil; InitConds := Nil;
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

function TGrNetwork.GetDistance(const i, j: Integer): Double;
begin
  Result := Sqrt(Sqr(FNeurons[i].X - FNeurons[j].X) +
    Sqr(FNeurons[i].Y - FNeurons[j].Y));
end;


function TGrNetwork.GetOptimalPath(const StartIndex, FinishIndex: Integer;
  var Path: TIntArray): Integer;

  function GetClosest(Index: Integer): Integer;
  var
    i: Integer;
    TempActivity: Double;
  begin
    Result := -1;
    //ƒвигаемс€ только к цели
    //јктивность следующего нейрона не ниже чем у текущего
    TempActivity := FNeurons[Index].Activity;
    for i := 0 to Length(FVisibilityGraph) - 1 do
    begin
      if (FVisibilityGraph[Index, i] <> 0) and
        (FNeurons[i].Activity > TempActivity) then
      begin
        TempActivity := FNeurons[i].Activity;
        Result := i;
      end;
    end;
  end;

var
  CurrIndex: Integer;
begin
  if (FinishIndex >= 0) and (FinishIndex < FNeurons.Count) and
    (StartIndex >= 0) and (StartIndex < FNeurons.Count)then
  begin
    FFinishIndex := FinishIndex;
    FStartIndex := StartIndex;
    try
      CalcActivity;
      CurrIndex := StartIndex;
      while (CurrIndex <> FinishIndex) and (CurrIndex <> -1) do
      begin
        SetLength(Path, Length(Path)+1);
        Path[Length(Path)-1] := CurrIndex;
        CurrIndex := GetClosest(CurrIndex);
      end;      
      SetLength(Path, Length(Path)+1);
      Path[Length(Path)-1] := CurrIndex;
      Result:=1;
    except
      Result := 0;
    end;
  end;
end;

function TGrNetwork.GetVisibility(i, j: Integer): Integer;
begin
  if (i >= 0) and (i <= Length(FVisibilityGraph) - 1) and
   (j >= 0) and (j <= Length(FVisibilityGraph[i]) - 1) then
  begin
    Result := FVisibilityGraph[i, j];
  end
  else
    Result := 0;
end;

procedure TGrNetwork.InitVisibilityGraph;
var
  i, j: Integer;
begin
  SetLength(FVisibilityGraph, FNeurons.Count);
  for i := 0 to Length(FVisibilityGraph) - 1 do
    SetLength(FVisibilityGraph[i], FNeurons.Count);

  for i := 0 to Length(FVisibilityGraph) - 1 do
    for j := 0 to Length(FVisibilityGraph[i]) - 1 do
      FVisibilityGraph[i,j] := 0;
end;

procedure TGrNetwork.CalcEquations(var t: TFloat; var X: TFloatVector;
                var RP: TFloatVector);

  function E(i: Integer): Extended;
  var
    E1, E2, Dist: Extended;
  begin
    Dist := GetDistance(i, FFinishIndex);
    if Dist > (Alfa/100) then
      E1 := Alfa / Dist
    //исправить на рассто€ние до перпендикул€ра к отрезку старт-финиш!!!!
    else
      E1 := 100;

    if i = FFinishIndex then
    begin
      E2 := 100;
    end
    else
    begin
      E2 := 0;
    end;
    Result := E1 + E2;
  end;

  function SumNeibs(const CurrVar: Integer): Extended;
  var
    j: Integer;
    W, Distance: Double;
  begin
    for j := 0 to Length(X) - 1 do
    begin
      if (j <> CurrVar) and (VisibilityGraph[CurrVar, j] <> 0) then
      begin
        Distance := GetDistance(CurrVar, j);
        if Distance > 0 then
        begin
          W := Mu / Distance;
          Result := Result + W * X[j];
        end;
      end;
    end;
  end;

var
  i: Integer;
begin
  for i := 0 to Length(X) - 1 do
  begin
    // Right parts of dif. eq-s: dXi/dt = -AXi + (B-Xi)(E + SUMj(Wij*Xj))
    // i - current Neuron index, j - neib. neurons
    RP[i] := -A * X[i] + (B - X[i]) * (E(i) + SumNeibs(i))
  end;  
end;

procedure TGrNetwork.SetNeurons(const Value: TNeuronCollection);
begin
  FNeurons.Assign(Value);
end;

procedure TGrNetwork.SetVisibility(i, j, Value: Integer);
begin
  if (i >= 0) and (i <= Length(FVisibilityGraph) - 1) then
    if (j >= 0) and (j <= Length(FVisibilityGraph[i]) - 1) then
    begin  
      FVisibilityGraph[i, j] := Value;
      FVisibilityGraph[j, i] := Value;
    end;
end;

end.
