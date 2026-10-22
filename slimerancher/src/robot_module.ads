with Ada.Calendar; use Ada.Calendar;
with common_module; use common_module;
with warehouse; use warehouse;

package robot_module is

  Obecne_Id : Integer := 0;
  Czas_Startu : Time := Clock;
  Szansa_Eksplozji : Integer := 25;

  function Zwroc_i_zwieksz_id return Integer;
  function Id_text(Id : Integer) return String;
  function random return Zakres_1_100;
  function Czy_Wybuchnie return Boolean;

  procedure Zakoncz_Roboty;

  task type Robot_Type is

    entry Transportuj(
      Storage : Warehouse_acc;
      Towar : Product_Type;
      Ilosc : Integer;
      Id_dostawy : Integer
    );
    entry Uruchom_Ponownie;
    entry Zakoncz;

  end Robot_Type;

  type Robot_Array is array (Integer range <>) of Robot_Type;
  subtype Robot_Array_N is Robot_Array(1 .. n_robotow);

  r : Robot_Array(1 .. n_robotow);

  task type Serwis_Naprawczy_Type is
    entry Napraw(Id : Integer);
  end Serwis_Naprawczy_Type;

  Serwis : Serwis_Naprawczy_Type;
end robot_module;
