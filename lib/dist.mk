########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_DIST_INCLUDED
MAKEFILE_DIST_INCLUDED := 1


include $(srcdir)/lib/build.mk
include $(srcdir)/lib/cmd.mk


DISTNAME    := $(shell $(GIT) describe 2>/dev/null)
DISTFILE    := $(builddir)/$(DISTNAME).tar
compression := gz xz
dist        := $(foreach x,$(compression),dist-$(x))


$(DISTFILE): $(shell $(GIT) ls-files 2>/dev/null) | $$(@D)/.
	$(info TAR	$@)
	$(TAR) cf $@ -T /dev/null
	$(GIT) ls-files \
	| $(SED) 's,^,./,' \
	| $(XARGS) $(TAR) rf $@ -C $(srcdir) --transform 's,^\.,$(DISTNAME),'

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
