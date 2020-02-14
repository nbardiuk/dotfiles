{ lib, pkgs, ...}:
let
  # https://liquidz.github.io/vim-iced/vim-iced.html#vim-iced-install-manually
  # https://github.com/liquidz/vim-iced/blob/master/bin/iced
  nrepl = ''"0.6.0"'';
  iced-nrepl = ''"0.7.1"'';
  cider-nrepl = ''"0.24.0"'';
  refactor-nrepl = ''"2.4.0"'';
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
  # clojure uses jdk11
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/interpreters/clojure/default.nix
  home.packages = with pkgs; [
    jdk11
    (leiningen.override { jdk = jdk11; })
    clojure
  ];

  home.file."/.lein/profiles.clj".text = ''
    {:user
      {:dependencies
        [ [nrepl ${nrepl}]
          [iced-nrepl ${iced-nrepl}]
          [cider/cider-nrepl ${cider-nrepl}]
          [refactor-nrepl ${refactor-nrepl}]
          [hashp ${hashp}]
        ]
       :repl-options {:nrepl-middleware [${middleware}]}
       :plugins [[refactor-nrepl ${refactor-nrepl}]]
       :injections [(require 'hashp.core)]
      }
    }
  '';

  home.file.".config/clojure/deps.edn".text = ''
    {:aliases
      {:iced
        {:extra-deps
          { nrepl {:mvn/version ${nrepl}}
            iced-nrepl {:mvn/version ${iced-nrepl}}
            cider/cider-nrepl {:mvn/version ${cider-nrepl}}
            refactor-nrepl {:mvn/version ${refactor-nrepl}}
          }
         :main-opts ["-m" "nrepl.cmdline" "--middleware" "[${middleware}]"]
        }
      }
    }
  '';
}
