########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_BUILD_SRC_INCLUDED
MAKEFILE_BUILD_SRC_INCLUDED := 1


include $(srcdir)/lib/build.mk
include $(srcdir)/lib/cmd.mk
include $(srcdir)/lib/lint.mk
include $(srcdir)/lib/src.mk
include $(srcdir)/lib/verbose.mk


PKG-CONFIG_LIBS := libbsd-overlay


DEFAULT_CPPFLAGS := $(shell $(PKG-CONFIG) --cflags $(PKG-CONFIG_LIBS) $(HIDE_ERR))
EXTRA_CPPFLAGS   :=
CPPFLAGS         := $(DEFAULT_CPPFLAGS) $(EXTRA_CPPFLAGS)

DEFAULT_CFLAGS := -std=gnu17
DEFAULT_CFLAGS += -Wall
DEFAULT_CFLAGS += -Wextra
DEFAULT_CFLAGS += -Wstrict-prototypes
DEFAULT_CFLAGS += -Wdeclaration-after-statement
DEFAULT_CFLAGS += -Werror
DEFAULT_CFLAGS += -Wno-error=unused-parameter
DEFAULT_CFLAGS += -Wno-error=sign-compare
DEFAULT_CFLAGS += -Wno-error=format
DEFAULT_CFLAGS += -Wno-error=uninitialized
#DEFAULT_CFLAGS += -Wno-error=declaration-after-statement
EXTRA_CFLAGS   :=
CFLAGS         := $(DEFAULT_CFLAGS) $(EXTRA_CFLAGS)

DEFAULT_LDFLAGS := -Wl,--as-needed
DEFAULT_LDFLAGS += -Wl,--no-allow-shlib-undefined
DEFAULT_LDFLAGS += -Wl,--no-copy-dt-needed-entries
DEFAULT_LDFLAGS += -Wl,--no-undefined
DEFAULT_LDFLAGS += $(shell $(PKG-CONFIG) --libs-only-L $(PKG-CONFIG_LIBS) $(HIDE_ERR))
DEFAULT_LDFLAGS += $(shell $(PKG-CONFIG) --libs-only-other $(PKG-CONFIG_LIBS) $(HIDE_ERR))
EXTRA_LDFLAGS   :=
LDFLAGS         := $(DEFAULT_LDFLAGS) $(EXTRA_LDFLAGS)

DEFAULT_LDLIBS := -lc
DEFAULT_LDLIBS += $(shell $(PKG-CONFIG) --libs-only-l $(PKG-CONFIG_LIBS) $(HIDE_ERR))
EXTRA_LDLIBS   :=
LDLIBS         := $(DEFAULT_LDLIBS) $(EXTRA_LDLIBS)


CC  := cc
LD  := $(CC) $(CFLAGS)
MAN := man


_SRCPAGEDIRS   := $(patsubst $(MANDIR)/%,$(_SRCDIR)/%.d,$(LINTMAN))

_UNITS_src_src := $(patsubst $(MANDIR)/%,$(_SRCDIR)/%,$(shell \
		$(FIND) $(MANDIR)/man*/ -type f \
		| $(GREP) '$(MANEXT)' \
		| $(XARGS) $(GREP) -l '^\.TH ' \
		| while read m; do \
		    <$$m \
		    $(SED) -n "s,^\... SRC BEGIN (\(.*.[ch]\))$$,$$m.d/\1,p"; \
		done \
		| $(SORT)))
_UNITS_src_h   := $(filter %.h,$(_UNITS_src_src))
_UNITS_src_c   := $(filter %.c,$(_UNITS_src_src))
_UNITS_src_o   := $(patsubst %.c,%.o,$(_UNITS_src_c))
_UNITS_src_bin := $(patsubst %.c,%,$(_UNITS_src_c))


$(_SRCPAGEDIRS): $(_SRCDIR)/%.d: $(MANDIR)/% | $$(@D)/.
	$(info MKDIR	$@)
	$(MKDIR) $@
	touch $@

$(_UNITS_src_src): $$(patsubst $(_SRCDIR)/%.d,$(MANDIR)/%,$$(@D)) | $$(@D)
$(_UNITS_src_c):   $$(filter $$(@D)/%.h,$(_UNITS_src_h))
$(_UNITS_src_src):
	$(info SED	$@)
	<$< \
	$(SED) -n \
		-e '/^\.TH/,/^\.SH/{/^\.SH/!p}' \
		-e '/^\.SH EXAMPLES/p' \
		-e "/^\... SRC BEGIN ($(@F))$$/,/^\... SRC END$$/p" \
	| $(MAN) -P cat -l - \
	| $(SED) '/^[^ ]/d' \
	| $(SED) 's/^       //' \
	>$@

$(_UNITS_src_o): $(_SRCDIR)/%.o: $(_SRCDIR)/%.c
	$(info CC	$@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(_UNITS_src_bin): $(_SRCDIR)/%: $(_SRCDIR)/%.o
	$(info LD	$@)
	$(LD) $(LDFLAGS) -o $@ $< $(LDLIBS)


.PHONY: build-src-c
build-src-c:   $(_UNITS_src_c)
	@:

.PHONY: build-src-cc
build-src-cc:  $(_UNITS_src_o)
	@:

.PHONY: build-src-ld
build-src-ld:  $(_UNITS_src_bin)
	@:

.PHONY: build-src
build-src: build-src-ld


endif  # MAKEFILE_BUILD_SRC_INCLUDED
