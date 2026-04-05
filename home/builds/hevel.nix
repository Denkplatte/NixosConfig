{ lib
, stdenv
, fetchFromGitHub
, zig
, pkg-config
, wayland
, libxkbcommon
, mesa
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "hevel";
  version = "git";

  src = fetchFromGitHub {
    owner = "dlm";
    repo = "hevel";
    rev = "main";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    zig
    pkg-config
  ];

  buildInputs = [
    wayland
    libxkbcommon
    mesa
    libdrm
  ];

  buildPhase = ''
    zig build -Doptimize=ReleaseSafe
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zig-out/bin/hevel $out/bin/
  '';

  meta = with lib; {
    description = "Infinite scrolling Wayland compositor";
    homepage = "https://github.com/dlm/hevel";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [];
  };
}
