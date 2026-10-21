with Ada.Numerics.Discrete_Random;

package common_module is
   type Product_Type is (Pink_Plort, Blue_Plort, Boom_Plort, Gold_Plort);

    subtype Zakres_1_100 is Integer range 1 .. 100;
    package Losowanie_1_100 is
        new Ada.Numerics.Discrete_Random(Zakres_1_100);
    Gen_1_100 : Losowanie_1_100.Generator;
end common_module;
