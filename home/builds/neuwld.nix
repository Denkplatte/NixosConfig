{ stdenv, fetchzip, bmake, pkg-config, libdrm, lib }:

stdenv.mkDerivation {
  pname = "neuwld";
  version = "unstable";
  src = fetchzip {
    url = "https://git.sr.ht/~dlm/neuwld/archive/HEAD.tar.gz";
    hash = lib.fakeHash;
  };
  nativeBuildInputs = [ bmake pkg-config ];
  buildInputs = [ libdrm ];
  buildPhase = "bmake PREFIX=$out";
  installPhase = "bmake PREFIX=$out install";
}
