{
  environment.shellAliases = {
    # Nix
    nix-srch = "nix-env -Pqa | grep";

    # Editors
    v = "vim";
    e = "emacs";
    et = "emacs -nw"; # Terminal Emacs

    # Git shortcuts
    ga = "git add";
    gb = "git branch";
    gc = "git commit -S -m";
    gd = "git diff";
    gl = "git log";
    gp = "git push";
    gr = "git remote -v";
    gs = "git status";

    # Misc
    mupdf = "mupdf-x11";
  };
}
