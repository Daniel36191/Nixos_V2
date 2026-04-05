{
  stdenv,
  lib,
  fetchFromGitHub,
  alsa-lib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "receivemidi";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "gbevin";
    repo = pname;
    rev = "1.4.4"; # Use the tag name without 'v'
    sha256 = "+eY/wW1G0PQOE587TmLo/k9BSyWjIEolVrWbzDG9PEk="; # Replace with actual hash
  };

  buildInputs = [
    stdenv.cc
    alsa-lib
    pkg-config
  ];

  makeFlags = [
    "-C"
    "Builds/LinuxMakefile"
    "CONFIG=Release"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp Builds/LinuxMakefile/build/${pname} $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    description = "A simple and compact tool to receive MIDI messages to the command line.";
    homepage = "https://github.com/gbevin/SendMIDI";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Daniel36191 ]; # Replace with your GitHub handle if desired
  };
}
