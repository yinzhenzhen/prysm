"""
cargo-raze crate workspace functions

DO NOT EDIT! Replaced on runs of cargo-raze
"""
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def _new_http_archive(name, **kwargs):
    if not native.existing_rule(name):
        http_archive(name=name, **kwargs)

def _new_git_repository(name, **kwargs):
    if not native.existing_rule(name):
        new_git_repository(name=name, **kwargs)

def raze_fetch_remote_crates():

    _new_git_repository(
        name = "raze__amcl__0_1_0",
        remote = "https://github.com/sigp/signature-schemes",
        commit = "1c3f4fb23546c90e3fd59d6d73fb0506c37be2ef",
        build_file = Label("//cargo/remote:amcl-0.1.0.BUILD"),
        init_submodules = True
    )

    _new_http_archive(
        name = "raze__arrayvec__0_4_10",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/arrayvec/arrayvec-0.4.10.crate",
        type = "tar.gz",
        sha256 = "92c7fb76bc8826a8b33b4ee5bb07a247a81e76764ab4d55e8f73e3a4d8808c71",
        strip_prefix = "arrayvec-0.4.10",
        build_file = Label("//cargo/remote:arrayvec-0.4.10.BUILD")
    )

    _new_http_archive(
        name = "raze__atty__0_2_11",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/atty/atty-0.2.11.crate",
        type = "tar.gz",
        sha256 = "9a7d5b8723950951411ee34d271d99dddcc2035a16ab25310ea2c8cfd4369652",
        strip_prefix = "atty-0.2.11",
        build_file = Label("//cargo/remote:atty-0.2.11.BUILD")
    )

    _new_http_archive(
        name = "raze__autocfg__0_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/autocfg/autocfg-0.1.2.crate",
        type = "tar.gz",
        sha256 = "a6d640bee2da49f60a4068a7fae53acde8982514ab7bae8b8cea9e88cbcfd799",
        strip_prefix = "autocfg-0.1.2",
        build_file = Label("//cargo/remote:autocfg-0.1.2.BUILD")
    )

    _new_http_archive(
        name = "raze__bitflags__1_0_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/bitflags/bitflags-1.0.4.crate",
        type = "tar.gz",
        sha256 = "228047a76f468627ca71776ecdebd732a3423081fcf5125585bcd7c49886ce12",
        strip_prefix = "bitflags-1.0.4",
        build_file = Label("//cargo/remote:bitflags-1.0.4.BUILD")
    )

    _new_git_repository(
        name = "raze__bls_aggregates__0_6_1",
        remote = "https://github.com/sigp/signature-schemes",
        commit = "1c3f4fb23546c90e3fd59d6d73fb0506c37be2ef",
        build_file = Label("//cargo/remote:bls-aggregates-0.6.1.BUILD"),
        init_submodules = True
    )

    _new_http_archive(
        name = "raze__byteorder__1_3_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/byteorder/byteorder-1.3.1.crate",
        type = "tar.gz",
        sha256 = "a019b10a2a7cdeb292db131fc8113e57ea2a908f6e7894b0c3c671893b65dbeb",
        strip_prefix = "byteorder-1.3.1",
        build_file = Label("//cargo/remote:byteorder-1.3.1.BUILD")
    )

    _new_http_archive(
        name = "raze__cast__0_2_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cast/cast-0.2.2.crate",
        type = "tar.gz",
        sha256 = "926013f2860c46252efceabb19f4a6b308197505082c609025aa6706c011d427",
        strip_prefix = "cast-0.2.2",
        build_file = Label("//cargo/remote:cast-0.2.2.BUILD")
    )

    _new_http_archive(
        name = "raze__cfg_if__0_1_9",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cfg-if/cfg-if-0.1.9.crate",
        type = "tar.gz",
        sha256 = "b486ce3ccf7ffd79fdeb678eac06a9e6c09fc88d33836340becb8fffe87c5e33",
        strip_prefix = "cfg-if-0.1.9",
        build_file = Label("//cargo/remote:cfg-if-0.1.9.BUILD")
    )

    _new_http_archive(
        name = "raze__clap__2_33_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/clap/clap-2.33.0.crate",
        type = "tar.gz",
        sha256 = "5067f5bb2d80ef5d68b4c87db81601f0b75bca627bc2ef76b141d7b846a3c6d9",
        strip_prefix = "clap-2.33.0",
        build_file = Label("//cargo/remote:clap-2.33.0.BUILD")
    )

    _new_http_archive(
        name = "raze__cloudabi__0_0_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/cloudabi/cloudabi-0.0.3.crate",
        type = "tar.gz",
        sha256 = "ddfc5b9aa5d4507acaf872de71051dfd0e309860e88966e1051e462a077aac4f",
        strip_prefix = "cloudabi-0.0.3",
        build_file = Label("//cargo/remote:cloudabi-0.0.3.BUILD")
    )

    _new_http_archive(
        name = "raze__criterion__0_2_11",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/criterion/criterion-0.2.11.crate",
        type = "tar.gz",
        sha256 = "0363053954f3e679645fc443321ca128b7b950a6fe288cf5f9335cc22ee58394",
        strip_prefix = "criterion-0.2.11",
        build_file = Label("//cargo/remote:criterion-0.2.11.BUILD")
    )

    _new_http_archive(
        name = "raze__criterion_plot__0_3_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/criterion-plot/criterion-plot-0.3.1.crate",
        type = "tar.gz",
        sha256 = "76f9212ddf2f4a9eb2d401635190600656a1f88a932ef53d06e7fa4c7e02fb8e",
        strip_prefix = "criterion-plot-0.3.1",
        build_file = Label("//cargo/remote:criterion-plot-0.3.1.BUILD")
    )

    _new_http_archive(
        name = "raze__crossbeam_deque__0_2_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-deque/crossbeam-deque-0.2.0.crate",
        type = "tar.gz",
        sha256 = "f739f8c5363aca78cfb059edf753d8f0d36908c348f3d8d1503f03d8b75d9cf3",
        strip_prefix = "crossbeam-deque-0.2.0",
        build_file = Label("//cargo/remote:crossbeam-deque-0.2.0.BUILD")
    )

    _new_http_archive(
        name = "raze__crossbeam_epoch__0_3_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-epoch/crossbeam-epoch-0.3.1.crate",
        type = "tar.gz",
        sha256 = "927121f5407de9956180ff5e936fe3cf4324279280001cd56b669d28ee7e9150",
        strip_prefix = "crossbeam-epoch-0.3.1",
        build_file = Label("//cargo/remote:crossbeam-epoch-0.3.1.BUILD")
    )

    _new_http_archive(
        name = "raze__crossbeam_utils__0_2_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crossbeam-utils/crossbeam-utils-0.2.2.crate",
        type = "tar.gz",
        sha256 = "2760899e32a1d58d5abb31129f8fae5de75220bc2176e77ff7c627ae45c918d9",
        strip_prefix = "crossbeam-utils-0.2.2",
        build_file = Label("//cargo/remote:crossbeam-utils-0.2.2.BUILD")
    )

    _new_http_archive(
        name = "raze__crunchy__0_1_6",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/crunchy/crunchy-0.1.6.crate",
        type = "tar.gz",
        sha256 = "a2f4a431c5c9f662e1200b7c7f02c34e91361150e382089a8f2dec3ba680cbda",
        strip_prefix = "crunchy-0.1.6",
        build_file = Label("//cargo/remote:crunchy-0.1.6.BUILD")
    )

    _new_http_archive(
        name = "raze__csv__1_0_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/csv/csv-1.0.7.crate",
        type = "tar.gz",
        sha256 = "9044e25afb0924b5a5fc5511689b0918629e85d68ea591e5e87fbf1e85ea1b3b",
        strip_prefix = "csv-1.0.7",
        build_file = Label("//cargo/remote:csv-1.0.7.BUILD")
    )

    _new_http_archive(
        name = "raze__csv_core__0_1_5",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/csv-core/csv-core-0.1.5.crate",
        type = "tar.gz",
        sha256 = "fa5cdef62f37e6ffe7d1f07a381bc0db32b7a3ff1cac0de56cb0d81e71f53d65",
        strip_prefix = "csv-core-0.1.5",
        build_file = Label("//cargo/remote:csv-core-0.1.5.BUILD")
    )

    _new_http_archive(
        name = "raze__either__1_5_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/either/either-1.5.2.crate",
        type = "tar.gz",
        sha256 = "5527cfe0d098f36e3f8839852688e63c8fff1c90b2b405aef730615f9a7bcf7b",
        strip_prefix = "either-1.5.2",
        build_file = Label("//cargo/remote:either-1.5.2.BUILD")
    )

    _new_http_archive(
        name = "raze__fuchsia_cprng__0_1_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/fuchsia-cprng/fuchsia-cprng-0.1.1.crate",
        type = "tar.gz",
        sha256 = "a06f77d526c1a601b7c4cdd98f54b5eaabffc14d5f2f0296febdc7f357c6d3ba",
        strip_prefix = "fuchsia-cprng-0.1.1",
        build_file = Label("//cargo/remote:fuchsia-cprng-0.1.1.BUILD")
    )

    _new_http_archive(
        name = "raze__hex__0_3_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/hex/hex-0.3.2.crate",
        type = "tar.gz",
        sha256 = "805026a5d0141ffc30abb3be3173848ad46a1b1664fe632428479619a3644d77",
        strip_prefix = "hex-0.3.2",
        build_file = Label("//cargo/remote:hex-0.3.2.BUILD")
    )

    _new_http_archive(
        name = "raze__itertools__0_8_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/itertools/itertools-0.8.0.crate",
        type = "tar.gz",
        sha256 = "5b8467d9c1cebe26feb08c640139247fac215782d35371ade9a2136ed6085358",
        strip_prefix = "itertools-0.8.0",
        build_file = Label("//cargo/remote:itertools-0.8.0.BUILD")
    )

    _new_http_archive(
        name = "raze__itoa__0_4_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/itoa/itoa-0.4.4.crate",
        type = "tar.gz",
        sha256 = "501266b7edd0174f8530248f87f99c88fbe60ca4ef3dd486835b8d8d53136f7f",
        strip_prefix = "itoa-0.4.4",
        build_file = Label("//cargo/remote:itoa-0.4.4.BUILD")
    )

    _new_http_archive(
        name = "raze__lazy_static__1_3_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/lazy_static/lazy_static-1.3.0.crate",
        type = "tar.gz",
        sha256 = "bc5729f27f159ddd61f4df6228e827e86643d4d3e7c32183cb30a1c08f604a14",
        strip_prefix = "lazy_static-1.3.0",
        build_file = Label("//cargo/remote:lazy_static-1.3.0.BUILD")
    )

    _new_http_archive(
        name = "raze__libc__0_2_55",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/libc/libc-0.2.55.crate",
        type = "tar.gz",
        sha256 = "42914d39aad277d9e176efbdad68acb1d5443ab65afe0e0e4f0d49352a950880",
        strip_prefix = "libc-0.2.55",
        build_file = Label("//cargo/remote:libc-0.2.55.BUILD")
    )

    _new_http_archive(
        name = "raze__linked_hash_map__0_5_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/linked-hash-map/linked-hash-map-0.5.2.crate",
        type = "tar.gz",
        sha256 = "ae91b68aebc4ddb91978b11a1b02ddd8602a05ec19002801c5666000e05e0f83",
        strip_prefix = "linked-hash-map-0.5.2",
        build_file = Label("//cargo/remote:linked-hash-map-0.5.2.BUILD")
    )

    _new_http_archive(
        name = "raze__memchr__2_2_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/memchr/memchr-2.2.0.crate",
        type = "tar.gz",
        sha256 = "2efc7bc57c883d4a4d6e3246905283d8dae951bb3bd32f49d6ef297f546e1c39",
        strip_prefix = "memchr-2.2.0",
        build_file = Label("//cargo/remote:memchr-2.2.0.BUILD")
    )

    _new_http_archive(
        name = "raze__memoffset__0_2_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/memoffset/memoffset-0.2.1.crate",
        type = "tar.gz",
        sha256 = "0f9dc261e2b62d7a622bf416ea3c5245cdd5d9a7fcc428c0d06804dfce1775b3",
        strip_prefix = "memoffset-0.2.1",
        build_file = Label("//cargo/remote:memoffset-0.2.1.BUILD")
    )

    _new_http_archive(
        name = "raze__nodrop__0_1_13",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/nodrop/nodrop-0.1.13.crate",
        type = "tar.gz",
        sha256 = "2f9667ddcc6cc8a43afc9b7917599d7216aa09c463919ea32c59ed6cac8bc945",
        strip_prefix = "nodrop-0.1.13",
        build_file = Label("//cargo/remote:nodrop-0.1.13.BUILD")
    )

    _new_http_archive(
        name = "raze__num_traits__0_2_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/num-traits/num-traits-0.2.7.crate",
        type = "tar.gz",
        sha256 = "d9c79c952a4a139f44a0fe205c4ee66ce239c0e6ce72cd935f5f7e2f717549dd",
        strip_prefix = "num-traits-0.2.7",
        build_file = Label("//cargo/remote:num-traits-0.2.7.BUILD")
    )

    _new_http_archive(
        name = "raze__num_cpus__1_10_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/num_cpus/num_cpus-1.10.0.crate",
        type = "tar.gz",
        sha256 = "1a23f0ed30a54abaa0c7e83b1d2d87ada7c3c23078d1d87815af3e3b6385fbba",
        strip_prefix = "num_cpus-1.10.0",
        build_file = Label("//cargo/remote:num_cpus-1.10.0.BUILD")
    )

    _new_http_archive(
        name = "raze__numtoa__0_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/numtoa/numtoa-0.1.0.crate",
        type = "tar.gz",
        sha256 = "b8f8bdf33df195859076e54ab11ee78a1b208382d3a26ec40d142ffc1ecc49ef",
        strip_prefix = "numtoa-0.1.0",
        build_file = Label("//cargo/remote:numtoa-0.1.0.BUILD")
    )

    _new_http_archive(
        name = "raze__proc_macro2__0_4_30",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/proc-macro2/proc-macro2-0.4.30.crate",
        type = "tar.gz",
        sha256 = "cf3d2011ab5c909338f7887f4fc896d35932e29146c12c8d01da6b22a80ba759",
        strip_prefix = "proc-macro2-0.4.30",
        build_file = Label("//cargo/remote:proc-macro2-0.4.30.BUILD")
    )

    _new_http_archive(
        name = "raze__quote__0_6_12",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/quote/quote-0.6.12.crate",
        type = "tar.gz",
        sha256 = "faf4799c5d274f3868a4aae320a0a182cbd2baee377b378f080e16a23e9d80db",
        strip_prefix = "quote-0.6.12",
        build_file = Label("//cargo/remote:quote-0.6.12.BUILD")
    )

    _new_http_archive(
        name = "raze__rand__0_5_6",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rand/rand-0.5.6.crate",
        type = "tar.gz",
        sha256 = "c618c47cd3ebd209790115ab837de41425723956ad3ce2e6a7f09890947cacb9",
        strip_prefix = "rand-0.5.6",
        build_file = Label("//cargo/remote:rand-0.5.6.BUILD")
    )

    _new_http_archive(
        name = "raze__rand_core__0_3_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rand_core/rand_core-0.3.1.crate",
        type = "tar.gz",
        sha256 = "7a6fdeb83b075e8266dcc8762c22776f6877a63111121f5f8c7411e5be7eed4b",
        strip_prefix = "rand_core-0.3.1",
        build_file = Label("//cargo/remote:rand_core-0.3.1.BUILD")
    )

    _new_http_archive(
        name = "raze__rand_core__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rand_core/rand_core-0.4.0.crate",
        type = "tar.gz",
        sha256 = "d0e7a549d590831370895ab7ba4ea0c1b6b011d106b5ff2da6eee112615e6dc0",
        strip_prefix = "rand_core-0.4.0",
        build_file = Label("//cargo/remote:rand_core-0.4.0.BUILD")
    )

    _new_http_archive(
        name = "raze__rand_os__0_1_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rand_os/rand_os-0.1.3.crate",
        type = "tar.gz",
        sha256 = "7b75f676a1e053fc562eafbb47838d67c84801e38fc1ba459e8f180deabd5071",
        strip_prefix = "rand_os-0.1.3",
        build_file = Label("//cargo/remote:rand_os-0.1.3.BUILD")
    )

    _new_http_archive(
        name = "raze__rand_xoshiro__0_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rand_xoshiro/rand_xoshiro-0.1.0.crate",
        type = "tar.gz",
        sha256 = "03b418169fb9c46533f326efd6eed2576699c44ca92d3052a066214a8d828929",
        strip_prefix = "rand_xoshiro-0.1.0",
        build_file = Label("//cargo/remote:rand_xoshiro-0.1.0.BUILD")
    )

    _new_http_archive(
        name = "raze__rayon__1_0_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rayon/rayon-1.0.3.crate",
        type = "tar.gz",
        sha256 = "373814f27745b2686b350dd261bfd24576a6fb0e2c5919b3a2b6005f820b0473",
        strip_prefix = "rayon-1.0.3",
        build_file = Label("//cargo/remote:rayon-1.0.3.BUILD")
    )

    _new_http_archive(
        name = "raze__rayon_core__1_4_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rayon-core/rayon-core-1.4.1.crate",
        type = "tar.gz",
        sha256 = "b055d1e92aba6877574d8fe604a63c8b5df60f60e5982bf7ccbb1338ea527356",
        strip_prefix = "rayon-core-1.4.1",
        build_file = Label("//cargo/remote:rayon-core-1.4.1.BUILD")
    )

    _new_http_archive(
        name = "raze__rdrand__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/rdrand/rdrand-0.4.0.crate",
        type = "tar.gz",
        sha256 = "678054eb77286b51581ba43620cc911abf02758c91f93f479767aed0f90458b2",
        strip_prefix = "rdrand-0.4.0",
        build_file = Label("//cargo/remote:rdrand-0.4.0.BUILD")
    )

    _new_http_archive(
        name = "raze__redox_syscall__0_1_54",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/redox_syscall/redox_syscall-0.1.54.crate",
        type = "tar.gz",
        sha256 = "12229c14a0f65c4f1cb046a3b52047cdd9da1f4b30f8a39c5063c8bae515e252",
        strip_prefix = "redox_syscall-0.1.54",
        build_file = Label("//cargo/remote:redox_syscall-0.1.54.BUILD")
    )

    _new_http_archive(
        name = "raze__redox_termios__0_1_1",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/redox_termios/redox_termios-0.1.1.crate",
        type = "tar.gz",
        sha256 = "7e891cfe48e9100a70a3b6eb652fef28920c117d366339687bd5576160db0f76",
        strip_prefix = "redox_termios-0.1.1",
        build_file = Label("//cargo/remote:redox_termios-0.1.1.BUILD")
    )

    _new_http_archive(
        name = "raze__ryu__0_2_8",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/ryu/ryu-0.2.8.crate",
        type = "tar.gz",
        sha256 = "b96a9549dc8d48f2c283938303c4b5a77aa29bfbc5b54b084fb1630408899a8f",
        strip_prefix = "ryu-0.2.8",
        build_file = Label("//cargo/remote:ryu-0.2.8.BUILD")
    )

    _new_http_archive(
        name = "raze__same_file__1_0_4",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/same-file/same-file-1.0.4.crate",
        type = "tar.gz",
        sha256 = "8f20c4be53a8a1ff4c1f1b2bd14570d2f634628709752f0702ecdd2b3f9a5267",
        strip_prefix = "same-file-1.0.4",
        build_file = Label("//cargo/remote:same-file-1.0.4.BUILD")
    )

    _new_http_archive(
        name = "raze__scopeguard__0_3_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/scopeguard/scopeguard-0.3.3.crate",
        type = "tar.gz",
        sha256 = "94258f53601af11e6a49f722422f6e3425c52b06245a5cf9bc09908b174f5e27",
        strip_prefix = "scopeguard-0.3.3",
        build_file = Label("//cargo/remote:scopeguard-0.3.3.BUILD")
    )

    _new_http_archive(
        name = "raze__serde__1_0_91",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/serde/serde-1.0.91.crate",
        type = "tar.gz",
        sha256 = "a72e9b96fa45ce22a4bc23da3858dfccfd60acd28a25bcd328a98fdd6bea43fd",
        strip_prefix = "serde-1.0.91",
        build_file = Label("//cargo/remote:serde-1.0.91.BUILD")
    )

    _new_http_archive(
        name = "raze__serde_derive__1_0_91",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/serde_derive/serde_derive-1.0.91.crate",
        type = "tar.gz",
        sha256 = "101b495b109a3e3ca8c4cbe44cf62391527cdfb6ba15821c5ce80bcd5ea23f9f",
        strip_prefix = "serde_derive-1.0.91",
        build_file = Label("//cargo/remote:serde_derive-1.0.91.BUILD")
    )

    _new_http_archive(
        name = "raze__serde_json__1_0_39",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/serde_json/serde_json-1.0.39.crate",
        type = "tar.gz",
        sha256 = "5a23aa71d4a4d43fdbfaac00eff68ba8a06a51759a89ac3304323e800c4dd40d",
        strip_prefix = "serde_json-1.0.39",
        build_file = Label("//cargo/remote:serde_json-1.0.39.BUILD")
    )

    _new_http_archive(
        name = "raze__syn__0_15_34",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/syn/syn-0.15.34.crate",
        type = "tar.gz",
        sha256 = "a1393e4a97a19c01e900df2aec855a29f71cf02c402e2f443b8d2747c25c5dbe",
        strip_prefix = "syn-0.15.34",
        build_file = Label("//cargo/remote:syn-0.15.34.BUILD")
    )

    _new_http_archive(
        name = "raze__termion__1_5_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/termion/termion-1.5.2.crate",
        type = "tar.gz",
        sha256 = "dde0593aeb8d47accea5392b39350015b5eccb12c0d98044d856983d89548dea",
        strip_prefix = "termion-1.5.2",
        build_file = Label("//cargo/remote:termion-1.5.2.BUILD")
    )

    _new_http_archive(
        name = "raze__textwrap__0_11_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/textwrap/textwrap-0.11.0.crate",
        type = "tar.gz",
        sha256 = "d326610f408c7a4eb6f51c37c330e496b08506c9457c9d34287ecc38809fb060",
        strip_prefix = "textwrap-0.11.0",
        build_file = Label("//cargo/remote:textwrap-0.11.0.BUILD")
    )

    _new_http_archive(
        name = "raze__tiny_keccak__1_4_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tiny-keccak/tiny-keccak-1.4.2.crate",
        type = "tar.gz",
        sha256 = "e9175261fbdb60781fcd388a4d6cc7e14764a2b629a7ad94abb439aed223a44f",
        strip_prefix = "tiny-keccak-1.4.2",
        build_file = Label("//cargo/remote:tiny-keccak-1.4.2.BUILD")
    )

    _new_http_archive(
        name = "raze__tinytemplate__1_0_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/tinytemplate/tinytemplate-1.0.2.crate",
        type = "tar.gz",
        sha256 = "4574b75faccaacddb9b284faecdf0b544b80b6b294f3d062d325c5726a209c20",
        strip_prefix = "tinytemplate-1.0.2",
        build_file = Label("//cargo/remote:tinytemplate-1.0.2.BUILD")
    )

    _new_http_archive(
        name = "raze__unicode_width__0_1_5",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/unicode-width/unicode-width-0.1.5.crate",
        type = "tar.gz",
        sha256 = "882386231c45df4700b275c7ff55b6f3698780a650026380e72dabe76fa46526",
        strip_prefix = "unicode-width-0.1.5",
        build_file = Label("//cargo/remote:unicode-width-0.1.5.BUILD")
    )

    _new_http_archive(
        name = "raze__unicode_xid__0_1_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/unicode-xid/unicode-xid-0.1.0.crate",
        type = "tar.gz",
        sha256 = "fc72304796d0818e357ead4e000d19c9c174ab23dc11093ac919054d20a6a7fc",
        strip_prefix = "unicode-xid-0.1.0",
        build_file = Label("//cargo/remote:unicode-xid-0.1.0.BUILD")
    )

    _new_http_archive(
        name = "raze__walkdir__2_2_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/walkdir/walkdir-2.2.7.crate",
        type = "tar.gz",
        sha256 = "9d9d7ed3431229a144296213105a390676cc49c9b6a72bd19f3176c98e129fa1",
        strip_prefix = "walkdir-2.2.7",
        build_file = Label("//cargo/remote:walkdir-2.2.7.BUILD")
    )

    _new_http_archive(
        name = "raze__winapi__0_3_7",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi/winapi-0.3.7.crate",
        type = "tar.gz",
        sha256 = "f10e386af2b13e47c89e7236a7a14a086791a2b88ebad6df9bf42040195cf770",
        strip_prefix = "winapi-0.3.7",
        build_file = Label("//cargo/remote:winapi-0.3.7.BUILD")
    )

    _new_http_archive(
        name = "raze__winapi_i686_pc_windows_gnu__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-i686-pc-windows-gnu/winapi-i686-pc-windows-gnu-0.4.0.crate",
        type = "tar.gz",
        sha256 = "ac3b87c63620426dd9b991e5ce0329eff545bccbbb34f3be09ff6fb6ab51b7b6",
        strip_prefix = "winapi-i686-pc-windows-gnu-0.4.0",
        build_file = Label("//cargo/remote:winapi-i686-pc-windows-gnu-0.4.0.BUILD")
    )

    _new_http_archive(
        name = "raze__winapi_util__0_1_2",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-util/winapi-util-0.1.2.crate",
        type = "tar.gz",
        sha256 = "7168bab6e1daee33b4557efd0e95d5ca70a03706d39fa5f3fe7a236f584b03c9",
        strip_prefix = "winapi-util-0.1.2",
        build_file = Label("//cargo/remote:winapi-util-0.1.2.BUILD")
    )

    _new_http_archive(
        name = "raze__winapi_x86_64_pc_windows_gnu__0_4_0",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/winapi-x86_64-pc-windows-gnu/winapi-x86_64-pc-windows-gnu-0.4.0.crate",
        type = "tar.gz",
        sha256 = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f",
        strip_prefix = "winapi-x86_64-pc-windows-gnu-0.4.0",
        build_file = Label("//cargo/remote:winapi-x86_64-pc-windows-gnu-0.4.0.BUILD")
    )

    _new_http_archive(
        name = "raze__yaml_rust__0_4_3",
        url = "https://crates-io.s3-us-west-1.amazonaws.com/crates/yaml-rust/yaml-rust-0.4.3.crate",
        type = "tar.gz",
        sha256 = "65923dd1784f44da1d2c3dbbc5e822045628c590ba72123e1c73d3c230c4434d",
        strip_prefix = "yaml-rust-0.4.3",
        build_file = Label("//cargo/remote:yaml-rust-0.4.3.BUILD")
    )

