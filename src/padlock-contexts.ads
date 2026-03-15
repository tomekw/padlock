with Ada.Finalization;
with Ada.Streams;

with Padlock.Thin;

package Padlock.Contexts is
   use Ada;

   type Context is new Finalization.Limited_Controlled with private;

   procedure Read (Self : in out Context; Buffer : out Streams.Stream_Element_Array; Last : out Streams.Stream_Element_Offset);

   procedure Write (Self : in out Context; Buffer : Streams.Stream_Element_Array);

   procedure Close (Self : in out Context);

private

   type Context is new Finalization.Limited_Controlled with record
      C_Ctx : Thin.TLS_Ctx_Ptr;
   end record;

   overriding procedure Finalize (Self : in out Context);
end Padlock.Contexts;
