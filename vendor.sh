#!/bin/sh

LIBRESSL_VERSION=4.3.2

curl -LO https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz
tar xzf libressl-${LIBRESSL_VERSION}.tar.gz
cd libressl-${LIBRESSL_VERSION}

./configure --enable-libtls-only --prefix=$(pwd)/dist \
  CFLAGS="-O2 -ffunction-sections -fdata-sections"
make -j$(nproc)
make install
