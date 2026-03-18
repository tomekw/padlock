with Interfaces.C;
with Interfaces.C.Strings;
with System;

package Padlock.Thin is
   pragma Elaborate_Body;

   use Interfaces;

   type TLS_Ctx_Record is null record
     with Convention => C;
   type TLS_Ctx_Ptr is access all TLS_Ctx_Record
     with Convention => C;

   type TLS_Cfg_Record is null record
     with Convention => C;
   type TLS_Cfg_Ptr is access all TLS_Cfg_Record
     with Convention => C;

   type C_ssize_t is range -(2 ** 63) .. (2 ** 63) - 1
     with Convention => C, Size => 64;

   TLS_WANT_POLLIN : constant C_ssize_t := -2;
   TLS_WANT_POLLOUT : constant C_ssize_t := -3;
   --  Positive: bytes transferred
   --  0: EOF
   --  -1: error
   --  -2 / -3: retry

   function TLS_Init return C.int
     with Import, Convention => C, External_Name => "tls_init";

   function TLS_Config_New return TLS_Cfg_Ptr
     with Import, Convention => C, External_Name => "tls_config_new";

   function TLS_Get_Config_Error (Cfg : TLS_Cfg_Ptr) return C.Strings.chars_ptr
     with Import, Convention => C, External_Name => "tls_config_error";

   function TLS_Config_Set_CA_File (Cfg : TLS_Cfg_Ptr; CA_File : C.Strings.chars_ptr) return C.int
     with Import, Convention => C, External_Name => "tls_config_set_ca_file";

   function TLS_Config_Set_Keypair_File
      (Cfg : TLS_Cfg_Ptr; Cert_File : C.Strings.chars_ptr; Key_File : C.Strings.chars_ptr) return C.int
     with Import, Convention => C, External_Name => "tls_config_set_keypair_file";

   function TLS_Config_Add_Keypair_File
      (Cfg : TLS_Cfg_Ptr; Cert_File : C.Strings.chars_ptr; Key_File : C.Strings.chars_ptr) return C.int
     with Import, Convention => C, External_Name => "tls_config_add_keypair_file";

   procedure TLS_Config_Free (Cfg : TLS_Cfg_Ptr)
     with Import, Convention => C, External_Name => "tls_config_free";

   function TLS_Client return TLS_Ctx_Ptr
     with Import, Convention => C, External_Name => "tls_client";

   function TLS_Server return TLS_Ctx_Ptr
     with Import, Convention => C, External_Name => "tls_server";

   function TLS_Configure (Ctx : TLS_Ctx_Ptr; Cfg : TLS_Cfg_Ptr) return C.int
     with Import, Convention => C, External_Name => "tls_configure";

   function TLS_Get_Error (Ctx : TLS_Ctx_Ptr) return C.Strings.chars_ptr
     with Import, Convention => C, External_Name => "tls_error";

   function TLS_Connect (Ctx : TLS_Ctx_Ptr; Host : C.Strings.chars_ptr; Port : C.Strings.chars_ptr) return C.int
     with Import, Convention => C, External_Name => "tls_connect";

   function TLS_Accept_Socket (Ctx : TLS_Ctx_Ptr; Child_Ctx : access TLS_Ctx_Ptr; Socket : C.int) return C.int
     with Import, Convention => C, External_Name => "tls_accept_socket";

   function TLS_Read (Ctx : TLS_Ctx_Ptr; Buffer : System.Address; Length : C.size_t) return C_ssize_t
     with Import, Convention => C, External_Name => "tls_read";

   function TLS_Write (Ctx : TLS_Ctx_Ptr; Buffer : System.Address; Length : C.size_t) return C_ssize_t
     with Import, Convention => C, External_Name => "tls_write";

   function TLS_Close (Ctx : TLS_Ctx_Ptr) return C_ssize_t
     with Import, Convention => C, External_Name => "tls_close";

   procedure TLS_Free (Ctx : TLS_Ctx_Ptr)
     with Import, Convention => C, External_Name => "tls_free";
end Padlock.Thin;
