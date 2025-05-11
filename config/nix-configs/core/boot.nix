{
  config,
  pkgs,
  lib,
  host,
  username,
  options,
  ...
}:
{
environment.systemPackages = with pkgs; [
  grub2_full
];
 boot = {
    ## Kernel
    kernelPackages = pkgs.linuxPackages_zen;

    ## This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    ## Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    ## Bootloader.
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
        ## Custom Theme
        theme = lib.mkForce (pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        });
        extraEntries =
        let
            ##run: sudo blkid -o export /dev/sd(xy of main windwos part(largest)) | grep UUID
            uuid = "CCF02DC0F02DB19E";

            ## lsblk, sda->hd0, sda1->gpt1
            drive = "hd1,gpt1";
        in
        ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          set root='hd0,gpt1'
          if [ x$feature_platform_search_hint = xy ]; then
           search --no-floppy --fs-uuid --set=root --hint-bios=${drive} --hint-efi=${drive} --hint-baremetal=ahci0,gpt1  ${uuid}
          else
           search --no-floppy --fs-uuid --set=root ${uuid}
          fi
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        '';

        # let ##run: sudo blkid -o export /dev/sd(xy of main windwos part(largest)) | grep PARTUUID
        #     partuuid = "1375c5c6-218b-4d2d-b0e5-26a698a62e5c";
        # in
        # ''
        #   menuentry "Windows" {
        #       insmod part_gpt
        #       insmod fat
        #       search --no-floppy --set=root --part-uuid ${partuuid}
        #       chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        #   }
        # '';
      };
    };

    ## Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    ## Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  ## Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
}
