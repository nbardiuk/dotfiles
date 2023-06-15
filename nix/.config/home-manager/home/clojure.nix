{ lib, pkgs, ... }:
let
  nrepl = ''"RELEASE"'';
  cider-nrepl = ''"RELEASE"'';
  hashp = ''"RELEASE"'';
  portal = ''"RELEASE"'';
  kaocha = ''"RELEASE"'';
  middleware = "cider.nrepl/cider-middleware";
  humane-test-output = ''"RELEASE"'';
  same-jdk = pkgs.jdk;
in
{
  home.packages = with pkgs; [
    same-jdk
    (leiningen.override { jdk = same-jdk; })
    (clojure.override { jdk = same-jdk; })
    babashka
    clj-kondo
    zprint
  ];

  home.file."/.lein/profiles.clj".text = ''
    {:repl
     {:dependencies     [[nrepl               ${nrepl}]
                         [djblue/portal       ${portal}]
                         [hashp               ${hashp}]
                         [lambdaisland/kaocha ${kaocha}]]
      :nrepl-middleware [${middleware}]
      :plugins          [[cider/cider-nrepl         ${cider-nrepl}]]
      :injections       [(require 'hashp.core)((requiring-resolve 'portal.api/tap))]}}
  '';

  xdg.configFile."clojure/deps.edn".text = ''
    {:aliases
     {:nrepl
      {:extra-deps {nrepl/nrepl               {:mvn/version ${nrepl}}
                    cider/cider-nrepl         {:mvn/version ${cider-nrepl}}
                    hashp/hashp               {:mvn/version ${hashp}}
                    djblue/portal             {:mvn/version ${portal}}
                    lambdaisland/kaocha       {:mvn/version ${kaocha}}
                    pjstadig/humane-test-output {:mvn/version ${humane-test-output}}}
       :main-opts  ["-e" "(require,'hashp.core)"
                    "-e" "((requiring-resolve 'portal.api/tap))"
                    "-e" "((requiring-resolve 'pjstadig.humane-test-output/activate!))"
                    "-m" "nrepl.cmdline" "--middleware" "[${middleware}]"]}}}
  '';

  xdg.configFile."clojure-lsp/config.edn".text = ''
    {:cljfmt {:remove-surrounding-whitespace? true
              :remove-trailing-whitespace? true
              :remove-consecutive-blank-lines? true
              :insert-missing-whitespace? true}
     :hover  {:hide-file-location? true}}
  '';

  home.file.".zprint.edn".text = ''
    {:search-config? true}
  '';
}
