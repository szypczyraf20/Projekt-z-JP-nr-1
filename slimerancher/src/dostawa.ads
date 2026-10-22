with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Calendar; 
use Ada.Calendar;
with common_module; use common_module;
with robot_module; use robot_module;
with warehouse; use warehouse;

package Dostawa is

    Total_Deliveries : Natural := 0;

    Type Paczka_plortow is record
        Id : Integer;
        Towar : Product_Type;
        Ilosc : Integer;
    end record;
    Storage : Warehouse_acc := new Warehouse_Storage;

    function Get_Total_Deliveries return Natural;

    subtype Zakres is Integer range 1 .. 5;
    package Losowanie is
        new Ada.Numerics.Discrete_Random(Zakres);
    Gen : Losowanie.Generator;
    X : Zakres;

    task type Ogarniacz_Plortow is
        entry Zarejestruj (Id : Integer; Towar : Product_Type; Ilosc : Integer);
    end Ogarniacz_Plortow;

    task type Stanowisko_odbiorow is
        entry rozladuj (ID : Integer; Towar : Product_Type; Ilosc : Integer);
    end Stanowisko_odbiorow;



end Dostawa;
