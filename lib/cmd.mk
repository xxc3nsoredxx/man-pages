########################################################################
# Copyright (C) 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_CMD_INCLUDED
MAKEFILE_CMD_INCLUDED := 1


ECHO       := echo
EXPR       := expr
FIND       := find
GIT        := git
GREP       := grep
GZIP       := gzip
HEAD       := head
INSTALL    := install
LN         := ln
LOCALE     := locale
PKG-CONFIG := pkg-config
SED        := sed
SORT       := sort
SPONGE     := sponge
TAC        := tac
TAIL       := tail
TAR        := tar
TEST       := test
XARGS      := xargs
XZ         := xz

INSTALL_DATA := $(INSTALL) -m 644
INSTALL_DIR  := $(INSTALL) -m 755 -d
RMDIR        := rmdir --ignore-fail-on-non-empty


endif  # MAKEFILE_CMD_INCLUDED
