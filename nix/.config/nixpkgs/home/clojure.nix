{ lib, pkgs, ... }:
let
  nrepl = ''"0.9.0"'';
  cider-nrepl = ''"0.28.3"'';
  hashp = ''"0.1.1"'';
  humane-test-output = ''"0.11.0"'';
  portal = ''"0.23.0"'';
  middleware = lib.concatStringsSep "," [ "cider.nrepl/cider-middleware" ];
  same-jdk = pkgs.jdk;
in
{
  home.packages = with pkgs; [
    same-jdk
    (leiningen.override { jdk = same-jdk; })
    (clojure.override { jdk = same-jdk; })
    babashka
  ];

  home.file."/.lein/profiles.clj".text = ''
    {:user
      {:dependencies [[nrepl ${nrepl}]
                      [cider/cider-nrepl ${cider-nrepl}]
                      [hashp ${hashp}]
                      [djblue/portal ${portal}]
                      [pjstadig/humane-test-output ${humane-test-output}]]
       :repl-options {:nrepl-middleware [${middleware}]
                      :prompt (fn [ns]
                        (let [dir-context (->> (clojure.string/split (System/getenv "PWD") #"/")
                                               (take-last 2)
                                               (clojure.string/join "/"))
                              terminal-title (format "\033]0;repl %s\007" dir-context)]
                          (format "%s%s %s\nλ " terminal-title dir-context ns)))}
        :injections  [(require 'hashp.core)
                      (require 'pjstadig.humane-test-output)
                      (pjstadig.humane-test-output/activate!)]}}
  '';

  xdg.configFile."clojure/deps.edn".text = ''
    {:aliases
      {:nrepl
        {:extra-deps {nrepl/nrepl {:mvn/version ${nrepl}}
                      cider/cider-nrepl {:mvn/version ${cider-nrepl}}
                      hashp/hashp {:mvn/version ${hashp}}
                      djblue/portal {:mvn/version ${portal}}
                      pjstadig/humane-test-output {:mvn/version ${humane-test-output}}}
         :main-opts  ["-e" "(require,'hashp.core)"
                      "-e" "(require,'pjstadig.humane-test-output)"
                      "-e" "(pjstadig.humane-test-output/activate!)"
                      "-m" "nrepl.cmdline" "--middleware" "[${middleware}]"]}}}
  '';

  xdg.configFile."clojure-lsp/config.edn".text = ''
    {:cljfmt
     {:remove-surrounding-whitespace? true
      :remove-trailing-whitespace? true
      :remove-consecutive-blank-lines? true
      :insert-missing-whitespace? true}
     :hover {:hide-file-location? true}}
  '';
}
