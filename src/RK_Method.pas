////////////////////////////////////////////////////////////////////////////////
//             Метод Рунге-Кутта решения ОДУ и систем ОДУ                     //
//                        RK_Method версия 1.00                               //
//                                                                            //
//                        Автор - Садовой А.Г                                 //
//                                                                            //
//                           сентябрь 2005                                    //
////////////////////////////////////////////////////////////////////////////////

unit RK_Method;

interface


type
        TVarsArray = array of Extended; // вектор переменных включая независимую
        TInitArray = array of Extended; // вектор начальных значений
        TFun = function(VarsArray: TVarsArray; CurrVar: Integer):Extended of object;
        // вектор функций
        TResArray = array of array of Extended; // матрица результатов
        TCoefsArray = array of Extended; // вектор коэффициетов метода

function Runge_Kutt(  // метод Рунге-Кутта
        Fun: TFun; // функция
        Num: Integer; // число уравнений
        First: Extended; // начальная точка по независимой координате
        Last: Extended; // конечная точка по независимой координате
        Steps: Integer; // число шагов по независимой координате
        InitArray: TInitArray; // вектор начальных значений
        var Res: TResArray // матрица результатов включая независ. переменную
         ):Word; // возвращаемое значение - код ошибки

implementation

Function Runge_Kutt(  // метод Рунге-Кутта
        Fun: TFun; // массив функций
        Num: Integer; // число уравнений
        First: Extended; // начальная точка по независимой координате
        Last: Extended; // конечная точка по независимой координате
        Steps: Integer; // число шагов по независимой координате
        InitArray: TInitArray; // вектор начальных значений
        var Res: TResArray // матрица результатов включая независ. переменную
         ):Word; // возвращаемое значение - код ошибки
var
        NumInit: Word; // число начальных условий
        Delt: Extended; // шаг разбиения
        Vars: TVarsArray; // вектор переменных включая независимую
        Vars2,Vars3,Vars4: TVarsArray; // значения перем. для 2-4 коэф.
        Coefs1: TCoefsArray; // вектор 1-ыx коэффициентов в методе
        Coefs2: TCoefsArray; // вектор 2 коэффициентов в методе
        Coefs3: TCoefsArray; // вектор 3 коэффициентов в методе
        Coefs4: TCoefsArray; // вектор 4 коэффициентов в методе
        I: Integer; // счетчик цикла по иттерациям
        J: Word; // индекс коэф.-тов метода
        K: Integer; // счетчик прочих циклов
begin
 NumInit:=Length(InitArray); // узнаем число начальных условий
 If NumInit<>Num then
   begin
     Result:=100; // код ошибки 100: число уравнений не равно числу нач. усл.
     Exit;
   end;
 Delt:=(Last-First)/Steps; // находим величину шага разбиений
 SetLength(Res,Num+1,Steps+1); // задаем размер матрицы ответов с незав. перем.
 SetLength(Vars,Num+1); // число переменных включая независимую
 SetLength(Vars2,Num+1); // число переменных для 2-го коэф. включая независимую
 SetLength(Vars3,Num+1); // число переменных для 3-го коэф. включая независимую
 SetLength(Vars4,Num+1); // число переменных для 4-го коэф. включая независимую
 SetLength(Coefs1,Num); // число 1-ыx коэф. метода по числу уравнений
 SetLength(Coefs2,Num); // число 2-ыx коэф. метода по числу уравнений
 SetLength(Coefs3,Num); // число 3-иx коэф. метода по числу уравнений
 SetLength(Coefs4,Num); // число 4-ыx коэф. метода по числу уравнений
 // Начальные значения переменных:
 Vars[0]:=First;
 For K:=0 to NumInit-1 do Vars[K+1]:=InitArray[K];
 For J:=0 to Num do Res[J,0]:=Vars[J]; // первая точка результата 
 For I:=0 to Steps-1 do // начало цикла иттераций
        begin
           For J:=0 to Num-1 do Coefs1[J]:=Fun(Vars, J)*delt; // 1-й коэфф.
           // Находим значения переменных для второго коэф.
           Vars2[0]:=Vars[0]+delt/2;
           For K:=1 to Num do Vars2[K]:=Vars[K]+Coefs1[K-1]/2;
           For J:=0 to Num-1 do Coefs2[J]:=Fun(Vars2, J)*delt; // 2-й коэф.
           // Находим значения переменных для третьго коэф.
           Vars3[0]:=Vars[0]+delt/2;
           For K:=1 to Num do Vars3[K]:=Vars[K]+Coefs2[K-1]/2;
           For J:=0 to Num-1 do Coefs3[J]:=Fun(Vars3, J)*delt; // 3 коэфф.
           // Находим значения переменных для 4 коэф.
           Vars4[0]:=Vars[0]+delt;
           For K:=1 to Num do Vars4[K]:=Vars[K]+Coefs3[K-1];
           For J:=0 to Num-1 do Coefs4[J]:=Fun(Vars4, J)*delt; // 4 коэфф.
           // Находим новые значения переменных включая независимую
           Vars[0]:=Vars[0]+delt;
           For K:=1 to Num do
           Vars[K]:=Vars[K]+
           (1/6)*(Coefs1[K-1]+2*(Coefs2[K-1]+Coefs3[K-1])+Coefs4[K-1]);
           // Результат  иттерации:
           For J:=0 to Num do Res[J,I+1]:=Vars[J];
        end; // конец итераций
 Result:=0; // код ошибки 0 - нет ошибок
end;


end.
