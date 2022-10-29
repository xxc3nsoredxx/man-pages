########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_INSTALL_HTML_INCLUDED
MAKEFILE_INSTALL_HTML_INCLUDED := 1


include $(srcdir)/lib/build-html.mk
include $(srcdir)/lib/install.mk


htmldir  := $(docdir)
htmldir_ := $(htmldir)/man
_htmldir := $(DESTDIR)$(htmldir_)


_htmlpages      := $(patsubst $(_HTMLDIR)/%,$(_htmldir)/%,$(_HTMLPAGES))
_htmldirs       := $(patsubst $(_HTMLDIR)/%,$(_htmldir)/%,$(_HTMLDIRS))
_htmlpages_rm   := $(addsuffix -rm,$(wildcard $(_htmlpages)))
_htmldirs_rmdir := $(addsuffix -rmdir,$(wildcard $(_htmldirs)))
_htmldir_rmdir  := $(addsuffix -rmdir,$(wildcard $(_htmldir)/.))


$(_htmlpages): $(_htmldir)/%: $(_HTMLDIR)/% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@

$(_htmldirs): %/.: | $$(dir %). $(_htmldir)/.


.PHONY: install-html
install-html: $(_htmlpages)
	@:

.PHONY: uninstall-html
uninstall-html: $(_htmldir_rmdir) $(_htmldirs_rmdir) $(_htmlpages_rm)
	@:


endif  # MAKEFILE_INSTALL_HTML_INCLUDED
