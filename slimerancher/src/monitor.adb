with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO; use Ada.Text_IO;
with common_module; use common_module;
with robot_module; use robot_module;
with Dostawa; use Dostawa;

package body Monitor is

   function Get_Status (Storage : Warehouse_Storage) return Warehouse_Report is
      Storage_Info : constant Storage_Status := Warehouse.Get_Status (Storage);
      Robot_Status : constant Status_Counts := Get_Robot_Status;
      Status       : Warehouse_Report;
   begin
      Status.Capacity         := Storage_Info.Max_Space;
      Status.Used_Space       := Storage_Info.Used_Space;
      Status.Free_Space       := Storage_Info.Max_Space - Storage_Info.Used_Space;
      Status.Percent_Full     := Storage_Info.Percent_Full;
      Status.Total_Deliveries := Get_Total_Deliveries;
      Status.Robots_InRepair  := Robot_Status(W_naprawie); 
      Status.Robots_Working   := Robot_Status(Dziala);
      Status.Robots_Error     := Robot_Status(Zepsuty);
      return Status;
   end Get_Status;

   procedure Display_Status (Storage : Warehouse_Storage) is
      Status : constant Warehouse_Report := Get_Status (Storage);
      Border : constant String := "+-------------------------------------------------+";

      function Format (Value : Natural) return String is
      begin
         return Trim (Natural'Image (Value), Ada.Strings.Left);
      end Format;
   begin
      Put_Line (Border);
      Put_Line ("| Capacity : " & Format (Status.Capacity));
      Put_Line ("| Used space : " & Format (Status.Used_Space));
      Put_Line ("| Free space : " & Format (Status.Free_Space));
      Put_Line ("| Fullness : " & Format (Status.Percent_Full));
      Put_Line ("| Total deliveries : " & Format (Status.Total_Deliveries));
      for Product in Product_Type'Range loop
         Put_Line ("| " & Product_Type'Image (Product) & " plorts" &
                   " " & Format (Product_Count (Storage, Product)));
      end loop;
      Put_Line ("| Robots in repair : " & Format (Status.Robots_InRepair));
      Put_Line ("| Robots working : " & Format (Status.Robots_Working));
      Put_Line ("| Robots error : " & Format (Status.Robots_Error));
      Put_Line (Border);
   end Display_Status;

end Monitor;