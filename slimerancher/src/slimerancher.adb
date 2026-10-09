with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Calendar; 
use Ada.Calendar;

procedure Slimerancher is
   Type Dostawa is record
      Id : Integer;
      Towar : String (1 .. 11);
      Ilosc : Integer;
   end record;
    
   subtype Zakres is Integer range 1 .. 5;
   package Losowanie is
      new Ada.Numerics.Discrete_Random(Zakres);
   Gen : Losowanie.Generator;
   X : Zakres;

   Czas_Startu : Time := Clock;



   function Log_Czas return String is
      Aktualny_Czas : Time := Clock;
      Roznica       : Duration := Aktualny_Czas - Czas_Startu;
   begin
      return "[" & Duration'Image(Roznica) & "] ";
   end Log_Czas;






   task Stanowisko_odbiorow is
      
      entry rozladuj (ID : Integer; Towar : String; Ilosc : Integer);
   end Stanowisko_odbiorow;

   task body Stanowisko_odbiorow is
      x : Duration;

   begin
      loop
         select
               accept rozladuj (Id : Integer; Towar : String; Ilosc : Integer) do
                  Put_Line (Log_Czas & "Rozpoczeto rozładunek dostawy plortów: nr " & Integer'Image (Id));
                  x := Duration(Ilosc/10);
                  delay Duration(x);
                  Put_Line ("Tu będzie pracował robot...");
                    
                  Put_Line (Log_Czas & "Zakonczono rozładunek dostawy plortów: nr " & Integer'Image (Id));
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

               Losowanie.Reset(Gen);
               X := Losowanie.Random(Gen);
               delay Duration(X);

               Put_Line (Log_Czas & "Teleportowała się dostawa: nr" & Integer'Image (Dostawa_Rekord.Id) & "  " & Dostawa_Rekord.Towar & " " & Integer'Image (Dostawa_Rekord.Ilosc) & " sztuk");
               Put_Line (Log_Czas & "Dostawa: nr " & Integer'Image (Dostawa_Rekord.Id) & "  czeka na rozładunek");
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