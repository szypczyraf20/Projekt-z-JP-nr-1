with Ada.Text_IO;
use Ada.Text_IO;

procedure Slimerancher is
   Type Dostawa is record
      Id : Integer;
      Towar : String (1 .. 11);
      Ilosc : Integer;
   end record;
    
    

   task Stanowisko_odbiorow is
      
      entry rozladuj (ID : Integer; Towar : String; Ilosc : Integer);
   end Stanowisko_odbiorow;

   task body Stanowisko_odbiorow is
   begin
      loop
         select
               accept rozladuj (Id : Integer; Towar : String; Ilosc : Integer) do
                  Put_Line ("Rozpoczeto rozładunek dostawy plortów: nr " & Integer'Image (Id));
                    
                  Put_Line ("Tu będzie pracował robot...");
                    
                  Put_Line ("Zakonczono rozładunek dostawy plortów: nr " & Integer'Image (Id));
               end rozladuj;
            or
               terminate;
            end select;
         end loop;
      end Stanowisko_odbiorow;



      task type Ogarniacz_Plortow is
         entry Zarejestruj (Id : Integer; Towar : String; Ilosc : Integer);
      end Ogarniacz_Plortow;

      task body Ogarniacz_Plortow is
         Dostawa_Rekord : Dostawa;
      begin
         loop
            select
               accept Zarejestruj (Id : Integer; Towar : String; Ilosc : Integer) do
                    
                  Dostawa_Rekord.Id    := Id;
                  Dostawa_Rekord.Towar := Towar;
                  Dostawa_Rekord.Ilosc := Ilosc;
               end Zarejestruj;

               Put_Line ("Teleportowała się dostawa: nr" & Integer'Image (Dostawa_Rekord.Id) & "  " & Dostawa_Rekord.Towar & " " & Integer'Image (Dostawa_Rekord.Ilosc) & " sztuk");
               Put_Line ("Dostawa: nr " & Integer'Image (Dostawa_Rekord.Id) & "  czeka na rozładunek");
               Stanowisko_odbiorow.rozladuj(Dostawa_Rekord.Id, Dostawa_Rekord.Towar, Dostawa_Rekord.Ilosc);

                
            or
               terminate;
         end select;
      end loop;
   end Ogarniacz_Plortow;

   dostawa_plortow : array (1 .. 3) of Ogarniacz_Plortow;

begin
    
   dostawa_plortow(1).Zarejestruj (1, "Pink Plort ", 10);
   dostawa_plortow(2).Zarejestruj (2, "Tabby Plort", 20);
   dostawa_plortow(3).Zarejestruj (3, "Boom  Plort", 15);
end Slimerancher;