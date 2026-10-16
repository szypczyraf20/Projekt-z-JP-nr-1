with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with common_module; use common_module;

package body robot_module is

  Robot_Status : Robot_Status_Report := (Error => 0, Working => 0, Waiting => 0);

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

  function Get_Robot_Status return Robot_Status_Report is
  begin
      return Robot_Status;
  end Get_Robot_Status;

  task body Robot_Type is

    Koniec : Boolean := False;
    TranTowar : Product_Type;
    TranIlosc : Integer := 5;
    TranStorage : Warehouse_acc;

  begin
    Robot_Status.Waiting := Robot_Status.Waiting + 1;

    while not Koniec loop
      select

      --W tym poleceniu robot musi otrzymać magazyn do którego ma przekazać plorty jako
      --parametr.
      --    accept Przypisz_magazyn(in out Storage : Warehouse_Storage) do
      --    end Przypisz_magazyn;
      --
      --  or

      --We have a serious fucking problem.
        accept Transportuj(
          Storage : Warehouse_acc;
          Towar : Product_Type;
          Ilosc : Integer
        ) do

          Put_Line(
            Log_Czas &
            "<R" & Id_text (Id) &
            "> otrzymalem transport"
          );
          TranStorage := Storage;
          TranTowar := Towar;
          TranIlosc := Ilosc;


        end Transportuj;

        Robot_Status.Waiting := Robot_Status.Waiting - 1;
        Robot_Status.Working := Robot_Status.Working + 1;

        Put_Line (
          Log_Czas &
          "<R" & Id_text (Id) &
          "> jade"
        );

        delay 2.0;

        Receive_Product(TranStorage.all, TranTowar, TranIlosc);

        Put_Line(
          Log_Czas &
          "<R" & Id_text(Id) &
          "> dostarczono transport."
        );

        Robot_Status.Working := Robot_Status.Working - 1;
        Robot_Status.Waiting := Robot_Status.Waiting + 1;

      or
        accept Zakoncz;
        Koniec := True;

      end select;

    end loop;

  end Robot_Type;
end robot_module;
