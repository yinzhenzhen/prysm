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
  "notice", # "MIT,Apache-2.0"
])

load(
    "@io_bazel_rules_rust//rust:rust.bzl",
    "rust_library",
    "rust_binary",
    "rust_test",
)



rust_library(
    name = "bls_aggregates",
    crate_root = "src/lib.rs",
    crate_type = "lib",
    edition = "2015",
    srcs = glob(["**/*.rs"]),
    deps = [
        "@raze__amcl__0_1_0//:amcl",
        "@raze__criterion__0_2_11//:criterion",
        "@raze__hex__0_3_2//:hex",
        "@raze__lazy_static__1_3_0//:lazy_static",
        "@raze__rand__0_5_6//:rand",
        "@raze__tiny_keccak__1_4_2//:tiny_keccak",
        "@raze__yaml_rust__0_4_3//:yaml_rust",
    ],
    rustc_flags = [
        "--cap-lints=allow",
    ],
    version = "0.6.1",
    crate_features = [
    ],
)

# Unsupported target "bls381_benches" with type "bench" omitted
