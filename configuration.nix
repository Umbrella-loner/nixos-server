# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, zen-browser, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

hardware.firmware = [
  (pkgs.runCommand "custom-edid" {} ''
    mkdir -p $out/lib/firmware/edid
    cp ${./edid.bin} $out/lib/firmware/edid/edid.bin
  '')
];




# Add this block to your configuration.nix
programs.dconf.enable = true;  # You already have this

# Force GTK apps to use dark theme
environment.sessionVariables = {
  GTK_THEME = "Adwaita:dark";
};

# Set dark theme via dconf (this is what was missing)
programs.dconf.profiles.user.databases = [{
  settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };
}];

#new kernels
boot.kernelPackages = pkgs.linuxPackages_latest;
#hyprland block
programs.hyprland = {
enable = true;
xwayland.enable = true;
};
boot.loader.systemd-boot.enable = false;

boot.loader.efi = {
  canTouchEfiVariables = true;
  efiSysMountPoint = "/boot";
};

boot.loader.grub = {
  enable = true;
  efiSupport = true;
  device = "nodev";
  useOSProber = true;
};


programs.fish.enable = true;

  # Global interactive config (applies to ALL users)
users.defaultUserShell = pkgs.fish;

#dbus-thing-block
services.dbus.enable = true;

environment.variables = {
XDG_DATA_DIRS = [
  "/usr/share"
  "${pkgs.gsettings-desktop-schemas}/share"
  "${pkgs.glib}/share"

  ];
EDITOR = "nvim";
VISUAL = "nvim";
  };

#app-image support don't forget
programs.appimage.enable = true;
programs.appimage.binfmt = true;

#xdg-portal-block
xdg.portal = {
enable = true;
extraPortals = with pkgs; [ 
xdg-desktop-portal-gtk
xdg-desktop-portal-hyprland ];
};

boot.kernelParams = [
"console=tty50"
"mem_sleep_default=deep"
  "drm.edid_firmware=VGA-1:edid/edid.bin"
];



#flakes-setting
nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "home"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


#flatpak-apps
services.flatpak.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robin = {
    isNormalUser = true;
    description = "robin";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

#nix-index
programs.nix-index.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
git
cliphist
zathura 
zathuraPkgs.zathura_pdf_mupdf
pkgs.nautilus
pkgs.file-roller
ps_mem
bc
flex
bison
s-tui
zen-browser.packages.${pkgs.system}.default
glib
gsettings-desktop-schemas
gcc 
zip
file
tree
less
ripgrep
fd
bat
eza
htop
ncdu
lsof
strace
yazi
p7zip
rar
nmap
netcat
rsync
jq
openssh
yq
man-pages
man-pages-posix
fzf
zoxide
gnumake
cmake
gdb
rofi
firefox
curl 
wget 
unzip 
neovim
gammastep
google-chrome
hyprpaper
alacritty
protonvpn-gui
adwaita-icon-theme
grim
slurp
tmux
swaynotificationcenter
wl-clipboard
brightnessctl
networkmanagerapplet
blueman
waybar
swayosd
nerd-fonts.jetbrains-mono
nerd-fonts.fira-code
aria2
  ];

#fonts
fonts = {
packages = with pkgs; [
 nerd-fonts.jetbrains-mono
 nerd-fonts.fira-code
 ];
 fontconfig = {
 enable = true;
 defaultFonts = {
  monospace = [ "JetBrainsMono Nerd Font"];
   sansSerif = [ "JetBrainsMono Nerd Font" ];
   serif = [ "JetbrainsMono Nerd Font" ];
   };
   };
   };

   
#powersaving tlp
#services.tlp.enable = true;


#acpi-thing-block
#services.acpid.enable = true;




#bluetooth-block
hardware.bluetooth.enable = true;
services.blueman.enable = true;





#audio-stack(don't forget)
services.pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
jack.enable = true;
};

security.rtkit.enable = true;



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
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  system.stateVersion = "25.11";
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
}
