# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Flake is an open-source FLAC audio encoder"
HOMEPAGE="http://flake-enc.sf.net"
SRC_URI="mirror://sourceforge/flake-enc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=""
RDEPEND=""

src_compile() {
	local myconf
	use debug || myconf="${myconf} --disable-debug"
	./configure \
		--prefix=/usr \
		--log=config.log \
		--disable-strip \
		--disable-opts \
		${myconf} || die
	make || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc Changelog README
}