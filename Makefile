########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
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


MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables


srcdir := .


.PHONY: all
all: build
	@:

.PHONY: help
help:
	$(info	Targets:)
	$(info	)
	$(info	all			Alias for "build")
	$(info	)
	$(info	clean			Remove $$(builddir))
	$(info	)
	$(info	build			Alias for "build-html")
	$(info	)
	$(info	build-html		Build HTML manual pages)
	$(info	html			Alias for "build-html")
	$(info	)
	$(info	build-src		Alias for "build-src-ld")
	$(info	build-src-c		Extract C programs from EXAMPLES)
	$(info	build-src-cc		Compile C programs from EXAMPLES)
	$(info	build-src-ld		Link C programs from EXAMPLES)
	$(info	)
	$(info	lint			Wrapper for "lint-c lint-man")
	$(info	lint-c			Wrapper for lint-c-* targets)
	$(info	lint-c-checkpatch	Lint C programs from EXAMPLES with checkpatch(1))
	$(info	lint-c-clang-tidy	Lint C programs from EXAMPLES with clang-tidy(1))
	$(info	lint-c-cpplint		Lint C programs from EXAMPLES with cpplint(1))
	$(info	lint-c-iwyu		Lint C programs from EXAMPLES with iwyu(1))
	$(info	lint-man		Wrapper for lint-man-* targets)
	$(info	lint-man-groff		Lint man pages with groff(1))
	$(info	lint-man-mandoc		Lint man pages with mandoc(1))
	$(info	lint-man-tbl		Lint man pages about '\" t' comment for tbl(1))
	$(info	)
	$(info	[un]install		Alias for "[un]install-man")
	$(info	[un]install-man		Wrapper for [un]install-man* targets)
	$(info	[un]install-man1	[Un]install man pages in section 1)
	$(info	[un]install-man2	[Un]install man pages in section 2)
	$(info	[un]install-man2type	[Un]install man pages in section 2type)
	$(info	[un]install-man3	[Un]install man pages in section 3)
	$(info	[un]install-man3const	[Un]install man pages in section 3const)
	$(info	[un]install-man3head	[Un]install man pages in section 3head)
	$(info	[un]install-man3type	[Un]install man pages in section 3type)
	$(info	[un]install-man4	[Un]install man pages in section 4)
	$(info	[un]install-man5	[Un]install man pages in section 5)
	$(info	[un]install-man6	[Un]install man pages in section 6)
	$(info	[un]install-man7	[Un]install man pages in section 7)
	$(info	[un]install-man8	[Un]install man pages in section 8)
	$(info	)
	$(info	[un]install-html	[Un]install HTML manual pages)
	$(info	)
	$(info	dist			Wrapper for dist-* targets)
	$(info	dist-tar		Create a tarball of the repository)
	$(info	dist-gz			Create a compressed tarball (.tar.gz))
	$(info	dist-xz			Create a compressed tarball (.tar.xz))
	$(info	)
	$(info	help			Print this help)
	$(info	)
	$(info	Variables:)
	$(info	)
	$(info	V			Define to non-empty string for verbose output)


.SECONDEXPANSION:


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
include $(srcdir)/lib/verbose.mk


FORCE:
