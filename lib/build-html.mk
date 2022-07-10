########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_BUILD_HTML_INCLUDED
MAKEFILE_BUILD_HTML_INCLUDED := 1


htmlext  := .html
_HTMLDIR := $(builddir)/html


DEFAULT_MAN2HTMLFLAGS :=
EXTRA_MAN2HTMLFLAGS   :=
MAN2HTMLFLAGS         := $(DEFAULT_MAN2HTMLFLAGS) $(EXTRA_MAN2HTMLFLAGS)
MAN2HTML              := man2html


_HTMLPAGES := $(patsubst $(MANDIR)/%,$(_HTMLDIR)/%.html,$(MANPAGES))
_HTMLDIRS  := $(patsubst $(MANDIR)/%,$(_HTMLDIR)/%/.,$(MANDIRS))


# Use with
#  make MAN2HTMLFLAGS=whatever html
# The sed removes the lines "Content-type: text/html\n\n"
$(_HTMLPAGES): $(_HTMLDIR)/%.html: $(MANDIR)/% | $$(@D)/.
	$(info MAN2HTML	$@)
	$(MAN2HTML) $(MAN2HTMLFLAGS) $< | sed -e 1,2d >$@

$(_HTMLDIRS): %/.: | $$(dir %). $(_HTMLDIR)/.


.PHONY: build-html html
build-html html: $(_HTMLPAGES) | builddirs-html
	@:

.PHONY: builddirs-html
builddirs-html: $(_HTMLDIRS)
	@:


endif  # MAKEFILE_BUILD_HTML_INCLUDED
