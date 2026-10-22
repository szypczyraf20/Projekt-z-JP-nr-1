with Ada.Calendar; use Ada.Calendar;
with common_module; use common_module;
with warehouse; use warehouse;

package robot_module is

  Obecne_Id : Integer := 0;
  Czas_Startu : Time := Clock;
  Szansa_Eksplozji : Integer := 100;

  function Zwroc_i_zwieksz_id return Integer;
  function Id_text(Id : Integer) return String;
  function random return Zakres_1_100;
  function Czy_Wybuchnie return Boolean;

  procedure Jade_z(Id : Integer; TranId_dostawy : Integer; czy_czesc : Boolean);
  procedure Dostarczono(Id : Integer; TranId_dostawy : Integer; czy_czesc : Boolean);
  procedure Zakoncz_Roboty;

  type Status_Type is (Dziala, Zepsuty, W_naprawie);

  task type Robot_Type is

    entry Transportuj(
      Storage : Warehouse_acc;
      Towar : Product_Type;
      Ilosc : Integer;
      Id_dostawy : Integer
    );
    entry Czy_Zepsuty(czy_zepsuty : out Boolean);
    entry Zwroc_Id(I : out Integer);
    entry Zwroc_Status(S : out Status_Type);
    entry Do_Naprawy;
    entry Uruchom_Ponownie;
    entry Zakoncz;

  end Robot_Type;

  type Robot_Array is array (Integer range <>) of Robot_Type;
  subtype Robot_Array_N is Robot_Array(1 .. n_robotow);

  r : Robot_Array(1 .. n_robotow);

  task type Serwis_Naprawczy_Type is
    entry Napraw(robot : Robot_Type);
  end Serwis_Naprawczy_Type;

  Serwis : Serwis_Naprawczy_Type;
end robot_module;
