{ config, pkgs, ... }:
let
  commit = "git/commit";
in {
  programs.git = {
    enable = true;
    userName = "Nazarii Bardiuk";
    userEmail = "";
    signing = {
      signByDefault = true;
      key = "1D8729AEF5622C0F7EA209C1C9C1904D44CDCDA1";
    };
    ignores = [
      # idea
      ".idea/" ".idea_modules/" "*.iml" "*.ipr"
      # Vim
      ".sw[a-p]" ".*.sw[a-p]" "Session.vim" ".netrwhist" "*~" "tags"
      # sbt
      "dist/*" "target/" "lib_managed/" "src_managed/" "project/boot/" "project/plugins/project/" ".history" ".cache" ".lib/"
      # Gradle
      ".gradle" "**/build/" "gradle-app.setting" ".gradletasknamecache"
      # Haskell
      "dist" "dist-*" "cabal-dev" "*.o" "*.hi" "*.chi" "*.chs.h" "*.dyn_o" "*.dyn_hi" ".hpc" ".hsenv" ".cabal-sandbox/" "cabal.sandbox.config" "*.prof" "*.aux" "*.hp" "*.eventlog" ".stack-work/" "cabal.project.local" "cabal.project.local~" ".HTF/" ".ghc.environment.*"
      # direnv
      ".envrc"
    ];
    extraConfig = {
      code.editor = "nvim";
      diff.tool = "vdiff";
      diff.algorithm = "histogram";
      "difftool \"vdiff\"".cmd = "nvim -d $LOCAL $REMOTE";
      difftool.promt = true;
      merge.tool = "vmerge";
      "mergetool \"vmerge\"".cmd = "nvim -d $LOCAL $REMOTE $MERGED -c 'wincmd w' -c 'wincmd J'";
      mergetool.promt = true;
      pull.rebase = true;
      rebase.autoStash = true;
      commit.template = "${config.xdg.configHome}/${commit}";
    };
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
    gitAndTools.hub
    git-secret
    gnupg
  ];
}
