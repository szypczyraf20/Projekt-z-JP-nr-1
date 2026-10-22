with Ada.Numerics.Discrete_Random;
with Ada.Calendar; use Ada.Calendar;

package common_module is
    type Product_Type is (Pink_Plort, Blue_Plort, Boom_Plort, Gold_Plort);

    subtype Zakres_1_100 is Integer range 1 .. 100;
    package Losowanie_1_100 is
        new Ada.Numerics.Discrete_Random(Zakres_1_100);
    Gen_1_100 : Losowanie_1_100.Generator;

    n_robotow : Integer := 5;

    Czas_Startu : Time := Clock;
    function Log_Czas return String;
    function Obecny_czas return Duration;
end common_module;
