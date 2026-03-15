with Padlock.Configs;

package Padlock.Contexts.Clients is
   type Client_Context is new Context with private;

   function Init (Cfg : Configs.Config) return Client_Context;

   procedure Connect (Self : in out Client_Context; Host : String; Port : String);

private

   type Client_Context is new Context with null record;
end Padlock.Contexts.Clients;
