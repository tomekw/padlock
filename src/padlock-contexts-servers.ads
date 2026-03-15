with GNAT.Sockets;

with Padlock.Configs;

package Padlock.Contexts.Servers is
   use GNAT;

   type Server_Context is new Context with private;

   function Init (Cfg : Configs.Config) return Server_Context;

   procedure Accept_Socket (Self : in out Server_Context; Child_Ctx : out Context; Socket : Sockets.Socket_Type);

private

   type Server_Context is new Context with null record;
end Padlock.Contexts.Servers;
