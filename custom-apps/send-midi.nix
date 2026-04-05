{
  stdenv,
  lib,
  fetchFromGitHub,
  alsa-lib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "sendmidi";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "gbevin";
    repo = pname;
    rev = "1.3.1"; # Use the tag name without 'v'
    sha256 = "C78byGWHim+wwIjtoqSR4kwAKXgW7Ky9w9BpYZ1mEVY="; # Replace with actual hash
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
    description = "A simple and compact tool to send MIDI messages from the command line.";
    homepage = "https://github.com/gbevin/SendMIDI";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dmoeller131 ]; # Replace with your GitHub handle if desired
  };
}
