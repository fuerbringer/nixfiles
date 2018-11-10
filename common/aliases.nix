{
  environment.shellAliases = {
    # Nix
    nix-srch = "nix-env -Pqa | grep";

    # Editors
    v = "vim";
    sv = "sudoedit";
    e = "emacs";
    et = "emacs -nw"; # Terminal Emacs

    # Git shortcuts
    g = "git";
    ga = "git add";
    gb = "git branch";
    gc = "git commit -S -m";
    gch = "git checkout";
    gchmp = "git checkout master && git pull";
    gd = "git diff";
    gl = "git log";
    gpush = "git push";
    gpull = "git pull";
    gr = "git remote -v";
    gs = "git status";

    # Misc
    mupdf = "mupdf-x11";
  };
}
