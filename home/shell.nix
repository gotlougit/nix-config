{ pkgs, ... }:

let
  hostname = "kratos";
  user = "gotlou";
in
{

  xdg.configFile."direnv/direnvrc".source = ./direnvrc;

  xdg.configFile."macchina/macchina.toml".text = ''
    show = ["Host", "Machine", "Kernel", "Distribution", "Shell", "Uptime", "Processor", "ProcessorLoad", "Memory", "Battery"]
  '';

  programs.fish.shellAliases = {
    open = "xdg-open";
    rollback-config = "sudo nixos-rebuild switch --rollback";
    switch-config = "sudo nixos-rebuild switch --flake /home/${user}/nixos#${hostname}";
    quick-switch-config = "switch-config --offline";
    update-config = "sudo nix flake update /home/${user}/nixos && sudo nixos-rebuild switch --flake /home/${user}/nixos#${hostname}";
    switch-config-boot = "sudo nixos-rebuild boot --flake /home/${user}/nixos#${hostname}";
    enter-rust-dev = "nix develop /home/${user}/nixos/project-flakes/generic-rust-dev/ --command code-sandbox";
    import-rust-dev = "cp /home/${user}/nixos/project-flakes/generic-rust-dev/* .; cp /home/${user}/nixos/project-flakes/generic-rust-dev/.envrc .";
    enter-golang-dev = "nix develop /home/${user}/nixos/project-flakes/generic-golang-dev/ --command code-sandbox";
    import-golang-dev = "cp /home/${user}/nixos/project-flakes/generic-golang-dev/* .; cp /home/${user}/nixos/project-flakes/generic-golang-dev/.envrc .";
    enter-cpp-dev = "nix develop /home/${user}/nixos/project-flakes/generic-c-cpp-dev/ --command code-sandbox";
    import-cpp-dev = "cp /home/${user}/nixos/project-flakes/generic-c-cpp-dev/* .; cp /home/${user}/nixos/project-flakes/generic-c-cpp-dev/.envrc .";
    init-microvm = "bash /home/${user}/nixos/microvms/init-workspace.sh";
  };

  # Host-specific fish init (adds macchina and XDG vars)
  programs.fish.interactiveShellInit = ''
    macchina
    fish_vi_key_bindings
  '';

  # Host-only packages
  home.packages = with pkgs; [
    macchina
    ffsend
    bear
    img2pdf
    picard
    poppler-utils
    tetex
    p7zip
    unrar
    whois
    wl-clipboard
    yt-dlp
  ];
}
