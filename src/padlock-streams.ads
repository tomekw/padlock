with Ada.Streams;

package Padlock.Streams is
   function To_String (Item : Ada.Streams.Stream_Element_Array) return String;

   function To_Elements (Item : String) return Ada.Streams.Stream_Element_Array;
end Padlock.Streams;
