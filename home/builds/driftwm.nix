{ lib, rustPlatform, fetchFromGitHub, pkg-config,
  libseat, libdisplay-info, libinput, udev, mesa, wayland }:

rustPlatform.buildRustPackage {
  pname = "driftwm";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "malbiruk";
    repo = "driftwm";
    rev = "main";
    hash = lib.fakeHash;
  };

  cargoLock.lockFile = ./driftwm-cargo.lock;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libseat libdisplay-info libinput udev mesa wayland ];

  meta = {
    description = "Trackpad-first infinite canvas Wayland compositor";
    homepage = "https://github.com/malbiruk/driftwm";
    license = lib.licenses.gpl3Plus;
    mainProgram = "driftwm";
  };
}
