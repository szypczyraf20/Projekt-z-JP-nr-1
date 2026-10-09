package body Warehouse is

   procedure Initialize
     (This     : in out Warehouse_Storage;
      Capacity : Positive := 10)
   is
   begin
      This.Capacity := Capacity;
      This.Used_Space := 0;
      This.Inventory := (others => 0);
   end Initialize;

   procedure Receive_Product
     (This    : in out Warehouse_Storage;
      Product : Product_Type;
      Amount  : Positive := 1)
   is
      Available_Space : constant Natural := This.Capacity - This.Used_Space;
      acc_amount : Natural;
   begin
      if Available_Space = 0 then
         return;
      end if;

      if Amount > Available_Space then
         acc_amount := Available_Space;
      else
         acc_amount := Amount;
      end if;

      This.Inventory (Product) := This.Inventory (Product) + acc_amount;
      This.Used_Space := This.Used_Space + acc_amount;
   end Receive_Product;

   function Get_Status (This : Warehouse_Storage) return Storage_Status is
      Status : Storage_Status;
   begin
      Status.Used_Space := This.Used_Space;
      Status.Max_Space := This.Capacity;
      Status.Percent_Full := (This.Used_Space * 100) / This.Capacity;
      Status.Is_Full := This.Used_Space >= This.Capacity;
      return Status;
   end Get_Status;

   function Is_Full (This : Warehouse_Storage) return Boolean is
   begin
      return This.Used_Space >= This.Capacity;
   end Is_Full;

   function Product_Count
     (This    : Warehouse_Storage;
      Product : Product_Type)
      return Natural
   is
   begin
      return This.Inventory (Product);
   end Product_Count;

end Warehouse;
