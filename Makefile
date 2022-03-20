########################################################################
# Copyright (C) 2021        Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################
# Conventions:
#
# - Follow "Makefile Conventions" from the "GNU Coding Standards" closely.
#   However, when something could be improved, don't follow those.
# - Uppercase variables, when referring files, refer to files in this repo,
#   or temporary files produced in $builddir.
# - Lowercase variables, when referring files, refer to system files.
# - Variables starting with '_' refer to absolute paths, including $(DESTDIR).
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

MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables


srcdir := .
builddir := tmp
LINTDIR := $(builddir)/lint
HTMLDIR := $(builddir)/html

DESTDIR :=
prefix := /usr/local
SYSCONFDIR := $(srcdir)/etc
TMACDIR := $(SYSCONFDIR)/groff/tmac
datarootdir := $(prefix)/share
docdir := $(datarootdir)/doc
MANDIR := $(srcdir)
mandir := $(datarootdir)/man
MAN0DIR := $(MANDIR)/man0
MAN1DIR := $(MANDIR)/man1
MAN2DIR := $(MANDIR)/man2
MAN3DIR := $(MANDIR)/man3
MAN4DIR := $(MANDIR)/man4
MAN5DIR := $(MANDIR)/man5
MAN6DIR := $(MANDIR)/man6
MAN7DIR := $(MANDIR)/man7
MAN8DIR := $(MANDIR)/man8
man0dir := $(mandir)/man0
man1dir := $(mandir)/man1
man2dir := $(mandir)/man2
man3dir := $(mandir)/man3
man4dir := $(mandir)/man4
man5dir := $(mandir)/man5
man6dir := $(mandir)/man6
man7dir := $(mandir)/man7
man8dir := $(mandir)/man8
manext := \.[0-9]
man0ext := .0
man1ext := .1
man2ext := .2
man3ext := .3
man4ext := .4
man5ext := .5
man6ext := .6
man7ext := .7
man8ext := .8
htmldir := $(docdir)
htmldir_ := $(htmldir)/man
htmlext := .html

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
RM           := rm
RMDIR        := rmdir --ignore-fail-on-non-empty
GROFF        := groff
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

MANPAGES   := $(sort $(shell find $(MANDIR)/man?/ -type f | grep '$(manext)$$'))
HTMLPAGES  := $(patsubst $(MANDIR)/%,$(HTMLDIR)/%.html,$(MANPAGES))
_htmlpages := $(patsubst $(HTMLDIR)/%,$(DESTDIR)$(htmldir_)/%,$(HTMLPAGES))
_manpages  := $(patsubst $(MANDIR)/%,$(DESTDIR)$(mandir)/%,$(MANPAGES))
_man0pages := $(filter %$(man0ext),$(_manpages))
_man1pages := $(filter %$(man1ext),$(_manpages))
_man2pages := $(filter %$(man2ext),$(_manpages))
_man3pages := $(filter %$(man3ext),$(_manpages))
_man4pages := $(filter %$(man4ext),$(_manpages))
_man5pages := $(filter %$(man5ext),$(_manpages))
_man6pages := $(filter %$(man6ext),$(_manpages))
_man7pages := $(filter %$(man7ext),$(_manpages))
_man8pages := $(filter %$(man8ext),$(_manpages))
LINT_groff := $(patsubst $(MANDIR)/%,$(LINTDIR)/%.lint.groff.touch,$(MANPAGES))
LINT_mandoc:= $(patsubst $(MANDIR)/%,$(LINTDIR)/%.lint.mandoc.touch,$(MANPAGES))

