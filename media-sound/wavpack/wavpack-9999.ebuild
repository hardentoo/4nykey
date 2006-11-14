# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="WavPack hybrid audio compression"
HOMEPAGE="http://www.wavpack.com/"
ESVN_REPO_URI="http://svn.slomosnail.de/wavpack/trunk"
ESVN_BOOTSTRAP="eautoreconf"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	virtual/libiconv
"
DEPEND="
	${RDEPEND}
"

src_install() {
	einstall || die
	dodoc *.txt
}
