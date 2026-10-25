with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with common_module; use common_module;
with Dostawa; use Dostawa;
with Monitor; use Monitor;

package body robot_module is

  protected body Robot_Status_Tracker is
    procedure Ustaw_Status (Id : Integer; Stan : Status_Type) is
    begin
      Statusy (Id) := Stan;
    end Ustaw_Status;

    procedure Ustaw_Aktywnosc (Id : Integer; Czy_Pracuje : Boolean) is
    begin
      Aktywne (Id) := Czy_Pracuje;
    end Ustaw_Aktywnosc;

    function Pobierz_Status (Id : Integer) return Status_Type is
    begin
      return Statusy (Id);
    end Pobierz_Status;

    function Pobierz_Aktywnosc (Id : Integer) return Boolean is
    begin
      return Aktywne (Id);
    end Pobierz_Aktywnosc;

    function Return_Counts return Status_Counts is
      Counts : Status_Counts := (others => 0);
    begin
      for I in 1 .. n_robotow loop
        if not r (I)'Terminated then
          if Aktywne (I) and then Statusy (I) = Dziala then
            Counts (Dziala) := Counts (Dziala) + 1;
          elsif Statusy (I) = W_naprawie then
            Counts (W_naprawie) := Counts (W_naprawie) + 1;
          elsif Statusy (I) = Zepsuty then
            Counts (Zepsuty) := Counts (Zepsuty) + 1;
          end if;
        end if;
      end loop;
      return Counts;
    end Return_Counts;
  end Robot_Status_Tracker;

  function Get_Robot_Status return Status_Counts is
  begin
    return Robot_Status_Tracker.Return_Counts;
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

  procedure Jade_z(Id : Integer; TranId_dostawy : Integer; czy_czesc : Czesc_Dostawy_Type) is
  begin
    if czy_czesc = Czesc then
      Put_Line(
        Log_Czas &
        "<R" & Id_text(Id) &
        "> jade z czescia dostawy " &
        "nr " & Id_text(TranId_dostawy)
      );
    elsif czy_czesc = Calosc then
      Put_Line(
        Log_Czas &
        "<R" & Id_text(Id) &
        "> jade z dostawa " &
        "nr " & Id_text(TranId_dostawy)
      );
    else
      Put_Line(
        Log_Czas &
        "<R" & Id_text(Id) &
        "> jade z reszta dostawy " &
        "nr " & Id_text(TranId_dostawy)
      );
    end if;
  end Jade_z;

  procedure Dostarczono(Id : Integer; TranId_dostawy : Integer; czy_czesc : Czesc_Dostawy_Type) is
  begin
    if czy_czesc = Czesc then
      Put_Line(
        Log_Czas &
        "<R" & Id_text(Id) &
        "> dostarczono czesc transportu " &
        "nr " & Id_text(TranId_dostawy)
      );
    elsif czy_czesc = Calosc then
      Put_Line(
        Log_Czas &
        "<R" & Id_text(Id) &
        "> dostarczono transport " &
        "nr " & Id_text(TranId_dostawy)
      );
    else
      Put_Line(
        Log_Czas &
        "<R" & Id_text(Id) &
        "> dostarczono reszte transportu " &
        "nr " & Id_text(TranId_dostawy)
      );
    end if;
  end Dostarczono;

  procedure Zakoncz_Roboty is
  begin
    for robot of r loop
      robot.Zakoncz;
    end loop;
  end Zakoncz_Roboty;

  task body Serwis_Naprawczy_Type is
    Czas_Naprawy_Robota : Duration := 3.0 + Duration(Losowanie_1_10.Random(Gen_1_10));
    Id_Naprawianego : Integer := 0;
  begin
    loop
      select
        accept Napraw(robot : Robot_Type) do
          robot.Do_Naprawy;
          robot.Zwroc_Id(Id_Naprawianego);
          Put_Line(Log_Czas & "Naprawiam robota o id " & Id_text(Id_Naprawianego) & "...");
          select
            delay 3.0;
            Put_Line(Log_Czas & "Naprawa robota R" & Id_text(Id_Naprawianego) & " przekroczyla limit 3s i robot zostal wymieniony.");
            robot.Uruchom_Ponownie;
          then abort
            delay Czas_Naprawy_Robota;
            Put_Line(Log_Czas & "Zakonczono naprawe robota R" & Id_text(Id_Naprawianego) & ".");
            robot.Uruchom_Ponownie;
          end select;
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
    Calkowita_Ilosc : Integer := 0;
    Pojemnosc : Integer := 50;
    Czas_Transportu : Duration := 2.0;
    Wybuchnie : Boolean := False;
    Czas_Do_Wybuchu : Duration := 0.0;
    Czy_Czesc_Dostawy : Czesc_Dostawy_Type;
  begin
    Robot_Status_Tracker.Ustaw_Status (Id, Dziala);
    Robot_Status_Tracker.Ustaw_Aktywnosc (Id, False);

    while not Koniec loop
      select
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
          Calkowita_Ilosc := Ilosc;
          TranId_dostawy := Id_dostawy;
        end Transportuj;

        Robot_Status_Tracker.Ustaw_Aktywnosc(Id, True);
        TranIlosc := Integer'Min(Calkowita_Ilosc, Pojemnosc);
        if Calkowita_Ilosc <= Pojemnosc then
          Czy_Czesc_Dostawy := Calosc;
        else
          Czy_Czesc_Dostawy := Czesc;
        end if;

        while(Calkowita_Ilosc > 0) loop
          TranIlosc := Integer'Min(Calkowita_Ilosc, Pojemnosc);
          Jade_z(Id, TranId_dostawy, Czy_Czesc_Dostawy);

          Wybuchnie := False;
          if TranTowar = Boom_Plort then
            Wybuchnie := Czy_Wybuchnie;
          end if;

          if Wybuchnie then
            Czas_Do_Wybuchu := (Czas_Transportu / 100) * random;
            delay Czas_Do_Wybuchu;
            Put_Line("Bum! Robot " & Id_text(Id) & " z dostawa " & Id_text(TranId_dostawy) & " wybuchl!");
            Status := Zepsuty;
            Robot_Status_Tracker.Ustaw_Status(Id, Zepsuty);
            Calkowita_Ilosc := 0;
            TranIlosc := 0;
          else

            delay Czas_Transportu;

            Calkowita_Ilosc := Calkowita_Ilosc - TranIlosc;
            Dostarczono(Id, TranId_dostawy, Czy_Czesc_Dostawy);
            Receive_Product(TranStorage.all, TranTowar, TranIlosc);
            if Calkowita_Ilosc <= Pojemnosc then
              Czy_Czesc_Dostawy := Reszta;
            end if;

            delay Czas_Transportu;

          end if;
        end loop;

      --    Robot_Status_Tracker.Ustaw_Aktywnosc (Id, False);
      --    Robot_Status_Tracker.Ustaw_Status (Id, Dziala);
      or
        accept Zwroc_Status(S : out Status_Type) do
          S := Robot_Status_Tracker.Pobierz_Status(Id);
        end Zwroc_Status;
      or
        accept Do_Naprawy do
          Status := W_naprawie;
          Robot_Status_Tracker.Ustaw_Status(Id, W_naprawie);
          Robot_Status_Tracker.Ustaw_Aktywnosc(Id, False);
        end Do_Naprawy;
      or
        accept Uruchom_Ponownie do
          Status := Dziala;
          Robot_Status_Tracker.Ustaw_Status(Id, Dziala);
          Robot_Status_Tracker.Ustaw_Aktywnosc(Id, False);
        end Uruchom_Ponownie;
      or
        accept Zwroc_Id(I : out Integer) do
          I := Id;
        end Zwroc_Id;
      or
        accept Zakoncz do
          Robot_Status_Tracker.Ustaw_Aktywnosc(Id, False);
          Koniec := True;
        end Zakoncz;
      or
        terminate;

      end select;

    end loop;

  end Robot_Type;

end robot_module;
