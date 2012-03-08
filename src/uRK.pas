////////////////////////////////////////////////////////////////////////////////
//      Runge-Kutt Method of solving of dif. equations and their systems      //
//                           RK_Method v.3.00 beta2                           //
//                                                                            //
//                          (for Delphi and Lazarus)                          //
//                                                                            //
//                         Author - Andrey G. Sadovoy                         //
//                                                                            //
//                                 sep. 2011                                  //
//                                                                            //
// freeware, open source, 'as is'                                             //
//                                                                            //
// sadovoya@mtu-net.ru                                                        //
// sadovoya.narod.ru (russian)                                                //
// sintreseng.narod.ru (english)                                              //
////////////////////////////////////////////////////////////////////////////////

unit uRK;

interface

type
  TFloat = Double; //you can change to Extended, for example..
  TFloatVector = array of TFloat;
  TFloatMatrix = array of array of TFloat;
  TSystem = procedure (var t: TFloat; var X: TFloatVector;
                       var RP: TFloatVector) of object;
  //t -- independent variable.
  //X, RP -- arrays indexed from 0 for dependent vars. and Right Parts.

function rk4fixed(
// Runge-Kutt method.

  Syst: TSystem;
  // describes system

  const InitConds: TFloatVector;
  // Array of initial conditions (indexed from 0)

  First: TFloat;       // begining point by independent axis
  Last : TFloat;       // end point of independent axis

  var tPoints: TFloatVector;
  // Array of points by independent axis at which dependent vars.
  // are calculated  (point's index 0 - for initial point, 1 - after first
  // step, etc.)

  var XPoints: TFloatMatrix;
  // 2-dim. array (matrix) of results for dependent vars.
  // The first matrix dimention corresponds to variable
  // (index 0 – first dependent var., 1 - second dependent var., etc.).
  // The second matrix dimention corresponds to calculation point
  // (index 0 – first point, etc.).

  StepsFact: Cardinal = 1 // factor for steps inside function

                   ):Word; // output - error code



implementation


//==============================================================================


function rk4fixed(
  Syst: TSystem;
  const InitConds: TFloatVector;
  First: TFloat;
  Last : TFloat;
  var tPoints: TFloatVector;
  var XPoints: TFloatMatrix;
  StepsFact: Cardinal = 1
                  ):Word;
var
  delt, halfDelt, t: TFloat;
  VarX, tmpX: TFloatVector;
  C: array [1..4] of TFloatVector;
  I, Points, Steps, I_out: Cardinal;
  J, Num, NumSubOne: Word;
begin

Result:= 5000; //Error Code 5000: Unknown error

Num := Length(InitConds);  // Get amount of equations
NumSubOne := Num - 1;

Points:= Length(tPoints); // Get number of output t points

If (Num = 0) or (Points <= 1) or (StepsFact = 0) then
begin
   Result:=1000;
   // Error Code 1000: Bad data
   Exit;
end;

If Last < First then
begin
   Result:=2000;
   // Error Code 2000: Last point Must be not less Fist point
   Exit;
end;

Steps:= (Points-1)*StepsFact;

delt:=(Last-First)/Steps; // Get length of step
halfDelt:= 0.5*delt;

try
   SetLength(VarX, Num);
   SetLength(tmpX, Num);
   for J := 1 to 4 do SetLength(C[J], Num);
except
   Result:=3000;
   //Error Code 3000: Can't allocate memory.
   Exit;
end;

try
 // Initial values of vars and first point of Results:
 tPoints[0] := First;
 For J:=0 to NumSubOne do
 begin
  XPoints[J,0] := InitConds[J];
  VarX[J] := InitConds[J];
 end;

 For I:= 1 to Steps do
 begin // itterations begin
   t := First+(I-1)*delt; // better then delt+delt+... but littly slowly
   Syst(t,VarX,C[1]);
   For J:=0 to NumSubOne do tmpX[J]:= VarX[J] + C[1][J]*halfDelt;
   t := t + halfDelt;
   Syst(t,tmpX,C[2]);
   For J:=0 to NumSubOne do tmpX[J]:= VarX[J] + C[2][J]*halfDelt;
   Syst(t,tmpX,C[3]);
   For J:=0 to NumSubOne do tmpX[J]:= VarX[J] + C[3][J]*delt;
   t := t + halfDelt;
   Syst(t,tmpX,C[4]);
   For J:=0 to NumSubOne do
     VarX[J]:= VarX[J] + delt*(C[1][J]+2.0*(C[2][J]+C[3][J])+C[4][J])/6.0;
   if I mod StepsFact = 0 then
   begin
      I_out:= I div StepsFact;
      For J:=0 to NumSubOne do XPoints[J,I_out]:= VarX[J];
      tPoints[I_out]:=t;
   end;
 end; // Itterations end

 Result:=0; // Error Code 0: No errors found.

except
 Result:=4000; //Error Code 4000: Method fail.
end;

//Free Memory
for J := 1 to 4 do C[J]:=Nil;
VarX:= Nil;
tmpX:= Nil;


end;


//==============================================================================


end.
