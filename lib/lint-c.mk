########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_LINT_C_INCLUDED
MAKEFILE_LINT_C_INCLUDED := 1


include $(srcdir)/lib/build-src.mk
include $(srcdir)/lib/cmd.mk
include $(srcdir)/lib/lint.mk


DEFAULT_CHECKPATCHFLAGS :=
EXTRA_CHECKPATCHFLAGS   :=
CHECKPATCHFLAGS         := $(DEFAULT_CHECKPATCHFLAGS) $(EXTRA_CHECKPATCHFLAGS)
CHECKPATCH              := checkpatch

clang-tidy_config       := $(SYSCONFDIR)/clang-tidy/config.yaml
DEFAULT_CLANG-TIDYFLAGS := --config-file=$(clang-tidy_config)
DEFAULT_CLANG-TIDYFLAGS += --quiet
DEFAULT_CLANG-TIDYFLAGS += --use-color
EXTRA_CLANG-TIDYFLAGS   :=
CLANG-TIDYFLAGS         := $(DEFAULT_CLANG-TIDYFLAGS) $(EXTRA_CLANG-TIDYFLAGS)
CLANG-TIDY              := clang-tidy

CPPCHECK_SUPPRESS     := $(SYSCONFDIR)/cppcheck/cppcheck.suppress
DEFAULT_CPPCHECKFLAGS := --enable=all
DEFAULT_CPPCHECKFLAGS += --error-exitcode=2
DEFAULT_CPPCHECKFLAgS += --inconclusive
DEFAULT_CPPCHECKFLAGS += --quiet
DEFAULT_CPPCHECKFLAGS += --suppressions-list=$(CPPCHECK_SUPPRESS)
EXTRA_CPPCHECKFLAGS   :=
CPPCHECKFLAGS         := $(DEFAULT_CPPCHECKFLAGS) $(EXTRA_CPPCHECKFLAGS)
CPPCHECK              := cppcheck

DEFAULT_CPPLINTFLAGS :=
EXTRA_CPPLINTFLAGS   :=
CPPLINTFLAGS         := $(DEFAULT_CPPLINTFLAGS) $(EXTRA_CPPLINTFLAGS)
CPPLINT              := cpplint

DEFAULT_IWYUFLAGS := -Xiwyu --no_fwd_decls
DEFAULT_IWYUFLAGS += -Xiwyu --error
EXTRA_IWYUFLAGS   :=
IWYUFLAGS         := $(DEFAULT_IWYUFLAGS) $(EXTRA_IWYUFLAGS)
IWYU              := iwyu


_LINT_c_checkpatch := $(patsubst %.c,%.lint-c.checkpatch.touch,$(_UNITS_src_c))
_LINT_c_clang-tidy := $(patsubst %.c,%.lint-c.clang-tidy.touch,$(_UNITS_src_c))
_LINT_c_cppcheck   := $(patsubst %.c,%.lint-c.cppcheck.touch,$(_UNITS_src_c))
_LINT_c_cpplint    := $(patsubst %.c,%.lint-c.cpplint.touch,$(_UNITS_src_c))
_LINT_c_iwyu       := $(patsubst %.c,%.lint-c.iwyu.touch,$(_UNITS_src_c))


linters_c := checkpatch clang-tidy cppcheck cpplint iwyu
lint_c    := $(foreach x,$(linters_c),lint-c-$(x))


$(_LINT_c_checkpatch): %.lint-c.checkpatch.touch: %.c
	$(info LINT (checkpatch)	$@)
	$(CHECKPATCH) $(CHECKPATCHFLAGS) -f $<
	touch $@

$(_LINT_c_clang-tidy): %.lint-c.clang-tidy.touch: %.c
	$(info LINT (clang-tidy)	$@)
	$(CLANG-TIDY) $(CLANG-TIDYFLAGS) $< -- $(CPPFLAGS) $(CFLAGS) 2>&1 \
	| $(SED) '/generated\.$$/d'
	touch $@

$(_LINT_c_cppcheck): %.lint-c.cppcheck.touch: %.c
	$(info LINT (cppcheck)	$@)
	$(CPPCHECK) $(CPPCHECKFLAGS) $<
	touch $@

$(_LINT_c_cpplint): %.lint-c.cpplint.touch: %.c
	$(info LINT (cpplint)	$@)
	$(CPPLINT) $(CPPLINTFLAGS) $< >/dev/null
	touch $@

$(_LINT_c_iwyu): %.lint-c.iwyu.touch: %.c
	$(info LINT (iwyu)	$@)
	$(IWYU) $(IWYUFLAGS) $(CPPFLAGS) $(CFLAGS) $< 2>&1 \
	| $(TAC) \
	| $(SED) '/correct/{N;d}' \
	| $(TAC)
	touch $@


.PHONY: $(lint_c)
$(lint_c): lint-c-%: $$(_LINT_c_%)
	@:

.PHONY: lint-c
lint-c: $(lint_c)
	@:


endif  # MAKEFILE_LINT_C_INCLUDED
