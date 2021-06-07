#!/usr/bin/env bb
(ns pre-commit
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :refer [split-lines]]))

(def changes
  (-> (sh "git" "diff" "--cached" "--name-only") :out split-lines))

(def matches
  (->> (apply (partial
               sh "grep"
               "-E" "(^| )#p($| )"
               "--with-filename"
               "--line-number")
              changes)
       :out
       split-lines
       (keep not-empty)))

(when (seq matches)
  (println "Extra hashp:")
  (run! println matches)
  (System/exit 1))

