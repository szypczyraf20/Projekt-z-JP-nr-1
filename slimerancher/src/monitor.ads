with Warehouse; use Warehouse;

package Monitor is

   type Warehouse_Report is record
      Capacity         : Positive := 1;
      Used_Space       : Natural := 0;
      Free_Space       : Natural := 0;
      Percent_Full     : Natural := 0;
      Total_Deliveries : Natural := 0;
      Robots_Waiting   : Natural := 0;
      Robots_Working   : Natural := 0;
      Robots_Error     : Natural := 0;
   end record;

   function Get_Status (Storage : Warehouse_Storage) return Warehouse_Report;
   procedure Display_Status (Storage : Warehouse_Storage);

end Monitor;