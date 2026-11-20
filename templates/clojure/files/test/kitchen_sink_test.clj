(ns kitchen-sink-test
  "Fifteen passing tests: the toolbox for solving a kata in Clojure."
  (:require [clojure.string :as str]
            [clojure.test :refer [deftest is]])
  (:import (clojure.lang ExceptionInfo)))

;; collections

(deftest a-vector-keeps-what-you-put-in-it-in-order
  (let [items ["a" "b"]
        grown (conj items "c")]

    (is (= ["a" "b" "c"] grown))
    (is (= 3 (count grown)))
    (is (= ["b" "c"] (subvec grown 1 3)))))

(deftest a-lookup-for-a-key-that-is-not-there-comes-back-nil
  (let [counts {"a" 2 "b" 1}]

    (is (= 2 (get counts "a")))
    (is (nil? (get counts "z")))
    (is (= 0 (get counts "z" 0)))))

(deftest a-set-discards-duplicates-and-answers-as-a-function
  (let [letters #{"a" "b"}
        grown (conj letters "a")]

    (is (= 2 (count grown)))
    (is (= "a" (grown "a")))
    (is (nil? (grown "z")))))

;; strings

(deftest a-string-splits-into-parts-and-joins-back-up
  (let [words (str/split "one two three" #" ")]

    (is (= ["one" "two" "three"] words))
    (is (= "one-two-three" (str/join "-" words)))))

(deftest a-slice-of-a-string-counts-from-zero-and-a-character-is-not-a-string
  (let [text "abcdef"]

    (is (= \a (first text)))
    (is (= "abc" (subs text 0 3)))
    (is (= "ef" (subs text (- (count text) 2))))))

(deftest text-is-assembled-by-str-and-laid-out-by-format
  (let [label "world"
        times 2]

    (is (= "world x2" (format "%s x%d" label times)))
    (is (= "ababab" (apply str (repeat 3 "ab"))))
    (is (= "padded" (str/trim "  padded  ")))))

;; types and branching

(deftest assoc-returns-a-new-map-and-leaves-the-original-alone
  (let [record {:x 1 :y 2}
        moved (assoc record :x 5)]

    (is (= {:x 5 :y 2} moved))
    (is (= {:x 1 :y 2} record))
    (is (= 1 (:x record)))))

(deftest a-case-over-keywords-needs-a-fallback-of-its-own
  ;; Keywords are the fixed set of named states, and nothing checks that a case
  ;; covered them all -- without the trailing default this throws instead.
  (let [next-state (fn [state]
                     (case state
                       :locked :open
                       :open :locked
                       :unknown))]

    (is (= :open (next-state :locked)))
    (is (= :locked (next-state :open)))
    (is (= :unknown (next-state :broken)))))

(deftest a-branch-produces-a-value-instead-of-setting-one
  (let [describe (fn [n]
                   (cond
                     (neg? n) "negative"
                     (zero? n) "zero"
                     :else "positive"))]

    (is (= "negative" (describe -1)))
    (is (= "zero" (describe 0)))
    (is (= "positive" (describe 1)))))

;; iteration

(deftest a-walk-can-read-both-the-position-and-the-item
  (let [items ["a" "b"]
        seen (map-indexed (fn [index item] (str index ":" item)) items)]

    (is (= ["0:a" "1:b"] (vec seen)))
    (is (= [1] (keep-indexed (fn [index item] (when (= "b" item) index)) items)))))

(deftest a-sequence-can-be-walked-two-items-at-a-time
  (let [values [1 2 3 4]
        pairs (partition 2 1 values)]

    (is (= [[1 2] [2 3] [3 4]] (map vec pairs)))
    (is (= [3 5 7] (map (partial apply +) pairs)))))

;; functions

(deftest a-function-can-be-handed-to-another-function
  (let [twice (fn [n] (* 2 n))]

    (is (= [2 4 6] (map twice [1 2 3])))
    (is (= [2 3] (filter (fn [n] (> n 1)) [1 2 3])))))

(deftest a-collection-is-folded-down-to-one-value-by-reduce
  (let [values [1 2 3 4]
        total (reduce + 0 values)
        counts (reduce (fn [acc value] (update acc value (fnil inc 0))) {} [1 1 2])]

    (is (= 10 total))
    (is (= {1 2, 2 1} counts))))

;; errors

(defn- parse-percentage
  [input]
  (let [value (parse-long input)]
    (when (or (nil? value) (neg? value) (> value 100))
      (throw (ex-info "not a percentage" {:type ::invalid :input input})))
    value))

(deftest an-invalid-input-is-refused-rather-than-guessed-at
  (is (= 40 (parse-percentage "40")))

  (is (thrown-with-msg? ExceptionInfo #"not a percentage" (parse-percentage "half")))
  (is (= {:type ::invalid :input "140"}
         (ex-data (try (parse-percentage "140") (catch ExceptionInfo error error))))))

;; gotchas

(deftest a-lazy-sequence-does-no-work-until-something-reads-it
  (let [seen (atom [])
        pending (map (fn [n] (swap! seen conj n) n) [1 2 3])]

    (is (= [] @seen))
    (is (= [1 2 3] (doall pending)))
    (is (= [1 2 3] @seen))))
