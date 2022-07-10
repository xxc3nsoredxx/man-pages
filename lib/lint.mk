########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_LINT_INCLUDED
MAKEFILE_LINT_INCLUDED := 1


SYSCONFDIR := $(srcdir)/etc

_LINTDIR   := $(builddir)/lint
_SRCDIR    := $(builddir)/src


LINTMAN   := $(shell find $(MANDIR)/man?/ -type f | grep '$(manext)' \
                     | xargs grep -l '^\.TH ' | sort))
_LINTDIRS := $(patsubst $(MANDIR)/%,$(_LINTDIR)/%/.,$(MANDIRS))
_SRCDIRS  := $(patsubst $(MANDIR)/%,$(_SRCDIR)/%/.,$(MANDIRS))


lint := lint-c lint-man


$(_LINTDIRS): %/.: | $$(dir %). $(_LINTDIR)/.


.PHONY: lintdirs
lintdirs: $(_LINTDIRS) $(_SRCDIRS)
	@:

.PHONY: lint
lint: $(lint)
	@:


endif
