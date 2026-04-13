{
  ...
}:
{
  ####################
  ## Profile Config ##
  ####################

  ################
  ## Networking ##
  ################

  # networking = {
  #   networkmanager = {
  #     insertNameservers = [
  #       # "192.168.0.141"
  #       "1.1.1.1"
  #     ];
  #   };
  #   resolvconf.enable = false; ## Needed for insertNameservers to work?
  # };

  ##################
  ## Boot Entries ##
  ##################
  # boot.loader.grub.extraEntries =
  #   let
  #       ## run: sudo blkid -o export /dev/sd(xy of main windwos part(largest)) | grep UUID
  #       uuid = "CCF02DC0F02DB19E";

  #       ## lsblk, sda->hd0, sda1->gpt1
  #       win-drive = "hd1,gpt1";
  #       nix-drive = "hd0,gpt1";
  #   in
  #   ''
  #   menuentry "Windows" {
  #     insmod part_gpt
  #     insmod fat
  #     set root='${nix-drive}'
  #     if [ x$feature_platform_search_hint = xy ]; then
  #      search --no-floppy --fs-uuid --set=root --hint-bios=${win-drive} --hint-efi=${win-drive} --hint-baremetal=ahci0,gpt1  ${uuid}
  #     else
  #      search --no-floppy --fs-uuid --set=root ${uuid}
  #     fi
  #     chainloader /EFI/Microsoft/Boot/bootmgfw.efi
  #   }
  #   '';
}
