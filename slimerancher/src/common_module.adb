with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Calendar; use Ada.Calendar;

package body common_module is
  function Log_Czas return String is
      Aktualny_Czas : Time := Clock;
      Roznica       : Duration := Aktualny_Czas - Czas_Startu;
  begin
      return "[" & Trim(Duration'Image(Roznica), Ada.Strings.Left) & "] ";
  end Log_Czas;

  function Obecny_czas return Duration is
      Aktualny_Czas : Time := Clock;
      Roznica       : Duration := Aktualny_Czas - Czas_Startu;
  begin
      return Roznica;
  end Obecny_czas;
end common_module;
