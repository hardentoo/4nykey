# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="
ca cs da de el en es fr gd it ja nl oc pl pt_BR pt_PT ru sk sl tr uk zh_CN zh_TW
"
inherit l10n qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mltframework/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/mltframework/${PN}/tar.gz/v${PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="https://www.shotcut.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="
	media-libs/mlt
	dev-qt/qtopengl:5
	dev-qt/qtdeclarative:5
	dev-qt/qtsql:5
	dev-qt/qtwebkit:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwebsockets:5
"
DEPEND="
	${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	eqmake5 ${PN}.pro PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs

	use nls || return
	insinto /usr/share/${PN}/translations
	local q
	for q in $(l10n_get_locales); do
		q="translations/${PN}_${q}"
		"$(qt5_get_bindir)"/lrelease ${q}.ts -qm ${q}.qm
		doins ${q}.qm
	done
}
