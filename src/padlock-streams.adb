package body Padlock.Streams is
   function To_String (Item : Ada.Streams.Stream_Element_Array) return String is
      Result : String (1 .. Item'Length);
      for Result'Address use Item'Address;
   begin
      return Result;
   end To_String;

   function To_Elements (Item : String) return Ada.Streams.Stream_Element_Array is
      Result : Ada.Streams.Stream_Element_Array (1 .. Item'Length);
      for Result'Address use Item'Address;
   begin
      return Result;
   end To_Elements;
end Padlock.Streams;
