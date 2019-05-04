{...}:
{
  programs.git = {
    enable = true;
    userName = "Nazarii Bardiuk";
    userEmail = "";
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
      "difftool \"vdiff\"".cmd = "nvim -d $LOCAL $REMOTE";
      difftool.promt = true;
      merge.tool = "vmerge";
      "mergetool \"vmerge\"".cmd = "nvim -d $LOCAL $REMOTE $MERGED -c 'wincmd w' -c 'wincmd J'";
      mergetool.promt = true;
    };
  };
}