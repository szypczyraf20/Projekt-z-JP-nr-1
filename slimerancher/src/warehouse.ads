package Warehouse is
   type Product_Type is (Pink_Plorp, Blue_Plorp, Gold_Plorp);

   type Storage_Status is record
      Used_Space : Natural := 0;
      Max_Space  : Positive := 1;
      Percent_Full : Natural := 0;
      Is_Full    : Boolean := False;
   end record;

   type Warehouse_Storage is private;

   procedure Initialize
     (This     : in out Warehouse_Storage;
      Capacity : Positive := 10);
   procedure Receive_Product
     (This    : in out Warehouse_Storage;
      Product : Product_Type;
      Amount  : Positive := 1);
   function Get_Status (This : Warehouse_Storage) return Storage_Status;
   function Is_Full (This : Warehouse_Storage) return Boolean;
   function Product_Count
     (This    : Warehouse_Storage;
      Product : Product_Type)
      return Natural;

private
   type Inventory_Array is array (Product_Type) of Natural;

   type Warehouse_Storage is record
      Capacity   : Positive := 10;
      Used_Space : Natural := 0;
      Inventory  : Inventory_Array := (others => 0);
   end record;

end Warehouse;
