with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;

procedure Slimerancher is
   Storage : Warehouse_acc := new Warehouse_Storage;
   Status  : Storage_Status;
   dostawa_plortow : array (1 .. 3) of Ogarniacz_Plortow;
begin
   -- Testing the warehouse module
   -- it works fine, it is safe from overflow + easy to reuse
   -- Teraz jak przekazujecie Storage do jakiejkolwiek funkcji / procedury / entry,
   -- to musicie na końcu napisać .all, co zmienia tą zmienną ze wskaźnika na zwykły typ.
   Initialize (Storage.all, 8);

   --połączyłęm dwa mainy w jeden
   --... i zmieniłem trochę kolejność zadań
   dostawa_plortow(1).Zarejestruj (1, Pink_Plort, 10);
   dostawa_plortow(2).Zarejestruj (2, Blue_Plort, 20);
   dostawa_plortow(3).Zarejestruj (3, Gold_Plort, 15);

   Status := Get_Status (Storage.all);

   Put_Line ("Warehouse status:");
   Put_Line
     ("Used space: " & Natural'Image (Status.Used_Space) &
      " / " & Positive'Image (Status.Max_Space));
   Put_Line ("Full: " & Boolean'Image (Status.Is_Full));
   Put_Line
     ("Pink plorts: " & Natural'Image (Product_Count (Storage.all, Pink_Plort)));
   Put_Line
     ("Blue plorts: " & Natural'Image (Product_Count (Storage.all, Blue_Plort)));
   Put_Line
     ("Gold plorts: " & Natural'Image (Product_Count (Storage.all, Gold_Plort)));

   Zakoncz_Roboty;
     
end Slimerancher;
