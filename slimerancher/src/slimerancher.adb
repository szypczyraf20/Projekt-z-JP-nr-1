with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;
with Monitor; use Monitor;

procedure Slimerancher is
   Storage : Warehouse_acc := new Warehouse_Storage;
   Status  : Storage_Status;
   dostawa_plortow : array (1 .. 10) of Ogarniacz_Plortow;
begin
   -- Testing the warehouse module
   -- it works fine, it is safe from overflow + easy to reuse
   -- Teraz jak przekazujecie Storage do jakiejkolwiek funkcji / procedury / entry,
   -- to musicie na końcu napisać .all, co zmienia tą zmienną ze wskaźnika na zwykły typ.
   Initialize (Storage.all, 100);

   --połączyłęm dwa mainy w jeden
   --... i zmieniłem trochę kolejność zadań
   dostawa_plortow(1).Zarejestruj (1, Pink_Plort, 10);
   dostawa_plortow(2).Zarejestruj (2, Blue_Plort, 20);
   dostawa_plortow(3).Zarejestruj (3, Gold_Plort, 15);
   for I in 4 .. 10 loop
     dostawa_plortow(I).Zarejestruj (4, Boom_Plort, 15);
   end loop;   

   Display_Status(Storage.all);

   --  Zakoncz_Roboty;
     
end Slimerancher;
