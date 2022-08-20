########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_DIST_INCLUDED
MAKEFILE_DIST_INCLUDED := 1


include $(srcdir)/lib/build.mk
include $(srcdir)/lib/cmd.mk
include $(srcdir)/lib/install.mk
include $(srcdir)/lib/version.mk



_DISTDIR := $(builddir)/dist

DISTFILES   := $(shell $(GIT) ls-files 2>/dev/null | $(SED) 's,^,$(srcdir)/,')
_DISTFILES  := $(patsubst $(srcdir)/%,$(_DISTDIR)/%,$(DISTFILES))
_DISTPAGES  := $(filter     $(_DISTDIR)/man%,$(_DISTFILES))
_DISTOTHERS := $(filter-out $(_DISTDIR)/man%,$(_DISTFILES))

DISTFILE    := $(builddir)/$(DISTNAME).tar
compression := gz xz
dist        := $(foreach x,$(compression),dist-$(x))


$(_DISTPAGES): $(_DISTDIR)/man%: $(srcdir)/man% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@
	$(SED) -i '/^.TH/s/(unreleased)/$(DISTVERSION)/' $@

$(_DISTOTHERS): $(_DISTDIR)/%: $(srcdir)/% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@


$(DISTFILE): $(_DISTFILES) | $$(@D)/.
	$(info TAR	$@)
	$(TAR) cf $@ -T /dev/null
	$(GIT) ls-files \
	| $(SED) 's,^,$(_DISTDIR)/,' \
	| $(XARGS) $(TAR) rf $@ -C $(srcdir) \
		--transform 's,^$(_DISTDIR),$(DISTNAME),'

$(DISTFILE).gz: %.gz: % | $$(@D)/.
	$(info GZIP	$@)
	$(GZIP) -knf $<

$(DISTFILE).xz: %.xz: % | $$(@D)/.
	$(info XZ	$@)
	$(XZ) -kf $<


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


endif  # MAKEFILE_DIST_INCLUDED
