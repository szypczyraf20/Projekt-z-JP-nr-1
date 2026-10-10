with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;

procedure Slimerancher is
   Storage : Warehouse_Storage;
   Status  : Storage_Status;
   dostawa_plortow : array (1 .. 3) of Ogarniacz_Plortow;
begin
   -- Testing the warehouse module
   -- it works fine, it is safe from overflow + easy to reuse
   Initialize (Storage, 8);

   Receive_Product (Storage, Pink_Plorp, 3);
   Receive_Product (Storage, Blue_Plorp, 2);

   Status := Get_Status (Storage);

   Put_Line ("Warehouse status:");
   Put_Line
     ("Used space: " & Natural'Image (Status.Used_Space) &
      " / " & Positive'Image (Status.Max_Space));
   Put_Line ("Full: " & Boolean'Image (Status.Is_Full));
   Put_Line
     ("Pink plorps: " & Natural'Image (Product_Count (Storage, Pink_Plorp)));
   Put_Line
     ("Blue plorps: " & Natural'Image (Product_Count (Storage, Blue_Plorp)));
   Put_Line
     ("Gold plorps: " & Natural'Image (Product_Count (Storage, Gold_Plorp)));
     
   --połączyłęm dwa mainy w jeden
   dostawa_plortow(1).Zarejestruj (1, "Pink Plort ", 10);
   dostawa_plortow(2).Zarejestruj (2, "Tabby Plort", 20);
   dostawa_plortow(3).Zarejestruj (3, "Boom  Plort", 15);

end Slimerancher;