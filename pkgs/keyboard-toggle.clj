(ns keyboard-toggle
  (:require [clojure.java.shell :refer [sh]]
            [clojure.string :as string]))

(defn parse-entry [s]
  (let [entry (into {} (map vector [:name :id :status] (string/split s #"\t")))]
    (-> entry
        (update :id #(re-find #"\d+" %))
        (update :status (comp set #(re-seq #"[a-z]+" %))))))

(def keyboards
  (->> (sh "xinput" "--list") :out
       string/split-lines
       (filter #(re-find #"keyboard" %))))

(def master
  (->> keyboards
       (filter #(re-find #"master" %))
       first
       parse-entry))

(def selection
  (let [{:keys [out exit]}
        (sh "rofi" "-dmenu"
            "-i"                      ;; case insensitive
            "-p" "Toggle Keyboard"    ;; prompt
            :in (string/join "\n" keyboards))]
    (when (zero? exit) (parse-entry out))))

(when selection
  (cond
    ((:status selection) "floating") (sh "xinput" "reattach" (:id selection) (:id master))
    ((:status selection) "slave") (sh "xinput" "float" (:id selection))))
