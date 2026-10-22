with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Calendar; 
use Ada.Calendar;
with common_module; use common_module;
with robot_module; use robot_module;
with warehouse; use warehouse;

package Dostawa is

    Type Paczka_plortow is record
        Id : Integer;
        Towar : Product_Type;
        Ilosc : Integer;
    end record;


    Czas_Startu : Time := Clock;

    --  r : Robot_Array(1 .. n_robotow);
    Storage : Warehouse_acc := new Warehouse_Storage;

    --  procedure Zinicjalizuj_Roboty(n : Integer);
    procedure Zakoncz_Roboty;

    function Log_Czas return String;

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
