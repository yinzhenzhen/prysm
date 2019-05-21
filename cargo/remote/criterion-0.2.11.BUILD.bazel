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
  "notice", # "Apache-2.0,MIT"
])

load(
    "@io_bazel_rules_rust//rust:rust.bzl",
    "rust_library",
    "rust_binary",
    "rust_test",
)


# Unsupported target "bench_main" with type "bench" omitted

rust_library(
    name = "criterion",
    crate_root = "src/lib.rs",
    crate_type = "lib",
    edition = "2015",
    srcs = glob(["**/*.rs"]),
    deps = [
        "@raze__atty__0_2_11//:atty",
        "@raze__cast__0_2_2//:cast",
        "@raze__clap__2_33_0//:clap",
        "@raze__criterion_plot__0_3_1//:criterion_plot",
        "@raze__csv__1_0_7//:csv",
        "@raze__itertools__0_8_0//:itertools",
        "@raze__lazy_static__1_3_0//:lazy_static",
        "@raze__libc__0_2_55//:libc",
        "@raze__num_traits__0_2_7//:num_traits",
        "@raze__rand_core__0_3_1//:rand_core",
        "@raze__rand_os__0_1_3//:rand_os",
        "@raze__rand_xoshiro__0_1_0//:rand_xoshiro",
        "@raze__rayon__1_0_3//:rayon",
        "@raze__rayon_core__1_4_1//:rayon_core",
        "@raze__serde__1_0_91//:serde",
        "@raze__serde_derive__1_0_91//:serde_derive",
        "@raze__serde_json__1_0_39//:serde_json",
        "@raze__tinytemplate__1_0_2//:tinytemplate",
        "@raze__walkdir__2_2_7//:walkdir",
    ],
    rustc_flags = [
        "--cap-lints=allow",
    ],
    version = "0.2.11",
    crate_features = [
        "criterion-plot",
        "default",
        "html_reports",
        "tinytemplate",
    ],
)

# Unsupported target "criterion_tests" with type "test" omitted
