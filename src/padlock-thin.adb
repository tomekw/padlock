package body Padlock.Thin is
   use type C.int;
begin
   if TLS_Init /= 0 then
      raise TLS_Error with "Failed to initialize TLS";
   end if;
end Padlock.Thin;
