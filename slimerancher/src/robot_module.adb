with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with common_module; use common_module;

package body robot_module is

  function Get_Robot_Status return Robot_Status_Report is
  begin
    return Robot_Status;
  end Get_Robot_Status;

  function Zwroc_i_zwieksz_id return Integer is
  begin
    Obecne_Id := Obecne_Id + 1;
    return Obecne_Id;
  end Zwroc_i_zwieksz_id;

  function Id_text(Id : Integer) return String is
  begin
      return Trim(Integer'Image(Id), Ada.Strings.Left);
  end Id_text;

  function random return Zakres_1_100 is
  begin
    Losowanie_1_100.Reset(Gen_1_100);
    return Losowanie_1_100.Random(Gen_1_100);
  end random;

  function Czy_Wybuchnie return Boolean is
    test : Zakres_1_100;
  begin
    test := random;
    return test <= Szansa_Eksplozji;
  end Czy_Wybuchnie;

  --You are being terminated!
  procedure Zakoncz_Roboty is
  begin
    for robot of r loop
      robot.Zakoncz;
    end loop;
  end Zakoncz_Roboty;


  task body Serwis_Naprawczy_Type is
    Czas_Naprawy_Robota : Duration := 2.0;
    Id_Naprawianego : Integer := 0;
  begin
    loop
      select
        accept Napraw(robot : Robot_Type) do
          robot.Do_Naprawy;
          robot.Zwroc_Id(Id_Naprawianego);
          Put_Line(Log_Czas & "Naprawiam robota o id " & Id_text(Id_Naprawianego) & "...");
          delay Czas_Naprawy_Robota;
          Put_Line(Log_Czas & "Zakonczono naprawe robota R" & Id_text(Id_Naprawianego) & ".");
          robot.Uruchom_Ponownie;
        end Napraw;
      or
        terminate;
      end select;
    end loop;
  end Serwis_Naprawczy_Type;	

  task body Robot_Type is

    Id : Integer := Zwroc_i_zwieksz_id;
    Koniec : Boolean := False;
    Status : Status_Type := Dziala;
    TranTowar : Product_Type;
    TranIlosc : Integer := 0;
    TranStorage : Warehouse_acc;
    TranId_dostawy : Integer;
    Czas_Transportu : Duration := 2.0;
    Wybuchnie : Boolean := False;
    Czas_Do_Wybuchu : Duration := 0.0;
  begin
    Robot_Status.Waiting := Robot_Status.Waiting + 1;

    while not Koniec loop
      select

      --We have a serious fucking problem.
      when Status = Dziala =>
        accept Transportuj(
          Storage : Warehouse_acc;
          Towar : Product_Type;
          Ilosc : Integer;
          Id_dostawy : Integer
        ) do

          Put_Line(
            Log_Czas &
            "<R" & Id_text(Id) &
            "> otrzymalem transport " &
            "nr " & Id_text(Id_dostawy)
          );
          TranStorage := Storage;
          TranTowar := Towar;
          TranIlosc := Ilosc;
          TranId_dostawy :=Id_dostawy;

        end Transportuj;

        Robot_Status.Waiting := Robot_Status.Waiting - 1;
        Robot_Status.Working := Robot_Status.Working + 1;

        Put_Line (
          Log_Czas &
          "<R" & Id_text(Id) &
          "> jade z dostawa " &
          "nr " & Id_text(TranId_dostawy)
        );

        if TranTowar = Boom_Plort then
          Wybuchnie := Czy_Wybuchnie;
        end if;

        if Wybuchnie then
          Czas_Do_Wybuchu := (Czas_Transportu / 100) * random;
          delay Czas_Do_Wybuchu;
          Put_Line("Bum! Robot " & Id_text(Id) & " z dostawa " & Id_text(TranId_dostawy) & " wybuchl!");
          Status := Zepsuty;
        else

          delay Czas_Transportu;
          Receive_Product(TranStorage.all, TranTowar, TranIlosc);
          Robot_Status.Working := Robot_Status.Working - 1;
          Robot_Status.Waiting := Robot_Status.Waiting + 1;

          Put_Line(
            Log_Czas &
            "<R" & Id_text(Id) &
            "> dostarczono transport " &
            "nr " & Id_text(TranId_dostawy)
          );

        end if;
      or
        accept Czy_Zepsuty(czy_zepsuty : out Boolean) do
          czy_zepsuty := Status = Zepsuty;
        end Czy_Zepsuty;
      or
        accept Zwroc_Status(S : out Status_Type) do
          S := Status;
        end Zwroc_Status;
      or
        accept Do_Naprawy;
        Robot_Status.Error := Robot_Status.Error + 1;
        Status := W_naprawie;
      or
        accept Uruchom_Ponownie;
        Status := Dziala;
      or
        accept Zwroc_Id(I : out Integer) do
          I := Id;
        end Zwroc_Id;
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
