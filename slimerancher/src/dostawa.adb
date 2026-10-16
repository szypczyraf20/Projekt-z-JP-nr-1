with common_module; use common_module;
package body Dostawa is

    function Log_Czas return String is
        Aktualny_Czas : Time := Clock;
        Roznica       : Duration := Aktualny_Czas - Czas_Startu;
    begin
        return "[" & Duration'Image(Roznica) & "] ";
    end Log_Czas;

   -- tutaj zostawiam swoja funckje Kasia
    function Get_Total_Deliveries return Natural is
    begin
        return Total_Deliveries;
    end Get_Total_Deliveries;

    task body Ogarniacz_Plortow is
        Dostawa_Rekord : Paczka_plortow;
        Stanowisko : Stanowisko_odbiorow;
    begin
        loop
            select
                accept Zarejestruj (Id : Integer; Towar : Product_Type; Ilosc : Integer) do
                        
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end Zarejestruj;

                Losowanie.Reset(Gen);
                X := Losowanie.Random(Gen);
                delay Duration(X);

                Put_Line (Log_Czas & "Teleportowala sie dostawa: nr" & Integer'Image (Dostawa_Rekord.Id) & "  " & Product_Type'Image(Dostawa_Rekord.Towar) & " " & Integer'Image (Dostawa_Rekord.Ilosc) & " sztuk");
                Put_Line (Log_Czas & "Dostawa: nr " & Integer'Image (Dostawa_Rekord.Id) & "  czeka na rozladunek");
                Stanowisko.rozladuj(Dostawa_Rekord.Id, Dostawa_Rekord.Towar, Dostawa_Rekord.Ilosc);

                    
            or
                terminate;
            end select;
        end loop;
    end Ogarniacz_Plortow;


    task body Stanowisko_odbiorow is
        x : Duration;
        Dostawa_Rekord : Paczka_plortow;
    begin
        loop
            select
                accept rozladuj (Id : Integer; Towar : Product_Type; Ilosc : Integer) do
                    Put_Line (Log_Czas & "Rozpoczeto rozladunek dostawy plortow: nr " & Integer'Image (Id));
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end rozladuj;
                x := Duration (Dostawa_Rekord.Ilosc / 10);
                delay Duration (x);

                Put_Line ("Tu bedzie pracowal robot...");

                Put_Line (Log_Czas & "Zakonczono rozladunek dostawy plortow: nr " & Integer'Image (Dostawa_Rekord.Id));
                Total_Deliveries := Total_Deliveries + 1;

            or
                terminate;
            end select;
        end loop;
    end Stanowisko_odbiorow;


end Dostawa;
