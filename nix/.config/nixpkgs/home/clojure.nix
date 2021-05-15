{ lib, pkgs, ... }:
let
  # https://liquidz.github.io/vim-iced/vim-iced.html#vim-iced-install-manually
  # https://github.com/liquidz/vim-iced/blob/master/bin/iced
  nrepl = ''"0.8.3"'';
  iced-nrepl = ''"1.2.4"'';
  cider-nrepl = ''"0.26.0"'';
  refactor-nrepl = ''"2.5.1"'';
  hashp = ''"0.1.1"'';
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
    "refactor-nrepl.middleware/wrap-refactor"
    "iced.nrepl/wrap-iced"
  ];
in
{
  home.packages = with pkgs; [
    jdk11
    (leiningen.override { jdk = jdk11; })
    (clojure.override { jdk = jdk11; })
    rep
  ];

  home.file."/.lein/profiles.clj".text = ''
    {:user
      {:dependencies
        [ [nrepl ${nrepl}]
          [com.github.liquidz/iced-nrepl ${iced-nrepl}]
          [cider/cider-nrepl ${cider-nrepl}]
          [refactor-nrepl ${refactor-nrepl}]
          [hashp ${hashp}]
        ]
       :repl-options {:nrepl-middleware [${middleware}]
                      :prompt (fn [ns] (format "%s %s\nλ " (clojure.string/join "/" (take-last 2 (clojure.string/split (System/getenv "PWD") #"/"))) ns))
                     }
       :plugins [[refactor-nrepl ${refactor-nrepl}]]
       :injections [(require 'hashp.core)]
      }
    }
  '';

  xdg.configFile."clojure/deps.edn".text = ''
    {:aliases
      {:iced
        {:extra-deps { nrepl/nrepl {:mvn/version ${nrepl}}
                       com.github.liquidz/iced-nrepl {:mvn/version ${iced-nrepl}}
                       cider/cider-nrepl {:mvn/version ${cider-nrepl}}
                       refactor-nrepl/refactor-nrepl {:mvn/version ${refactor-nrepl}}
                       hashp/hashp {:mvn/version ${hashp}}}
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
}
