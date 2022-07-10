########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
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

SHELL := /usr/bin/env bash -Eeuo pipefail


MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables


srcdir   := .
builddir := tmp
DESTDIR  :=
prefix   := /usr/local

SYSCONFDIR  := $(srcdir)/etc
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
manext      := \.[0-9]\w*

_LINTDIR    := $(builddir)/lint
_SRCDIR     := $(builddir)/src


INSTALL      := install
INSTALL_DATA := $(INSTALL) -m 644
INSTALL_DIR  := $(INSTALL) -m 755 -d
MKDIR        := mkdir -p
RM           := rm
RMDIR        := rmdir --ignore-fail-on-non-empty


.PHONY: all
all: build-html

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

MANDIRS   := $(sort $(shell find $(MANDIR)/man? -type d))
_LINTDIRS  := $(patsubst $(MANDIR)/%,$(_LINTDIR)/%/.,$(MANDIRS))


.SECONDEXPANSION:


########################################################################
# lint

$(_LINTDIRS): %/.: | $$(dir %). $(_LINTDIR)/.

lint: lint-c lint-man


.PHONY: lintdirs
lintdirs: $(_LINTDIRS) $(_SRCDIRS)
	@:

.PHONY: lint
lint: $(lint)
	@:


########################################################################
include $(srcdir)/lib/build-html.mk
include $(srcdir)/lib/build-src.mk
include $(srcdir)/lib/dist.mk
include $(srcdir)/lib/install-html.mk
include $(srcdir)/lib/install-man.mk
include $(srcdir)/lib/lint-c.mk
include $(srcdir)/lib/lint-man.mk


$(V).SILENT:
FORCE:
