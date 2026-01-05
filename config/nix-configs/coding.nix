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

    zellij

    ## Code editors
    vscode
    # zed-editor
    micro
    jetbrains.idea

    ## Language servers
    nixd ## Nix-lang interpiter
    nil ## Nix-lang server
    nixfmt-rfc-style ## Nix-lang formattor

    ## Java
    javaPackages.compiler.temurin-bin.jdk-21

    ];

    environment.variables = {
        EDITOR = "${pkgs.micro}/bin/micro";
    };

    programs.java = {
    	enable = false;
    	# package = pkgs.javaPackages.compiler.temurin-bin.jre-21;
    };
    

}
