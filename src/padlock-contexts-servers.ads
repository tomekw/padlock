with Padlock.Configs;

package Padlock.Contexts.Servers is
   type Server_Context is new Context with private;

   function Init (Cfg : Configs.Config) return Server_Context;

private

   type Server_Context is new Context with null record;
end Padlock.Contexts.Servers;
