with common_module; use common_module;

package body Dostawa is

    task body Ogarniacz_Plortow is
        Dostawa_Rekord : Paczka_plortow;
        Stanowisko : Stanowisko_odbiorow;
        Y : Duration;
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
                Y := Duration(X) + Obecny_czas;
                delay Y;

                Put_Line (Log_Czas & "Teleportowała się dostawa: nr" & Integer'Image (Dostawa_Rekord.Id) & "  " & Product_Type'Image(Dostawa_Rekord.Towar) & " " & Integer'Image (Dostawa_Rekord.Ilosc) & " sztuk");
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
        Znaleziono_Robota : Boolean;

        --Moje zmienne (oby były tymczasowe)
        Statusy : array(1 .. n_robotow) of Status_Type;
    begin
        loop
            select
                accept rozladuj (Id : Integer; Towar : Product_Type; Ilosc : Integer) do
                    
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end rozladuj;
                x := Duration(Float(Dostawa_Rekord.Ilosc) / 10.0);
                delay Duration(x);
                
                Znaleziono_Robota := False;
                
                --Wyszukiwanie niezajętego robota.
                
                    for I in 1 .. n_robotow loop
                      select
                          r(I).Transportuj(Storage, Dostawa_Rekord.Towar, Dostawa_Rekord.Ilosc, Dostawa_Rekord.Id);
                          --Jeśli zostanie znaleziony - wychodzimy z pętli.
                          Znaleziono_Robota := True;
                          exit;
                      else
                          
                          null;
                      end select;
                    end loop;

                    --Sprawdzanie statusu robotów (czy działają)
                    for I in 1 .. n_robotow loop
                      select
                          r(I).Zwroc_Status(Statusy(I));
                      else
                          Statusy(I) := Dziala;
                      end select;
                    end loop;

                    --Doświadczenie z prawdziwego życia: Jeżeli jakieś urządzenie jest
                    --zepsute, to tego problemu nie zgłasza samo urządzenie, ani
                    --serwisant nie poszukuje stale niedziałających urządzeń, aby je
                    --naprawić. To przechodzący obok człowiek, być może chcący z
                    --urządzenia skorzystać zgłasza awarię, aby serwis się tym zajął.
                    for I in 1 .. n_robotow loop
                      if Statusy(I) = Zepsuty then
                        Serwis.Napraw(r(I));
                      end if;
                    end loop;
                
                if not Znaleziono_Robota then
                    delay 2.0;
                    Put_Line (Log_Czas & "Plorty z dostawy: nr " & Integer'Image (Dostawa_Rekord.Id) & " zniknęły");
                    
                end if;

                --Jest przez to też możliwość, że nie zostanie znaleziony żaden wolny
                --robot i to potencjalnie w przyszłości może być problem, ale na razie
                --znajdujemy się w teraźniejszości, więc on nas nie dotyczy.
                
            or
                terminate;
            end select;
        end loop;
        
    end Stanowisko_odbiorow;


end Dostawa;
