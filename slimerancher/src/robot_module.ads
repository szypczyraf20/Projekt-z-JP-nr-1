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
  type Status_Counts is array (Status_Type) of Natural;
  type Robot_Status_Array is array (1 .. n_robotow) of Status_Type;
  type Robot_Active_Array is array (1 .. n_robotow) of Boolean;

  protected Robot_Status_Tracker is
    procedure Ustaw_Status (Id : Integer; Stan : Status_Type);
    procedure Ustaw_Aktywnosc (Id : Integer; Czy_Pracuje : Boolean);
    function Pobierz_Status (Id : Integer) return Status_Type;
    function Pobierz_Aktywnosc (Id : Integer) return Boolean;
    function Return_Counts return Status_Counts;
  private
    Statusy : Robot_Status_Array := (others => Dziala);
    Aktywne : Robot_Active_Array := (others => False);
  end Robot_Status_Tracker;

  function Get_Robot_Status return Status_Counts;

  task type Robot_Type is

    entry Transportuj(
      Storage : Warehouse_acc;
      Towar : Product_Type;
      Ilosc : Integer;
      Id_dostawy : Integer
    );
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
