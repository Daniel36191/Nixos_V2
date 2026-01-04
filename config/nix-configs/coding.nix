{
    pkgs,
    ...
}:
{
    environment.systemPackages = with pkgs; [
    ## Git tools
    lazygit
    git
    github-desktop

    mkcert ## Https Cert Maker for local addrs

    termius

    ## Code editors
    vscode
    # zed-editor
    micro
    jetbrains.idea

    ## Language servers
    nixd ## Nix-lang interpiter
    nil ## Nix-lang server
    nixfmt-rfc-style ## Nix-lang formattor
    ];

    environment.variables = {
        EDITOR = "${pkgs.micro}/bin/micro";
    };

}
