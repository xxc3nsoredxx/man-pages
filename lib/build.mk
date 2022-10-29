########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_BUILD_INCLUDED
MAKEFILE_BUILD_INCLUDED := 1


include $(srcdir)/lib/src.mk


builddir := tmp

_SRCDIR := $(builddir)/src


MKDIR := mkdir -p
RM    := rm


_SRCDIRS := $(patsubst $(MANDIR)/%,$(_SRCDIR)/%/.,$(MANDIRS))


$(_SRCDIRS): %/.: | $$(dir %). $(_SRCDIR)/.


$(builddir)/%/.:
	$(info MKDIR	$(@D)/)
	$(MKDIR) $(@D)


.PHONY: build
build: build-html
	@:

.PHONY: clean
clean:
	$(info RM -rf	$(builddir))
	$(RM) -rf $(builddir)


endif  # MAKEFILE_BUILD_INCLUDED
