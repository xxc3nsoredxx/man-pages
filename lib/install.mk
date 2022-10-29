########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_INSTALL_INCLUDED
MAKEFILE_INSTALL_INCLUDED := 1


include $(srcdir)/lib/cmd.mk


DESTDIR :=
prefix  := /usr/local

datarootdir := $(prefix)/share
docdir      := $(datarootdir)/doc


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
install: install-man
	@:

.PHONY: uninstall
uninstall: uninstall-man
	@:


endif  # MAKEFILE_INSTALL_INCLUDED
