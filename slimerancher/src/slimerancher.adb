with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;
with Monitor; use Monitor;

procedure Slimerancher is
   dostawa_plortow : array (1 .. n_dostaw) of Ogarniacz_Plortow;
begin
   Initialize (Storage.all, 3000);
   begin
      for I in 1 .. n_dostaw loop
         Losowanie_10_100.Reset (Gen_10_100);
         dostawa_plortow(I).Zarejestruj(I, Losowy_plort, Losowanie_10_100.Random (Gen_10_100));
      end loop;
   loop
      delay 3.0;
      Display_Status (Storage.all);
      exit when Get_Total_Deliveries >= n_dostaw;
   end loop;
   end;
end Slimerancher;
