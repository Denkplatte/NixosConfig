{ stdenv, fetchzip, meson, ninja, pkg-config, libdrm, freetype, fontconfig, pixman, wayland, lib }:

stdenv.mkDerivation {
  pname = "neuwld";
  version = "unstable";
  src = fetchzip {
    url = "https://git.sr.ht/~shrub900/neuwld/archive/HEAD.tar.gz";
    hash = "sha256-rP03qodS9zUKJ6WPxPlu/sn+yRWc6jssa10mVPEjodc=";
  };
  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libdrm freetype fontconfig pixman wayland];
}
