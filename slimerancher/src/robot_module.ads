with Ada.Calendar; use Ada.Calendar;
with common_module; use common_module;
with warehouse; use warehouse;

package robot_module is

  Obecne_Id : Integer := 0;
  Czas_Startu : Time := Clock;

  function Zwroc_i_zwieksz_id return Integer;
  function Log_Czas return String;
  function Id_text(Id : Integer) return String;

  task type Robot_Type is

    entry Transportuj(
      Storage : Warehouse_acc;
      Towar : Product_Type;
      Ilosc : Integer
    );
    entry Zakoncz;

  end Robot_Type;

  type Robot_Array is array (Integer range <>) of Robot_Type;
end robot_module;
