with magazyn_module; use magazyn_module;
with Ada.Calendar; use Ada.Calendar;
package robot_module is

  Czas_Startu : Time := Clock;
  function Log_Czas return String;

  task type Robot_Type(Id : Integer) is

    entry Transportuj(
      Towar : String;
      Ilosc : Integer
    );
    entry Zakoncz;

  end Robot_Type;
end robot_module;
