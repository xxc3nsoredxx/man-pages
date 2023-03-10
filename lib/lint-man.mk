########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_LINT_MAN_INCLUDED
MAKEFILE_LINT_MAN_INCLUDED := 1


include $(srcdir)/lib/cmd.mk
include $(srcdir)/lib/lint.mk
include $(srcdir)/lib/src.mk


TMACDIR := $(SYSCONFDIR)/groff/tmac


MANWIDTH          ?= 80
TROFF_LINE_LENGTH := $(shell $(EXPR) $(MANWIDTH) - 2)
TROFF_OUT_DEVICE  := $(shell $(LOCALE) charmap \
                             | $(GREP) -i 'utf-*8' >/dev/null \
                                 && $(ECHO) utf8 \
                                 || $(ECHO) ascii)

DEFAULT_PRECONVFLAGS :=
EXTRA_PRECONVFLAGS   :=
PRECONVFLAGS         := $(DEFAULT_PRECONVFLAGS) $(EXTRA_PRECONVFLAGS)
PRECONV              := preconv

TBL := tbl

DEFAULT_EQNFLAGS := -T$(TROFF_OUT_DEVICE)
EXTRA_EQNFLAGS   :=
EQNFLAGS         := $(DEFAULT_EQNFLAGS) $(EXTRA_EQNFLAGS)
EQN              := eqn

TMACFILES            := $(shell $(FIND) $(TMACDIR) -not -type d | $(SORT))
TMACNAMES            := $(basename $(notdir $(TMACFILES)))
TROFF_CHECKSTYLE_LVL := 3
DEFAULT_TROFFFLAGS   := -man
DEFAULT_TROFFFLAGS   += -t
DEFAULT_TROFFFLAGS   += -M $(TMACDIR)
DEFAULT_TROFFFLAGS   += $(foreach x,$(TMACNAMES),-m $(x))
DEFAULT_TROFFFLAGS   += -rCHECKSTYLE=$(TROFF_CHECKSTYLE_LVL)
DEFAULT_TROFFFLAGS   += -ww
DEFAULT_TROFFFLAGS   += -T$(TROFF_OUT_DEVICE)
DEFAULT_TROFFFLAGS   += -rLL=$(TROFF_LINE_LENGTH)n
EXTRA_TROFFFLAGS     :=
TROFFFLAGS           := $(DEFAULT_TROFFFLAGS) $(EXTRA_TROFFFLAGS)
TROFF                := troff

DEFAULT_GROTTYFLAGS := -c
EXTRA_GROTTYFLAGS   :=
GROTTYFLAGS         := $(DEFAULT_GROTTYFLAGS) $(EXTRA_GROTTYFLAGS)
GROTTY              := grotty

DEFAULT_COLFLAGS := -b
DEFAULT_COLFLAGS += -p
DEFAULT_COLFLAGS += -x
EXTRA_COLFLAGS   :=
COLFLAGS         := $(DEFAULT_COLFLAGS) $(EXTRA_COLFLAGS)
COL              := col

DEFAULT_MANDOCFLAGS := -man
DEFAULT_MANDOCFLAGS += -Tlint
EXTRA_MANDOCFLAGS   :=
MANDOCFLAGS         := $(DEFAULT_MANDOCFLAGS) $(EXTRA_MANDOCFLAGS)
MANDOC              := mandoc


_LINT_man_groff_tbl    :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.tbl,$(LINTMAN))
_LINT_man_groff_eqn    :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.eqn,$(LINTMAN))
_LINT_man_groff_troff  :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.troff,$(LINTMAN))
_LINT_man_groff_grotty :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.grotty,$(LINTMAN))
_LINT_man_groff_col    :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.col,$(LINTMAN))
_LINT_man_groff_grep   :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.grep,$(LINTMAN))

_LINT_man_groff :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint-man.groff.touch,$(LINTMAN))
_LINT_man_mandoc:=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint-man.mandoc.touch,$(LINTMAN))
_LINT_man_tbl   :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint-man.tbl.touch,$(LINTMAN))


linters_man := groff mandoc tbl
lint_man    := $(foreach x,$(linters_man),lint-man-$(x))


$(_LINT_man_groff_tbl): $(_LINTDIR)/%.tbl: $(MANDIR)/% | $$(@D)/.
	$(info LINT (preconv)	$@)
	$(PRECONV) $(PRECONVFLAGS) $< >$@

