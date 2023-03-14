# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

## further reading for me: https://discourse.nixos.org/t/zramswap-enable-true-does-nothing/6734 https://nixos.wiki/wiki/PipeWire https://nixos.wiki/wiki/Btrfs https://search.nixos.org/options?channel=unstable&show=i18n.extraLocaleSettings&from=0&size=50&sort=relevance&type=packages&query=locale

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./disks.nix
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  
  # Use grub bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      version = 2;
      devices = ["nodev"];
      efiSupport = true;
    };
  };
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Enabling nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "artemis"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_CH.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     keyMap = "sg";
     #useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  programs.xwayland.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "ch";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Use pipewire instead of pulse
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable flatpaks
  services.flatpak.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nf = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" ]; 
    initialHashedPassword = "$y$j9T$egAsObwIE9SW5FLYK1IAY1$G340S9JTGbYXLFWEaRLjKdxx4YfCPZNNJBFrTLhRPA1";
    createHome = true;
    description = "Nico";
    # packages = with pkgs; [
    #   firefox
    #   thunderbird
    # ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
  ];

  # Disable some gnome packages
  environment.gnome.excludePackages = [ pkgs.gnome.yelp pkgs.gnome.cheese pkgs.gnome.geary pkgs.gnome.totem pkgs.gnome.gnome-maps pkgs.gnome.gnome-music pkgs.gnome-tour ];

  # Disable xterm
  services.xserver.excludePackages = [ pkgs.xterm ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

