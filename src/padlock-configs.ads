with Ada.Finalization;

with Padlock.Thin;

package Padlock.Configs is
   use Ada;

   type Config is new Finalization.Limited_Controlled with private;

   function Init (CA_File : String) return Config;

   function C_Cfg (Self : Config) return Thin.TLS_Cfg_Ptr;
private

   type Config is new Finalization.Limited_Controlled with record
      C_Cfg : Thin.TLS_Cfg_Ptr;
   end record;

   overriding procedure Finalize (Self : in out Config);
end Padlock.Configs;
