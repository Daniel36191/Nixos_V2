{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  freetype,
  curl,
  bluez,
  webkitgtk_4_1,
  hidapi,
  libX11,
  libXext,
  libXinerama,
  libXrandr,
  libXcursor,
  alsa-lib,
  libjack2,
  gtk3,
  libglvnd,
}:

let
  # Modified JUCE version required by Chataigne
  juce = stdenv.mkDerivation rec {
    pname = "juce-modified";
    version = "develop-local";

    src = fetchFromGitHub {
      owner = "benkuper";
      repo = "JUCE";
      rev = "develop-local";
      sha256 = "sha256-Dk66pXlJ/B9ezsDVqV0cxSNkqPVb2fqo4YGoCrCCHOE=";
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      freetype
      libX11
      libXext
      libXinerama
      libXrandr
      libXcursor
      alsa-lib
      libjack2
      gtk3
      libglvnd
      webkitgtk_4_1
    ];

    buildPhase = ''
        ls -al extras
      cd extras/Projucer/Builds/LinuxMakefile
      make -j$NIX_BUILD_CORES
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp build/Projucer $out/bin/

      mkdir -p $out/modules
      cp -r ../../../modules $out/
    '';

    meta = with lib; {
      description = "Modified JUCE framework for Chataigne";
      homepage = "https://github.com/benkuper/JUCE";
      license = licenses.gpl3;
    };
  };

  # Servus dependency
  servus = stdenv.mkDerivation rec {
    pname = "servus";
    version = "unstable";

    src = fetchFromGitHub {
      owner = "HBPVIS";
      repo = "servus";
      rev = "master";
      sha256 = "sha256-4dQUq6A+j39FUnk7oXTdFDPdIK+3EPFJddHcyNVHCPY="; # Replace with actual hash
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      curl
    ];

    buildPhase = ''
      mkdir Servus/build
      cd Servus/build
      cmake ..
      # ninja
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "chataigne";
  version = "1.9.25b13";

  src = fetchFromGitHub {
    owner = "benkuper";
    repo = "Chataigne";
    rev = version;
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    juce
  ];

  buildInputs = [
    freetype
    curl
    bluez
    webkitgtk_4_1
    hidapi
    libX11
    libXext
    libXinerama
    libXrandr
    libXcursor
    alsa-lib
    libjack2
    servus
    gtk3
    libglvnd
  ];

  preBuild = ''
    # Use the Projucer we built
    PROJUCER_PATH=${juce}/bin/Projucer

    # Go to Chataigne source
    cd Builds/LinuxMakefile

    # Run Projucer to generate makefiles
    $PROJUCER_PATH --resave ../Chataigne.jucer

    # Add JUCE modules to include path
    export CXXFLAGS="-I${juce}/modules $CXXFLAGS"
    export PKG_CONFIG_PATH=${lib.makeSearchPathOutput "dev" "lib/pkgconfig" buildInputs}
  '';

  buildPhase = ''
    cd Builds/LinuxMakefile
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/Chataigne $out/bin/

    wrapProgram $out/bin/Chataigne \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ servus ]}
  '';

  meta = with lib; {
    description = "Modular OSC and DMX controller with a timeline based sequencer";
    homepage = "https://github.com/benkuper/Chataigne";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
