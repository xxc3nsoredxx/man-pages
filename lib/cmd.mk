########################################################################
# Copyright (C) 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_CMD_INCLUDED
MAKEFILE_CMD_INCLUDED := 1


BC         := bc
ECHO       := echo
FIND       := find
GIT        := git
GREP       := grep
GZIP       := gzip
INSTALL    := install
LOCALE     := locale
PKG-CONFIG := pkg-config
SED        := sed
SORT       := sort
TAC        := tac
TAR        := tar
XARGS      := xargs
XZ         := xz

INSTALL_DATA := $(INSTALL) -m 644
INSTALL_DIR  := $(INSTALL) -m 755 -d
RMDIR        := rmdir --ignore-fail-on-non-empty


endif  # MAKEFILE_CMD_INCLUDED
