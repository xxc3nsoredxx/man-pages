########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_SRC_INCLUDED
MAKEFILE_SRC_INCLUDED := 1


include $(srcdir)/lib/cmd.mk


MANDIR := $(srcdir)
MANEXT := \.[0-9]\w*$


MANPAGES := $(shell $(FIND) $(MANDIR)/man*/ -type f \
		| $(GREP) '$(MANEXT)' \
		| $(SORT))
MANDIRS  := $(shell $(FIND) $(MANDIR)/man* -type d \
		| $(SORT))


endif  # MAKEFILE_SRC_INCLUDED
