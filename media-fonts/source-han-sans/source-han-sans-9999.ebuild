# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	MY_PN="SourceHanSans"
	SRC_URI="https://github.com/adobe-fonts/${PN}/raw/${PV}R/SubsetOTF/${MY_PN}"
	SRC_URI="
		!afdko? (
			l10n_ja? ( ${SRC_URI}JP.zip -> ${MY_PN}JP-${PV}.zip )
			l10n_ko? ( ${SRC_URI}KR.zip -> ${MY_PN}KR-${PV}.zip )
			l10n_zh-CN? ( ${SRC_URI}CN.zip -> ${MY_PN}CN-${PV}.zip )
			l10n_zh-TW? ( ${SRC_URI}TW.zip -> ${MY_PN}TW-${PV}.zip )
		)
		afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="afdko l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW monospace"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"

DEPEND="
	afdko? ( media-gfx/afdko )
"
RDEPEND="
	l10n_ja? ( monospace? ( media-fonts/source-han-code-jp ) )
"

FONT_SUFFIX="otf"
DOCS="README.md"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex afdko master release)"
		git-r3_src_unpack
		if use !afdko; then
			use l10n_ja || rm -r "${S}"/SubsetOTF/JP
			use l10n_ko || rm -r "${S}"/SubsetOTF/KR
			use l10n_zh-CN || rm -r "${S}"/SubsetOTF/CN
			use l10n_zh-TW || rm -r "${S}"/SubsetOTF/TW
		fi
	else
		default
		if use !afdko; then
			DOCS=
			mkdir -p "${S}"/SubsetOTF
			mv SourceHanSans* "${S}"/SubsetOTF/
		fi
	fi
}

src_prepare() {
	default
	use afdko && eapply "${FILESDIR}"/${P}*.diff
}

src_compile() {
	if use !afdko; then
		find SubsetOTF -mindepth 2 -name '*.otf' -exec mv -f {} "${S}" \;
	else
		source ${EROOT}etc/afdko
		source "${S}"/COMMANDS.txt
	fi
}
