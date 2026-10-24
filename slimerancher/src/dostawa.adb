with common_module; use common_module;

package body Dostawa is

    protected Delivery_Counter is
        procedure Increment;
        function Get return Natural;
    private
        Count : Natural := 0;
    end Delivery_Counter;

    protected body Delivery_Counter is
        procedure Increment is
        begin
            Count := Count + 1;
        end Increment;

        function Get return Natural is
        begin
            return Count;
        end Get;
    end Delivery_Counter;

    function Get_Total_Deliveries return Natural is
    begin
        return Delivery_Counter.Get;
    end Get_Total_Deliveries;

    task body Ogarniacz_Plortow is
        Dostawa_Rekord : Paczka_plortow;
        Stanowisko : Stanowisko_odbiorow;
        Y : Duration;
        G : Generator;
        Z : Uniformly_Distributed;
    begin
        loop
            select
                accept Zarejestruj (Id : Integer; Towar : Product_Type; Ilosc : Integer) do
                        
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end Zarejestruj;

                Reset(G);
                Losowanie.Reset(Gen);
                X := Losowanie.Random(Gen);
                Y := Duration(Random(G)*10.0);
                delay Y;

                Put_Line (Log_Czas & "Teleportowala sie dostawa: nr" & Integer'Image (Dostawa_Rekord.Id) & "  " & Product_Type'Image(Dostawa_Rekord.Towar) & " " & Integer'Image (Dostawa_Rekord.Ilosc) & " sztuk");
                Put_Line (Log_Czas & "Dostawa: nr " & Integer'Image (Dostawa_Rekord.Id) & "  czeka na rozladunek");
                
                Stanowisko.rozladuj(Dostawa_Rekord.Id, Dostawa_Rekord.Towar, Dostawa_Rekord.Ilosc);
                Delivery_Counter.Increment;
                    
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
        Czas_Zakonczenia : Duration := Obecny_czas;
    begin
        loop
            select
                accept rozladuj (Id : Integer; Towar : Product_Type; Ilosc : Integer) do
                    
                    Dostawa_Rekord.Id    := Id;
                    Dostawa_Rekord.Towar := Towar;
                    Dostawa_Rekord.Ilosc := Ilosc;
                end rozladuj;
                
                
                Znaleziono_Robota := False;
                
                --Wyszukiwanie niezajętego robota.
                
                    Czas_Zakonczenia := Obecny_czas + Czas_do_znikniecia;
                    while Obecny_czas <= Czas_Zakonczenia and Znaleziono_Robota = False loop
                        --Put_Line("Obecny_czas =" & Duration'Image(Obecny_czas));
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
                    Put_Line (Log_Czas & "Plorty z dostawy: nr " & Integer'Image (Dostawa_Rekord.Id) & " zniknely");
                    
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
