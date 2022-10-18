########################################################################
# Copyright (C) 2022  Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:  GPL-3.0
########################################################################


ifndef MAKEFILE_VERBOSE_INCLUDED
MAKEFILE_VERBOSE_INCLUDED := 1


ifdef V
HIDE_ERR :=
else
HIDE_ERR := 2>/dev/null
endif


$(V).SILENT:


endif  # MAKEFILE_VERBOSE_INCLUDED
