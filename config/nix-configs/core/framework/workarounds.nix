{
    ...
}:{
  ##########################
  ## Hardware Workarounds ##
  ##########################

  boot.kernelParams =
  [
    # There seems to be an issue with panel self-refresh (PSR) that
    # causes hangs for users.
    #
    # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
    "amdgpu.dcdebugmask=0x10"
  ]
  # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
  ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") [
    "rtc_cmos.use_acpi_alarm=1"
  ];

  # Fix TRRS headphones missing a mic
   # https://community.frame.work/t/headset-microphone-on-linux/12387/3
    boot.extraModprobeConfig = lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.6.8") ''
      options snd-hda-intel model=dell-headset-multi
    '';
}