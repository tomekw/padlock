with Interfaces.C;
with Interfaces.C.Strings;

package body Padlock.Contexts is
   use Interfaces;

   use type Thin.TLS_Ctx_Ptr;

   procedure Read (Self : in out Context; Buffer : out Streams.Stream_Element_Array; Last : out Streams.Stream_Element_Offset) is
      use type Thin.C_ssize_t;
      use type Streams.Stream_Element_Offset;

      C_Read_Result : Thin.C_ssize_t;
   begin
      loop
         C_Read_Result := Thin.TLS_Read (Self.C_Ctx, Buffer'Address, Buffer'Length);

         if C_Read_Result = Thin.TLS_WANT_POLLIN or else
            C_Read_Result = Thin.TLS_WANT_POLLOUT
         then
            null;
         elsif C_Read_Result < 0 then
            raise TLS_Error with C.Strings.Value (Thin.TLS_Get_Error (Self.C_Ctx));
         else
            Last := Buffer'First + Streams.Stream_Element_Offset (C_Read_Result) - 1;
            return;
         end if;
      end loop;
   end Read;

   procedure Write (Self : in out Context; Buffer : Streams.Stream_Element_Array) is
      use type Thin.C_ssize_t;
      use type Streams.Stream_Element_Offset;

      C_Write_Result : Thin.C_ssize_t;
      Write_Offset : Streams.Stream_Element_Offset :=  Buffer'First;
   begin
      while Write_Offset <= Buffer'Last loop
         C_Write_Result := Thin.TLS_Write (Self.C_Ctx, Buffer (Write_Offset)'Address, C.size_t (Buffer'Last - Write_Offset + 1));

         if C_Write_Result = Thin.TLS_WANT_POLLIN or else
            C_Write_Result = Thin.TLS_WANT_POLLOUT
         then
            null;
         elsif C_Write_Result <= 0 then
            raise TLS_Error with C.Strings.Value (Thin.TLS_Get_Error (Self.C_Ctx));
         else
            Write_Offset := Write_Offset + Streams.Stream_Element_Offset (C_Write_Result);
         end if;
      end loop;
   end Write;

   procedure Close (Self : in out Context) is
      use type Thin.C_ssize_t;

      C_Close_Result : Thin.C_ssize_t;
   begin
      loop
         C_Close_Result := Thin.TLS_Close (Self.C_Ctx);

         if C_Close_Result = 0 then
            return;
         elsif C_Close_Result = Thin.TLS_WANT_POLLIN or else
            C_Close_Result = Thin.TLS_WANT_POLLOUT
         then
            null;
         elsif C_Close_Result < 0 then
            raise TLS_Error with "Failed to close context: " & C.Strings.Value (Thin.TLS_Get_Error (Self.C_Ctx));
         end if;
      end loop;
   end Close;

   overriding procedure Finalize (Self : in out Context) is
      Unused_Result : Thin.C_ssize_t;
   begin
      if Self.C_Ctx /= null then
         Unused_Result := Thin.TLS_Close (Self.C_Ctx);
         Thin.TLS_Free (Self.C_Ctx);
         Self.C_Ctx := null;
      end if;
   end Finalize;
end Padlock.Contexts;
