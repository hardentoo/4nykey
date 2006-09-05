# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

IUSE="sndfile modplug mp3 vorbis speex flac alsa oss musepack cddb systray
jack libsamplerate ape ladspa pda"

DESCRIPTION="Aqualung"
HOMEPAGE="http://aqualung.sourceforge.net"
SRC_URI=""
ECVS_SERVER="aqualung.cvs.sourceforge.net:/cvsroot/aqualung"
ECVS_MODULE="aqualung"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

RDEPEND="vorbis? ( >=media-libs/libvorbis-1.0 )
	libsndfile? ( media-libs/libsndfile )
	flac? ( media-libs/flac )
	modplug? ( media-libs/libmodplug )
	alsa? ( media-libs/alsa-lib )
	jack? ( jack-audio-connection-kit )
	mp3? ( media-libs/id3lib media-libs/libmad )
	musepack? ( media-libs/libmpcdec )
	ape? ( media-sound/mac )
	ladspa? ( media-libs/liblrdf )
	speex? ( media-libs/speex media-libs/liboggz )
	cddb? ( >=media-libs/libcddb-1.2.1 )
	pda? ( media-libs/libifp )
	libsamplerate? ( media-libs/libsamplerate )"

DEPEND="systray? ( >=x11-libs/gtk+-2.10 )
	>=dev-util/pkgconfig-0.9.0
	media-sound/jack-audio-connection-kit
	virtual/libc
	>=x11-libs/gtk+-2.4
	dev-libs/libxml2
	>=media-libs/liblrdf-0.4.0
	media-libs/raptor
	${RDEPEND}"

S="${WORKDIR}/${ECVS_MODULE}"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	# respect my cflagz
	sed -i "s:-O2:${CFLAGS}:" configure.ac
	eautoreconf
}

src_compile() {
	econf \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with sndfile) \
		$(use_with libsamplerate src) \
		$(use_with flac) \
		$(use_with vorbis ogg) \
		$(use_with speex) \
		$(use_with mp3 mpeg) \
		$(use_with mp3 id3) \
		$(use_with modplug mod) \
		$(use_with musepack mpc) \
		$(use_with ape mac) \
		$(use_with ladspa) \
		$(use_with cddb) \
		$(use_with pda ifp) \
		$(use_with systray) || die "econf failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "einstall failed"
} 