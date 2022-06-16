########################################################################
# Copyright (C) 2021        Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################
# Conventions:
#
# - Follow "Makefile Conventions" from the "GNU Coding Standards" closely.
#   However, when something could be improved, don't follow those.
# - Uppercase variables, when referring files, refer to files in this repo.
# - Lowercase variables, when referring files, refer to system files.
# - Lowercase variables starting with '_' refer to absolute paths,
#   including $(DESTDIR).
# - Uppercase variables starting with '_' refer to temporary files produced
#   in $builddir.
# - Variables ending with '_' refer to a subdir of their parent dir, which
#   is in a variable of the same name but without the '_'.  The subdir is
#   named after this project: <*/man>.
# - Variables ending in '_rm' refer to files that can be removed (exist).
# - Variables ending in '_rmdir' refer to dirs that can be removed (exist).
# - Targets of the form '%-rm' remove their corresponding file '%'.
# - Targets of the form '%/.-rmdir' remove their corresponding dir '%/'.
# - Targets of the form '%/.' create their corresponding directory '%/'.
# - Every file or directory to be created depends on its parent directory.
#   This avoids race conditions caused by `mkdir -p`.  Only the root
#   directories are created with parents.
# - The 'FORCE' target is used to make phony some variables that can't be
#   .PHONY to avoid some optimizations.
#
########################################################################

SHELL := /bin/bash -Eeuo pipefail


MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables


srcdir   := .
builddir := tmp
DESTDIR  :=
prefix   := /usr/local

SYSCONFDIR  := $(srcdir)/etc
TMACDIR     := $(SYSCONFDIR)/groff/tmac
MANDIR      := $(srcdir)
MAN0DIR     := $(MANDIR)/man0
MAN1DIR     := $(MANDIR)/man1
MAN2DIR     := $(MANDIR)/man2
MAN3DIR     := $(MANDIR)/man3
MAN4DIR     := $(MANDIR)/man4
MAN5DIR     := $(MANDIR)/man5
MAN6DIR     := $(MANDIR)/man6
MAN7DIR     := $(MANDIR)/man7
MAN8DIR     := $(MANDIR)/man8

datarootdir := $(prefix)/share
docdir      := $(datarootdir)/doc
mandir      := $(datarootdir)/man
man0dir     := $(mandir)/man0
man1dir     := $(mandir)/man1
man2dir     := $(mandir)/man2
man3dir     := $(mandir)/man3
man4dir     := $(mandir)/man4
man5dir     := $(mandir)/man5
man6dir     := $(mandir)/man6
man7dir     := $(mandir)/man7
man8dir     := $(mandir)/man8
manext      := \.[0-9]\w*
man0ext     := .0
man1ext     := .1
man2ext     := .2
man2type_ext:= .2type
man3ext     := .3
man3type_ext:= .3type
man4ext     := .4
man5ext     := .5
man6ext     := .6
man7ext     := .7
man8ext     := .8
htmldir     := $(docdir)
htmlext     := .html

htmldir_    := $(htmldir)/man

_LINTDIR    := $(builddir)/lint
_HTMLDIR    := $(builddir)/html
_SRCDIR     := $(builddir)/src

_mandir     := $(DESTDIR)$(mandir)
_htmldir    := $(DESTDIR)$(htmldir_)


DEFAULT_CHECKPATCHFLAGS :=
EXTRA_CHECKPATCHFLAGS   :=
CHECKPATCHFLAGS         := $(DEFAULT_CHECKPATCHFLAGS) $(EXTRA_CHECKPATCHFLAGS)

clang-tidy_config       := $(SYSCONFDIR)/clang-tidy/config.yaml
DEFAULT_CLANG-TIDYFLAGS := --config-file=$(clang-tidy_config)
DEFAULT_CLANG-TIDYFLAGS += --quiet
DEFAULT_CLANG-TIDYFLAGS += --use-color
EXTRA_CLANG-TIDYFLAGS   :=
CLANG-TIDYFLAGS         := $(DEFAULT_CLANG-TIDYFLAGS) $(EXTRA_CLANG-TIDYFLAGS)

DEFAULT_CPPLINTFLAGS :=
EXTRA_CPPLINTFLAGS   :=
CPPLINTFLAGS         := $(DEFAULT_CPPLINTFLAGS) $(EXTRA_CPPLINTFLAGS)

