{ lib, pkgs, ... }:
let
  nrepl = ''"0.8.3"'';
  cider-nrepl = ''"0.26.0"'';
  hashp = ''"0.1.1"'';
  kaocha = ''"1.0.861"'';
  humane-test-output = ''"0.11.0"'';
  middleware = lib.concatStringsSep "," [
    "cider.nrepl/wrap-classpath"
    "cider.nrepl/wrap-clojuredocs"
    "cider.nrepl/wrap-complete"
    "cider.nrepl/wrap-debug"
    "cider.nrepl/wrap-format"
    "cider.nrepl/wrap-info"
    "cider.nrepl/wrap-macroexpand"
    "cider.nrepl/wrap-ns"
    "cider.nrepl/wrap-out"
    "cider.nrepl/wrap-refresh"
    "cider.nrepl/wrap-spec"
    "cider.nrepl/wrap-test"
    "cider.nrepl/wrap-trace"
    "cider.nrepl/wrap-undef"
    "cider.nrepl/wrap-xref"
  ];
in
{
  home.packages = with pkgs; [
    jdk11
    (leiningen.override { jdk = jdk11; })
    (clojure.override { jdk = jdk11; })
    rep
    babashka
  ];

  home.file."/.lein/profiles.clj".text = ''
    {:user
      {:dependencies
        [ [nrepl ${nrepl}]
          [cider/cider-nrepl ${cider-nrepl}]
          [hashp ${hashp}]
          [lambdaisland/kaocha ${kaocha}]
          [pjstadig/humane-test-output ${humane-test-output}]
        ]
       :repl-options {:nrepl-middleware [${middleware}]
                      :prompt (fn [ns]
                        (let [dir-context (->> (clojure.string/split (System/getenv "PWD") #"/")
                                               (take-last 2)
                                               (clojure.string/join "/"))
                              terminal-title (format "\033]0;repl %s\007" dir-context)]
                          (format "%s%s %s\nλ " terminal-title dir-context ns)))
                     }
        :injections [(require 'hashp.core)
                     (require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
      }
    }
  '';

  xdg.configFile."clojure/deps.edn".text = ''
    {:aliases
      {:rep
        {:extra-deps { nrepl/nrepl {:mvn/version ${nrepl}}
                       cider/cider-nrepl {:mvn/version ${cider-nrepl}}
                       lambdaisland/kaocha {:mvn/version ${kaocha}}
                       hashp/hashp {:mvn/version ${hashp}}
                       pjstadig/humane-test-output {:mvn/version ${humane-test-output}}
                     }
         :main-opts ["-m" "nrepl.cmdline" "--middleware" "[${middleware}]"]
        }
      }
    }
  '';

  xdg.configFile."cljfmt/indentation.edn".text = ''
    {
      Given [[:inner 0]]
      When [[:inner 0]]
      Then [[:inner 0]]
      And [[:inner 0]]
      let-system [[:inner 0]]
    }
  '';

  xdg.configFile.".lsp/config.edn".text = ''
    {:cljfmt
     {:remove-surrounding-whitespace true
      :remove-trailing-whitespace true
      :remove-consecutive-blank-lines true
      :insert-missing-whitespace true
      :indents
      {Given [[:inner 0]]
       When [[:inner 0]]
       Then [[:inner 0]]
       And [[:inner 0]]
       let-system [[:inner 0]]}}
     :hover {:hide-file-location? true}}
  '';
}
