# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="OCRopus is a state-of-the-art document analysis and OCR system"
HOMEPAGE="http://www.ocropus.org"
ESVN_REPO_URI="http://ocropus.googlecode.com/svn/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="spell readline sdl verbose-build"

RDEPEND="
	|| ( app-text/tesseract-ocr app-text/tesseract )
	media-libs/iulib
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	spell? (
		app-text/aspell
		app-dicts/aspell-en
	)
	readline? ( sys-libs/readline )
	sdl? (
		media-libs/sdl-gfx
		media-libs/sdl-image
	)
"
DEPEND="
	${RDEPEND}
	dev-util/scons
"

my_use() {
	use $1 && echo yes || echo no
}

src_compile() {
	myconf=" tess=yes"
	myconf+=" openfst=no"
	myconf+=" leptonica=no"
	myconf+=" aspell=$(my_use spell)"
	myconf+=" editline=$(my_use readline)"
	myconf+=" sdl=$(my_use sdl)"

	scons \
		${MAKEOPTS} \
		prefix="/usr" \
		opt="${CXXFLAGS}" \
		iulib="/usr" \
		tesseract="/usr" \
		${myconf} \
		|| die
}

src_install() {
	mkdir -p "${D}"usr
	scons \
		${MAKEOPTS} \
		prefix="${D}usr" \
		opt="${CXXFLAGS}" \
		iulib="/usr" \
		tesseract="/usr" \
		${myconf} \
		install || die
	dodoc CHANGES INSTALL README

	insinto /usr/share/ocropus
	doins -r ocroscript/scripts data/{models,words}
}