DEFAULT_IWYUFLAGS := -Xiwyu --no_fwd_decls
DEFAULT_IWYUFLAGS += -Xiwyu --error
EXTRA_IWYUFLAGS   :=
IWYUFLAGS         := $(DEFAULT_IWYUFLAGS) $(EXTRA_IWYUFLAGS)

DEFAULT_CPPFLAGS :=
EXTRA_CPPFLAGS   :=
CPPFLAGS         := $(DEFAULT_CPPFLAGS) $(EXTRA_CPPFLAGS)

DEFAULT_CFLAGS := -std=gnu17
DEFAULT_CFLAGS += -Wall
DEFAULT_CFLAGS += -Wextra
DEAFULT_CFLAGS += -Wstrict-prototypes
DEFAULT_CFLAGS += -Werror
DEFAULT_CFLAGS += -Wno-error=unused-parameter
DEFAULT_CFLAGS += -Wno-error=sign-compare
DEFAULT_CFLAGS += -Wno-error=format
DEFAULT_CFLAGS += -Wno-error=uninitialized
EXTRA_CFLAGS   :=
CFLAGS         := $(DEFAULT_CFLAGS) $(EXTRA_CFLAGS)

DEFAULT_LDFLAGS := -Wl,--as-needed
DEFAULT_LDFLAGS += -Wl,--no-allow-shlib-undefined
DEFAULT_LDFLAGS += -Wl,--no-copy-dt-needed-entries
DEFAULT_LDFLAGS += -Wl,--no-undefined
EXTRA_LDFLAGS   :=
LDFLAGS         := $(DEFAULT_LDFLAGS) $(EXTRA_LDFLAGS)

DEFAULT_LDLIBS := -lc
EXTRA_LDLIBS   :=
LDLIBS         := $(DEFAULT_LDLIBS) $(EXTRA_LDLIBS)

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

DEFAULT_MANDOCFLAGS := -man
DEFAULT_MANDOCFLAGS += -Tlint
EXTRA_MANDOCFLAGS   :=
MANDOCFLAGS         := $(DEFAULT_MANDOCFLAGS) $(EXTRA_MANDOCFLAGS)

DEFAULT_MAN2HTMLFLAGS :=
EXTRA_MAN2HTMLFLAGS   :=
MAN2HTMLFLAGS         := $(DEFAULT_MAN2HTMLFLAGS) $(EXTRA_MAN2HTMLFLAGS)


INSTALL      := install
INSTALL_DATA := $(INSTALL) -m 644
INSTALL_DIR  := $(INSTALL) -m 755 -d
MKDIR        := mkdir -p
RM           := rm
RMDIR        := rmdir --ignore-fail-on-non-empty
CHECKPATCH   := checkpatch
CLANG-TIDY   := clang-tidy
CPPLINT      := cpplint
IWYU         := iwyu
CC           := cc
LD           := $(CC) $(CFLAGS)
GROFF        := groff
MAN          := man
MANDOC       := mandoc
MAN2HTML     := man2html


MAN_SECTIONS := 0 1 2 3 4 5 6 7 8


.PHONY: all
all:
	$(MAKE) uninstall
	$(MAKE) install

%/.:
	$(info INSTALL	$(@D)/)
	$(INSTALL_DIR) $(@D)

%-rm:
	$(info RM	$*)
	$(RM) $*

%-rmdir:
	$(info RMDIR	$(@D))
	$(RMDIR) $(@D)


.PHONY: install
install: install-man | installdirs
	@:

.PHONY: installdirs
installdirs: | installdirs-man
	@:

.PHONY: uninstall remove
uninstall remove: uninstall-man
	@:

.PHONY: clean
clean:
	$(RM) -rf $(builddir)


########################################################################
# man

MANPAGES   := $(sort $(shell find $(MANDIR)/man?/ -type f | grep '$(manext)'))
LINTMAN    := $(sort $(shell find $(MANDIR)/man?/ -type f | grep '$(manext)' \
                             | xargs grep -l '^\.TH '))