MANDIRS   := $(sort $(shell find $(MANDIR)/man? -type d))
HTMLDIRS  := $(patsubst $(MANDIR)/%,$(HTMLDIR)/%/.,$(MANDIRS))
LINTDIRS  := $(patsubst $(MANDIR)/%,$(LINTDIR)/%/.,$(MANDIRS))
_htmldirs := $(patsubst $(HTMLDIR)/%,$(DESTDIR)$(htmldir_)/%,$(HTMLDIRS))
_mandirs  := $(patsubst $(MANDIR)/%,$(DESTDIR)$(mandir)/%/.,$(MANDIRS))
_man0dir  := $(filter %man0/.,$(_mandirs))
_man1dir  := $(filter %man1/.,$(_mandirs))
_man2dir  := $(filter %man2/.,$(_mandirs))
_man3dir  := $(filter %man3/.,$(_mandirs))
_man4dir  := $(filter %man4/.,$(_mandirs))
_man5dir  := $(filter %man5/.,$(_mandirs))
_man6dir  := $(filter %man6/.,$(_mandirs))
_man7dir  := $(filter %man7/.,$(_mandirs))
_man8dir  := $(filter %man8/.,$(_mandirs))
_mandir   := $(DESTDIR)$(mandir)/.
_htmldir  := $(DESTDIR)$(htmldir_)/.

_htmlpages_rm := $(addsuffix -rm,$(wildcard $(_htmlpages)))
_manpages_rm  := $(addsuffix -rm,$(wildcard $(_manpages)))
_man0pages_rm := $(filter %$(man0ext)-rm,$(_manpages_rm))
_man1pages_rm := $(filter %$(man1ext)-rm,$(_manpages_rm))
_man2pages_rm := $(filter %$(man2ext)-rm,$(_manpages_rm))
_man3pages_rm := $(filter %$(man3ext)-rm,$(_manpages_rm))
_man4pages_rm := $(filter %$(man4ext)-rm,$(_manpages_rm))
_man5pages_rm := $(filter %$(man5ext)-rm,$(_manpages_rm))
_man6pages_rm := $(filter %$(man6ext)-rm,$(_manpages_rm))
_man7pages_rm := $(filter %$(man7ext)-rm,$(_manpages_rm))
_man8pages_rm := $(filter %$(man8ext)-rm,$(_manpages_rm))

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
_mandir_rmdir   := $(addsuffix -rmdir,$(wildcard $(_mandir)))
_htmldir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_htmldir)))

install_manX     := $(foreach x,$(MAN_SECTIONS),install-man$(x))
installdirs_manX := $(foreach x,$(MAN_SECTIONS),installdirs-man$(x))
uninstall_manX   := $(foreach x,$(MAN_SECTIONS),uninstall-man$(x))


.SECONDEXPANSION:
$(_manpages): $(DESTDIR)$(mandir)/man%: $(MANDIR)/man% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@

$(_mandirs): %/.: | $$(dir %). $(_mandir)

$(_mandirs_rmdir): $(DESTDIR)$(mandir)/man%/.-rmdir: $$(_man%pages_rm) FORCE
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
# lint

linters := groff mandoc
lint    := $(foreach x,$(linters),lint-$(x))

$(LINT_groff): $(LINTDIR)/%.lint.groff.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (groff)	$@)
	$(GROFF) $(GROFFFLAGS) -z $<
	touch $@

$(LINT_mandoc): $(LINTDIR)/%.lint.mandoc.touch: $(MANDIR)/% | $$(@D)/.
	$(info LINT (mandoc)	$@)
	$(MANDOC) $(MANDOCFLAGS) $<
	touch $@

$(LINTDIRS): %/.: | $$(dir %). $(LINTDIR)/.

.PHONY: $(lint)
$(lint): lint-%: $$(LINT_%) | lintdirs
	@:

.PHONY: lintdirs
lintdirs: $(LINTDIRS)
	@:

.PHONY: lint
lint: $(lint)
	@:


########################################################################
# html

# Use with
#  make MAN2HTMLFLAGS=whatever html
# The sed removes the lines "Content-type: text/html\n\n"
$(HTMLPAGES): $(HTMLDIR)/%.html: $(MANDIR)/% | $$(@D)/.
	$(info MAN2HTML	$@)
	$(MAN2HTML) $(MAN2HTMLFLAGS) $< | sed -e 1,2d >$@ || exit $$?

$(HTMLDIRS): %/.: | $$(dir %). $(HTMLDIR)/.

$(_htmlpages): $(DESTDIR)$(htmldir_)/%: $(HTMLDIR)/% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@

$(_htmldirs): %/.: | $$(dir %). $(_htmldir)


.PHONY: build-html html
build-html html: $(HTMLPAGES) | builddirs-html
	@:

.PHONY: builddirs-html
builddirs-html: $(HTMLDIRS)
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
