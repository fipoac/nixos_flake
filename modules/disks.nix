{ config, pkgs, ... }:

{
  boot.initrd.luks.devices."cr_root".device = "/dev/disk/by-uuid/2e4aa2f2-0945-4429-9a3e-40fd28ddc9c4";

  fileSystems."/" =
    { device = "/dev/mapper/cr_root";
      fsType = "btrfs";
      options = [ "subvolid=256" "ssd" "noatime" "discard=async" "compress=zstd:3" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/cr_root";
      fsType = "btrfs";
      options = [ "subvolid=257" "ssd" "noatime" "discard=async" "compress=zstd:3" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/mapper/cr_root";
      fsType = "btrfs";
      options = [ "subvolid=258" "ssd" "noatime" "discard=async" "compress=zstd:3" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/cr_root";
      fsType = "btrfs";
      options = [ "subvolid=259" "ssd" "noatime" "discard=async" "compress=zstd:3" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/748fa566-af7f-42da-8f7a-4454833612db";
      fsType = "btrfs";
      options = [ "subvolid=256" "ssd" "noatime" "discard=async" "compress=zstd:3" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/62ED-9147";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/ab7ad3ca-b15f-4a42-98cd-eaef63365e12"; } ];
}
