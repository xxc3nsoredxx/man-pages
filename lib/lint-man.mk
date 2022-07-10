########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_LINT_MAN_INCLUDED
MAKEFILE_LINT_MAN_INCLUDED := 1


TMACDIR := $(SYSCONFDIR)/groff/tmac


TMACFILES            := $(sort $(shell find $(TMACDIR) -not -type d))
TMACNAMES            := $(basename $(notdir $(TMACFILES)))
GROFF_CHECKSTYLE_LVL := 3
DEFAULT_GROFFFLAGS   := -man
DEFAULT_GROFFFLAGS   += -t
DEFAULT_GROFFFLAGS   += -M $(TMACDIR)
DEFAULT_GROFFFLAGS   += $(foreach x,$(TMACNAMES),-m $(x))
DEFAULT_GROFFFLAGS   += -rCHECKSTYLE=$(GROFF_CHECKSTYLE_LVL)
DEFAULT_GROFFFLAGS   += -ww
EXTRA_GROFFFLAGS     :=
GROFFFLAGS           := $(DEFAULT_GROFFFLAGS) $(EXTRA_GROFFFLAGS)
GROFF                := groff

DEFAULT_MANDOCFLAGS := -man
DEFAULT_MANDOCFLAGS += -Tlint
EXTRA_MANDOCFLAGS   :=
MANDOCFLAGS         := $(DEFAULT_MANDOCFLAGS) $(EXTRA_MANDOCFLAGS)
MANDOC              := mandoc


_LINT_man_groff :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint-man.groff.touch,$(LINTMAN))
_LINT_man_mandoc:=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint-man.mandoc.touch,$(LINTMAN))


linters_man := groff mandoc
lint_man    := $(foreach x,$(linters_man),lint-man-$(x))


$(_LINT_man_groff): $(_LINTDIR)/%.lint-man.groff.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (groff)	$@)
	$(GROFF) $(GROFFFLAGS) -z $<
	touch $@

$(_LINT_man_mandoc): $(_LINTDIR)/%.lint-man.mandoc.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (mandoc)	$@)
	$(MANDOC) $(MANDOCFLAGS) $<
	touch $@


.PHONY: $(lint_man)
$(lint_man): lint-man-%: $$(_LINT_man_%) | lintdirs
	@:

.PHONY: lint-man
lint-man: $(lint_man)
	@:


endif  # MAKEFILE_LINT_MAN_INCLUDED
