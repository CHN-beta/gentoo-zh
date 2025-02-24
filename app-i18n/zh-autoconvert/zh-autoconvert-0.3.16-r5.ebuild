# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Chinese HZ/GB/BIG5/UNI/UTF7/UTF8 encodings auto-converter"
HOMEPAGE="https://packages.debian.org/stable/source/zh-autoconvert"
SRC_URI="mirror://debian/pool/main/z/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/z/${PN}/${PN}_${PV}-3.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/zh-}

PATCHES=(
	"${WORKDIR}/${PN}_${PV}-3.diff"
	"${FILESDIR}/make-makefile-respect-compiler-references.patch"
)

src_prepare() {
	default

	# don't build xchat-plugins
	# so don't depend on gtk+-1.2 anymore
	sed -i -e 's/[ ]*xchat-plugins$//' Makefile
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install() {
	dobin autogb
	dosym autogb /usr/bin/autob5

	if use static-libs; then
		dolib.a lib/libhz.a
	fi

	dolib.so lib/libhz.so.0.0

	LIBDIR_VAR="LIBDIR_${ABI}"
	dosym libhz.so.0.0 /usr/${!LIBDIR_VAR}/libhz.so.0
	dosym libhz.so.0 /usr/${!LIBDIR_VAR}/libhz.so

	insinto /usr/include
	doins include/*.h
}
