########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_DIST_INCLUDED
MAKEFILE_DIST_INCLUDED := 1


include $(srcdir)/lib/build.mk


DISTNAME    := $(shell git describe 2>/dev/null)
DISTFILE    := $(builddir)/$(DISTNAME).tar
compression := gz xz
dist        := $(foreach x,$(compression),dist-$(x))


$(DISTFILE): $(shell git ls-files 2>/dev/null) | $$(@D)/.
	$(info TAR	$@)
	tar cf $@ -T /dev/null
	git ls-files \
	| sed 's,^,./,' \
	| xargs tar rf $@ -C $(srcdir) --transform 's,^\.,$(DISTNAME),'

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


endif  # MAKEFILE_DIST_INCLUDED
