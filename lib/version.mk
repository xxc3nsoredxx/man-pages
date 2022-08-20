########################################################################
# Copyright (C) 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_VERSION_INCLUDED
MAKEFILE_VERSION_INCLUDED := 1


include $(srcdir)/lib/cmd.mk


DISTNAME    := $(shell $(GIT) describe 2>/dev/null)
DISTVERSION := $(patsubst man-pages-%,%,$(DISTNAME))


endif  # MAKEFILE_VERSION_INCLUDED
