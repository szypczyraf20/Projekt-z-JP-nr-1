with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with warehouse; use warehouse;
with common_module; use common_module;

package body robot_module is
  function Log_Czas return String is
      Aktualny_Czas : Time := Clock;
      Roznica       : Duration := Aktualny_Czas - Czas_Startu;
  begin
      return "[" & Trim(Duration'Image(Roznica), Ada.Strings.Left) & "] ";
  end Log_Czas;

  task body Robot_Type is

    Koniec : Boolean := False;
    TranTowar : Product_Type;
    TranIlosc : Integer := 5;
    Storage : Warehouse_Storage;

  begin
    while not Koniec loop
      select

      --W tym poleceniu robot musi otrzymać magazyn do którego ma przekazać plorty jako
      --parametr.
        accept Transportuj(
          Towar : Product_Type;
          Ilosc : Integer
        ) do

          Put_Line(
            Log_Czas &
            "<R" & Trim(Integer'Image(Id), Ada.Strings.Left) &
            "> otrzymałem transport"
          );

          TranTowar := Towar;
          TranIlosc := Ilosc;

        end Transportuj;

        Put_Line(
          Log_Czas &
          "<R" & Trim(Integer'Image(Id), Ada.Strings.Left) &
          "> jadę"
        );

        delay 2.0;

        Receive_Product(Storage, TranTowar, TranIlosc);

      or
        accept Zakoncz;
        Koniec := True;

      end select;

    end loop;

  end Robot_Type;
end robot_module;
