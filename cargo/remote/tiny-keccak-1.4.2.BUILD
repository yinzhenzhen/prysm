"""
cargo-raze crate build file.

DO NOT EDIT! Replaced on runs of cargo-raze
"""
package(default_visibility = [
  # Public for visibility by "@raze__crate__version//" targets.
  #
  # Prefer access through "//cargo", which limits external
  # visibility to explicit Cargo.toml dependencies.
  "//visibility:public",
])

licenses([
  "unencumbered", # "CC0-1.0"
])

load(
    "@io_bazel_rules_rust//rust:rust.bzl",
    "rust_library",
    "rust_binary",
    "rust_test",
)


# Unsupported target "sha3" with type "bench" omitted
# Unsupported target "simple" with type "example" omitted
# Unsupported target "test" with type "test" omitted

rust_library(
    name = "tiny_keccak",
    crate_root = "src/lib.rs",
    crate_type = "lib",
    edition = "2015",
    srcs = glob(["**/*.rs"]),
    deps = [
        "@raze__crunchy__0_1_6//:crunchy",
    ],
    rustc_flags = [
        "--cap-lints=allow",
    ],
    version = "1.4.2",
    crate_features = [
    ],
)

