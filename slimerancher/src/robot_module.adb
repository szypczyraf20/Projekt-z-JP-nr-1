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

  --O godzinie 12:23 dnia bierzącego dodam informację o czasie w którym rozpoczęła się
  --i zakończyła naprawa robota oraz przeniosę funkcję Log_Czas do common_module
  task body Serwis_Naprawczy_Type is
    Czas_Naprawy_Robota : Duration := 2.0;
    Id_Naprawianego : Integer := 0;
  begin
    loop
      select
        accept Napraw(Id : Integer) do
          Id_Naprawianego := Id;
        end Napraw;
        Put_Line(Log_Czas & "Naprawiam robota o id " & Id_text(Id_Naprawianego) & "...");
        delay Czas_Naprawy_Robota;
        Put_Line(Log_Czas & "Zakończono naprawę robota R" & Id_text(Id_Naprawianego) & ".");
        r(Id_Naprawianego).Uruchom_Ponownie;
      or
        terminate;
      end select;
    end loop;
  end Serwis_Naprawczy_Type;	

  task body Robot_Type is

    Id : Integer := Zwroc_i_zwieksz_id;
    Koniec : Boolean := False;
    Zepsuty : Boolean := False;
    TranTowar : Product_Type;
    TranIlosc : Integer := 5;
    TranSerwis : Serwis_Naprawczy_Type;
    TranStorage : Warehouse_acc;
    TranId_dostawy : Integer;
    Czas_Transportu : Duration := 2.0;
    Wybuchnie : Boolean := False;
    Czas_Do_Wybuchu : Duration := 0.0;
--  <<<<<<< HEAD
--  =======
--
--  >>>>>>> roboty_module
  begin
    while not Koniec loop
      select

      --We have a serious fucking problem.
      when Zepsuty = False =>
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

        if TranTowar = Boom_Plort then
          Wybuchnie := Czy_Wybuchnie;
        end if;

        if Wybuchnie then
          Czas_Do_Wybuchu := (Czas_Transportu / 100) * random;
          delay Czas_Do_Wybuchu;
          Put_Line("Bum! Robot " & Id_text(Id) & " wybuchł!");
          Zepsuty := True;
          Serwis.Napraw(Id);
        else

--  <<<<<<< HEAD
--  =======
--  >>>>>>> roboty_module

          delay Czas_Transportu;
          Receive_Product(TranStorage.all, TranTowar, TranIlosc);

        Put_Line(
          Log_Czas &
          "<R" & Id_text(Id) &
          "> dostarczono transport " &
          "nr " & Id_text(TranId_dostawy)
        );

        end if;
      or
        accept Uruchom_Ponownie;
        Zepsuty := False;
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
