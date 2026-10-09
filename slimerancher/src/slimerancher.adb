with Ada.Text_IO;
use Ada.Text_IO;


with Dostawa; use Dostawa;

procedure Slimerancher is

   dostawa_plortow : array (1 .. 3) of Ogarniacz_Plortow;

begin
   
   dostawa_plortow(1).Zarejestruj (1, "Pink Plort ", 10);
   dostawa_plortow(2).Zarejestruj (2, "Tabby Plort", 20);
   dostawa_plortow(3).Zarejestruj (3, "Boom  Plort", 15);
   
end Slimerancher;