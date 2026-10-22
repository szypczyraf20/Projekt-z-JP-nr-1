with Ada.Numerics.Discrete_Random;
with Ada.Calendar; use Ada.Calendar;

package common_module is
    type Product_Type is (Pink_Plort, Water_Plort, Boom_Plort, Gold_Plort, Tabby_Plort, Rock_plort, Rad_Plort);

    subtype Zakres_1_100 is Integer range 1 .. 100;
    package Losowanie_1_100 is
        new Ada.Numerics.Discrete_Random(Zakres_1_100);
    Gen_1_100 : Losowanie_1_100.Generator;

    package Losowanie_plortow is
        new Ada.Numerics.Discrete_Random(Product_Type);
    Gen_plortow : Losowanie_plortow.generator;

    n_robotow : Integer := 5;

    n_dostaw : Integer := 15;

    subtype Zakres_10_100 is Integer range 10 .. 100;
    package Losowanie_10_100 is
        new Ada.Numerics.Discrete_Random(Zakres_10_100);
    Gen_10_100 : Losowanie_10_100.Generator;

    Czas_Startu : Time := Clock;
    function Log_Czas return String;
    function Obecny_czas return Duration;
    function Losowy_plort return Product_Type;
    
end common_module;
