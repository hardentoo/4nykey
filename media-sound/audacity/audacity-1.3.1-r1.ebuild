# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-1.2.3-r1.ebuild,v 1.1 2005/04/15 17:46:25 luckyduck Exp $

inherit cvs autotools

# static: uses system libs instead of bundled with audacity,
#	for wx - runs `wx-config --static=yes';
# no sndfile flag, as:
#	"we need to have libsndfile one way or another"
IUSE="lame flac mad vorbis libsamplerate alsa jack oss ladspa soundtouch
static unicode"

DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="http://audacity.sourceforge.net/"
ECVS_SERVER="audacity.cvs.sourceforge.net:/cvsroot/audacity"
ECVS_MODULE="audacity"
RESTRICT="test"

S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

RDEPEND=">=x11-libs/wxGTK-2.6.0
	>=app-arch/zip-2.3
	libsamplerate? ( >=media-libs/libsamplerate-0.0.14 )
	ladspa? ( >=media-libs/ladspa-sdk-1.12 )
	flac? ( media-libs/flac )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	mad? ( media-libs/libmad 
		media-libs/libid3tag )
	jack? ( media-sound/jack-audio-connection-kit )
	alsa? ( media-libs/alsa-lib )
	!static? ( media-libs/libsndfile )
	soundtouch? ( media-libs/libsoundtouch )
	lame? ( >=media-sound/lame-3.92 )"
#	=media-libs/portaudio-18*
DEPEND="${RDEPEND} 
	>=sys-devel/autoconf-2.5"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${PN}-*.diff
	sed -i 's: Win32/Makefile\.mingw::' lib-src/libsamplerate/configure
	eautoreconf
}

src_compile() {
	CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"

	use static && LIBPREF="local" || LIBPREF="system"

	if use alsa || use jack; then
		PORTAUDIO=19
		cd lib-src/portaudio-v19
		econf \
			$(use_with alsa) \
			$(use_with jack) \
			$(use_with oss) || die
		cd ${S}
	else
		PORTAUDIO=18
	fi

	econf \
		$(use_enable static) \
		$(use_enable unicode) \
		$(use_with ladspa) \
		--with-lib-preference=${LIBPREF} \
		--with-nyquist=local \
		--with-libsndfile=${LIBPREF} \
		--with-portaudio=v${PORTAUDIO} \
		$(use_with libsamplerate libsamplerate ${LIBPREF}) \
		$(use_with !libsamplerate libresample ${LIBPREF}) \
		$(use_with soundtouch soundtouch ${LIBPREF}) \
		$(use_with mad libmad ${LIBPREF}) \
		$(use_with mad id3tag ${LIBPREF}) \
		$(use_with vorbis vorbis ${LIBPREF}) \
		$(use_with flac flac ${LIBPREF}) || die

	# parallel b0rks
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die

	# Install our docs
	dodoc README.txt
	dohtml -r help/webbrowser/

	# Remove bad doc install
	rm -rf ${D}usr/share/doc/audacity

	insinto /usr/share/pixmaps
	newins images/AudacityLogo.xpm audacity.xpm
	dosed \
		'/^Name\[/d; s:^Icon=.*:Icon=audacity:; s:.*\(Desktop Entry\).*:[\1]:' \
		/usr/share/applications/audacity.desktop
}