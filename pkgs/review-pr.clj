#!/usr/bin/env bb
(ns review-pr
  (:require
    [babashka.fs :as bfs]
    [babashka.process :as process]
    [clojure.java.io :as io]
    [clojure.string :as str]))


(def max-output-capture-bytes
  ;; 1 GB
  (* 1000 1000 1000))


(defn output-prompt
  [{:keys [dir]}]
  (format "[%s]$" (bfs/real-path (or dir "."))))


(defn sh [& args]
  (let [[cmd opts] (split-with string? args)
        opts (merge {:err :out ; redirect err to out
                     :pre-start-fn
                     #(apply println (output-prompt opts) (:cmd %))}
                    (apply hash-map opts))
        pr (apply process/process opts cmd)]
    ;; cache output of the command
    (.mark (:out pr) max-output-capture-bytes)
    ;; print command output to stdout while the command runs
    (io/copy (:out pr) *out*)
    (let [pr @pr]
      (if (zero? (:exit pr))
        (do (.reset (:out pr)) (str/trim (slurp (:out pr))))
        (throw (ex-info (format "Shell error exit code %s" (:exit pr))
                        {:exit (:exit pr)}))))))


(defn fetch [pr]
  (sh "git" "fetch" "origin" (format "refs/pull/%s/head" pr)))


(defn merge-base []
  (sh "git" "merge-base" "HEAD" "main"))


(defn switch-fetch-head []
  (sh "git" "switch" "--detach" "FETCH_HEAD"))


(defn reset [rev]
  (sh "git" "reset" rev))


;; https://matklad.github.io/2023/10/23/unified-vs-split-diff.html
(let [[pr] *command-line-args*]
  (when (empty? pr) (println "Usage: pr") (System/exit 1))
  (fetch pr)
  (switch-fetch-head)
  (reset (merge-base)))
