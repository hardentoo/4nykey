# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cvs autotools qt4

DESCRIPTION="Dirac is a general-purpose wavelet video codec"
HOMEPAGE="http://www.bbc.co.uk/rd/projects/dirac/overview.shtml"
ECVS_SERVER="dirac.cvs.sourceforge.net:/cvsroot/dirac"
ECVS_MODULE="compress"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug mmx doc qt4"

RDEPEND="
	qt4? ( $(qt4_min_version 4.0) )
"
DEPEND="
	doc? (
		app-doc/doxygen
		virtual/tetex
	)
"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	sed -i 's:g++\*):*g++*):g' configure.ac
	sed -i 's:SUBDIRS = .*:SUBDIRS = :' util/Makefile.am
	eautoreconf || die
}

src_compile() {
	if use !doc; then
		export ac_cv_prog_HAVE_DOXYGEN="false" ac_cv_prog_HAVE_LATEX="false"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable mmx) \
		|| die

	emake || die

	if use qt4; then
		cd util/encoder_gui
		qmake -project || die
		qmake || die
		emake || die
	fi
}

src_install() {
	einstall || die
	use qt4 && newbin util/encoder_gui/encoder_gui dirac_encoder_gui
	if use doc; then
		mkdir -p "${D}"usr/share/doc/${PF}
		mv "${D}"usr/share/doc/dirac "${D}"usr/share/doc/${PF}/html
	fi
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
}