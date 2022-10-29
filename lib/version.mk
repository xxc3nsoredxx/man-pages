########################################################################
# Copyright (C) 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_VERSION_INCLUDED
MAKEFILE_VERSION_INCLUDED := 1


include $(srcdir)/lib/cmd.mk
include $(srcdir)/lib/verbose.mk


DISTNAME    := $(shell $(GIT) describe $(HIDE_ERR))
DISTVERSION := $(patsubst man-pages-%,%,$(DISTNAME))


endif  # MAKEFILE_VERSION_INCLUDED
