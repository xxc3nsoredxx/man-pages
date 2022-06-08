#!/bin/sh
#
# (C) Copyright 2022, Alejandro Colomar
# SPDX-License-Identifier:  GPL-3.0-only
#
# Update the timestamp of the manual pages modified since the last git
# tag, with the date of the latest commit that modifies that page.
#
#######################################################################


git diff --name-only $(git describe --abbrev=0)..HEAD \
|while read f; do
	date="$(git log --format=%ci -1 -- $f | cut -f1 -d' ')";

	awk "/^\.TH/ {\$4 = \"$date\"} {print}" <$f \
	|sponge $f;
done;
