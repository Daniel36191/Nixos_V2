{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  curl,
}:
let
in
stdenv.mkDerivation rec {
  pname = "servus";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "HBPVIS";
    repo = "servus";
    rev = "master";
    sha256 = "sha256-YVyNyz+C1NPYtMhbFCOuiWiPvP89GEYBfbwNRUXf4MU="; # Replace with actual hash
    fetchSubmodules = true;
  };

  # sourceRoot = ".";

  # dontUseCmakeConfigure = true;

  pqqreConfigurePhase = ''

  '';

nativeBuildInputs = [
  cmake
  ninja
  pkg-config
];

cmakeBuildDir = "Release";
cmakeBuildType = "Release";

  buildInputs = [
    curl
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  buildPhase = ''
    mkdir Release
    cd Release

    type cmake

    ls -al ..

    cmake -GNinja -DCMAKE_INSTALL_PREFIX=$PWD/install -DCMAKE_BUILD_TYPE=Release ..

    ninja all
    ninja Servus-tests
  '';
}
