with Ada.Calendar; use Ada.Calendar;
with common_module; use common_module;
with warehouse; use warehouse;

package robot_module is

  type Robot_State is (Error, Working, Waiting);

  type Robot_Status_Report is record
    Error   : Natural := 0;
    Working : Natural := 0;
    Waiting : Natural := 0;
  end record;

  Czas_Startu : Time := Clock;
  function Log_Czas return String;
  function Id_text (Id : Integer) return String;
  function Get_Robot_Status return Robot_Status_Report;

  task type Robot_Type(Id : Integer) is

    entry Transportuj(
      Storage : Warehouse_acc;
      Towar : Product_Type;
      Ilosc : Integer
    );
    entry Zakoncz;

  end Robot_Type;
end robot_module;
