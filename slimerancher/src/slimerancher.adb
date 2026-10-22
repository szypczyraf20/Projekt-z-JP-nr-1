with Ada.Text_IO; use Ada.Text_IO;
with Warehouse; use Warehouse;
with Dostawa; use Dostawa;
with robot_module; use robot_module;
with common_module; use common_module;
with Monitor; use Monitor;

procedure Slimerancher is
  --Tak btw, Szymon ta zmienna Storage poniżej nie jest do niczego wykorzystywana. Ta,
  --która jest parametrem dla robotów jest zadeklarowana w pliku dostawa.ads (nie
  --umiałem jej w jakiś sprytny sposób przekazać do robotów)
   Storage : Warehouse_acc := new Warehouse_Storage;
   --Tą zmienną pewnie też będziesz musiał przenieść.
   Status  : Storage_Status;
   dostawa_plortow : array (1 .. n_dostaw) of Ogarniacz_Plortow;
begin
   -- Testing the warehouse module
   -- it works fine, it is safe from overflow + easy to reuse
   -- Teraz jak przekazujecie Storage do jakiejkolwiek funkcji / procedury / entry,
   -- to musicie na końcu napisać .all, co zmienia tą zmienną ze wskaźnika na zwykły typ.
   Initialize (Storage.all, 100);

   --połączyłęm dwa mainy w jeden
   --... i zmieniłem trochę kolejność zadań
   for I in 1 .. n_dostaw loop
    Losowanie_10_100.Reset(Gen_10_100);
     dostawa_plortow(I).Zarejestruj (I, Losowy_plort, Losowanie_10_100.Random(Gen_10_100));
   end loop;

   Display_Status(Storage.all);

   --  Zakoncz_Roboty;
     
end Slimerancher;
