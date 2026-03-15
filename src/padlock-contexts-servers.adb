with Interfaces.C;
with Interfaces.C.Strings;

with Padlock.Thin;

package body Padlock.Contexts.Servers is
   use Interfaces;

   use type C.int;
   use type Thin.TLS_Ctx_Ptr;

   function Init (Cfg : Configs.Config) return Server_Context is
      C_Ctx : constant Thin.TLS_Ctx_Ptr := Thin.TLS_Server;
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

      return Ctx : Server_Context do
         Ctx.C_Ctx := C_Ctx;
      end return;
   end Init;
end Padlock.Contexts.Servers;
