{ stdenv, fetchzip, bmake, pkg-config, wayland, wayland-scanner, libdrm, pixman,
  libxkbcommon, libevdev, libinput, neuwld, lib }:

stdenv.mkDerivation {
  pname = "neuswc";
  version = "unstable";
  src = fetchzip {
    url = "https://git.sr.ht/~shrub900/neuswc/archive/cc19cf90.tar.gz";
    hash = lib.fakeHash;
  };
  nativeBuildInputs = [ bmake pkg-config wayland-scanner ];
  buildInputs = [ wayland libdrm pixman libxkbcommon libevdev libinput neuwld ];
  buildPhase = "bmake PREFIX=$out";
  installPhase = "bmake PREFIX=$out install";
}
