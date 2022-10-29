########################################################################
# Copyright (C) 2021, 2022  Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier:  GPL-2.0  OR  LGPL-2.0
########################################################################


ifndef MAKEFILE_INSTALL_MAN_INCLUDED
MAKEFILE_INSTALL_MAN_INCLUDED := 1


include $(srcdir)/lib/install.mk
include $(srcdir)/lib/src.mk


mandir      := $(datarootdir)/man
man1dir     := $(mandir)/man1
man2dir     := $(mandir)/man2
man2typedir := $(mandir)/man2type
man3dir     := $(mandir)/man3
man3constdir:= $(mandir)/man3const
man3headdir := $(mandir)/man3head
man3typedir := $(mandir)/man3type
man4dir     := $(mandir)/man4
man5dir     := $(mandir)/man5
man6dir     := $(mandir)/man6
man7dir     := $(mandir)/man7
man8dir     := $(mandir)/man8
man1ext     := .1
man2ext     := .2
man2typeext := .2type
man3ext     := .3
man3headext := .3head
man3typeext := .3type
man4ext     := .4
man5ext     := .5
man6ext     := .6
man7ext     := .7
man8ext     := .8
_mandir     := $(DESTDIR)$(mandir)


_manpages      := $(patsubst $(MANDIR)/%,$(_mandir)/%,$(MANPAGES))
_man1pages     := $(filter %$(man1ext),$(_manpages))
_man2pages     := $(filter %$(man2ext),$(_manpages))
_man2typepages := $(filter %$(man2typeext),$(_manpages))
_man3pages     := $(filter %$(man3ext),$(_manpages))
_man3constpages:= $(filter %$(man3constext),$(_manpages))
_man3headpages := $(filter %$(man3headext),$(_manpages))
_man3typepages := $(filter %$(man3typeext),$(_manpages))
_man4pages     := $(filter %$(man4ext),$(_manpages))
_man5pages     := $(filter %$(man5ext),$(_manpages))
_man6pages     := $(filter %$(man6ext),$(_manpages))
_man7pages     := $(filter %$(man7ext),$(_manpages))
_man8pages     := $(filter %$(man8ext),$(_manpages))

_mandirs     := $(patsubst $(MANDIR)/%,$(_mandir)/%/.,$(MANDIRS))
_man1dir     := $(filter %man1/.,$(_mandirs))
_man2dir     := $(filter %man2/.,$(_mandirs))
_man2typedir := $(filter %man2type/.,$(_mandirs))
_man3dir     := $(filter %man3/.,$(_mandirs))
_man3constdir:= $(filter %man3const/.,$(_mandirs))
_man3headdir := $(filter %man3head/.,$(_mandirs))
_man3typedir := $(filter %man3type/.,$(_mandirs))
_man4dir     := $(filter %man4/.,$(_mandirs))
_man5dir     := $(filter %man5/.,$(_mandirs))
_man6dir     := $(filter %man6/.,$(_mandirs))
_man7dir     := $(filter %man7/.,$(_mandirs))
_man8dir     := $(filter %man8/.,$(_mandirs))

_man1pages_rm     := $(addsuffix -rm,$(wildcard $(_man1pages)))
_man2pages_rm     := $(addsuffix -rm,$(wildcard $(_man2pages)))
_man2typepages_rm := $(addsuffix -rm,$(wildcard $(_man2typepages)))
_man3pages_rm     := $(addsuffix -rm,$(wildcard $(_man3pages)))
_man3constpages_rm:= $(addsuffix -rm,$(wildcard $(_man3constpages)))
_man3headpages_rm := $(addsuffix -rm,$(wildcard $(_man3headpages)))
_man3typepages_rm := $(addsuffix -rm,$(wildcard $(_man3typepages)))
_man4pages_rm     := $(addsuffix -rm,$(wildcard $(_man4pages)))
_man5pages_rm     := $(addsuffix -rm,$(wildcard $(_man5pages)))
_man6pages_rm     := $(addsuffix -rm,$(wildcard $(_man6pages)))
_man7pages_rm     := $(addsuffix -rm,$(wildcard $(_man7pages)))
_man8pages_rm     := $(addsuffix -rm,$(wildcard $(_man8pages)))

_mandirs_rmdir     := $(addsuffix -rmdir,$(wildcard $(_mandirs)))
_man1dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man1dir)))
_man2dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man2dir)))
_man2typedir_rmdir := $(addsuffix -rmdir,$(wildcard $(_man2typedir)))
_man3dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man3dir)))
_man3constdir_rmdir:= $(addsuffix -rmdir,$(wildcard $(_man3constdir)))
_man3headdir_rmdir := $(addsuffix -rmdir,$(wildcard $(_man3headdir)))
_man3typedir_rmdir := $(addsuffix -rmdir,$(wildcard $(_man3typedir)))
_man4dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man4dir)))
_man5dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man5dir)))
_man6dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man6dir)))
_man7dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man7dir)))
_man8dir_rmdir     := $(addsuffix -rmdir,$(wildcard $(_man8dir)))
_mandir_rmdir      := $(addsuffix -rmdir,$(wildcard $(_mandir)/.))

MAN_SECTIONS     := 1 2 2type 3 3const 3head 3type 4 5 6 7 8
install_manX     := $(foreach x,$(MAN_SECTIONS),install-man$(x))
installdirs_manX := $(foreach x,$(MAN_SECTIONS),installdirs-man$(x))
uninstall_manX   := $(foreach x,$(MAN_SECTIONS),uninstall-man$(x))


$(_manpages): $(_mandir)/man%: $(MANDIR)/man% | $$(@D)/.
	$(info INSTALL	$@)
	$(INSTALL_DATA) -T $< $@

$(_mandirs): %/.: | $$(dir %). $(_mandir)/.

$(_mandirs_rmdir): $(_mandir)/man%/.-rmdir: $$(_man%pages_rm) FORCE
$(_mandir_rmdir): $(uninstall_manX) FORCE


.PHONY: $(install_manX)
$(install_manX): install-man%: $$(_man%pages)
	@:

.PHONY: install-man
install-man: $(install_manX)
	@:

.PHONY: $(uninstall_manX)
$(uninstall_manX): uninstall-man%: $$(_man%pages_rm) $$(_man%dir_rmdir)
	@:

.PHONY: uninstall-man
uninstall-man: $(_mandir_rmdir) $(uninstall_manX)
	@:


endif  # MAKEFILE_INSTALL_MAN_INCLUDED