_HTMLPAGES  := $(patsubst $(MANDIR)/%,$(_HTMLDIR)/%.html,$(MANPAGES))
_htmlpages  := $(patsubst $(_HTMLDIR)/%,$(_htmldir)/%,$(_HTMLPAGES))
_manpages   := $(patsubst $(MANDIR)/%,$(_mandir)/%,$(MANPAGES))
_man0pages  := $(filter %$(man0ext),$(_manpages))
_man1pages  := $(filter %$(man1ext),$(_manpages))
_man2pages  := $(filter %$(man2ext),$(_manpages))
_man2pages  += $(filter %$(man2type_ext),$(_manpages))
_man3pages  := $(filter %$(man3ext),$(_manpages))
_man3pages  += $(filter %$(man3type_ext),$(_manpages))
_man4pages  := $(filter %$(man4ext),$(_manpages))
_man5pages  := $(filter %$(man5ext),$(_manpages))
_man6pages  := $(filter %$(man6ext),$(_manpages))
_man7pages  := $(filter %$(man7ext),$(_manpages))
_man8pages  := $(filter %$(man8ext),$(_manpages))
_LINT_groff :=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint.groff.touch,$(LINTMAN))
_LINT_mandoc:=$(patsubst $(MANDIR)/%,$(_LINTDIR)/%.lint.mandoc.touch,$(LINTMAN))
_SRCPAGEDIRS:=$(patsubst $(MANDIR)/%,$(_SRCDIR)/%.d,$(LINTMAN))
_UNITS_src  :=$(sort $(patsubst $(MANDIR)/%,$(_SRCDIR)/%,$(shell \
		find $(MANDIR)/man?/ -type f \
		| grep '$(manext)$$' \
		| xargs grep -l '^\.TH ' \
		| while read m; do \
			<$$m \
			sed -n "s,^\... SRC BEGIN (\(.*.[ch]\))$$,$$m.d/\1,p"; \
		done)))
_UNITS_h    := $(filter %.h,$(_UNITS_src))
_UNITS_c    := $(filter %.c,$(_UNITS_src))
_UNITS_o    := $(patsubst %.c,%.o,$(_UNITS_c))
_UNITS_bin  := $(patsubst %.c,%,$(_UNITS_c))
_LINT_checkpatch := $(patsubst %.c,%.lint.checkpatch.touch,$(_UNITS_c))
_LINT_clang-tidy := $(patsubst %.c,%.lint.clang-tidy.touch,$(_UNITS_c))
_LINT_cpplint    := $(patsubst %.c,%.lint.cpplint.touch,$(_UNITS_c))
_LINT_iwyu       := $(patsubst %.c,%.lint.iwyu.touch,$(_UNITS_c))

MANDIRS   := $(sort $(shell find $(MANDIR)/man? -type d))
_HTMLDIRS  := $(patsubst $(MANDIR)/%,$(_HTMLDIR)/%/.,$(MANDIRS))
_LINTDIRS  := $(patsubst $(MANDIR)/%,$(_LINTDIR)/%/.,$(MANDIRS))
_SRCDIRS   := $(patsubst $(MANDIR)/%,$(_SRCDIR)/%/.,$(MANDIRS))
_htmldirs := $(patsubst $(_HTMLDIR)/%,$(_htmldir)/%,$(_HTMLDIRS))
_mandirs  := $(patsubst $(MANDIR)/%,$(_mandir)/%/.,$(MANDIRS))
_man0dir  := $(filter %man0/.,$(_mandirs))
_man1dir  := $(filter %man1/.,$(_mandirs))
_man2dir  := $(filter %man2/.,$(_mandirs))
_man3dir  := $(filter %man3/.,$(_mandirs))
_man4dir  := $(filter %man4/.,$(_mandirs))
_man5dir  := $(filter %man5/.,$(_mandirs))
_man6dir  := $(filter %man6/.,$(_mandirs))
_man7dir  := $(filter %man7/.,$(_mandirs))
_man8dir  := $(filter %man8/.,$(_mandirs))

