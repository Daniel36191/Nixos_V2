{
    pkgs,
    inputs,
    ...
}:
{
    environment.systemPackages = with pkgs; [
    ## Git tools
    lazygit
    git
    github-desktop

    ## Code editors
    vscode
    # zed-editor
    micro

    ## Language servers
    nixd # # Nix-lang interpiter
    nil # # Nix-lang server
    nixfmt-rfc-style # # Nix-lang formattor
    ];

}