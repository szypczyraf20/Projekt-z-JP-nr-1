with Ada.Strings.Bounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
package body robot_module is
  package B_Str is new
     Ada.Strings.Bounded.Generic_Bounded_Length
       (Max => 30);
     use B_Str;

  function Log_Czas return String is
      Aktualny_Czas : Time := Clock;
      Roznica       : Duration := Aktualny_Czas - Czas_Startu;
  begin
      return "[" & Trim(Duration'Image(Roznica), Ada.Strings.Left) & "] ";
  end Log_Czas;

  task body Robot_Type is

    Koniec : Boolean := False;
    TranTowar : Bounded_String;
    TranIlosc : Integer := 5;

  begin
    while not Koniec loop
      select

        accept Transportuj(
          Towar : String;
          Ilosc : Integer
        ) do

          Put_Line(
            Log_Czas &
            "<R" & Trim(Integer'Image(Id), Ada.Strings.Left) &
            "> otrzymałem transport"
          );

          Overwrite(TranTowar, 1, Towar);
          TranIlosc := Ilosc;

        end Transportuj;

        Put_Line(
          Log_Czas &
          "<R" & Trim(Integer'Image(Id), Ada.Strings.Left) &
          "> jadę"
        );

        delay 2.0;

        Magazyn.Przyjmij(To_String(TranTowar), TranIlosc);

      or
        accept Zakoncz;
        Koniec := True;

      end select;

    end loop;

  end Robot_Type;
end robot_module;
