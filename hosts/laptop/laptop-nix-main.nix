{
  ...
}:
{
  ##################
  ## Boot Entries ##
  ##################

  boot.loader.grub.extraEntries =
    let
      ##run: sudo blkid -o export /dev/sd(xy of main windwos part(largest)) | grep UUID
      uuid = "4A92FDDF92FDD005";

      ## lsblk, sda->hd0, sda1->gpt1
      win-drive = "nvme0n1,gpt4";
      nix-drive = "nvme0n1,gpt1";
    in
    ''
      menuentry "Windows" {
        insmod part_gpt
        insmod fat
        set root='${nix-drive}'
        if [ x$feature_platform_search_hint = xy ]; then
         search --no-floppy --fs-uuid --set=root --hint-bios=${win-drive} --hint-efi=${win-drive} --hint-baremetal=ahci0,gpt1  ${uuid}
        else
         search --no-floppy --fs-uuid --set=root ${uuid}
        fi
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';

}
