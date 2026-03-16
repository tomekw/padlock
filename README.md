# Padlock

LibreSSL's [libtls](https://man.openbsd.org/tls_init.3) in Ada.

## Status

This is alpha software. I'm actively working it. YMMV.

Tested on Linux x86_64, MacOS ARM and Windows x86_64.

## Usage

Install [tada](https://github.com/tomekw/tada).

Generate certificates with:

``` shell
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 365 -keyout key.pem -out cert.pem -subj "/CN=localhost"
```

Add:

``` toml
padlock = "0.1.0"
```

to your [tada.toml](https://github.com/tomekw/tada).

Or see:

* [example echo server implementation](https://github.com/tomekw/padlock_echo_server)
* [example echo client implementation](https://github.com/tomekw/padlock_echo_client)

Run both with:

``` shell
tada run
```

## Disclaimer

This codebase is written by hand. Claude Code is used for Socratic design exploration and code review.

## License

[EUPL](LICENSE)
