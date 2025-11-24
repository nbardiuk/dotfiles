{ config, pkgs, mypkgs, ... }:
let
  commit = "git/commit";
  hooks = "git/hooks";
in
{
  programs.git = {
    enable = true;
    ignores = [
      # python
      ".venv/"
      ".env/"
      # idea
      ".idea/"
      ".idea_modules/"
      "*.iml"
      "*.ipr"
      # Vim
      ".sw[a-p]"
      ".*.sw[a-p]"
      "Session.vim"
      ".netrwhist"
      "*~"
      "tags"
      ".nfnl.fnl"
      ".nvim.fnl"
      ".nvim.lua"
      # sbt
      "dist/*"
      "target/"
      "lib_managed/"
      "src_managed/"
      "project/boot/"
      "project/plugins/project/"
      ".history"
      ".cache"
      ".lib/"
      # metals
      ".metals/"
      ".bloop/"
      ".bsp/"
      ".ammonite/"
      "metals.sbt"
      # Gradle
      ".gradle"
      "**/build/"
      "gradle-app.setting"
      ".gradletasknamecache"
      # Haskell
      "dist"
      "dist-*"
      "cabal-dev"
      "*.o"
      "*.hi"
      "*.chi"
      "*.chs.h"
      "*.dyn_o"
      "*.dyn_hi"
      ".hpc"
      ".hsenv"
      ".cabal-sandbox/"
      "cabal.sandbox.config"
      "*.prof"
      "*.aux"
      "*.hp"
      "*.eventlog"
      ".stack-work/"
      "cabal.project.local"
      "cabal.project.local~"
      ".HTF/"
      ".ghc.environment.*"
      # direnv
      ".envrc"
      ".direnv/"
      # Clojure
      "nazarii.clj"
      "pom.xml.asc"
      "*.jar"
      "*.class"
      "/classes/"
      "/target/"
      "/checkouts/"
      ".lein-deps-sum"
      ".lein-repl-history"
      ".lein-plugins/"
      ".lein-failures"
      ".nrepl-port"
      ".cpcache/"
      "**/.clj-kondo/.cache"
      "**/.clj-kondo/imports"
      ".shadow-cljs"
      # c/cpp
      ".ccls-cache"
      # syncthing
      ".stversions/"
      ".stfolder/"
    ];
    settings = {
      user.name = "Nazarii Bardiuk";
      user.email = "nazarii@bardiuk.com";
      branch.sort = "committerdate";
      checkout.defaultRemote = "origin";
      code.editor = "nvim";
      core.fsmonitor = true; # use process to monitor file changes
      core.hooksPath = "${config.xdg.configHome}/${hooks}";
      core.untrackedCache = true;
      column.ui = "auto"; # commands can output in columns
      commit.template = "${config.xdg.configHome}/${commit}";
      commit.verbose = true;
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.tool = "vdiff";
      difftool.prompt = true;
      "difftool \"vdiff\"".cmd = "nvim -d $LOCAL $REMOTE";
      fetch.all = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      init.defaultBranch = "main";
      merge.autoStash = true;
      merge.conflictStyle = "zdiff3";
      merge.stat = true;
      merge.tool = "vmerge";
      "mergetool \"vmerge\"".cmd = "nvim -d $LOCAL $REMOTE $MERGED -c 'wincmd w' -c 'wincmd J'";
      mergetool.prompt = true;
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      rebase.stat = true;
      rebase.updateRefs = true;
      remote.defaultPush = "origin";
      rerere.autoupdate = true;
      rerere.enabled = true;
      tag.sort = "version:refname";
      # "diff \"clojure\"".xfuncname = "!^;.*\\n^[^ \\t].*$";
      # "diff \"clojure\"".wordRegex = "[#@:]?[^0-9][a-zA-Z0-9*+!-_'?<>=/.]+|[-]?[0-9a-fA-Frxb/MN]+|[\\0-9a-fA-F]+";
      "diff \"secret\"".cachetextconv = true;
    };
    attributes = [
      "*.clj diff=clojure"
      "*.secret diff=secret"
    ];
  };

  xdg.configFile."${hooks}/pre-commit" = {
    source = ./pre-commit.clj;
    executable = true;
  };

  xdg.configFile.${commit}.text = ''
    feat: 

    # --- COMMIT END ---
    #    feat     (new feature)
    #    fix      (bug fix)
    #    refactor (refactoring production code)
    #    style    (formatting, missing semi colons, etc; no code change)
    #    docs     (changes to documentation)
    #    test     (adding or refactoring tests; no production code change)
    #    chore    (updating grunt tasks etc; no production code change)
    # --------------------
  '';

  home.packages = with pkgs; [
    babashka # for pre-commit
    git-crypt
    git-secret
    mypkgs.review-pr
    gh # github cli
  ];

  programs.lazygit = {
    enable = true;
    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    settings.gui.theme.selectedLineBgColor = [ "#E6E6E6" ];
    settings.animateExplosion = false;
    settings.promptToReturnFromSubprocess = false;
  };
}
