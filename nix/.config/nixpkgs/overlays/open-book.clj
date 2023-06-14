(ns open-book
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :refer [split-lines split join trim]]))

(def home (System/getenv "HOME"))

(def books (-> (sh "fd"
                   "--type" "file"
                   "."
                   "./Books"
                   "./Pragmatic Bookshelf"
                   "./Dropbox/piano"
                   :dir home)
               :out
               split-lines))

(def pattern->book
  (into {}
        (for [book books]
          [(->> (split book #"/") reverse (join " 〈 "))
           book])))

(def selection (let [{:keys [out exit]}
                     (sh "rofi" "-dmenu"
                         "-i"                ;; case insensitive
                         "-p" "Open a book"  ;; prompt
                         :in (join "\n" (keys pattern->book)))]
                 (when (zero? exit) (trim out))))

(when selection
  (sh "xdg-open" (pattern->book selection)
      :dir home))
