{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = config.mod.nixld;
in
{
  config = lib.mkIf mod.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with unstable; [
        ## Core
        stdenv.cc.cc.lib # libstdc++, libgcc_s
        zlib
        openssl
        curl
        glibc

        ## Cli
        bzip2
        xz

        ## Libs
        icu
        libxml2
        libxslt
        expat
        libuuid
        util-linux
        attr
        acl
        libcap
        keyutils
        numactl
        glib
        gtk3
        nss
        nspr
        atk
        cairo
        pango
        gdk-pixbuf
        fontconfig
        freetype
        dbus
        at-spi2-atk
        at-spi2-core
        cups
        libdrm
        mesa
        libxkbcommon
        libGL
        libX11
        libXext
        libXcursor
        libXi
        libXrandr
        libXrender
        libXfixes
        libXcomposite
        libXinerama
        libXxf86vm
        libXtst
        libxcb
        vulkan-loader
        alsa-lib
        libpulseaudio
      ];
    };
  };
}
