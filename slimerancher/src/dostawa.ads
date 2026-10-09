with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Calendar; 
use Ada.Calendar;

package Dostawa is

    Type Paczka_plortow is record
        Id : Integer;
        Towar : String (1 .. 11);
        Ilosc : Integer;
    end record;


    Czas_Startu : Time := Clock;
    function Log_Czas return String;

    subtype Zakres is Integer range 1 .. 5;
    package Losowanie is
        new Ada.Numerics.Discrete_Random(Zakres);
    Gen : Losowanie.Generator;
    X : Zakres;

    task type Ogarniacz_Plortow is
        entry Zarejestruj (Id : Integer; Towar : String; Ilosc : Integer);
    end Ogarniacz_Plortow;

    task Stanowisko_odbiorow is
        entry rozladuj (ID : Integer; Towar : String; Ilosc : Integer);
    end Stanowisko_odbiorow;



end Dostawa;