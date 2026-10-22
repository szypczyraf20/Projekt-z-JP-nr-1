with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;

procedure Slimerancher is
   Storage : Warehouse_acc := new Warehouse_Storage;
   Status  : Storage_Status;
   dostawa_plortow : array (1 .. n_dostaw) of Ogarniacz_Plortow;
begin
   -- Testing the warehouse module
   -- it works fine, it is safe from overflow + easy to reuse
   -- Teraz jak przekazujecie Storage do jakiejkolwiek funkcji / procedury / entry,
   -- to musicie na końcu napisać .all, co zmienia tą zmienną ze wskaźnika na zwykły typ.
   Initialize (Storage.all, 8);

   --połączyłęm dwa mainy w jeden
   --... i zmieniłem trochę kolejność zadań
   for I in 1 .. n_dostaw loop
    Losowanie_10_100.Reset(Gen_10_100);
     dostawa_plortow(I).Zarejestruj (I, Losowy_plort, Losowanie_10_100.Random(Gen_10_100));
   end loop;

   Status := Get_Status (Storage.all);

   Put_Line ("Warehouse status:");
   Put_Line
     ("Used space: " & Natural'Image (Status.Used_Space) &
      " / " & Positive'Image (Status.Max_Space));
   Put_Line ("Full: " & Boolean'Image (Status.Is_Full));
   Put_Line
     ("Pink plorts: " & Natural'Image (Product_Count (Storage.all, Pink_Plort)));
   Put_Line
     ("Blue plorts: " & Natural'Image (Product_Count (Storage.all, Water_Plort)));
   Put_Line
     ("Gold plorts: " & Natural'Image (Product_Count (Storage.all, Gold_Plort)));

   --  Zakoncz_Roboty;
     
end Slimerancher;
