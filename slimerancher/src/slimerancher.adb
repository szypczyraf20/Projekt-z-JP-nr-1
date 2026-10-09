with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;

procedure Slimerancher is
   Storage : Warehouse_Storage;
   Status  : Storage_Status;
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

end Slimerancher;
