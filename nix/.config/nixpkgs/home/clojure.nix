{ lib, pkgs, ... }:
let
  # https://liquidz.github.io/vim-iced/vim-iced.html#vim-iced-install-manually
  # https://github.com/liquidz/vim-iced/blob/master/bin/iced
  nrepl = ''"0.8.3"'';
  iced-nrepl = ''"1.2.1"'';
  cider-nrepl = ''"0.25.8"'';
  refactor-nrepl = ''"2.5.1"'';
  hashp = ''"0.1.1"'';
  reveal = ''"1.3.193"'';
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
    "cider.nrepl/wrap-spec"
    "cider.nrepl/wrap-test"
    "cider.nrepl/wrap-trace"
    "cider.nrepl/wrap-undef"
    "cider.nrepl/wrap-xref"
    "refactor-nrepl.middleware/wrap-refactor"
    "iced.nrepl/wrap-iced"
    "vlaaad.reveal.nrepl/middleware"
  ];
in
{
  # clojure uses jdk11
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/interpreters/clojure/default.nix
  home.packages = with pkgs; [
    jdk11
    (leiningen.override { jdk = jdk11; })
    clojure
    rep
  ];

  home.file."/.lein/profiles.clj".text = ''
    {:user
      {:dependencies
        [ [nrepl ${nrepl}]
          [iced-nrepl ${iced-nrepl}]
          [cider/cider-nrepl ${cider-nrepl}]
          [refactor-nrepl ${refactor-nrepl}]
          [hashp ${hashp}]
          [vlaaad/reveal ${reveal}]
        ]
       :repl-options {:nrepl-middleware [${middleware}]
                      :prompt (fn [ns] (format "%s %s\nλ " (clojure.string/join "/" (take-last 2 (clojure.string/split (System/getenv "PWD") #"/"))) ns))
                     }
       :plugins [[refactor-nrepl ${refactor-nrepl}]]
       :injections [(require 'hashp.core)]
       :jvm-opts ["-Dvlaaad.reveal.prefs={:theme :light, :font-family \"Iosevka\", :font-size 16}"]
      }
    }
  '';

  xdg.configFile."clojure/deps.edn".text = ''
    {:aliases
      {:iced
        {:extra-deps { nrepl/nrepl {:mvn/version ${nrepl}}
                       iced-nrepl/iced-nrepl {:mvn/version ${iced-nrepl}}
                       cider/cider-nrepl {:mvn/version ${cider-nrepl}}
                       refactor-nrepl/refactor-nrepl {:mvn/version ${refactor-nrepl}}
                       hashp/hashp {:mvn/version ${hashp}}
                       vlaaad/reveal {:mvn/version ${reveal}}}
         :main-opts ["-m" "nrepl.cmdline" "--middleware" "[${middleware}]"]
        }
      }
    }
  '';
}
