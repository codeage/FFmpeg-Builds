#!/bin/bash

# Pinned to the 3.100 release tag (the trunk snapshot used upstream is a 4.1 alpha and encodes ~13% slower).
# The peg revision only selects the repository state; the tag content is the 3.100 release.
SCRIPT_REPO="https://svn.code.sf.net/p/lame/svn/tags/RELEASE__3_100/lame"
SCRIPT_REV="6835"

ffbuild_depends() {
    echo base
    echo libiconv
}

ffbuild_enabled() {
    return 0
}

ffbuild_dockerdl() {
    echo "retry-tool sh -c \"rm -rf lame && svn checkout '${SCRIPT_REPO}@${SCRIPT_REV}' lame\" && cd lame"
    echo "autoreconf -i"
}

ffbuild_dockerbuild() {
    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --disable-cpml
        --disable-frontend
        --disable-decoder
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$CFLAGS -DNDEBUG"

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-libmp3lame
}

ffbuild_unconfigure() {
    echo --disable-libmp3lame
}
