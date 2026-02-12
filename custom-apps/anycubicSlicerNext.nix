{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  dpkg,
  makeWrapper,

  libGL,
  libGLU,
  zlib,
  dbus,
  gtk3,
  wayland,
  webkitgtk_4_1,
  gst_all_1,
  libsoup_3,

  nanum-gothic-coding,
  noto-fonts-cjk-sans,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "AnycubicSlicerNext";
  version = "1.3.96";

  src = fetchurl {
    url = "https://cdn-universe-slicer.anycubic.com/prod/dists/noble/main/binary-amd64/develop_${finalAttrs.pname}-${finalAttrs.version}_20260131_153250-Ubuntu_24_04_3_LTS.deb";
    sha256 = "0r7dabm86ynavzr21w4581la7ak1v5wp0s7c0adsdnx60k1bm2va";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    makeWrapper
  ];
  buildInputs = [
    libGL
    libGLU
    zlib
    dbus
    gtk3
    wayland
    webkitgtk_4_1
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-libav
    libsoup_3

    nanum-gothic-coding
    noto-fonts-cjk-sans
  ];

  autoPatchelfDirectories = [
    "$out/lib"
  ];

  unpackPhase = ''
    echo "Unpacking"
    ls -al
    dpkg-deb -x $src .
  '';

  installPhase = ''
    echo "installing"
    ls -al usr/share
    echo "all"
    ls -al
    echo "bin"
    ls -al usr/bin
    echo "lib"
    ls -al usr/lib
    echo "share"
    ls -al usr/share/applications
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/lib
    cp usr/lib/* $out/lib
    cp usr/bin/${finalAttrs.pname} $out/bin
    cp usr/share/applications/AnycubicSlicer.desktop $out/share/applications
  '';

  postFixup = ''
  wrapProgram $out/bin/AnycubicSlicerNext \
    --set QT_QPA_PLATFORM xcb \
    --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
    --prefix LD_LIBRARY_PATH : "$out/lib"
'';

  desktopItems = [
    (makeDesktopItem {
      name = "anycubic-slicer-next";
      exec = "anycubic-slicer-next";
      icon = "anycubic-slicer";
      desktopName = "Anycubic Slicer Next";
      comment = "3D printing slicer for Anycubic printers";
      categories = [ "Graphics" "3DGraphics" ];
      mimeTypes = [ "model/stl" "model/3mf" ];
    })
  ];

  meta = {
    platforms = lib.platforms.linux;
  };
})