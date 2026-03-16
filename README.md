# Padlock

LibreSSL's [libtls](https://man.openbsd.org/tls_init.3) in Ada.

## Status

This is alpha software. I'm actively working it. YMMV.

Tested on Linux x86_64, MacOS ARM and Windows x86_64.

## Usage

Generate certificates with:

``` shell
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 365 -keyout key.pem -out cert.pem -subj "/CN=localhost"
```

Add:

``` toml
padlock = "0.1.0"
```

to your [tada.toml](https://github.com/tomekw/tada).

Echo server. Create with:

``` shell
tada init padlock_echo_server --exe
```

``` ada
with Ada.Streams;
with Ada.Text_IO;

with GNAT.Sockets;

with Padlock.Configs;
with Padlock.Contexts;
with Padlock.Contexts.Servers;
with Padlock.Streams;

procedure Padlock_Echo_Server.Main is
   use Ada;
   use GNAT;
   package TLS renames Padlock;

   Server_Socket : Sockets.Socket_Type;

   Cfg : constant TLS.Configs.Config := TLS.Configs.Init ("cert.pem", "key.pem");
   Ctx : TLS.Contexts.Servers.Server_Context := TLS.Contexts.Servers.Init (Cfg);
begin
   Sockets.Create_Socket (Server_Socket);
   Sockets.Bind_Socket (Server_Socket, (Family => Sockets.Family_Inet,
                                        Addr => Sockets.Any_Inet_Addr,
                                        Port => 4343));
   Sockets.Listen_Socket (Server_Socket);

   declare
      use type Streams.Stream_Element_Offset;

      Client_Socket : Sockets.Socket_Type;
      Client_Addr : Sockets.Sock_Addr_Type;
      Child_Ctx : TLS.Contexts.Context;

      Buffer : Streams.Stream_Element_Array (1 .. 5);
      Last : Streams.Stream_Element_Offset;
   begin
      Sockets.Accept_Socket (Server_Socket, Client_Socket, Client_Addr);

      Ctx.Accept_Socket (Child_Ctx, Client_Socket);

      loop
         Child_Ctx.Read (Buffer, Last);

         exit when Last = 0;

         Text_IO.Put_Line ("Got: " & TLS.Streams.To_String (Buffer (Buffer'First .. Last)));

         Child_Ctx.Write (Buffer);
      end loop;

      Child_Ctx.Close;
      Sockets.Close_Socket (Client_Socket);
   end;

   Ctx.Close;
   Sockets.Close_Socket (Server_Socket);
end Padlock_Echo_Server.Main;
```

Echo client. Create with:

``` shell
tada init padlock_echo_client --exe
```

``` ada
with Ada.Streams;
with Ada.Text_IO;

with Padlock.Configs;
with Padlock.Contexts;
with Padlock.Contexts.Clients;
with Padlock.Streams;

procedure Padlock_Echo_Client.Main is
   use Ada;
   package TLS renames Padlock;

   Cfg : constant TLS.Configs.Config := TLS.Configs.Init ("cert.pem");
   Ctx : TLS.Contexts.Clients.Client_Context := TLS.Contexts.Clients.Init (Cfg);

begin
   Ctx.Connect ("localhost", "4343");

   declare
      use type Streams.Stream_Element_Offset;

      Buffer : Streams.Stream_Element_Array (1 .. 5);
      Last : Streams.Stream_Element_Offset;

      Message : constant String := "hello";
   begin
      for Unused_I in 1 .. 5 loop
         Ctx.Write (TLS.Streams.To_Elements (Message));

         Ctx.Read (Buffer, Last);

         Text_IO.Put_Line ("Got: " & TLS.Streams.To_String (Buffer (Buffer'First .. Last)));

         delay 1.0;
      end loop;
   end;

   Ctx.Close;
end Padlock_Echo_Client.Main;
```

Run both with:

``` shell
tada run
```

## Disclaimer

This codebase is written by hand. Claude Code is used for Socratic design exploration and code review.

## License

[EUPL](LICENSE)
