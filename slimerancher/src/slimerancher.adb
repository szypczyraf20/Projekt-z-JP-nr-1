with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;

procedure Slimerancher is
   Storage : Warehouse_Storage;
   Status  : Storage_Status;
   dostawa_plortow : array (1 .. 3) of Ogarniacz_Plortow;
   r1 : Robot_Type(1);
begin
   -- Testing the warehouse module
   -- it works fine, it is safe from overflow + easy to reuse
   Initialize (Storage, 8);

   Receive_Product (Storage, Pink_Plort, 3);
   Receive_Product (Storage, Blue_Plort, 2);

   Status := Get_Status (Storage);

   Put_Line ("Warehouse status:");
   Put_Line
     ("Used space: " & Natural'Image (Status.Used_Space) &
      " / " & Positive'Image (Status.Max_Space));
   Put_Line ("Full: " & Boolean'Image (Status.Is_Full));
   Put_Line
     ("Pink plorts: " & Natural'Image (Product_Count (Storage, Pink_Plort)));
   Put_Line
     ("Blue plorts: " & Natural'Image (Product_Count (Storage, Blue_Plort)));
   Put_Line
     ("Gold plorts: " & Natural'Image (Product_Count (Storage, Gold_Plort)));
     
   --połączyłęm dwa mainy w jeden
   dostawa_plortow(1).Zarejestruj (1, Pink_Plort, 10);
   dostawa_plortow(2).Zarejestruj (2, Blue_Plort, 20);
   dostawa_plortow(3).Zarejestruj (3, Gold_Plort, 15);

   r1.Zakoncz;

end Slimerancher;
