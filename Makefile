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
	$(info	lint-c-cppcheck		Lint C programs from EXAMPLES with cppcheck(1))
	$(info	lint-c-cpplint		Lint C programs from EXAMPLES with cpplint(1))
	$(info	lint-c-iwyu		Lint C programs from EXAMPLES with iwyu(1))
	$(info	lint-man		Wrapper for lint-man-* targets)
	$(info	lint-man-mandoc		Lint man pages with mandoc(1))
	$(info	lint-man-tbl		Lint man pages about '\" t' comment for tbl(1))
	$(info	lint-man-groff		Alias for "lint-man-groff-grep")
	$(info	lint-man-groff-preconv	Lint man pages with preconv(1))
	$(info	lint-man-groff-tbl	Lint man pages with tbl(1))
	$(info	lint-man-groff-eqn	Lint man pages with eqn(1))
	$(info	lint-man-groff-troff	Lint man pages with troff(1))
	$(info	lint-man-groff-grotty	Lint man pages with grotty(1))
	$(info	lint-man-groff-col	Lint man pages with col(1))
	$(info	lint-man-groff-grep	Lint man pages with grep(1))
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
	$(info	help-variables		Print all variables available, and their default values)
	$(info	)


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


help-variables:
	$(info	V		Define to non-empty string for verbose output)
	$(info	)
	$(info	LINK_PAGES	How to install link pages.  ["so", "symlink"])
	$(info	Z		Install pages compressed.  ["", ".gz"])
	$(info	)
	$(info	DISTNAME	$$(git describe))
	$(info	DISTVERSION	/$$DISTNAME/s/man-pages-//)
	$(info	)
	$(info	# Directory variables:)
	$(info	)
	$(info	builddir	.tmp)
	$(info	DESTDIR		)
	$(info	prefix		/usr/local)
	$(info	mandir		$$(datarootdir)/man)
	$(info	docdir		$$(datarootdir)/doc)
	$(info	)
	$(info	man1dir		$$(mandir)/man1)
	$(info	man2dir		$$(mandir)/man2)
	$(info	man2typedir	$$(mandir)/man2type)
	$(info	man3dir		$$(mandir)/man3)
	$(info	man3constdir	$$(mandir)/man3const)
	$(info	man3headdir	$$(mandir)/man3head)
	$(info	man3typedir	$$(mandir)/man3type)
	$(info	man4dir		$$(mandir)/man4)
	$(info	man5dir		$$(mandir)/man5)
	$(info	man6dir		$$(mandir)/man6)
	$(info	man7dir		$$(mandir)/man7)
	$(info	man8dir		$$(mandir)/man8)
	$(info	)
	$(info	htmldir		$$(docdir))
	$(info	htmlext		.html)
	$(info	)
	$(info	# Command variables (and flags):)
	$(info	)
	$(info	PRECONV		{EXTRA_,}PRECONVFLAGS)
	$(info	TBL)
	$(info	EQN		{EXTRA_,}EQNFLAGS)
	$(info	TROFF		{EXTRA_,}TROFFFLAGS)
	$(info	GROTTY		{EXTRA_,}GROTTYFLAGS)
	$(info	COL		{EXTRA_,}COLFLAGS)
	$(info	)
	$(info	MAN)
	$(info	MANDOC		{EXTRA_,}MANDOCFLAGS)
	$(info	MAN2HTML	{EXTRA_,}MAN2HTMLFLAGS)
	$(info	)
	$(info	ECHO)
	$(info	EXPR)
	$(info	FIND)
	$(info	GIT)
	$(info	GZIP)
	$(info	HEAD)
	$(info	LN)
	$(info	LOCALE)
	$(info	PKGCONF)
	$(info	SED)
	$(info	SORT)
	$(info	SPONGE)
	$(info	TAC)
	$(info	TAIL)
	$(info	TAR)
	$(info	TEST)
	$(info	XARGS)
	$(info	XZ)
	$(info	)
	$(info	INSTALL)
	$(info	INSTALL_DATA)
	$(info	MKDIR)
	$(info	RM)
	$(info	)
	$(info	-		{EXTRA_,}CPPFLAGS)
	$(info	CC		{EXTRA_,}CFLAGS)
	$(info	LD		{EXTRA_,}LDFLAGS	{EXTRA_,}LDLIBS)
	$(info	)
	$(info	CHECKPATCH	{EXTRA_,}CHECKPATCHFLAGS)
	$(info	CLANG-TIDY	{EXTRA_,}CLANG-TIDYFLAGS)
	$(info	CPPCHECK	{EXTRA_,}CPPCHECKFLAGS)
	$(info	CPPLINT		{EXTRA_,}CPPLINTFLAGS)
	$(info	IWYU		{EXTRA_,}IWYUFLAGS)
	$(info	)


.DELETE_ON_ERROR:
FORCE:
