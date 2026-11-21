# syntax=docker/dockerfile:1
# The long tag looks fully pinned and is not: no patch-level temurin tag is
# published, so temurin-25 floats and a JDK rebuild would move this image with
# no commit behind it. The digest is the index, so it covers both architectures.
FROM clojure:temurin-27-tools-deps-1.12.6.1673-trixie-slim@sha256:95f73d2d4f6495a83b1cddfeee7538e5d5a48bb229813fb508644260940d2dee

ARG CLJ_KONDO_VERSION=2026.10.26
ARG CLJFMT_VERSION=0.16.6
ARG TARGETARCH

# Both tools ship a native binary, so they live in the image and the project's
# deps.edn declares nothing. The archives are per-architecture and so are their
# checksums, so the architecture buildkit is targeting picks both.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
         amd64) arch=amd64; \
                kondo_sha=22696257b98c34fe305f478a255e67573a9e1482ecfcef8e3c3412e60a946a35; \
                cljfmt_sha=39db2aaa1eacdbae6a555d29df9b499727717c9e000c12403d70c5d8b3f34237 ;; \
         arm64) arch=aarch64; \
                kondo_sha=8825e6bcdc443d222dd86d0167fea7e59342446f31de591e089a04b029fbf352; \
                cljfmt_sha=ecda99b7270daa649ef0bfc01f15e73201e87917940642fde132ce8fc589bace ;; \
         *) echo "no clj-kondo or cljfmt release for architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl -fsSL -o /tmp/clj-kondo.zip \
         "https://github.com/clj-kondo/clj-kondo/releases/download/v${CLJ_KONDO_VERSION}/clj-kondo-${CLJ_KONDO_VERSION}-linux-${arch}.zip" \
    && printf '%s  /tmp/clj-kondo.zip\n' "$kondo_sha" > /tmp/clj-kondo.sha256 \
    && sha256sum -c /tmp/clj-kondo.sha256 \
    && unzip -q -d /usr/local/bin /tmp/clj-kondo.zip \
    && curl -fsSL -o /tmp/cljfmt.tar.gz \
         "https://github.com/weavejester/cljfmt/releases/download/${CLJFMT_VERSION}/cljfmt-${CLJFMT_VERSION}-linux-${arch}.tar.gz" \
    && printf '%s  /tmp/cljfmt.tar.gz\n' "$cljfmt_sha" > /tmp/cljfmt.sha256 \
    && sha256sum -c /tmp/cljfmt.sha256 \
    && tar -xzf /tmp/cljfmt.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/clj-kondo /usr/local/bin/cljfmt \
    && rm /tmp/clj-kondo.zip /tmp/clj-kondo.sha256 /tmp/cljfmt.tar.gz /tmp/cljfmt.sha256

COPY <<'EDN' /opt/clojure-test-runner/deps.edn
{:paths ["src"]}
EDN

COPY <<'CLJ' /opt/clojure-test-runner/src/bootstrap/test_runner.clj
(ns bootstrap.test-runner
  "clojure.test has no command-line runner: run-tests takes the namespaces as
  arguments, and naming them is what a deletable suite cannot afford."
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.test :as test])
  (:import (java.io PushbackReader)))

(defn- declared-ns
  "The symbol in the file's own (ns ...) form. A path cannot be mapped back to a
  namespace, because munging a hyphen to an underscore does not reverse."
  [^java.io.File file]
  (with-open [reader (PushbackReader. (io/reader file))]
    (loop []
      (let [form (read {:eof ::eof :read-cond :allow} reader)]
        (cond
          (= ::eof form) nil
          (and (seq? form) (= 'ns (first form))) (second form)
          :else (recur))))))

(defn- source?
  [^java.io.File file]
  (let [filename (.getName file)]
    (and (.isFile file)
         (or (str/ends-with? filename ".clj")
             (str/ends-with? filename ".cljc")))))

(defn- test-namespaces
  [dirs]
  (->> dirs
       (mapcat (comp file-seq io/file))
       (filter source?)
       (sort-by (fn [^java.io.File file] (.getPath file)))
       (keep declared-ns)
       distinct))

(defn -main
  [& dirs]
  (let [namespaces (test-namespaces (or (seq dirs) ["test"]))]
    (run! require namespaces)
    (let [{:keys [fail error]} (if (seq namespaces)
                                 (apply test/run-tests namespaces)
                                 (do (println "No test namespaces found.")
                                     {:fail 0 :error 0}))]
      (shutdown-agents)
      (System/exit (if (zero? (+ fail error)) 0 1)))))
CLJ

# The uid Compose maps in has no passwd entry, so $HOME is / and the JVM's
# user.home follows it -- which is where ~/.m2 and ~/.gitlibs would land.
ENV HOME=/cache
ENV CLJ_CONFIG=/cache/clojure
ENV CLJ_CACHE=/cache/cpcache
ENV GITLIBS=/cache/gitlibs

# root has a passwd entry and the run-time uid does not, so user.home is /root
# at build time and /cache at run time. Naming the repository makes the two
# agree, which is what lets the layer below prime it.
RUN mkdir -p /cache/clojure \
    && printf '%s\n' '{:mvn/local-repo "/cache/m2"}' > /cache/clojure/deps.edn

# A cold run downloads Clojure itself and computes the classpath before it
# reaches a line of test code. Priming it here seeds both named volumes from
# the image, so the first `make test` pays for neither.
WORKDIR /work
COPY deps.edn ./
# /cache and the .cpcache mount point are world-writable so the service runs as
# any host uid without a passwd entry or a writable $HOME. See
# docs/containers.md "File ownership". The chmod shares this layer deliberately:
# run separately it rewrites the mode of every jar just cached, and overlayfs
# then copies all of it again.
RUN clojure -P -M:test \
    && rm /work/deps.edn \
    && chmod -R 777 /cache /work/.cpcache
