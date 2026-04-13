{ stdenv, fetchzip, bmake, pkg-config, libdrm, freetype, fontconfig, pixman, lib }:

stdenv.mkDerivation {
  pname = "neuwld";
  version = "unstable";
  src = fetchzip {
    url = "https://git.sr.ht/~shrub900/neuwld/archive/6446a281.tar.gz";
    hash = "sha256-rP03qodS9zUKJ6WPxPlu/sn+yRWc6jssa10mVPEjodc=";
  };
  nativeBuildInputs = [ bmake pkg-config ];
  buildInputs = [ libdrm freetype fontconfig pixman ];
  buildPhase = ''
    bmake PREFIX=$out \
      ENABLE_DEBUG=0 \
      ENABLE_STATIC=0 \
      ENABLE_SHARED=1
  '';
  installPhase = ''
    bmake PREFIX=$out \
      ENABLE_DEBUG=0 \
      ENABLE_STATIC=0 \
      ENABLE_SHARED=1 \
      install
  '';
}
