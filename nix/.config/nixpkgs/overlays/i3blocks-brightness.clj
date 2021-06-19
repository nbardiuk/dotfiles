(ns brightness
  (:require [clojure.java.shell :refer [sh]]
            [clojure.edn :as edn]))

(def mouse
  ({"1" :left-click
    "2" :middle-click
    "3" :right-click
    "4" :scroll-up
    "5" :scroll-down}
   (System/getenv "button")))

(case mouse
  :scroll-up (sh "light" "-A" "1")
  :scroll-down (sh "light" "-U" "1")
  nil)

(def level
  (-> (sh "light") :out edn/read-string long))

(println (str level "%"))
