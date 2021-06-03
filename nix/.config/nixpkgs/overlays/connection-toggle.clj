(ns connection-toggle
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :as str]))

;; get table of connections from nmcli
(def table (-> (sh "nmcli"
                   "--colors" "no"
                   "--fields" "name,type,state"
                   "connection" "show")
               :out
               str/split-lines))

;; use rofi promt to chose connection
(def selection (let [header (first table)
                     rows (rest table)
                     {:keys [out exit]}
                     (sh "rofi" "-dmenu"
                         "-i"                      ;; case insensitive
                         "-p" "Toggle Connection"  ;; prompt
                         "-mesg" header
                         :in (str/join "\n" rows))]
                 (when (zero? exit) out)))

;; toggle connection
(let [[name _ state] (some-> selection (str/split  #"\s{2,}"))
      action (if (= "--" state) "up" "down")]
  (when (some? state)
    (sh "nmcli" "connection" action name)))


