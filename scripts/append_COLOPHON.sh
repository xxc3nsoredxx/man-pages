#!/bin/sh
#
# append_COLOPHON.sh
#
# Append the COLOPHON section to the man pages.  This script should be
# run before running `make dist`.
#
########################################################################
# SPDX-License-Identifier: GPL-2.0-only
########################################################################
#
# (C) Copyright 2022, Alejandro Colomar
# These functions are free software; you can redistribute them and/or
# modify them under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2.
#
# These functions are distributed in the hope that they will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details
# (http://www.gnu.org/licenses/gpl-2.0.html).
#
########################################################################
find man?/ -not -type d \
|xargs sed -i "\$a \\
.SH COLOPHON\\
This page is part of release\\
$(git describe | sed 's/^man-pages-//')\\
of the Linux\\
.I man-pages\\
project.\\
A description of the project,\\
information about reporting bugs,\\
and the latest version of this page,\\
can be found at\\
.UR https://www.kernel.org/doc/man-pages/\\
.UE .
"
