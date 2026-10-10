package body Dostawa is

    function Log_Czas return String is
        Aktualny_Czas : Time := Clock;
        Roznica       : Duration := Aktualny_Czas - Czas_Startu;
    begin
        return "[" & Duration'Image(Roznica) & "] ";
    end Log_Czas;


    task body Ogarniacz_Plortow is
        Dostawa_Rekord : Paczka_plortow;
        Stanowisko : Stanowisko_odbiorow;
    begin
        loop
            select
                accept Zarejestruj (Id : Integer; Towar : String; Ilosc : Integer) do
                        
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end Zarejestruj;

                Losowanie.Reset(Gen);
                X := Losowanie.Random(Gen);
                delay Duration(X);

                Put_Line (Log_Czas & "Teleportowała się dostawa: nr" & Integer'Image (Dostawa_Rekord.Id) & "  " & Dostawa_Rekord.Towar & " " & Integer'Image (Dostawa_Rekord.Ilosc) & " sztuk");
                Put_Line (Log_Czas & "Dostawa: nr " & Integer'Image (Dostawa_Rekord.Id) & "  czeka na rozładunek");
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
                accept rozladuj (Id : Integer; Towar : String; Ilosc : Integer) do
                    Put_Line (Log_Czas & "Rozpoczeto rozładunek dostawy plortów: nr " & Integer'Image (Id));
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end rozladuj;
                x := Duration(Dostawa_Rekord.Ilosc/10);
                delay Duration(x);
                
                Put_Line ("Tu będzie pracował robot...");
                        
                Put_Line (Log_Czas & "Zakonczono rozładunek dostawy plortów: nr " & Integer'Image (Dostawa_Rekord.Id));
                
            or
                terminate;
            end select;
        end loop;
    end Stanowisko_odbiorow;


end Dostawa;