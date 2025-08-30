{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
}:

let
  protonSrc = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "Proton";
    rev = "proton_9.0-3e";
    sha256 = "05yi6iz94c40c7049dj4dgv0r2dkkkczsapig7ridibyn14ikfgf"; # You'll need to replace this
  };

  wineOpenXRPatch = fetchpatch {
    url = "https://gist.githubusercontent.com/gotzl/294c849af4b497f537a2904eeff73140/raw/73ad92c885b11ab75886a30c9b60d4f5442e72be/wineopenxr_vulkan.patch";
    sha256 = "1v2d3gzv30n54ff075g28spsrvdrilkbn5dcmcqm97hkqblm6jcp"; # You'll need to replace this
  };

  winePatched = pkgs.wineWowPackages.unstable.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ wineOpenXRPatch ];
  });

in
stdenv.mkDerivation rec {
  pname = "proton";
  version = "9.0";

  src = protonSrc;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
  ];

  # You'll need to adjust the build process based on Proton's actual build system
  buildPhase = ''
    # Proton typically expects to be built in a specific way
    # This is a simplified version - you'll need to adjust it
    mkdir -p build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release \
             -DCMAKE_INSTALL_PREFIX=$out \
             -DNIX_ENABLE_OPENXR_VULKAN=ON
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    # Install Proton files
    mkdir -p $out
    cp -r ../dist $out/

    # Create wrapper script
    makeWrapper $out/dist/bin/wine $out/bin/proton \
      --prefix PATH : ${lib.makeBinPath [ winePatched ]} \
      --set PROTON_PATH $out
  '';

  meta = with lib; {
    description = "Compatibility tool for Steam Play based on Wine and additional components";
    homepage = "https://github.com/ValveSoftware/Proton";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
