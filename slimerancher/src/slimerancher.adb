with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;
with Monitor; use Monitor;

procedure Slimerancher is
   dostawa_plortow : array (1 .. n_dostaw) of Ogarniacz_Plortow;
begin
   Initialize (Storage.all, 100);
   Display_Status (Storage.all); -- Pierwszy print statusu magazynu
   declare
      dostawa_plortow : array (1 .. n_dostaw) of Ogarniacz_Plortow;
   begin
      for I in 1 .. n_dostaw loop
         Losowanie_10_100.Reset (Gen_10_100);
         dostawa_plortow(I).Zarejestruj
           (I, Losowy_plort, Losowanie_10_100.Random (Gen_10_100));
      end loop;
      -- teraz trzeba dodac sygnal albo procedure do zakonczenia, ewentualnie
      -- przycisk do wyswietlenia statusu magazynu w trakcie dzialania programu
      Delay 15.0;
      Display_Status (Storage.all);  -- Drugi print magazynu po operacjach
   end;
end Slimerancher;
