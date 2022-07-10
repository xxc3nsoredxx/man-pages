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


srcdir := .

MANDIR  := $(srcdir)
MAN0DIR := $(MANDIR)/man0
MAN1DIR := $(MANDIR)/man1
MAN2DIR := $(MANDIR)/man2
MAN3DIR := $(MANDIR)/man3
MAN4DIR := $(MANDIR)/man4
MAN5DIR := $(MANDIR)/man5
MAN6DIR := $(MANDIR)/man6
MAN7DIR := $(MANDIR)/man7
MAN8DIR := $(MANDIR)/man8
MANEXT  := \.[0-9]\w*


.PHONY: all
all: build


########################################################################
# man

MANPAGES := $(sort $(shell find $(MANDIR)/man?/ -type f | grep '$(MANEXT)'))
MANDIRS  := $(sort $(shell find $(MANDIR)/man? -type d))


.SECONDEXPANSION:


########################################################################
include $(srcdir)/lib/build.mk
include $(srcdir)/lib/build-html.mk
include $(srcdir)/lib/build-src.mk
include $(srcdir)/lib/dist.mk
include $(srcdir)/lib/install.mk
include $(srcdir)/lib/install-html.mk
include $(srcdir)/lib/install-man.mk
include $(srcdir)/lib/lint.mk
include $(srcdir)/lib/lint-c.mk
include $(srcdir)/lib/lint-man.mk


$(V).SILENT:
FORCE:
