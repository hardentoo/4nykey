# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
FONTDIR_BIN=( fonts/{o,t}tf )
myemakeargs=(
	SRCDIR=sources
	INTERPOLATE=
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="f0857d4"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A minimalistic sans serif typeface"
HOMEPAGE="https://github.com/alexeiva/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
