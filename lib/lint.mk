########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_LINT_INCLUDED
MAKEFILE_LINT_INCLUDED := 1


include $(srcdir)/lib/build.mk
include $(srcdir)/lib/cmd.mk
include $(srcdir)/lib/src.mk


SYSCONFDIR := $(srcdir)/etc

_LINTDIR   := $(builddir)/lint


LINTMAN   := $(shell $(FIND) $(MANDIR)/man*/ -type f \
		| $(GREP) '$(MANEXT)' \
		| $(XARGS) $(GREP) -l '^\.TH ' \
		| $(SORT))
_LINTDIRS := $(patsubst $(MANDIR)/%,$(_LINTDIR)/%/.,$(MANDIRS))


lint := lint-c lint-man


$(_LINTDIRS): %/.: | $$(dir %). $(_LINTDIR)/.


.PHONY: lint
lint: $(lint)
	@:


endif  # MAKEFILE_LINT_INCLUDED