_htmlpages_rm := $(addsuffix -rm,$(wildcard $(_htmlpages)))
_man0pages_rm := $(addsuffix -rm,$(wildcard $(_man0pages)))
_man1pages_rm := $(addsuffix -rm,$(wildcard $(_man1pages)))
_man2pages_rm := $(addsuffix -rm,$(wildcard $(_man2pages)))
_man3pages_rm := $(addsuffix -rm,$(wildcard $(_man3pages)))
_man4pages_rm := $(addsuffix -rm,$(wildcard $(_man4pages)))
_man5pages_rm := $(addsuffix -rm,$(wildcard $(_man5pages)))
_man6pages_rm := $(addsuffix -rm,$(wildcard $(_man6pages)))
_man7pages_rm := $(addsuffix -rm,$(wildcard $(_man7pages)))
_man8pages_rm := $(addsuffix -rm,$(wildcard $(_man8pages)))

_htmldirs_rmdir := $(addsuffix -rmdir,$(wildcard $(_htmldirs)))
_mandirs_rmdir  := $(addsuffix -rmdir,$(wildcard $(_mandirs)))
_man0dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man0dir)))
_man1dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man1dir)))
_man2dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man2dir)))
_man3dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man3dir)))
_man4dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man4dir)))
_man5dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man5dir)))
_man6dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man6dir)))
_man7dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man7dir)))
_man8dir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_man8dir)))
_mandir_rmdir   := $(addsuffix -rmdir,$(wildcard $(_mandir)/.))
_htmldir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_htmldir)/.))

install_manX     := $(foreach x,$(MAN_SECTIONS),install-man$(x))
installdirs_manX := $(foreach x,$(MAN_SECTIONS),installdirs-man$(x))
uninstall_manX   := $(foreach x,$(MAN_SECTIONS),uninstall-man$(x))


.SECONDEXPANSION:
$(_manpages): $(_mandir)/man%: $(MANDIR)/man% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@

$(_mandirs): %/.: | $$(dir %). $(_mandir)/.

$(_mandirs_rmdir): $(_mandir)/man%/.-rmdir: $$(_man%pages_rm) FORCE
$(_mandir_rmdir): $(uninstall_manX) FORCE


.PHONY: $(install_manX)
$(install_manX): install-man%: $$(_man%pages) | installdirs-man%
	@:

.PHONY: install-man
install-man: $(install_manX)
	@:

.PHONY: $(installdirs_manX)
$(installdirs_manX): installdirs-man%: $$(_man%dir)
	@:

.PHONY: installdirs-man
installdirs-man: $(installdirs_manX)
	@:

.PHONY: $(uninstall_manX)
$(uninstall_manX): uninstall-man%: $$(_man%pages_rm) $$(_man%dir_rmdir)
	@:

.PHONY: uninstall-man
uninstall-man: $(_mandir_rmdir) $(uninstall_manX)
	@:


########################################################################
# dist

DISTNAME    := $(shell git describe 2>/dev/null)
DISTFILE    := $(builddir)/$(DISTNAME).tar
compression := gz xz
dist        := $(foreach x,$(compression),dist-$(x))


$(DISTFILE): $(shell git ls-files 2>/dev/null) | $$(@D)/.
	$(info TAR	$@)
	tar cf $@ -T /dev/null
	git ls-files \
	| xargs tar rf $@

$(DISTFILE).gz: %.gz: % | $$(@D)/.
	$(info GZIP	$@)
	gzip -knf $<

$(DISTFILE).xz: %.xz: % | $$(@D)/.
	$(info XZ	$@)
	xz -kf $<


.PHONY: dist-tar
dist-tar: $(DISTFILE) | builddirs-dist
	@:

.PHONY: $(dist)
$(dist): dist-%: $(DISTFILE).% | builddirs-dist
	@:

.PHONY: builddirs-dist
builddirs-dist: $(builddir)/.
	@:

.PHONY: dist
dist: $(dist)
	@:


########################################################################
# src

$(_SRCPAGEDIRS): $(_SRCDIR)/%.d: $(MANDIR)/% | $$(@D)/.
	$(info MKDIR	$@)
	$(MKDIR) $@
	touch $@

$(_UNITS_src): $$(patsubst $(_SRCDIR)/%.d,$(MANDIR)/%,$$(@D)) | $$(@D)
$(_UNITS_c):   $$(filter $$(@D)/%.h,$(_UNITS_h))
$(_UNITS_src):
	$(info SED	$@)
	<$< \
	sed -n \
		-e '/^\.TH/,/^\.SH/{/^\.SH/!p}' \
		-e '/^\.SH EXAMPLES/p' \
		-e "/^\... SRC BEGIN ($(@F))$$/,/^\... SRC END$$/p" \
	| $(MAN) -P cat -l - \
	| sed '/^[^ ]/d' \
	| sed 's/^       //' \
	>$@

