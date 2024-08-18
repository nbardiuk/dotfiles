{ lib, pkgs, ... }:
let
  nrepl = ''"RELEASE"'';
  cider-nrepl = ''"RELEASE"'';
  hashp = ''"RELEASE"'';
  portal = ''"RELEASE"'';
  kaocha = ''"RELEASE"'';
  middleware = "cider.nrepl/cider-middleware";
  humane-test-output = ''"RELEASE"'';
  same-jdk = pkgs.jdk21;
in
{
  home.packages = with pkgs; [
    same-jdk
    (clojure.override { jdk = same-jdk; })
    babashka
    clj-kondo
    zprint
  ];

  home.file.".clojure/deps.edn".text = ''
    {:aliases
     {:nrepl
      {:extra-deps {nrepl/nrepl               {:mvn/version ${nrepl}}
                    cider/cider-nrepl         {:mvn/version ${cider-nrepl}}
                    hashp/hashp               {:mvn/version ${hashp}}
                    djblue/portal             {:mvn/version ${portal}}
                    lambdaisland/kaocha       {:mvn/version ${kaocha}}
                    pjstadig/humane-test-output {:mvn/version ${humane-test-output}}}
       :jvm-opts ["-Djdk.attach.allowAttachSelf"]
       :main-opts  ["-e" "(require,'hashp.core)"
                    "-e" "((requiring-resolve 'portal.api/tap))"
                    "-e" "((requiring-resolve 'pjstadig.humane-test-output/activate!))"
                    "--main" "nrepl.cmdline"
                    "--middleware" "[${middleware}]"]}}}
  '';

  xdg.configFile."clojure-lsp/config.edn".text = ''
    {:cljfmt {:remove-surrounding-whitespace? true
              :remove-trailing-whitespace? true
              :remove-consecutive-blank-lines? true
              :insert-missing-whitespace? true}
     :hover  {:hide-file-location? true}
     :java   {:jdk-source-uri "file://${same-jdk}/lib/src.zip"
              :decompile-jar-as-project? true}}
  '';

  home.file.".zprint.edn".text = ''
    {:search-config? true
:style :indent-only
 :set {; Sort sets.
       :sort-in-code? true
       :sort? true}
 :map {; Do not put commas in maps.
       :comma? false
       ; Sort map keys
       :sort? true
       :sort-in-code? true}
 ; Set max width to 100 characters.
 :width 100
    }
  '';
}
