with Ada.Calendar; use Ada.Calendar;
with common_module; use common_module;
with warehouse; use warehouse;

package robot_module is

  Czas_Startu : Time := Clock;
  function Log_Czas return String;

  task type Robot_Type(Id : Integer) is

    entry Transportuj(
      Towar : Product_Type;
      Ilosc : Integer
    );
    entry Zakoncz;

  end Robot_Type;
end robot_module;
