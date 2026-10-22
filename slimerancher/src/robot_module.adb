with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with warehouse; use warehouse;
with common_module; use common_module;

package body robot_module is

  function Zwroc_i_zwieksz_id return Integer is
  begin
    Obecne_Id := Obecne_Id + 1;
    return Obecne_Id;
  end Zwroc_i_zwieksz_id;

  function Log_Czas return String is
      Aktualny_Czas : Time := Clock;
      Roznica       : Duration := Aktualny_Czas - Czas_Startu;
  begin
      return "[" & Trim(Duration'Image(Roznica), Ada.Strings.Left) & "] ";
  end Log_Czas;

  function Id_text(Id : Integer) return String is
  begin
      return Trim(Integer'Image(Id), Ada.Strings.Left);
  end Id_text;

  task body Robot_Type is

    Id : Integer := Zwroc_i_zwieksz_id;
    Koniec : Boolean := False;
    TranTowar : Product_Type;
    TranIlosc : Integer := 5;
    TranStorage : Warehouse_acc;
    TranId_dostawy : Integer;
  begin
    while not Koniec loop
      select

      --We have a serious fucking problem.
        accept Transportuj(
          Storage : Warehouse_acc;
          Towar : Product_Type;
          Ilosc : Integer;
          Id_dostawy : Integer
        ) do

          Put_Line(
            Log_Czas &
            "<R" & Id_text(Id) &
            "> otrzymałem transport " &
            "nr " & Id_text(Id_dostawy)
          );
          TranStorage := Storage;
          TranTowar := Towar;
          TranIlosc := Ilosc;
          TranId_dostawy :=Id_dostawy;

        end Transportuj;

        Put_Line(
          Log_Czas &
          "<R" & Id_text(Id) &
          "> jadę z dostawą " &
          "nr " & Id_text(TranId_dostawy)
        );

        delay 2.0;

        Receive_Product(TranStorage.all, TranTowar, TranIlosc);

        Put_Line(
          Log_Czas &
          "<R" & Id_text(Id) &
          "> dostarczono transport " &
          "nr " & Id_text(TranId_dostawy)
        );

      or
        accept Zakoncz;
        Koniec := True;

      --W najlepszym wypadku to jest tymczasowe.
      or
	terminate;

      end select;

    end loop;

  end Robot_Type;
end robot_module;
