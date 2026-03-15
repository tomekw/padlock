with Interfaces.C.Strings;

package body Padlock.Configs is
   use Interfaces;

   use type C.int;
   use type Thin.TLS_Cfg_Ptr;

   function Init (CA_File : String) return Config is
      C_Cfg : constant Thin.TLS_Cfg_Ptr := Thin.TLS_Config_New;
   begin
      if C_Cfg = null then
         raise TLS_Error with "Failed to create configuration";
      end if;

      declare
         C_CA_File : C.Strings.chars_ptr := C.Strings.New_String (CA_File);
      begin
         if Thin.TLS_Config_Set_CA_File (C_Cfg, C_CA_File) /= 0 then
            C.Strings.Free (C_CA_File);

            declare
               Error_Message : constant String :=
                  "Failed to set CA file: " & C.Strings.Value (Thin.TLS_Get_Config_Error (C_Cfg));
            begin
               Thin.TLS_Config_Free (C_Cfg);
               raise TLS_Error with Error_Message;
            end;
         end if;

         C.Strings.Free (C_CA_File);
      end;

      return Cfg : Config do
         Cfg.C_Cfg := C_Cfg;
      end return;
   end Init;

   function Init (Cert_File : String; Key_File : String) return Config is
      C_Cfg : constant Thin.TLS_Cfg_Ptr := Thin.TLS_Config_New;
   begin
      if C_Cfg = null then
         raise TLS_Error with "Failed to create configuration";
      end if;

      declare
         C_Cert_File : C.Strings.chars_ptr := C.Strings.New_String (Cert_File);
         C_Key_File : C.Strings.chars_ptr := C.Strings.New_String (Key_File);
      begin
         if Thin.TLS_Config_Set_Keypair_File (C_Cfg, C_Cert_File, C_Key_File) /= 0 then
            C.Strings.Free (C_Cert_File);
            C.Strings.Free (C_Key_File);

            declare
               Error_Message : constant String :=
                  "Failed to set keypair file: " & C.Strings.Value (Thin.TLS_Get_Config_Error (C_Cfg));
            begin
               Thin.TLS_Config_Free (C_Cfg);
               raise TLS_Error with Error_Message;
            end;
         end if;

         C.Strings.Free (C_Cert_File);
         C.Strings.Free (C_Key_File);
      end;

      return Cfg : Config do
         Cfg.C_Cfg := C_Cfg;
      end return;
   end Init;

   function C_Cfg (Self : Config) return Thin.TLS_Cfg_Ptr is
   begin
      return Self.C_Cfg;
   end C_Cfg;

   overriding procedure Finalize (Self : in out Config) is
   begin
      if Self.C_Cfg /= null then
         Thin.TLS_Config_Free (Self.C_Cfg);
         Self.C_Cfg := null;
      end if;
   end Finalize;
end Padlock.Configs;
