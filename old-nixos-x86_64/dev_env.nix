{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        vim neovim emacs kate # editors
        ocamlPackages.ocaml-lsp # LSPs
        nodePackages_latest.bash-language-server
        ocaml opam glibc rustc python3 go # languages
        git cmake ninja meson
        distrobox podman
        busybox
        ];
}
