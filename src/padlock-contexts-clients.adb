with Interfaces.C;
with Interfaces.C.Strings;

with Padlock.Thin;

package body Padlock.Contexts.Clients is
   use Interfaces;

   use type C.int;
   use type Thin.TLS_Ctx_Ptr;

   function Init (Cfg : Configs.Config) return Client_Context is
      C_Ctx : constant Thin.TLS_Ctx_Ptr := Thin.TLS_Client;
   begin
      if C_Ctx = null then
         raise TLS_Error with "Failed to create context";
      end if;

      if Thin.TLS_Configure (C_Ctx, Cfg.C_Cfg) /= 0 then
         declare
            Error_Message : constant String :=
               "Failed to configure context: " & C.Strings.Value (Thin.TLS_Get_Error (C_Ctx));
         begin
            Thin.TLS_Free (C_Ctx);
            raise TLS_Error with Error_Message;
         end;
      end if;

      return Ctx : Client_Context do
         Ctx.C_Ctx := C_Ctx;
      end return;
   end Init;

   procedure Connect (Self : in out Client_Context; Host : String;  Port : String) is
      C_Host : C.Strings.chars_ptr := C.Strings.New_String (Host);
      C_Port : C.Strings.chars_ptr := C.Strings.New_String (Port);
   begin
      if Thin.TLS_Connect (Self.C_Ctx, C_Host, C_Port) /= 0 then
         C.Strings.Free (C_Host);
         C.Strings.Free (C_Port);

         raise TLS_Error with "Failed to connect to " & Host & ":" & Port & ": " &
                              C.Strings.Value (Thin.TLS_Get_Error (Self.C_Ctx));
      end if;

      C.Strings.Free (C_Host);
      C.Strings.Free (C_Port);
   end Connect;
end Padlock.Contexts.Clients;
