{ stdenv, fetchzip, bmake, pkg-config, wayland, libdrm, pixman, libxkbcommon, libevdev, lib }:

stdenv.mkDerivation {
  pname = "hevel";
  version = "unstable";
  src = fetchzip {
    url = "https://git.sr.ht/~dlm/hevel/archive/cce195a2.tar.gz";
    sha256 = "sha256-9B180ebZzOtv9eEICVpYSo558T0/UYEVELFztPzOX4o=";
    
  };
 nativeBuildInputs = [ bmake pkg-config ];
  buildInputs = [ wayland libdrm pixman libxkbcommon libevdev ];
  buildPhase = "bmake PREFIX=$out";
  installPhase = "bmake PREFIX=$out install";
}