$(_UNITS_o): $(_SRCDIR)/%.o: $(_SRCDIR)/%.c
	$(info CC	$@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(_UNITS_bin): $(_SRCDIR)/%: $(_SRCDIR)/%.o
	$(info LD	$@)
	$(LD) $(LDFLAGS) -o $@ $< $(LDLIBS)

$(_SRCDIRS): %/.: | $$(dir %). $(_SRCDIR)/.


.PHONY: build-src src
build-src src: $(_UNITS_c) | builddirs-src
	@:

.PHONY: build-cc
build-cc: $(_UNITS_o)
	@:

.PHONY: build-ld
build-ld: $(_UNITS_bin)
	@:

.PHONY: builddirs-src
builddirs-src: $(_SRCDIRS)
	@:


########################################################################
# lint

linters := checkpatch clang-tidy cpplint iwyu groff mandoc
lint    := $(foreach x,$(linters),lint-$(x))

$(_LINT_checkpatch): %.lint.checkpatch.touch: %.c
	$(info LINT (checkpatch)	$@)
	$(CHECKPATCH) $(CHECKPATCHFLAGS) -f $<
	touch $@

$(_LINT_clang-tidy): %.lint.clang-tidy.touch: %.c
	$(info LINT (clang-tidy)	$@)
	$(CLANG-TIDY) $(CLANG-TIDYFLAGS) $< -- $(CPPFLAGS) $(CFLAGS) 2>&1 \
	| sed '/generated\.$$/d'
	touch $@

$(_LINT_cpplint): %.lint.cpplint.touch: %.c
	$(info LINT (cpplint)	$@)
	$(CPPLINT) $(CPPLINTFLAGS) $< >/dev/null
	touch $@

$(_LINT_iwyu): %.lint.iwyu.touch: %.c
	$(info LINT (iwyu)	$@)
	$(IWYU) $(IWYUFLAGS) $(CPPFLAGS) $(CFLAGS) $< 2>&1 \
	| tac \
	| sed '/correct/{N;d}' \
	| tac
	touch $@

$(_LINT_groff): $(_LINTDIR)/%.lint.groff.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (groff)	$@)
	$(GROFF) $(GROFFFLAGS) -z $<
	touch $@

$(_LINT_mandoc): $(_LINTDIR)/%.lint.mandoc.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (mandoc)	$@)
	$(MANDOC) $(MANDOCFLAGS) $<
	touch $@

$(_LINTDIRS): %/.: | $$(dir %). $(_LINTDIR)/.


.PHONY: $(lint)
$(lint): lint-%: $$(_LINT_%) | lintdirs
	@:

.PHONY: lintdirs
lintdirs: $(_LINTDIRS) $(_SRCDIRS)
	@:

.PHONY: lint
lint: $(lint)
	@:


########################################################################
# html

# Use with
#  make MAN2HTMLFLAGS=whatever html
# The sed removes the lines "Content-type: text/html\n\n"
$(_HTMLPAGES): $(_HTMLDIR)/%.html: $(MANDIR)/% | $$(@D)/.
	$(info MAN2HTML	$@)
	$(MAN2HTML) $(MAN2HTMLFLAGS) $< | sed -e 1,2d >$@

$(_HTMLDIRS): %/.: | $$(dir %). $(_HTMLDIR)/.

$(_htmlpages): $(_htmldir)/%: $(_HTMLDIR)/% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@

$(_htmldirs): %/.: | $$(dir %). $(_htmldir)/.


.PHONY: build-html html
build-html html: $(_HTMLPAGES) | builddirs-html
	@:

.PHONY: builddirs-html
builddirs-html: $(_HTMLDIRS)
	@:

.PHONY: install-html
install-html: $(_htmlpages) | installdirs-html
	@:

.PHONY: installdirs-html
installdirs-html: $(_htmldirs)
	@:

.PHONY: uninstall-html
uninstall-html: $(_htmldir_rmdir) $(_htmldirs_rmdir) $(_htmlpages_rm)
	@:


########################################################################

$(V).SILENT:
FORCE:
