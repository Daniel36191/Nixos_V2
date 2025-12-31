self: pkgs:
{
  redhat-nerd = pkgs.redhat-official-fonts.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      pkgs.nerd-font-patcher
    ];
    postInstall = ''
      mkdir -p $out/share/fonts/truetype/{redhat,redhat-nerd}
      mv $out/share/fonts/truetype/*.ttf $out/share/fonts/truetype/redhat/
      for f in $out/share/fonts/truetype/redhat/*.ttf; do
        nerd-font-patcher --complete --outputdir $out/share/fonts/truetype/redhat-nerd/ $f
      done
    '';
  });
}