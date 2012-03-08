////////////////////////////////////////////////////////////////////////////////
//             ����� �����-����� ������� ��� � ������ ���                     //
//                        RK_Method ������ 1.00                               //
//                                                                            //
//                        ����� - ������� �.�                                 //
//                                                                            //
//                           �������� 2005                                    //
////////////////////////////////////////////////////////////////////////////////

unit RK_Method;

interface


type
        TVarsArray = array of Extended; // ������ ���������� ������� �����������
        TInitArray = array of Extended; // ������ ��������� ��������
        TFun = function(VarsArray: TVarsArray; CurrVar: Integer):Extended of object;
        // ������ �������
        TResArray = array of array of Extended; // ������� �����������
        TCoefsArray = array of Extended; // ������ ������������ ������

function Runge_Kutt(  // ����� �����-�����
        Fun: TFun; // �������
        Num: Integer; // ����� ���������
        First: Extended; // ��������� ����� �� ����������� ����������
        Last: Extended; // �������� ����� �� ����������� ����������
        Steps: Integer; // ����� ����� �� ����������� ����������
        InitArray: TInitArray; // ������ ��������� ��������
        var Res: TResArray // ������� ����������� ������� �������. ����������
         ):Word; // ������������ �������� - ��� ������

implementation

Function Runge_Kutt(  // ����� �����-�����
        Fun: TFun; // ������ �������
        Num: Integer; // ����� ���������
        First: Extended; // ��������� ����� �� ����������� ����������
        Last: Extended; // �������� ����� �� ����������� ����������
        Steps: Integer; // ����� ����� �� ����������� ����������
        InitArray: TInitArray; // ������ ��������� ��������
        var Res: TResArray // ������� ����������� ������� �������. ����������
         ):Word; // ������������ �������� - ��� ������
var
        NumInit: Word; // ����� ��������� �������
        Delt: Extended; // ��� ���������
        Vars: TVarsArray; // ������ ���������� ������� �����������
        Vars2,Vars3,Vars4: TVarsArray; // �������� �����. ��� 2-4 ����.
        Coefs1: TCoefsArray; // ������ 1-�x ������������� � ������
        Coefs2: TCoefsArray; // ������ 2 ������������� � ������
        Coefs3: TCoefsArray; // ������ 3 ������������� � ������
        Coefs4: TCoefsArray; // ������ 4 ������������� � ������
        I: Integer; // ������� ����� �� ����������
        J: Word; // ������ ����.-��� ������
        K: Integer; // ������� ������ ������
begin
 NumInit:=Length(InitArray); // ������ ����� ��������� �������
 If NumInit<>Num then
   begin
     Result:=100; // ��� ������ 100: ����� ��������� �� ����� ����� ���. ���.
     Exit;
   end;
 Delt:=(Last-First)/Steps; // ������� �������� ���� ���������
 SetLength(Res,Num+1,Steps+1); // ������ ������ ������� ������� � �����. �����.
 SetLength(Vars,Num+1); // ����� ���������� ������� �����������
 SetLength(Vars2,Num+1); // ����� ���������� ��� 2-�� ����. ������� �����������
 SetLength(Vars3,Num+1); // ����� ���������� ��� 3-�� ����. ������� �����������
 SetLength(Vars4,Num+1); // ����� ���������� ��� 4-�� ����. ������� �����������
 SetLength(Coefs1,Num); // ����� 1-�x ����. ������ �� ����� ���������
 SetLength(Coefs2,Num); // ����� 2-�x ����. ������ �� ����� ���������
 SetLength(Coefs3,Num); // ����� 3-�x ����. ������ �� ����� ���������
 SetLength(Coefs4,Num); // ����� 4-�x ����. ������ �� ����� ���������
 // ��������� �������� ����������:
 Vars[0]:=First;
 For K:=0 to NumInit-1 do Vars[K+1]:=InitArray[K];
 For J:=0 to Num do Res[J,0]:=Vars[J]; // ������ ����� ���������� 
 For I:=0 to Steps-1 do // ������ ����� ���������
        begin
           For J:=0 to Num-1 do Coefs1[J]:=Fun(Vars, J)*delt; // 1-� �����.
           // ������� �������� ���������� ��� ������� ����.
           Vars2[0]:=Vars[0]+delt/2;
           For K:=1 to Num do Vars2[K]:=Vars[K]+Coefs1[K-1]/2;
           For J:=0 to Num-1 do Coefs2[J]:=Fun(Vars2, J)*delt; // 2-� ����.
           // ������� �������� ���������� ��� ������� ����.
           Vars3[0]:=Vars[0]+delt/2;
           For K:=1 to Num do Vars3[K]:=Vars[K]+Coefs2[K-1]/2;
           For J:=0 to Num-1 do Coefs3[J]:=Fun(Vars3, J)*delt; // 3 �����.
           // ������� �������� ���������� ��� 4 ����.
           Vars4[0]:=Vars[0]+delt;
           For K:=1 to Num do Vars4[K]:=Vars[K]+Coefs3[K-1];
           For J:=0 to Num-1 do Coefs4[J]:=Fun(Vars4, J)*delt; // 4 �����.
           // ������� ����� �������� ���������� ������� �����������
           Vars[0]:=Vars[0]+delt;
           For K:=1 to Num do
           Vars[K]:=Vars[K]+
           (1/6)*(Coefs1[K-1]+2*(Coefs2[K-1]+Coefs3[K-1])+Coefs4[K-1]);
           // ���������  ���������:
           For J:=0 to Num do Res[J,I+1]:=Vars[J];
        end; // ����� ��������
 Result:=0; // ��� ������ 0 - ��� ������
end;


end.