$(_LINT_man_groff_eqn): %.eqn: %.tbl | $$(@D)/.
	$(info LINT (tbl)	$@)
	$(TBL) <$< >$@

$(_LINT_man_groff_troff): %.troff: %.eqn | $$(@D)/.
	$(info LINT (eqn)	$@)
	$(EQN) $(EQNFLAGS) <$< 2>&1 >$@ \
	| ( ! $(GREP) . )

$(_LINT_man_groff_grotty): %.grotty: %.troff | $$(@D)/.
	$(info LINT (troff)	$@)
	$(TROFF) $(TROFFFLAGS) <$< >$@

$(_LINT_man_groff_col): %.col: %.grotty | $$(@D)/.
	$(info LINT (grotty)	$@)
	$(GROTTY) $(GROTTYFLAGS) <$< >$@

$(_LINT_man_groff_grep): %.grep: %.col | $$(@D)/.
	$(info LINT (col)	$@)
	$(COL) $(COLFLAGS) <$< >$@

$(_LINT_man_groff): %.lint-man.groff.touch: %.grep | $$(@D)/.
	$(info LINT (grep)	$@)
	! $(GREP) -n '.\{$(MANWIDTH)\}.' $< /dev/null >&2
	touch $@

$(_LINT_man_mandoc): $(_LINTDIR)/%.lint-man.mandoc.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (mandoc)	$@)
	! ($(MANDOC) $(MANDOCFLAGS) $< 2>&1 \
	   | $(GREP) -v 'STYLE: lower case character in document title:' \
	   | $(GREP) -v 'UNSUPP: ignoring macro in table:' \
	   | $(GREP) -v 'WARNING: cannot parse date, using it verbatim: TH (date)' \
	   | $(GREP) -v 'WARNING: empty block: UR' \
	   | $(GREP) -v 'WARNING: missing date, using "": TH' \
	   | $(GREP) -v 'WARNING: undefined escape, printing literally: \\\\' \
	   ||:; \
	) \
	| $(GREP) '.' >&2
	touch $@

$(_LINT_man_tbl): $(_LINTDIR)/%.lint-man.tbl.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (tbl comment)	$@)
	if $(GREP) -q '^\.TS$$' $< && ! $(HEAD) -n1 $< | $(GREP) -q '\\" t$$'; \
	then \
		>&2 $(ECHO) "$<:1: missing '\\\" t' comment:"; \
		>&2 $(HEAD) -n1 <$<; \
		exit 1; \
	fi
	if $(HEAD) -n1 $< | $(GREP) -q '\\" t$$' && ! $(GREP) -q '^\.TS$$' $<; \
	then \
		>&2 $(ECHO) "$<:1: spurious '\\\" t' comment:"; \
		>&2 $(HEAD) -n1 <$<; \
		exit 1; \
	fi
	if $(TAIL) -n+2 <$< | $(GREP) -q '\\" t$$'; \
	then \
		>&2 $(ECHO) "$<: spurious '\\\" t' not in first line:"; \
		>&2 $(GREP) -n '\\" t$$' $< /dev/null; \
		exit 1; \
	fi
	touch $@


.PHONY: lint-man-groff-preconv
lint-man-groff-preconv: $(_LINT_man_groff_tbl)
	@:

.PHONY: lint-man-groff-tbl
lint-man-groff-tbl: $(_LINT_man_groff_eqn)
	@:

.PHONY: lint-man-groff-eqn
lint-man-groff-eqn: $(_LINT_man_groff_troff)
	@:

.PHONY: lint-man-groff-troff
lint-man-groff-troff: $(_LINT_man_groff_grotty)
	@:

.PHONY: lint-man-groff-grotty
lint-man-groff-grotty: $(_LINT_man_groff_col)
	@:

.PHONY: lint-man-groff-col
lint-man-groff-col: $(_LINT_man_groff_grep)
	@:

.PHONY: lint-man-groff-grep
lint-man-groff-grep: $(_LINT_man_groff)
	@:

.PHONY: $(lint_man)
$(lint_man): lint-man-%: $$(_LINT_man_%)
	@:

.PHONY: lint-man
lint-man: $(lint_man)
	@:


endif  # MAKEFILE_LINT_MAN_INCLUDED
