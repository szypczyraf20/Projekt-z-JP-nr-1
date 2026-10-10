with Ada.Text_IO; use Ada.Text_IO;

--Szkielet modułu magazynu (potrzebowałem go utworzyć, by dokończyć moduł robotów,
--przerabiaj go sobie jak chcesz, Szymon)
package body magazyn_module is
  package B_Str is new
  task body Magazyn is
  begin
    loop
      select
        accept Przyjmij(Towar : String; Ilosc : Integer) do
          Put_Line("Przyjęto " & Towar & " w ilosci" & Integer'Image(Ilosc));
        end Przyjmij;
      or
        terminate;
      end select;
    end loop;
  end Magazyn;
end magazyn_module;
