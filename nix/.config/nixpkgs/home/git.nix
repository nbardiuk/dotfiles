{ config, pkgs, ... }:
let
  commit = "git/commit";
  hooks = "git/hooks";
in {
  programs.git = {
    enable = true;
    userName = "Nazarii Bardiuk";
    userEmail = "nazarii@bardiuk.com";
    ignores = [
      # python
      ".venv/" ".env/"
      # idea
      ".idea/" ".idea_modules/" "*.iml" "*.ipr"
      # Vim
      ".sw[a-p]" ".*.sw[a-p]" "Session.vim" ".netrwhist" "*~" "tags" ".lnvim.fnl" ".lnvim.lua"
      # sbt
      "dist/*" "target/" "lib_managed/" "src_managed/" "project/boot/" "project/plugins/project/" ".history" ".cache" ".lib/"
      # Gradle
      ".gradle" "**/build/" "gradle-app.setting" ".gradletasknamecache"
      # Haskell
      "dist" "dist-*" "cabal-dev" "*.o" "*.hi" "*.chi" "*.chs.h" "*.dyn_o" "*.dyn_hi" ".hpc" ".hsenv" ".cabal-sandbox/" "cabal.sandbox.config" "*.prof" "*.aux" "*.hp" "*.eventlog" ".stack-work/" "cabal.project.local" "cabal.project.local~" ".HTF/" ".ghc.environment.*"
      # direnv
      ".envrc" ".direnv"
      # Clojure
      "pom.xml" "pom.xml.asc" "*.jar" "*.class" "/classes/" "/target/" "/checkouts/" ".lein-deps-sum" ".lein-repl-history" ".lein-plugins/" ".lein-failures" ".nrepl-port" ".cpcache/"
      # c/cpp
      ".ccls-cache"
      # syncthing
      ".stversions/" ".stfolder/"
    ];
    extraConfig = {
      checkout.defaultRemote = "origin";
      core.hooksPath = "${config.xdg.configHome}/${hooks}";
      code.editor = "nvim";
      commit.template = "${config.xdg.configHome}/${commit}";
      diff.algorithm = "histogram";
      diff.tool = "vdiff";
      difftool.prompt = true;
      "difftool \"vdiff\"".cmd = "nvim -d $LOCAL $REMOTE";
      fetch.prune = true;
      fetch.pruneTags = true;
      init.defaultBranch = "main";
      merge.autoStash = true;
      merge.stat = true;
      merge.tool = "vmerge";
      "mergetool \"vmerge\"".cmd = "nvim -d $LOCAL $REMOTE $MERGED -c 'wincmd w' -c 'wincmd J'";
      mergetool.prompt = true;
      pull.rebase = true;
      push.autoSetupRemote = true; 
      rebase.autoStash = true;
      rebase.stat = true;
      remote.defaultPush = "origin";
      "diff \"clojure\"".xfuncname = "!^;.*\n^[^ \t].*$";
      "diff \"clojure\"".wordRegex = "[#@:]?[^0-9][a-zA-Z0-9*+!-_'?<>=/.]+|[-]?[0-9a-fA-Frxb/MN]+|[\\0-9a-fA-F]+";
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
    gitAndTools.hub
    mu-repo
    gitui
  ];
}
