#!/bin/bash
# Size-reduced build. Applied after the per-script --enable flags (see FF_CONFIGURE_POST in generate.sh).
# Library wrapper decoders that duplicate a native FFmpeg decoder for the same codec.
# The libraries stay enabled where they also provide an encoder.
FF_CONFIGURE_POST+=" --disable-decoder=libopus,libvorbis"
