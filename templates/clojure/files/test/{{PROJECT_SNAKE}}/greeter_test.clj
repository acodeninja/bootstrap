(ns {{PROJECT_SLUG}}.greeter-test
  (:require [clojure.test :refer [deftest is]]
            [{{PROJECT_SLUG}}.greeter :as greeter]))

(deftest a-greeting-addresses-the-name-it-is-given
  (let [greeting (greeter/greet "world")]

    (is (= "Hello, world!" greeting))))
